Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FF6C3A59D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 03:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiJXD0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 23:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiJXDYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 23:24:11 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E07316F268
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 20:22:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 58C0A2041BB;
        Mon, 24 Oct 2022 05:22:04 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ntK0bEu3Xghc; Mon, 24 Oct 2022 05:22:04 +0200 (CEST)
Received: from treten.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id C264F2041AF;
        Mon, 24 Oct 2022 05:22:02 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v25 42/44] sg: add statistics similar to st
Date:   Sun, 23 Oct 2022 23:20:56 -0400
Message-Id: <20221024032058.14077-43-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024032058.14077-1-dgilbert@interlog.com>
References: <20221024032058.14077-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the existing statistics gathering framework from the st
driver, collect statistics for access via sysfs. The sysstat
package already has a utility called tapestat for presenting
st statistics. Its author is keen to use the existing
tapestat code for showing sg statistics (rather than write a
new utility).

In keeping with the sg driver being SCSI command agnostic, the
"read" statistics are compiled for requests that have "data-in"
user data while write statistics are compiled for requests that
have "data-out" user data.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 260 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 228 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 496e7a89bf8e..4bf2363d1b17 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -217,7 +217,7 @@ struct sg_request {	/* active SCSI command or inactive request */
 	int sense_len;		/* actual sense buffer length (data-in) */
 	atomic_t rq_st;		/* request state, holds a enum sg_rq_state */
 	u8 cmd_opcode;		/* first byte of SCSI cdb */
-	u64 start_ns;		/* starting point of command duration calc */
+	ktime_t start_dur;	/* start time if before completion */
 	unsigned long frq_bm[1];	/* see SG_FRQ_* defines above */
 	u8 *sense_bp;		/* mempool alloc-ed sense buffer, as needed */
 	struct sg_fd *parentfp;	/* pointer to owning fd, even when on fl */
@@ -260,9 +260,11 @@ struct sg_device { /* holds the state of each scsi generic device */
 	u32 index;		/* device index number */
 	atomic_t open_cnt;	/* count of opens (perhaps < num(sfds) ) */
 	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */
+	spinlock_t stats_lock;
 	char name[DISK_NAME_LEN];
 	struct cdev *cdev;
 	struct block_device *dummy_bdev;	/* hack for REQ_POLLED */
+	struct sg_dev_stats *statsp;
 	struct xarray sfp_arr;
 	struct kref d_ref;
 };
@@ -280,6 +282,19 @@ struct sg_comm_wr_t {  /* arguments to sg_common_write() */
 	const u8 __user *u_cmdp;
 };
 
+struct sg_dev_stats {	/* copied from drivers/scsi/st.h scsi_tape_stats */
+	u64 read_byte_cnt;	/* data-in bytes */
+	u64 write_byte_cnt;	/* data-out bytes */
+	u64 read_cnt;		/* Count of data-in requests */
+	u64 write_cnt;		/* Count of data-out requests */
+	u64 other_cnt;		/* Count of non-data requests */
+	u64 resid_cnt;		/* Count of cmds with resid_len > 0 */
+	u64 tot_read_time;	/* time spent completing data-in requests */
+	u64 tot_write_time;	/* time spent completing data-out requests */
+	u64 tot_ndata_time;	/* time spent completing non-data requests */
+	atomic_t in_flight;	/* Number of I/Os in flight */
+};
+
 /* tasklet or soft irq callback */
 static enum rq_end_io_ret sg_rq_end_io(struct request *rq, blk_status_t status);
 /* Declarations of other static functions used before they are defined */
@@ -312,6 +327,8 @@ static struct sg_request *sg_mk_srp_sgat(struct sg_fd *sfp, bool first,
 static int sg_sfp_bio_poll(struct sg_fd *sfp, int loop_count);
 static int sg_srp_q_bio_poll(struct sg_request *srp, struct request_queue *q,
 			     int loop_count);
+static u32 sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
+		      bool *is_durp);
 #if IS_ENABLED(CONFIG_SCSI_LOGGING) && IS_ENABLED(CONFIG_SG_DEBUG)
 static const char *sg_rq_st_str(enum sg_rq_state rq_st, bool long_str);
 #endif
@@ -1017,11 +1034,17 @@ sg_execute_cmd(struct sg_fd *sfp, struct sg_request *srp)
 {
 	bool at_head, is_v4h, sync;
 	struct request *rqq = READ_ONCE(srp->rqq);
+	struct sg_device *sdp = sfp->parentdp;
 
 	is_v4h = test_bit(SG_FRQ_IS_V4I, srp->frq_bm);
 	sync = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
 	SG_LOG(3, sfp, "%s: is_v4h=%d\n", __func__, (int)is_v4h);
-	srp->start_ns = ktime_get_boottime_ns();
+	if (sdp->statsp) {
+		atomic_inc(&sdp->statsp->in_flight);
+		WRITE_ONCE(srp->start_dur, ktime_get_boottime());
+	} else {
+		WRITE_ONCE(srp->start_dur, 0);
+	}
 	srp->duration = 0;
 
 	if (!is_v4h && srp->s_hdr3.interface_id == '\0')
@@ -1195,11 +1218,47 @@ sg_copy_sense(struct sg_request *srp, bool v4_active)
 	return sb_len_ret;
 }
 
+static void
+sg_do_stats(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
+{
+	int dir = v4_active ? srp->s_hdr4.dir : srp->s_hdr3.dxfer_direction;
+	ktime_t kt = READ_ONCE(srp->start_dur);
+	u64 ns = (kt > 0) ? ktime_to_ns(kt) : 0;
+	struct sg_device *sdp = sfp->parentdp;
+	struct sg_dev_stats *statsp = sdp->statsp;
+
+	if (!statsp)
+		return;
+	spin_lock(&sdp->stats_lock);
+	if (dir == SG_DXFER_TO_DEV) {		/* data-out, write-like */
+		statsp->tot_write_time += ns;
+		++statsp->write_cnt;
+		statsp->write_byte_cnt += srp->sgat_h.dlen;
+	} else if (dir == SG_DXFER_FROM_DEV) {	/* data-in, read-like */
+		statsp->tot_read_time += ns;
+		++statsp->read_cnt;
+		statsp->read_byte_cnt += srp->sgat_h.dlen;
+		if (srp->in_resid > 0)
+			++statsp->resid_cnt;
+	} else {	/* no data transfer (e.g. TEST UNIT READY) */
+		statsp->tot_ndata_time += ns;
+		++statsp->other_cnt;
+	}
+	atomic_dec(&statsp->in_flight);
+	spin_unlock(&sdp->stats_lock);
+}
+
 static int
 sg_rec_state_v3v4(struct sg_fd *sfp, struct sg_request *srp, bool v4_active)
 {
 	u32 rq_res = srp->rq_result;
 
+	if (sfp->parentdp->statsp) {
+		const enum sg_rq_state sr_st = SG_RS_BUSY;
+
+		sg_do_stats(sfp, srp, v4_active);
+		srp->duration = sg_get_dur(srp, &sr_st, NULL);
+	}
 	if (unlikely(srp->rq_result & 0xff)) {
 		int sb_len_wr = sg_copy_sense(srp, v4_active);
 
@@ -1625,49 +1684,41 @@ sg_calc_sgat_param(struct sg_device *sdp)
 	sdp->max_sgat_sz = sz;
 }
 
-static u32
-sg_calc_rq_dur(const struct sg_request *srp)
-{
-	ktime_t ts0 = ns_to_ktime(srp->start_ns);
-	ktime_t now_ts;
-	s64 diff;
-
-	if (ts0 == 0)
-		return 0;
-	if (unlikely(ts0 == S64_MAX))	/* _prior_ to issuing req */
-		return 999999999;	/* eye catching */
-	now_ts = ktime_get_boottime();
-	if (unlikely(ts0 > now_ts))
-		return 999999998;
-	/* unlikely req duration will exceed 2**32 milliseconds */
-	diff = ktime_ms_delta(now_ts, ts0);
-	return (diff > (s64)U32_MAX) ? 3999999999U : (u32)diff;
-}
-
-/* Return of U32_MAX means srp is inactive state */
 static u32
 sg_get_dur(struct sg_request *srp, const enum sg_rq_state *sr_stp,
 	   bool *is_durp)
 {
 	bool is_dur = false;
-	u32 res = U32_MAX;
+	s64 dur_ns;
+	ktime_t start_dur = READ_ONCE(srp->start_dur);
 
+	if (ktime_to_ns(start_dur) <= 0) {
+		is_dur = true;
+		dur_ns = 0;
+		goto fini;
+	}
 	switch (sr_stp ? *sr_stp : atomic_read(&srp->rq_st)) {
-	case SG_RS_INFLIGHT:
 	case SG_RS_BUSY:
-		res = sg_calc_rq_dur(srp);
+		if (test_bit(SG_FRQ_ISSUED, srp->frq_bm)) {
+			dur_ns = ktime_to_ns(start_dur);
+			is_dur = true;
+			break;
+		}
+		dur_ns = 1;
+		break;
+	case SG_RS_INFLIGHT:
+		dur_ns = ktime_sub(ktime_get_boottime(), start_dur);
 		break;
 	case SG_RS_AWAIT_RCV:
 	case SG_RS_INACTIVE:
-		res = srp->duration;
+		dur_ns = ktime_to_ns(start_dur);
 		is_dur = true;	/* completion has occurred, timing finished */
 		break;
-	default:
-		break;
 	}
+fini:
 	if (is_durp)
 		*is_durp = is_dur;
-	return res;
+	return ktime_to_ms(ns_to_ktime(dur_ns));
 }
 
 static void
@@ -1678,8 +1729,6 @@ sg_fill_request_element(struct sg_fd *sfp, struct sg_request *srp,
 
 	xa_lock_irqsave(&sfp->srp_arr, iflags);
 	rip->duration = sg_get_dur(srp, NULL, NULL);
-	if (rip->duration == U32_MAX)
-		rip->duration = 0;
 	rip->orphan = test_bit(SG_FRQ_IS_ORPHAN, srp->frq_bm);
 	rip->sg_io_owned = test_bit(SG_FRQ_SYNC_INVOC, srp->frq_bm);
 	rip->problem = !!(srp->rq_result & SG_ML_RESULT_MSK);
@@ -2527,6 +2576,7 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 	int a_resid, slen;
 	u32 rq_result;
 	unsigned long iflags;
+	ktime_t start_tm;
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rqq);
 	struct sg_request *srp = rqq->end_io_data;
 	struct sg_device *sdp;
@@ -2553,7 +2603,9 @@ sg_rq_end_io(struct request *rqq, blk_status_t status)
 
 	SG_LOG(6, sfp, "%s: pack_id=%d, res=0x%x\n", __func__, srp->pack_id,
 	       rq_result);
-	srp->duration = sg_calc_rq_dur(srp);
+	start_tm = READ_ONCE(srp->start_dur);
+	if (start_tm > 0)
+		WRITE_ONCE(srp->start_dur, ktime_sub(ktime_get_boottime(), start_tm));
 	if (unlikely((rq_result & SG_ML_RESULT_MSK) && slen > 0 &&
 		     test_bit(SG_FDEV_LOG_SENSE, sdp->fdev_bm))) {
 		u32 scsi_stat = rq_result & 0xff;
@@ -2701,9 +2753,12 @@ sg_add_device_helper(struct scsi_device *scsidp)
 		kfree(sdp);
 		return ERR_PTR(error);
 	}
+	spin_lock_init(&sdp->stats_lock);
 	return sdp;
 }
 
+static const struct attribute_group *sg_dev_groups[];
+
 static int
 sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 {
@@ -2728,6 +2783,8 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 		error = PTR_ERR(sdp);
 		goto out;
 	}
+	sdp->statsp = kzalloc(sizeof(*sdp->statsp), GFP_KERNEL);
+	/* don't worry if NULL, probably a lot of devices */
 
 	error = cdev_add(cdev, MKDEV(SCSI_GENERIC_MAJOR, sdp->index), 1);
 	if (error)
@@ -2737,6 +2794,8 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	if (sg_sysfs_valid) {
 		struct device *sg_class_member;
 
+		if (sdp->statsp)
+			sg_sysfs_class->dev_groups = sg_dev_groups;
 		sg_class_member = device_create(sg_sysfs_class, cl_dev->parent,
 						MKDEV(SCSI_GENERIC_MAJOR,
 						      sdp->index),
@@ -2763,6 +2822,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	return 0;
 
 cdev_add_err:
+	kfree(sdp->statsp);
 	write_lock_irqsave(&sg_index_lock, iflags);
 	idr_remove(&sg_index_idr, sdp->index);
 	write_unlock_irqrestore(&sg_index_lock, iflags);
@@ -2791,6 +2851,7 @@ sg_device_destroy(struct kref *kref)
 	 */
 
 	xa_destroy(&sdp->sfp_arr);
+	kfree(sdp->statsp);
 	write_lock_irqsave(&sg_index_lock, flags);
 	idr_remove(&sg_index_idr, sdp->index);
 	write_unlock_irqrestore(&sg_index_lock, flags);
@@ -3963,6 +4024,141 @@ sg_rq_st_str(enum sg_rq_state rq_st, bool long_str)
 }
 #endif
 
+static ssize_t read_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n", sp->read_cnt);
+}
+static DEVICE_ATTR_RO(read_cnt);
+
+static ssize_t read_byte_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n", sp->read_byte_cnt);
+}
+static DEVICE_ATTR_RO(read_byte_cnt);
+
+static ssize_t read_ns_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n", sp->tot_read_time);
+}
+static DEVICE_ATTR_RO(read_ns);
+
+static ssize_t write_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n", sp->write_cnt);
+}
+static DEVICE_ATTR_RO(write_cnt);
+
+static ssize_t write_byte_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n", sp->write_byte_cnt);
+}
+static DEVICE_ATTR_RO(write_byte_cnt);
+
+static ssize_t write_ns_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n", sp->tot_write_time);
+}
+static DEVICE_ATTR_RO(write_ns);
+
+static ssize_t in_flight_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%d\n", atomic_read(&sp->in_flight));
+}
+static DEVICE_ATTR_RO(in_flight);
+
+static ssize_t io_ns_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n",
+			  sp->tot_read_time + sp->tot_write_time + sp->tot_ndata_time);
+}
+static DEVICE_ATTR_RO(io_ns);
+
+static ssize_t other_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n", sp->other_cnt);
+}
+static DEVICE_ATTR_RO(other_cnt);
+
+static ssize_t resid_cnt_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct sg_device *sdp = dev_get_drvdata(dev);
+	struct sg_dev_stats *sp = sdp->statsp;
+
+	if (!sdp || !sp)
+		return -EINVAL;
+	return sysfs_emit(buf, "%llu\n", sp->resid_cnt);
+}
+static DEVICE_ATTR_RO(resid_cnt);
+
+static struct attribute *sg_stats_attrs[] = {
+	&dev_attr_read_cnt.attr,
+	&dev_attr_read_byte_cnt.attr,
+	&dev_attr_read_ns.attr,
+	&dev_attr_write_cnt.attr,
+	&dev_attr_write_byte_cnt.attr,
+	&dev_attr_write_ns.attr,
+	&dev_attr_in_flight.attr,
+	&dev_attr_io_ns.attr,
+	&dev_attr_other_cnt.attr,
+	&dev_attr_resid_cnt.attr,
+	NULL,
+};
+
+static struct attribute_group sg_stats_group = {
+	.name = "stats",
+	.attrs = sg_stats_attrs,
+};
+
+static const struct attribute_group *sg_dev_groups[] = {
+	&sg_stats_group,
+	NULL,
+};
+
 #if IS_ENABLED(CONFIG_SG_PROC_OR_DEBUG_FS)
 
 #define SG_SNAPSHOT_DEV_MAX 4
-- 
2.37.3

