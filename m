From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.17-rc2
Date: Wed, 25 Apr 2018 13:44:25 -0700
Message-ID: <1524689065.4100.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

8 bug fixes, one spelling update and one tracepoint addition.  The most
serious is probably the mpt3sas write same fix because it means anyone
using these controllers sees errors when modern filesystems try to
issue discards (if the drive supports the WRITE SAME variant).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: sd_zbc: Avoid that resetting a zone fails sporadically

Chris Leech (1):
      scsi: iscsi: respond to netlink with unicast when appropriate

Colin Ian King (1):
      scsi: fnic: fix spelling mistake in fnic stats "Abord" -> "Abort"

Douglas Gilbert (1):
      scsi: scsi_debug: IMMED related delay adjustments

John Pittman (1):
      scsi: core: remove reference to scsi_show_extd_sense()

Mahesh Rajashekhara (1):
      scsi: sd: Defer spinning up drive while SANITIZE is in progress

Martin K. Petersen (1):
      scsi: mptsas: Disable WRITE SAME

Ming Lei (1):
      scsi: target: fix crash with iscsi target and dvd

Ohad Sharabi (1):
      scsi: ufs: add trace event for ufs upiu

Vinson Lee (1):
      scsi: megaraid_sas: Do not log an error if FW successfully initializes.

And the diffstat:

 drivers/message/fusion/mptsas.c             |   1 +
 drivers/scsi/fnic/fnic_trace.c              |   2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   6 +-
 drivers/scsi/scsi_debug.c                   |  33 +++++--
 drivers/scsi/scsi_transport_iscsi.c         |  29 +++---
 drivers/scsi/sd.c                           |   2 +
 drivers/scsi/sd_zbc.c                       | 140 ++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.c                   |  40 ++++++++
 drivers/target/target_core_pscsi.c          |   2 +
 include/linux/blkdev.h                      |   5 +
 include/scsi/scsi_dbg.h                     |   2 -
 include/trace/events/ufs.h                  |  27 ++++++
 12 files changed, 205 insertions(+), 84 deletions(-)

With full diff below

James

---

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 231f3a1e27bf..86503f60468f 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1994,6 +1994,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.cmd_per_lun			= 7,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= mptscsih_host_attrs,
+	.no_write_same			= 1,
 };
 
 static int mptsas_get_linkerrors(struct sas_phy *phy)
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index abddde11982b..98597b59c12a 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -296,7 +296,7 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  "Number of Abort FW Timeouts: %lld\n"
 		  "Number of Abort IO NOT Found: %lld\n"
 
-		  "Abord issued times: \n"
+		  "Abort issued times: \n"
 		  "            < 6 sec : %lld\n"
 		  "     6 sec - 20 sec : %lld\n"
 		  "    20 sec - 30 sec : %lld\n"
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index ce97cde3b41c..f4d988dd1e9d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1124,12 +1124,12 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		goto fail_fw_init;
 	}
 
-	ret = 0;
+	return 0;
 
 fail_fw_init:
 	dev_err(&instance->pdev->dev,
-		"Init cmd return status %s for SCSI host %d\n",
-		ret ? "FAILED" : "SUCCESS", instance->host->host_no);
+		"Init cmd return status FAILED for SCSI host %d\n",
+		instance->host->host_no);
 
 	return ret;
 }
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9ef5e3b810f6..656c98e116a9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -234,11 +234,13 @@ static const char *sdebug_version_date = "20180128";
 #define F_INV_OP		0x200
 #define F_FAKE_RW		0x400
 #define F_M_ACCESS		0x800	/* media access */
-#define F_LONG_DELAY		0x1000
+#define F_SSU_DELAY		0x1000
+#define F_SYNC_DELAY		0x2000
 
 #define FF_RESPOND (F_RL_WLUN_OK | F_SKIP_UA | F_DELAY_OVERR)
 #define FF_MEDIA_IO (F_M_ACCESS | F_FAKE_RW)
 #define FF_SA (F_SA_HIGH | F_SA_LOW)
+#define F_LONG_DELAY		(F_SSU_DELAY | F_SYNC_DELAY)
 
 #define SDEBUG_MAX_PARTS 4
 
@@ -510,7 +512,7 @@ static const struct opcode_info_t release_iarr[] = {
 };
 
 static const struct opcode_info_t sync_cache_iarr[] = {
-	{0, 0x91, 0, F_LONG_DELAY | F_M_ACCESS, resp_sync_cache, NULL,
+	{0, 0x91, 0, F_SYNC_DELAY | F_M_ACCESS, resp_sync_cache, NULL,
 	    {16,  0x6, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },	/* SYNC_CACHE (16) */
 };
@@ -553,7 +555,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	    resp_write_dt0, write_iarr,			/* WRITE(16) */
 		{16,  0xfa, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 		 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7} },
-	{0, 0x1b, 0, F_LONG_DELAY, resp_start_stop, NULL,/* START STOP UNIT */
+	{0, 0x1b, 0, F_SSU_DELAY, resp_start_stop, NULL,/* START STOP UNIT */
 	    {6,  0x1, 0, 0xf, 0xf7, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 	{ARRAY_SIZE(sa_in_16_iarr), 0x9e, 0x10, F_SA_LOW | F_D_IN,
 	    resp_readcap16, sa_in_16_iarr, /* SA_IN(16), READ CAPACITY(16) */
@@ -606,7 +608,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	    resp_write_same_10, write_same_iarr,	/* WRITE SAME(10) */
 		{10,  0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0,
 		 0, 0, 0, 0, 0} },
-	{ARRAY_SIZE(sync_cache_iarr), 0x35, 0, F_LONG_DELAY | F_M_ACCESS,
+	{ARRAY_SIZE(sync_cache_iarr), 0x35, 0, F_SYNC_DELAY | F_M_ACCESS,
 	    resp_sync_cache, sync_cache_iarr,
 	    {10,  0x7, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
 	     0, 0, 0, 0} },			/* SYNC_CACHE (10) */
@@ -667,6 +669,7 @@ static bool sdebug_strict = DEF_STRICT;
 static bool sdebug_any_injecting_opt;
 static bool sdebug_verbose;
 static bool have_dif_prot;
+static bool write_since_sync;
 static bool sdebug_statistics = DEF_STATISTICS;
 
 static unsigned int sdebug_store_sectors;
@@ -1607,6 +1610,7 @@ static int resp_start_stop(struct scsi_cmnd *scp,
 {
 	unsigned char *cmd = scp->cmnd;
 	int power_cond, stop;
+	bool changing;
 
 	power_cond = (cmd[4] & 0xf0) >> 4;
 	if (power_cond) {
@@ -1614,8 +1618,12 @@ static int resp_start_stop(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 	stop = !(cmd[4] & 1);
+	changing = atomic_read(&devip->stopped) == !stop;
 	atomic_xchg(&devip->stopped, stop);
-	return (cmd[1] & 0x1) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */
+	if (!changing || cmd[1] & 0x1)  /* state unchanged or IMMED set */
+		return SDEG_RES_IMMED_MASK;
+	else
+		return 0;
 }
 
 static sector_t get_sdebug_capacity(void)
@@ -2473,6 +2481,7 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 	if (do_write) {
 		sdb = scsi_out(scmd);
 		dir = DMA_TO_DEVICE;
+		write_since_sync = true;
 	} else {
 		sdb = scsi_in(scmd);
 		dir = DMA_FROM_DEVICE;
@@ -3583,6 +3592,7 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 static int resp_sync_cache(struct scsi_cmnd *scp,
 			   struct sdebug_dev_info *devip)
 {
+	int res = 0;
 	u64 lba;
 	u32 num_blocks;
 	u8 *cmd = scp->cmnd;
@@ -3598,7 +3608,11 @@ static int resp_sync_cache(struct scsi_cmnd *scp,
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		return check_condition_result;
 	}
-	return (cmd[1] & 0x2) ? SDEG_RES_IMMED_MASK : 0; /* check IMMED bit */
+	if (!write_since_sync || cmd[1] & 0x2)
+		res = SDEG_RES_IMMED_MASK;
+	else		/* delay if write_since_sync and IMMED clear */
+		write_since_sync = false;
+	return res;
 }
 
 #define RL_BUCKET_ELEMS 8
@@ -5777,13 +5791,14 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		return schedule_resp(scp, devip, errsts, pfp, 0, 0);
 	else if ((sdebug_jdelay || sdebug_ndelay) && (flags & F_LONG_DELAY)) {
 		/*
-		 * If any delay is active, want F_LONG_DELAY to be at least 1
+		 * If any delay is active, for F_SSU_DELAY want at least 1
 		 * second and if sdebug_jdelay>0 want a long delay of that
-		 * many seconds.
+		 * many seconds; for F_SYNC_DELAY want 1/20 of that.
 		 */
 		int jdelay = (sdebug_jdelay < 2) ? 1 : sdebug_jdelay;
+		int denom = (flags & F_SYNC_DELAY) ? 20 : 1;
 
-		jdelay = mult_frac(USER_HZ * jdelay, HZ, USER_HZ);
+		jdelay = mult_frac(USER_HZ * jdelay, HZ, denom * USER_HZ);
 		return schedule_resp(scp, devip, errsts, pfp, jdelay, 0);
 	} else
 		return schedule_resp(scp, devip, errsts, pfp, sdebug_jdelay,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4b52b44b966..65f6c94f2e9b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2322,6 +2322,12 @@ iscsi_multicast_skb(struct sk_buff *skb, uint32_t group, gfp_t gfp)
 	return nlmsg_multicast(nls, skb, 0, group, gfp);
 }
 
+static int
+iscsi_unicast_skb(struct sk_buff *skb, u32 portid)
+{
+	return nlmsg_unicast(nls, skb, portid);
+}
+
 int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 		   char *data, uint32_t data_size)
 {
@@ -2524,14 +2530,11 @@ void iscsi_ping_comp_event(uint32_t host_no, struct iscsi_transport *transport,
 EXPORT_SYMBOL_GPL(iscsi_ping_comp_event);
 
 static int
-iscsi_if_send_reply(uint32_t group, int seq, int type, int done, int multi,
-		    void *payload, int size)
+iscsi_if_send_reply(u32 portid, int type, void *payload, int size)
 {
 	struct sk_buff	*skb;
 	struct nlmsghdr	*nlh;
 	int len = nlmsg_total_size(size);
-	int flags = multi ? NLM_F_MULTI : 0;
-	int t = done ? NLMSG_DONE : type;
 
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
@@ -2539,10 +2542,9 @@ iscsi_if_send_reply(uint32_t group, int seq, int type, int done, int multi,
 		return -ENOMEM;
 	}
 
-	nlh = __nlmsg_put(skb, 0, 0, t, (len - sizeof(*nlh)), 0);
-	nlh->nlmsg_flags = flags;
+	nlh = __nlmsg_put(skb, 0, 0, type, (len - sizeof(*nlh)), 0);
 	memcpy(nlmsg_data(nlh), payload, size);
-	return iscsi_multicast_skb(skb, group, GFP_ATOMIC);
+	return iscsi_unicast_skb(skb, portid);
 }
 
 static int
@@ -3470,6 +3472,7 @@ static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 {
 	int err = 0;
+	u32 portid;
 	struct iscsi_uevent *ev = nlmsg_data(nlh);
 	struct iscsi_transport *transport = NULL;
 	struct iscsi_internal *priv;
@@ -3490,10 +3493,12 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 	if (!try_module_get(transport->owner))
 		return -EINVAL;
 
+	portid = NETLINK_CB(skb).portid;
+
 	switch (nlh->nlmsg_type) {
 	case ISCSI_UEVENT_CREATE_SESSION:
 		err = iscsi_if_create_session(priv, ep, ev,
-					      NETLINK_CB(skb).portid,
+					      portid,
 					      ev->u.c_session.initial_cmdsn,
 					      ev->u.c_session.cmds_max,
 					      ev->u.c_session.queue_depth);
@@ -3506,7 +3511,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		}
 
 		err = iscsi_if_create_session(priv, ep, ev,
-					NETLINK_CB(skb).portid,
+					portid,
 					ev->u.c_bound_session.initial_cmdsn,
 					ev->u.c_bound_session.cmds_max,
 					ev->u.c_bound_session.queue_depth);
@@ -3664,6 +3669,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 static void
 iscsi_if_rx(struct sk_buff *skb)
 {
+	u32 portid = NETLINK_CB(skb).portid;
+
 	mutex_lock(&rx_queue_mutex);
 	while (skb->len >= NLMSG_HDRLEN) {
 		int err;
@@ -3699,8 +3706,8 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			if (ev->type == ISCSI_UEVENT_GET_CHAP && !err)
 				break;
-			err = iscsi_if_send_reply(group, nlh->nlmsg_seq,
-				nlh->nlmsg_type, 0, 0, ev, sizeof(*ev));
+			err = iscsi_if_send_reply(portid, nlh->nlmsg_type,
+						  ev, sizeof(*ev));
 		} while (err < 0 && err != -ECONNREFUSED && err != -ESRCH);
 		skb_pull(skb, rlen);
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a6201e696ab9..9421d9877730 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2121,6 +2121,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				break;	/* standby */
 			if (sshdr.asc == 4 && sshdr.ascq == 0xc)
 				break;	/* unavailable */
+			if (sshdr.asc == 4 && sshdr.ascq == 0x1b)
+				break;	/* sanitize in progress */
 			/*
 			 * Issue command to spin up drive when not ready
 			 */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 41df75eea57b..210407cd2341 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -400,8 +400,10 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf)
  *
  * Check that all zones of the device are equal. The last zone can however
  * be smaller. The zone size must also be a power of two number of LBAs.
+ *
+ * Returns the zone size in bytes upon success or an error code upon failure.
  */
-static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
+static s64 sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 {
 	u64 zone_blocks = 0;
 	sector_t block = 0;
@@ -412,8 +414,6 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	int ret;
 	u8 same;
 
-	sdkp->zone_blocks = 0;
-
 	/* Get a buffer */
 	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -445,16 +445,17 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
 		/* Parse zone descriptors */
 		while (rec < buf + buf_len) {
-			zone_blocks = get_unaligned_be64(&rec[8]);
-			if (sdkp->zone_blocks == 0) {
-				sdkp->zone_blocks = zone_blocks;
-			} else if (zone_blocks != sdkp->zone_blocks &&
-				   (block + zone_blocks < sdkp->capacity
-				    || zone_blocks > sdkp->zone_blocks)) {
-				zone_blocks = 0;
+			u64 this_zone_blocks = get_unaligned_be64(&rec[8]);
+
+			if (zone_blocks == 0) {
+				zone_blocks = this_zone_blocks;
+			} else if (this_zone_blocks != zone_blocks &&
+				   (block + this_zone_blocks < sdkp->capacity
+				    || this_zone_blocks > zone_blocks)) {
+				this_zone_blocks = 0;
 				goto out;
 			}
-			block += zone_blocks;
+			block += this_zone_blocks;
 			rec += 64;
 		}
 
@@ -467,8 +468,6 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
 	} while (block < sdkp->capacity);
 
-	zone_blocks = sdkp->zone_blocks;
-
 out:
 	if (!zone_blocks) {
 		if (sdkp->first_scan)
@@ -488,8 +487,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 				  "Zone size too large\n");
 		ret = -ENODEV;
 	} else {
-		sdkp->zone_blocks = zone_blocks;
-		sdkp->zone_shift = ilog2(zone_blocks);
+		ret = zone_blocks;
 	}
 
 out_free:
@@ -500,15 +498,14 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 
 /**
  * sd_zbc_alloc_zone_bitmap - Allocate a zone bitmap (one bit per zone).
- * @sdkp: The disk of the bitmap
+ * @nr_zones: Number of zones to allocate space for.
+ * @numa_node: NUMA node to allocate the memory from.
  */
-static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
+static inline unsigned long *
+sd_zbc_alloc_zone_bitmap(u32 nr_zones, int numa_node)
 {
-	struct request_queue *q = sdkp->disk->queue;
-
-	return kzalloc_node(BITS_TO_LONGS(sdkp->nr_zones)
-			    * sizeof(unsigned long),
-			    GFP_KERNEL, q->node);
+	return kzalloc_node(BITS_TO_LONGS(nr_zones) * sizeof(unsigned long),
+			    GFP_KERNEL, numa_node);
 }
 
 /**
@@ -516,6 +513,7 @@ static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
  * @sdkp: disk used
  * @buf: report reply buffer
  * @buflen: length of @buf
+ * @zone_shift: logarithm base 2 of the number of blocks in a zone
  * @seq_zones_bitmap: bitmap of sequential zones to set
  *
  * Parse reported zone descriptors in @buf to identify sequential zones and
@@ -525,7 +523,7 @@ static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
  * Return the LBA after the last zone reported.
  */
 static sector_t sd_zbc_get_seq_zones(struct scsi_disk *sdkp, unsigned char *buf,
-				     unsigned int buflen,
+				     unsigned int buflen, u32 zone_shift,
 				     unsigned long *seq_zones_bitmap)
 {
 	sector_t lba, next_lba = sdkp->capacity;
@@ -544,7 +542,7 @@ static sector_t sd_zbc_get_seq_zones(struct scsi_disk *sdkp, unsigned char *buf,
 		if (type != ZBC_ZONE_TYPE_CONV &&
 		    cond != ZBC_ZONE_COND_READONLY &&
 		    cond != ZBC_ZONE_COND_OFFLINE)
-			set_bit(lba >> sdkp->zone_shift, seq_zones_bitmap);
+			set_bit(lba >> zone_shift, seq_zones_bitmap);
 		next_lba = lba + get_unaligned_be64(&rec[8]);
 		rec += 64;
 	}
@@ -553,12 +551,16 @@ static sector_t sd_zbc_get_seq_zones(struct scsi_disk *sdkp, unsigned char *buf,
 }
 
 /**
- * sd_zbc_setup_seq_zones_bitmap - Initialize the disk seq zone bitmap.
+ * sd_zbc_setup_seq_zones_bitmap - Initialize a seq zone bitmap.
  * @sdkp: target disk
+ * @zone_shift: logarithm base 2 of the number of blocks in a zone
+ * @nr_zones: number of zones to set up a seq zone bitmap for
  *
  * Allocate a zone bitmap and initialize it by identifying sequential zones.
  */
-static int sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp)
+static unsigned long *
+sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp, u32 zone_shift,
+			      u32 nr_zones)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned long *seq_zones_bitmap;
@@ -566,9 +568,9 @@ static int sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp)
 	unsigned char *buf;
 	int ret = -ENOMEM;
 
-	seq_zones_bitmap = sd_zbc_alloc_zone_bitmap(sdkp);
+	seq_zones_bitmap = sd_zbc_alloc_zone_bitmap(nr_zones, q->node);
 	if (!seq_zones_bitmap)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	buf = kmalloc(SD_ZBC_BUF_SIZE, GFP_KERNEL);
 	if (!buf)
@@ -579,7 +581,7 @@ static int sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp)
 		if (ret)
 			goto out;
 		lba = sd_zbc_get_seq_zones(sdkp, buf, SD_ZBC_BUF_SIZE,
-					   seq_zones_bitmap);
+					   zone_shift, seq_zones_bitmap);
 	}
 
 	if (lba != sdkp->capacity) {
@@ -591,12 +593,9 @@ static int sd_zbc_setup_seq_zones_bitmap(struct scsi_disk *sdkp)
 	kfree(buf);
 	if (ret) {
 		kfree(seq_zones_bitmap);
-		return ret;
+		return ERR_PTR(ret);
 	}
-
-	q->seq_zones_bitmap = seq_zones_bitmap;
-
-	return 0;
+	return seq_zones_bitmap;
 }
 
 static void sd_zbc_cleanup(struct scsi_disk *sdkp)
@@ -612,44 +611,64 @@ static void sd_zbc_cleanup(struct scsi_disk *sdkp)
 	q->nr_zones = 0;
 }
 
-static int sd_zbc_setup(struct scsi_disk *sdkp)
+static int sd_zbc_setup(struct scsi_disk *sdkp, u32 zone_blocks)
 {
 	struct request_queue *q = sdkp->disk->queue;
+	u32 zone_shift = ilog2(zone_blocks);
+	u32 nr_zones;
 	int ret;
 
-	/* READ16/WRITE16 is mandatory for ZBC disks */
-	sdkp->device->use_16_for_rw = 1;
-	sdkp->device->use_10_for_rw = 0;
-
 	/* chunk_sectors indicates the zone size */
-	blk_queue_chunk_sectors(sdkp->disk->queue,
-			logical_to_sectors(sdkp->device, sdkp->zone_blocks));
-	sdkp->nr_zones =
-		round_up(sdkp->capacity, sdkp->zone_blocks) >> sdkp->zone_shift;
+	blk_queue_chunk_sectors(q,
+			logical_to_sectors(sdkp->device, zone_blocks));
+	nr_zones = round_up(sdkp->capacity, zone_blocks) >> zone_shift;
 
 	/*
 	 * Initialize the device request queue information if the number
 	 * of zones changed.
 	 */
-	if (sdkp->nr_zones != q->nr_zones) {
-
-		sd_zbc_cleanup(sdkp);
-
-		q->nr_zones = sdkp->nr_zones;
-		if (sdkp->nr_zones) {
-			q->seq_zones_wlock = sd_zbc_alloc_zone_bitmap(sdkp);
-			if (!q->seq_zones_wlock) {
+	if (nr_zones != sdkp->nr_zones || nr_zones != q->nr_zones) {
+		unsigned long *seq_zones_wlock = NULL, *seq_zones_bitmap = NULL;
+		size_t zone_bitmap_size;
+
+		if (nr_zones) {
+			seq_zones_wlock = sd_zbc_alloc_zone_bitmap(nr_zones,
+								   q->node);
+			if (!seq_zones_wlock) {
 				ret = -ENOMEM;
 				goto err;
 			}
 
-			ret = sd_zbc_setup_seq_zones_bitmap(sdkp);
-			if (ret) {
-				sd_zbc_cleanup(sdkp);
+			seq_zones_bitmap = sd_zbc_setup_seq_zones_bitmap(sdkp,
+							zone_shift, nr_zones);
+			if (IS_ERR(seq_zones_bitmap)) {
+				ret = PTR_ERR(seq_zones_bitmap);
+				kfree(seq_zones_wlock);
 				goto err;
 			}
 		}
-
+		zone_bitmap_size = BITS_TO_LONGS(nr_zones) *
+			sizeof(unsigned long);
+		blk_mq_freeze_queue(q);
+		if (q->nr_zones != nr_zones) {
+			/* READ16/WRITE16 is mandatory for ZBC disks */
+			sdkp->device->use_16_for_rw = 1;
+			sdkp->device->use_10_for_rw = 0;
+
+			sdkp->zone_blocks = zone_blocks;
+			sdkp->zone_shift = zone_shift;
+			sdkp->nr_zones = nr_zones;
+			q->nr_zones = nr_zones;
+			swap(q->seq_zones_wlock, seq_zones_wlock);
+			swap(q->seq_zones_bitmap, seq_zones_bitmap);
+		} else if (memcmp(q->seq_zones_bitmap, seq_zones_bitmap,
+				  zone_bitmap_size) != 0) {
+			memcpy(q->seq_zones_bitmap, seq_zones_bitmap,
+			       zone_bitmap_size);
+		}
+		blk_mq_unfreeze_queue(q);
+		kfree(seq_zones_wlock);
+		kfree(seq_zones_bitmap);
 	}
 
 	return 0;
@@ -661,6 +680,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 
 int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
+	int64_t zone_blocks;
 	int ret;
 
 	if (!sd_is_zoned(sdkp))
@@ -697,12 +717,16 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	 * Check zone size: only devices with a constant zone size (except
 	 * an eventual last runt zone) that is a power of 2 are supported.
 	 */
-	ret = sd_zbc_check_zone_size(sdkp);
-	if (ret)
+	zone_blocks = sd_zbc_check_zone_size(sdkp);
+	ret = -EFBIG;
+	if (zone_blocks != (u32)zone_blocks)
+		goto err;
+	ret = zone_blocks;
+	if (ret < 0)
 		goto err;
 
 	/* The drive satisfies the kernel restrictions: set it up */
-	ret = sd_zbc_setup(sdkp);
+	ret = sd_zbc_setup(sdkp, zone_blocks);
 	if (ret)
 		goto err;
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c5b1bf1cadcb..00e79057f870 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -276,6 +276,35 @@ static inline void ufshcd_remove_non_printable(char *val)
 		*val = ' ';
 }
 
+static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned int tag,
+		const char *str)
+{
+	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+
+	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->sc.cdb);
+}
+
+static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba, unsigned int tag,
+		const char *str)
+{
+	struct utp_upiu_req *rq = hba->lrb[tag].ucd_req_ptr;
+
+	trace_ufshcd_upiu(dev_name(hba->dev), str, &rq->header, &rq->qr);
+}
+
+static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
+		const char *str)
+{
+	struct utp_task_req_desc *descp;
+	struct utp_upiu_task_req *task_req;
+	int off = (int)tag - hba->nutrs;
+
+	descp = &hba->utmrdl_base_addr[off];
+	task_req = (struct utp_upiu_task_req *)descp->task_req_upiu;
+	trace_ufshcd_upiu(dev_name(hba->dev), str, &task_req->header,
+			&task_req->input_param1);
+}
+
 static void ufshcd_add_command_trace(struct ufs_hba *hba,
 		unsigned int tag, const char *str)
 {
@@ -285,6 +314,9 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba,
 	struct ufshcd_lrb *lrbp;
 	int transfer_len = -1;
 
+	/* trace UPIU also */
+	ufshcd_add_cmd_upiu_trace(hba, tag, str);
+
 	if (!trace_ufshcd_command_enabled())
 		return;
 
@@ -2550,6 +2582,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	hba->dev_cmd.complete = &wait;
 
+	ufshcd_add_query_upiu_trace(hba, tag, "query_send");
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -2559,6 +2592,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
 
+	ufshcd_add_query_upiu_trace(hba, tag,
+			err ? "query_complete_err" : "query_complete");
+
 out_put_tag:
 	ufshcd_put_dev_cmd_tag(hba, tag);
 	wake_up(&hba->dev_cmd.tag_wq);
@@ -5443,11 +5479,14 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
+	ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_send");
+
 	/* wait until the task management command is completed */
 	err = wait_event_timeout(hba->tm_wq,
 			test_bit(free_slot, &hba->tm_condition),
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
+		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete_err");
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
 		if (ufshcd_clear_tm_cmd(hba, free_slot))
@@ -5456,6 +5495,7 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 		err = -ETIMEDOUT;
 	} else {
 		err = ufshcd_task_req_compl(hba, free_slot, tm_response);
+		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete");
 	}
 
 	clear_bit(free_slot, &hba->tm_condition);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 0d99b242e82e..6cb933ecc084 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -890,6 +890,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			bytes = min(bytes, data_len);
 
 			if (!bio) {
+new_bio:
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
 				nr_pages -= nr_vecs;
 				/*
@@ -931,6 +932,7 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				 * be allocated with pscsi_get_bio() above.
 				 */
 				bio = NULL;
+				goto new_bio;
 			}
 
 			data_len -= bytes;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9af3e0f430bc..21e21f273a21 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -605,6 +605,11 @@ struct request_queue {
 	 * initialized by the low level device driver (e.g. scsi/sd.c).
 	 * Stacking drivers (device mappers) may or may not initialize
 	 * these fields.
+	 *
+	 * Reads of this information must be protected with blk_queue_enter() /
+	 * blk_queue_exit(). Modifying this information is only allowed while
+	 * no requests are being processed. See also blk_mq_freeze_queue() and
+	 * blk_mq_unfreeze_queue().
 	 */
 	unsigned int		nr_zones;
 	unsigned long		*seq_zones_bitmap;
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 04e0679767f6..e03bd9d41fa8 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -11,8 +11,6 @@ struct scsi_sense_hdr;
 extern void scsi_print_command(struct scsi_cmnd *);
 extern size_t __scsi_format_command(char *, size_t,
 				   const unsigned char *, size_t);
-extern void scsi_show_extd_sense(const struct scsi_device *, const char *,
-				 unsigned char, unsigned char);
 extern void scsi_print_sense_hdr(const struct scsi_device *, const char *,
 				 const struct scsi_sense_hdr *);
 extern void scsi_print_sense(const struct scsi_cmnd *);
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index bf6f82673492..f8260e5c79ad 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -257,6 +257,33 @@ TRACE_EVENT(ufshcd_command,
 	)
 );
 
+TRACE_EVENT(ufshcd_upiu,
+	TP_PROTO(const char *dev_name, const char *str, void *hdr, void *tsf),
+
+	TP_ARGS(dev_name, str, hdr, tsf),
+
+	TP_STRUCT__entry(
+		__string(dev_name, dev_name)
+		__string(str, str)
+		__array(unsigned char, hdr, 12)
+		__array(unsigned char, tsf, 16)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev_name, dev_name);
+		__assign_str(str, str);
+		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
+		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
+	),
+
+	TP_printk(
+		"%s: %s: HDR:%s, CDB:%s",
+		__get_str(str), __get_str(dev_name),
+		__print_hex(__entry->hdr, sizeof(__entry->hdr)),
+		__print_hex(__entry->tsf, sizeof(__entry->tsf))
+	)
+);
+
 #endif /* if !defined(_TRACE_UFS_H) || defined(TRACE_HEADER_MULTI_READ) */
 
 /* This part must be outside protection */
