Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92213C63709
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLHLEZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLHLDX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:03:23 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA38785669
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 03:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497296; x=1702033296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cwbeswERpri7S0OvuN19RuknsWkkKg0ZDb7ceoG2q0M=;
  b=LpxZtJmRvrnlZP3yCOJpdJlhYw9Hl5PYGHi/ggJQ+5uekerEuz6d/401
   XejCJR0+iqvRm2kEDa5jqPzzkIi7hMNoimnwyzbUiWwUIWUu8bYOi9Dhr
   mlpx6KLUr+h/zx7kr6hbDL9JG296Zl15sSieoWLCTdqdqxoD18RzBT9+L
   hXRtGqP8PcupEpNW6Mu8meb3XxtXwB75x1TWifWgudNL1VDulaCKH0zwS
   vVJJVbEqk68rSrp99yNF3LKY913jh7QmVDnPkFO3rTKrLGLg4GegLY5Ro
   CDasOqDfefnLLH/6M517hcHm6tWxV/C8opYYqNhddgnncmgqOnMIKFg2d
   g==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333432"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:36 +0800
IronPort-SDR: wgGEJ95nH18BIY1HLGBRC1cTJx2rNe08fFCOBBIPLp/JXQtYQOlH1bduNwEIVoZBD3KkfFbm3O
 oRpsdvTEnpm6kXfh6ZBz/ta5QX/2ZlrIuUpahBbYbds8h+50rKSpl1USNNMOVkc/y5wcmRxuTn
 IjAgICvgZ6SpHEtyZpBjQTKRSqSn9PFjGQN512fPsUFeNwNGc1M4Qu7imRkV5UCWx7YR40Qa3F
 MZ/z9CuoV0UVJpESjPQwDSPosSlDXl34dxZdOqagaJW3xDUtHItjPUDNepIPLZposGhI0AaDEP
 WNw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:14:21 -0800
IronPort-SDR: 2ieOg0b5XT/IpxmBgLoB2+B4LbZMyAAus109Lf2MZM42/Oo83FFKlKmz2v/8aMXXJr+te5iko/
 1GHUUz3jo0wx/kRJsF0On4p85BvTuylIURb58sv9g4jG53qTWjfCJ6n9sWQspiAUajbLyzmnkL
 Tyc33qmnnXdQBBxE/LMLBLFTOTgdmHjGEZytd8IPsbKhjJs3SkaKI/GvhIQl5CFIczYHFkz8SR
 yBqSiguEL/ugOXBoHRwy9oUKO8jCRGSpYJYzji29ypP24l3VNdR6jcnWHQBsYOQRb9kTi80AOn
 leM=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:35 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH 22/25] scsi: sd: set read/write commands CDL index
Date:   Thu,  8 Dec 2022 11:59:38 +0100
Message-Id: <20221208105947.2399894-23-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the command duration limits helper function
sd_cdl_cmd_limit() to retrieve and set the DLD bits of the
READ/WRITE 16 and READ/WRITE 32 commands to indicate to the device
the command duration limit descriptor to apply to the command.

When command duration limits are enabled, sd_cdl_cmd_limit() obtains the
index of the descriptor to apply to the command for requests that have
the IOPRIO_CLASS_DL priority class with a priority data sepcifying a
valid descriptor index (1 to 7).

The read-write sysfs attribute "enable" is introduced to control
setting the command duration limits indexes. If this attribute is set
to 0 (default), command duration limits specified by the user are
ignored. The user must set this attribute to 1 for command duration
limits to be set. Enabling and disabling the command duration limits
feature for ATA devices must be done using the ATA feature sub-page of
the control mode page. The sd_cdl_enable() function is introduced to
check if this mode page is supported by the device and if it is, use
it to enable/disable CDL.

Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/sd.c     |  16 +++--
 drivers/scsi/sd.h     |  10 ++++
 drivers/scsi/sd_cdl.c | 134 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 152 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 45ff44a73256..1f516910da0b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1042,13 +1042,14 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 
 static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
-				       unsigned char flags)
+				       unsigned char flags, unsigned int dld)
 {
 	cmd->cmd_len = SD_EXT_CDB_SIZE;
 	cmd->cmnd[0]  = VARIABLE_LENGTH_CMD;
 	cmd->cmnd[7]  = 0x18; /* Additional CDB len */
 	cmd->cmnd[9]  = write ? WRITE_32 : READ_32;
 	cmd->cmnd[10] = flags;
+	cmd->cmnd[11] = dld & 0x07;
 	put_unaligned_be64(lba, &cmd->cmnd[12]);
 	put_unaligned_be32(lba, &cmd->cmnd[20]); /* Expected Indirect LBA */
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[28]);
@@ -1058,12 +1059,12 @@ static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 
 static blk_status_t sd_setup_rw16_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
-				       unsigned char flags)
+				       unsigned char flags, unsigned int dld)
 {
 	cmd->cmd_len  = 16;
 	cmd->cmnd[0]  = write ? WRITE_16 : READ_16;
-	cmd->cmnd[1]  = flags;
-	cmd->cmnd[14] = 0;
+	cmd->cmnd[1]  = flags | ((dld >> 2) & 0x01);
+	cmd->cmnd[14] = (dld & 0x03) << 6;
 	cmd->cmnd[15] = 0;
 	put_unaligned_be64(lba, &cmd->cmnd[2]);
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
@@ -1126,6 +1127,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
 	bool write = rq_data_dir(rq) == WRITE;
 	unsigned char protect, fua;
+	unsigned int dld = 0;
 	blk_status_t ret;
 	unsigned int dif;
 	bool dix;
@@ -1175,6 +1177,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
 	dix = scsi_prot_sg_count(cmd);
 	dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
+	if (sd_cdl_enabled(sdkp))
+		dld = sd_cdl_dld(sdkp, cmd);
 
 	if (dif || dix)
 		protect = sd_setup_protect_cmnd(cmd, dix, dif);
@@ -1183,10 +1187,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
-					 protect | fua);
+					 protect | fua, dld);
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
-					 protect | fua);
+					 protect | fua, dld);
 	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
 		   sdp->use_10_for_rw || protect) {
 		ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index e60d33bd222a..5b6b6dc4b92d 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -130,8 +130,11 @@ struct sd_cdl_page {
 	struct sd_cdl_desc      descs[SD_CDL_MAX_DESC];
 };
 
+struct scsi_disk;
+
 struct sd_cdl {
 	struct kobject		kobj;
+	struct scsi_disk	*sdkp;
 	bool			sysfs_registered;
 	u8			perf_vs_duration_guideline;
 	struct sd_cdl_page	pages[SD_CDL_RW];
@@ -188,6 +191,7 @@ struct scsi_disk {
 	u8		zeroing_mode;
 	u8		nr_actuators;		/* Number of actuators */
 	struct sd_cdl	*cdl;
+	unsigned	cdl_enabled : 1;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
@@ -355,5 +359,11 @@ void sd_print_result(const struct scsi_disk *sdkp, const char *msg, int result);
 /* Command duration limits support (in sd_cdl.c) */
 void sd_read_cdl(struct scsi_disk *sdkp, unsigned char *buf);
 void sd_cdl_release(struct scsi_disk *sdkp);
+int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd);
+
+static inline bool sd_cdl_enabled(struct scsi_disk *sdkp)
+{
+	return sdkp->cdl && sdkp->cdl_enabled;
+}
 
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_cdl.c b/drivers/scsi/sd_cdl.c
index 513cd989f19a..59d02dbb5ea1 100644
--- a/drivers/scsi/sd_cdl.c
+++ b/drivers/scsi/sd_cdl.c
@@ -93,6 +93,63 @@ static const char *sd_cdl_policy_name(u8 policy)
 	}
 }
 
+/*
+ * Enable/disable CDL.
+ */
+static int sd_cdl_enable(struct scsi_disk *sdkp, bool enable)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mode_data data;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_vpd *vpd;
+	bool is_ata = false;
+	char buf[64];
+	int ret;
+
+	rcu_read_lock();
+	vpd = rcu_dereference(sdp->vpd_pg89);
+	if (vpd)
+		is_ata = true;
+	rcu_read_unlock();
+
+	/*
+	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
+	 */
+	if (is_ata) {
+		char *buf_data;
+		int len;
+
+		ret = scsi_mode_sense(sdp, 0x08, 0x0a, 0xf2, buf, sizeof(buf),
+				      SD_TIMEOUT, sdkp->max_retries, &data,
+				      NULL);
+		if (ret)
+			return -EINVAL;
+
+		/* Enable CDL using the ATA feature page */
+		len = min_t(size_t, sizeof(buf),
+			    data.length - data.header_length -
+			    data.block_descriptor_length);
+		buf_data = buf + data.header_length +
+			data.block_descriptor_length;
+		if (enable)
+			buf_data[4] = 0x02;
+		else
+			buf_data[4] = 0;
+
+		ret = scsi_mode_select(sdp, 1, 0, buf_data, len, SD_TIMEOUT,
+				       sdkp->max_retries, &data, &sshdr);
+		if (ret) {
+			if (scsi_sense_valid(&sshdr))
+				sd_print_sense_hdr(sdkp, &sshdr);
+			return -EINVAL;
+		}
+	}
+
+	sdkp->cdl_enabled = enable;
+
+	return 0;
+}
+
 /*
  * Command duration limits descriptors sysfs plumbing.
  */
@@ -324,6 +381,7 @@ static int sd_cdl_sysfs_register_page(struct scsi_disk *sdkp,
 struct sd_cdl_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct sd_cdl *cdl, char *buf);
+	ssize_t (*store)(struct sd_cdl *cdl, const char *buf, size_t length);
 };
 
 #define CDL_ATTR_RO(_name)	\
@@ -332,6 +390,13 @@ struct sd_cdl_sysfs_entry {
 		.show	= cdl_##_name##_show,				\
 	}
 
+#define CDL_ATTR_RW(_name)	\
+	static struct sd_cdl_sysfs_entry cdl_##_name##_entry = {	\
+		.attr	= { .name = __stringify(_name), .mode = 0644 },	\
+		.show	= cdl_##_name##_show,				\
+		.store	= cdl_##_name##_store,				\
+	}
+
 static ssize_t cdl_perf_vs_duration_guideline_show(struct sd_cdl *cdl,
 						   char *buf)
 {
@@ -340,8 +405,31 @@ static ssize_t cdl_perf_vs_duration_guideline_show(struct sd_cdl *cdl,
 }
 CDL_ATTR_RO(perf_vs_duration_guideline);
 
+static ssize_t cdl_enable_show(struct sd_cdl *cdl, char *buf)
+{
+	return sysfs_emit(buf, "%d\n", (int)cdl->sdkp->cdl_enabled);
+}
+
+static ssize_t cdl_enable_store(struct sd_cdl *cdl,
+				const char *buf, size_t count)
+{
+	int ret;
+	bool v;
+
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	ret = sd_cdl_enable(cdl->sdkp, v);
+	if (ret)
+		return ret;
+
+	return count;
+}
+CDL_ATTR_RW(enable);
+
 static struct attribute *sd_cdl_attrs[] = {
 	&cdl_perf_vs_duration_guideline_entry.attr,
+	&cdl_enable_entry.attr,
 	NULL,
 };
 
@@ -375,8 +463,25 @@ static ssize_t sd_cdl_sysfs_show(struct kobject *kobj,
 	return entry->show(cdl, page);
 }
 
+static ssize_t sd_cdl_sysfs_store(struct kobject *kobj, struct attribute *attr,
+				  const char *buf, size_t length)
+{
+	struct sd_cdl_sysfs_entry *entry =
+		container_of(attr, struct sd_cdl_sysfs_entry, attr);
+	struct sd_cdl *cdl = container_of(kobj, struct sd_cdl, kobj);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (!entry->store)
+		return -EIO;
+
+	return entry->store(cdl, buf, length);
+}
+
 static const struct sysfs_ops sd_cdl_sysfs_ops = {
 	.show	= sd_cdl_sysfs_show,
+	.store	= sd_cdl_sysfs_store,
 };
 
 static void sd_cdl_sysfs_release(struct kobject *kobj)
@@ -411,6 +516,7 @@ static void sd_cdl_sysfs_unregister(struct scsi_disk *sdkp)
 			sd_cdl_sysfs_unregister_page(&cdl->pages[i]);
 	}
 
+	cdl->sdkp->cdl_enabled = 0;
 	kobject_del(&cdl->kobj);
 	kobject_put(&cdl->kobj);
 }
@@ -689,7 +795,7 @@ static bool sd_cdl_supported(struct scsi_disk *sdkp, enum sd_cdlp *rw_cdlp,
 		rw_cdlp[SD_CDL_WRITE] != SD_CDLP_NONE;
 }
 
-static struct sd_cdl *sd_cdl_alloc(void)
+static struct sd_cdl *sd_cdl_alloc(struct scsi_disk *sdkp)
 {
 	struct sd_cdl *cdl;
 	struct sd_cdl_page *page;
@@ -699,6 +805,7 @@ static struct sd_cdl *sd_cdl_alloc(void)
 	if (!cdl)
 		return NULL;
 
+	cdl->sdkp = sdkp;
 	kobject_init(&cdl->kobj, &sd_cdl_ktype);
 	for (i = 0; i < SD_CDL_RW; i++) {
 		page = &cdl->pages[i];
@@ -725,7 +832,7 @@ void sd_read_cdl(struct scsi_disk *sdkp, unsigned char *buf)
 		goto unregister;
 
 	if (!cdl) {
-		cdl = sd_cdl_alloc();
+		cdl = sd_cdl_alloc(sdkp);
 		if (!cdl)
 			return;
 	}
@@ -762,3 +869,26 @@ void sd_cdl_release(struct scsi_disk *sdkp)
 {
 	sd_cdl_sysfs_unregister(sdkp);
 }
+
+/*
+ * Check if a command has a duration limit set. If it does, return the
+ * descriptor index to use and 0 if the command has no limit set.
+ */
+int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
+{
+	unsigned int ioprio = req_get_ioprio(scsi_cmd_to_rq(scmd));
+	unsigned int dld;
+
+	/*
+	 * Use "no limit" if the request ioprio class is not IOPRIO_CLASS_DL
+	 * or if the user specified an invalid CDL descriptor index.
+	 */
+	if (IOPRIO_PRIO_CLASS(ioprio) != IOPRIO_CLASS_DL)
+		return 0;
+
+	dld = IOPRIO_PRIO_DATA(ioprio);
+	if (dld > SD_CDL_MAX_DESC)
+		return 0;
+
+	return dld;
+}
-- 
2.38.1

