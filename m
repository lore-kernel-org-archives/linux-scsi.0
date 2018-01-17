From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [RFC PATCH] scsi: sd: add wce_rcd sysfs interface
Date: Wed, 17 Jan 2018 20:49:52 +0800
Message-ID: <20180117124945.GA7787@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.didichuxing.com ([36.110.17.22]:2582 "EHLO
        BJEXCAS004.didichuxing.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752675AbeAQMuL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jan 2018 07:50:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

add user friendly interface wce_rcd to enable/disable
write&read cache. The code base on cache_type, but need short input.

enable both write and read cache:
echo "10" > wce_rcd

wce rcd write_cache read_cache
0   0   off         on
0   1   off         off
1   0   on          on
1   1   on          off

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/sd.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a028ab3..9ab210c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -139,6 +139,15 @@ static const char *sd_cache_types[] = {
 	"write back, no read (daft)"
 };
 
+/*
+ * wce rcd write_cache read_cache
+ * 0   0   off         on
+ * 0   1   off         off
+ * 1   0   on          on
+ * 1   1   on          off
+ */
+static const char * const sd_wce_rcd[] = {"00", "01", "10", "11"};
+
 static void sd_set_flush_flag(struct scsi_disk *sdkp)
 {
 	bool wc = false, fua = false;
@@ -287,6 +296,80 @@ cache_type_show(struct device *dev, struct device_attribute *attr, char *buf)
 static DEVICE_ATTR_RW(cache_type);
 
 static ssize_t
+wce_rcd_store(struct device *dev, struct device_attribute *attr,
+		 const char *buf, size_t count)
+{
+	int ct, rcd, wce, sp;
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+	char buffer[64];
+	char *buffer_data;
+	struct scsi_mode_data data;
+	struct scsi_sense_hdr sshdr;
+	static const char temp[] = "temp ";
+	int len;
+
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
+		/* no cache control on RBC devices; theoretically they
+		 * can do it, but there's probably so many exceptions
+		 * it's not worth the risk
+		 */
+		return -EINVAL;
+
+	if (strncmp(buf, temp, sizeof(temp) - 1) == 0) {
+		buf += sizeof(temp) - 1;
+		sdkp->cache_override = 1;
+	} else {
+		sdkp->cache_override = 0;
+	}
+
+	ct = sysfs_match_string(sd_wce_rcd, buf);
+	if (ct < 0)
+		return -EINVAL;
+
+	rcd = ct & 0x01 ? 1 : 0;
+	wce = (ct & 0x02) && !sdkp->write_prot ? 1 : 0;
+
+	if (sdkp->cache_override) {
+		sdkp->WCE = wce;
+		sdkp->RCD = rcd;
+		sd_set_flush_flag(sdkp);
+		return count;
+	}
+
+	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
+			    SD_MAX_RETRIES, &data, NULL))
+		return -EINVAL;
+	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
+		  data.block_descriptor_length);
+	buffer_data = buffer + data.header_length +
+		data.block_descriptor_length;
+	buffer_data[2] &= ~0x05;
+	buffer_data[2] |= wce << 2 | rcd;
+	sp = buffer_data[0] & 0x80 ? 1 : 0;
+	buffer_data[0] &= ~0x80;
+
+	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
+			     SD_MAX_RETRIES, &data, &sshdr)) {
+		if (scsi_sense_valid(&sshdr))
+			sd_print_sense_hdr(sdkp, &sshdr);
+		return -EINVAL;
+	}
+	revalidate_disk(sdkp->disk);
+	return count;
+}
+
+static ssize_t
+wce_rcd_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	int ct = sdkp->RCD + 2*sdkp->WCE;
+
+	return sprintf(buf, "%s\n", sd_wce_rcd[ct]);
+}
+static DEVICE_ATTR_RW(wce_rcd);
+
+static ssize_t
 FUA_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
@@ -524,6 +607,7 @@ static DEVICE_ATTR_RW(max_write_same_blocks);
 
 static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_cache_type.attr,
+	&dev_attr_wce_rcd.attr,
 	&dev_attr_FUA.attr,
 	&dev_attr_allow_restart.attr,
 	&dev_attr_manage_start_stop.attr,
-- 
2.9.4
