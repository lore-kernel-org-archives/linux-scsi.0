Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B64C47425
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 15:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FCD9206C1
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 15:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wkBS9o8b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732431AbgJAPgf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 11:36:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60566 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732681AbgJAPgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 11:36:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091FJcwb036657;
        Thu, 1 Oct 2020 15:36:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=VmkDy27Mbd2A5RxXCOMwnTduBl0BzYPMZQLkmdvBCSE=;
 b=wkBS9o8b808Z77qxcjxSwrU2aRxU/i1GtIgAiNCBidpNoCeEo0slBpBKD/N1Ri8GbkOF
 5b3/jzuRhZoVYoFyiiFNo3JWpKddKUJ42mGT9lQK8UdUjKA7YgIMKIWeXAGvK6dtAQvi
 dKBCzjFR3u8HtIym3DQycEqC1zK6yQ4f75U3lbSObpmHSqVzvB7DRkhgLmim1BMav2qs
 6xyGSH+Q0jTxCMFTMWtoP/T/SwIcdLPTaWyFJfhMXNsmoYRbXGQX2xHDEpEPoxBL5GI+
 Jffo6nPbS7IIUCVCXOiBERt8d+JQ8FbQSmwKGEqhosKxb6ccjvRIcJmkeT7A1sanX0b5 tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkm6quk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 15:36:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091FKrXm182440;
        Thu, 1 Oct 2020 15:36:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdw0sux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 15:36:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 091Fa2kb008665;
        Thu, 1 Oct 2020 15:36:02 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 08:36:02 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 2/2] scsi sd: Allow user to config cmd retries
Date:   Thu,  1 Oct 2020 10:35:54 -0500
Message-Id: <1601566554-26752-3-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601566554-26752-1-git-send-email-michael.christie@oracle.com>
References: <1601566554-26752-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010132
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some iSCSI targets went the traditional export N ports and then allowed
the initiator to multipath over them. Other targets went the opposite
direction and export 1 port, and then software on the target side
performs load balancing and failover to other targets via a iscsi
specific feature or IP takover.

The problem for the 2nd type of config is we quickly run out of our
five retries and get IO errors. In these setups we want to reduce
resource use on the initaitor side so we only wanted the one session
and no dm-multipath. To handle traditional multipath operations like
failover we do IP takover on the target side. So we would have a
iscsi target running on node1. Some monitoring software decides it's
dead or the node is overloaded, so it starts the iscsi target on
node2. The problem is for the failover case where we might have the
equivalent of a dm-multipath temp all paths down, or we just have to
try more than 5 nodes before finding a good one.

To handle this type of issue, this patch allows the user to config
the disk cmd retries from -1 to the current max of 5. -1 means
infinite retries and should be used for setups where some other
setting is going to control when to fail. For example iscsi has the
replacement/recovery timeout and fc (some users have used FC with
NPIV and done something similar as IP takover) has
dev_loss_tmo/fast_io_fail which will eventually expire and fail IO.

Note:
One alternative to this patch would be to make it transport class
setting, then have it hook in to where we can config the
scsi_cmnd->allowed value. I put the setting in sd_mod because I
thought users might want to lower retries for the general case.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

---
 drivers/scsi/sd.c | 101 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/sd.h |   1 +
 2 files changed, 72 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 16503e22691e..162b996334e5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -194,7 +194,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
-			    SD_MAX_RETRIES, &data, NULL))
+			    sdkp->max_retries, &data, NULL))
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
 		  data.block_descriptor_length);
@@ -212,7 +212,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	data.device_specific = 0;
 
 	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
-			     SD_MAX_RETRIES, &data, &sshdr)) {
+			     sdkp->max_retries, &data, &sshdr)) {
 		if (scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
@@ -543,6 +543,39 @@ zoned_cap_show(struct device *dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR_RO(zoned_cap);
 
+static ssize_t
+max_retries_store(struct device *dev, struct device_attribute *attr,
+		  const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdev = sdkp->device;
+	int retries, err;
+
+	err = kstrtoint(buf, 10, &retries);
+	if (err)
+		return err;
+
+	if (retries == SCSI_CMD_RETRIES_NO_LIMIT || retries <= SD_MAX_RETRIES) {
+		sdkp->max_retries = retries;
+		return count;
+	}
+
+	sdev_printk(KERN_ERR, sdev, "max_retries must be between -1 and %d\n",
+		    SD_MAX_RETRIES);
+	return -EINVAL;
+}
+
+static ssize_t
+max_retries_show(struct device *dev, struct device_attribute *attr,
+		 char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return sprintf(buf, "%d\n", sdkp->max_retries);
+}
+
+static DEVICE_ATTR_RW(max_retries);
+
 static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_cache_type.attr,
 	&dev_attr_FUA.attr,
@@ -557,6 +590,7 @@ static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_max_write_same_blocks.attr,
 	&dev_attr_max_medium_access_timeouts.attr,
 	&dev_attr_zoned_cap.attr,
+	&dev_attr_max_retries.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sd_disk);
@@ -665,7 +699,8 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 		size_t len, bool send)
 {
-	struct scsi_device *sdev = data;
+	struct scsi_disk *sdkp = data;
+	struct scsi_device *sdev = sdkp->device;
 	u8 cdb[12] = { 0, };
 	int ret;
 
@@ -676,7 +711,7 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 
 	ret = scsi_execute_req(sdev, cdb,
 			send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
-			buffer, len, NULL, SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+			buffer, len, NULL, SD_TIMEOUT, sdkp->max_retries, NULL);
 	return ret <= 0 ? ret : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
@@ -839,6 +874,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	unsigned int data_len = 24;
@@ -862,7 +898,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	put_unaligned_be64(lba, &buf[8]);
 	put_unaligned_be32(nr_blocks, &buf[16]);
 
-	cmd->allowed = SD_MAX_RETRIES;
+	cmd->allowed = sdkp->max_retries;
 	cmd->transfersize = data_len;
 	rq->timeout = SD_TIMEOUT;
 
@@ -874,6 +910,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
@@ -893,7 +930,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	put_unaligned_be64(lba, &cmd->cmnd[2]);
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
 
-	cmd->allowed = SD_MAX_RETRIES;
+	cmd->allowed = sdkp->max_retries;
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
@@ -905,6 +942,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
@@ -924,7 +962,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	put_unaligned_be32(lba, &cmd->cmnd[2]);
 	put_unaligned_be16(nr_blocks, &cmd->cmnd[7]);
 
-	cmd->allowed = SD_MAX_RETRIES;
+	cmd->allowed = sdkp->max_retries;
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
@@ -1056,7 +1094,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	}
 
 	cmd->transfersize = sdp->sector_size;
-	cmd->allowed = SD_MAX_RETRIES;
+	cmd->allowed = sdkp->max_retries;
 
 	/*
 	 * For WRITE SAME the data transferred via the DATA OUT buffer is
@@ -1078,6 +1116,7 @@ static blk_status_t sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
 	/* flush requests don't perform I/O, zero the S/G table */
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
@@ -1085,7 +1124,7 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 	cmd->cmnd[0] = SYNCHRONIZE_CACHE;
 	cmd->cmd_len = 10;
 	cmd->transfersize = 0;
-	cmd->allowed = SD_MAX_RETRIES;
+	cmd->allowed = sdkp->max_retries;
 
 	rq->timeout = rq->q->rq_timeout * SD_FLUSH_TIMEOUT_MULTIPLIER;
 	return BLK_STS_OK;
@@ -1262,7 +1301,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	 */
 	cmd->transfersize = sdp->sector_size;
 	cmd->underflow = nr_blocks << 9;
-	cmd->allowed = SD_MAX_RETRIES;
+	cmd->allowed = sdkp->max_retries;
 	cmd->sdb.length = nr_blocks * sdp->sector_size;
 
 	SCSI_LOG_HLQUEUE(1,
@@ -1609,7 +1648,7 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	if (scsi_block_when_processing_errors(sdp)) {
 		struct scsi_sense_hdr sshdr = { 0, };
 
-		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
+		retval = scsi_test_unit_ready(sdp, SD_TIMEOUT, sdkp->max_retries,
 					      &sshdr);
 
 		/* failed to execute TUR, assume media not present */
@@ -1666,7 +1705,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * flush everything.
 		 */
 		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
-				timeout, SD_MAX_RETRIES, 0, RQF_PM, NULL);
+				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
 		if (res == 0)
 			break;
 	}
@@ -1761,7 +1800,8 @@ static char sd_pr_type(enum pr_type type)
 static int sd_pr_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
-	struct scsi_device *sdev = scsi_disk(bdev->bd_disk)->device;
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	int result;
 	u8 cmd[16] = { 0, };
@@ -1777,7 +1817,7 @@ static int sd_pr_command(struct block_device *bdev, u8 sa,
 	data[20] = flags;
 
 	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
-			&sshdr, SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+			&sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
 
 	if (driver_byte(result) == DRIVER_SENSE &&
 	    scsi_sense_valid(&sshdr)) {
@@ -2114,7 +2154,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			the_result = scsi_execute_req(sdkp->device, cmd,
 						      DMA_NONE, NULL, 0,
 						      &sshdr, SD_TIMEOUT,
-						      SD_MAX_RETRIES, NULL);
+						      sdkp->max_retries, NULL);
 
 			/*
 			 * If the drive has indicated to us that it
@@ -2170,7 +2210,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 					cmd[4] |= 1 << 4;
 				scsi_execute_req(sdkp->device, cmd, DMA_NONE,
 						 NULL, 0, &sshdr,
-						 SD_TIMEOUT, SD_MAX_RETRIES,
+						 SD_TIMEOUT, sdkp->max_retries,
 						 NULL);
 				spintime_expire = jiffies + 100 * HZ;
 				spintime = 1;
@@ -2312,7 +2352,7 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					buffer, RC16_LEN, &sshdr,
-					SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+					SD_TIMEOUT, sdkp->max_retries, NULL);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2397,7 +2437,7 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
 					buffer, 8, &sshdr,
-					SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+					SD_TIMEOUT, sdkp->max_retries, NULL);
 
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
@@ -2582,12 +2622,12 @@ sd_print_capacity(struct scsi_disk *sdkp,
 
 /* called with buffer of length 512 */
 static inline int
-sd_do_mode_sense(struct scsi_device *sdp, int dbd, int modepage,
+sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data,
 		 struct scsi_sense_hdr *sshdr)
 {
-	return scsi_mode_sense(sdp, dbd, modepage, buffer, len,
-			       SD_TIMEOUT, SD_MAX_RETRIES, data,
+	return scsi_mode_sense(sdkp->device, dbd, modepage, buffer, len,
+			       SD_TIMEOUT, sdkp->max_retries, data,
 			       sshdr);
 }
 
@@ -2610,14 +2650,14 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	if (sdp->use_192_bytes_for_3f) {
-		res = sd_do_mode_sense(sdp, 0, 0x3F, buffer, 192, &data, NULL);
+		res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 192, &data, NULL);
 	} else {
 		/*
 		 * First attempt: ask for all pages (0x3F), but only 4 bytes.
 		 * We have to start carefully: some devices hang if we ask
 		 * for more than is available.
 		 */
-		res = sd_do_mode_sense(sdp, 0, 0x3F, buffer, 4, &data, NULL);
+		res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 4, &data, NULL);
 
 		/*
 		 * Second attempt: ask for page 0 When only page 0 is
@@ -2626,13 +2666,13 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		 * CDB.
 		 */
 		if (!scsi_status_is_good(res))
-			res = sd_do_mode_sense(sdp, 0, 0, buffer, 4, &data, NULL);
+			res = sd_do_mode_sense(sdkp, 0, 0, buffer, 4, &data, NULL);
 
 		/*
 		 * Third attempt: ask 255 bytes, as we did earlier.
 		 */
 		if (!scsi_status_is_good(res))
-			res = sd_do_mode_sense(sdp, 0, 0x3F, buffer, 255,
+			res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 255,
 					       &data, NULL);
 	}
 
@@ -2694,7 +2734,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	/* cautiously ask */
-	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, first_len,
+	res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, first_len,
 			&data, &sshdr);
 
 	if (!scsi_status_is_good(res))
@@ -2726,7 +2766,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 
 	/* Get the data */
 	if (len > first_len)
-		res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len,
+		res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, len,
 				&data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
@@ -2845,7 +2885,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 		return;
 
 	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
-			      SD_MAX_RETRIES, &data, &sshdr);
+			      sdkp->max_retries, &data, &sshdr);
 
 	if (!scsi_status_is_good(res) || !data.header_length ||
 	    data.length < 6) {
@@ -3368,6 +3408,7 @@ static int sd_probe(struct device *dev)
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
 	sdkp->index = index;
+	sdkp->max_retries = SD_MAX_RETRIES;
 	atomic_set(&sdkp->openers, 0);
 	atomic_set(&sdkp->device->ioerr_cnt, 0);
 
@@ -3431,7 +3472,7 @@ static int sd_probe(struct device *dev)
 	sd_revalidate_disk(gd);
 
 	if (sdkp->security) {
-		sdkp->opal_dev = init_opal_dev(sdp, &sd_sec_submit);
+		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
 			sd_printk(KERN_NOTICE, sdkp, "supports TCG Opal\n");
 	}
@@ -3546,7 +3587,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 		return -ENODEV;
 
 	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-			SD_TIMEOUT, SD_MAX_RETRIES, 0, RQF_PM, NULL);
+			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (driver_byte(res) == DRIVER_SENSE)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index a3aad608bc38..b59136c4125b 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -90,6 +90,7 @@ struct scsi_disk {
 #endif
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
+	int		max_retries;
 	u32		max_xfer_blocks;
 	u32		opt_xfer_blocks;
 	u32		max_ws_blocks;
-- 
2.18.2

