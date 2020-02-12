Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C89BC352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A2624671
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QY9d8n1r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgBLVoq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:44:46 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38036 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVop (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:44:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLf6WF001716;
        Wed, 12 Feb 2020 13:44:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=jIThZWMX8yc+xcnRaR/7kpy3SqPT8KA3VjTn6wPcr00=;
 b=QY9d8n1rwoNlfY2ISIKOxHzrW1xUDq79pRnYAnieD+irU+2HhTuw2JURqhXQsp7E7JUA
 +Q3wnQ+Hl0g/AJpSGS/LO8meosUEHe5d6mjNnzt7ddtMLli/zaXqRVHRGt1V3pr1TEvT
 ehlgHACFRr76lmCqdD/ut1/Fe2m46Mkz351xTKkwG3qZNBoGxe/mOeTNJLoR0OJseKfp
 kDFTsLTEGMM1IiY6ak5g5fx/ZUuwlZbTQn0X5V2K+2ueSbumz1CgQsQJNEqW4rDB4H5l
 b06bfyDTl77IiYnAnwIgSBO9i0SFtZ2YSNTiMRKfs3D3j5ytDhkeiddWaiJRw1lE+64P 7g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:44:41 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:39 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:44:39 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8C0B13F703F;
        Wed, 12 Feb 2020 13:44:39 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLidON025571;
        Wed, 12 Feb 2020 13:44:39 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLidfu025570;
        Wed, 12 Feb 2020 13:44:39 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 01/25] qla2xxx: Add beacon LED config sysfs interface
Date:   Wed, 12 Feb 2020 13:44:12 -0800
Message-ID: <20200212214436.25532-2-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

This patch Provides interface to do the following
(using MBC 0x3B):
- Displays (in hex) the LED config words for all
  three LEDs.
- Programs the config words for one LED or for all
  three LEDs.

The sysfs node defined is named beacon_config.

First, to allow driver to gain LED control, do this:
 # echo 1 > /sys/class/scsi_host/host#/beacon

Then, to display config words for all three LEDs do this:
 # cat /sys/class/scsi_host/host#/beacon_config

To set config words for all three LEDs do this:
 # echo 3 xxxx yyyy zzzz > /sys/class/scsi_host/host#/beacon_config

Or, to set config word for a specific single LED n do this:
 # echo n xxxx > /sys/class/scsi_host/host#/beacon_config
  where n is the LED number (0, 1, 2)

Finally, to restore LED control back to firmware, do this:
 # echo 0 > /sys/class/scsi_host/host#/beacon

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 76 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |  1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_mbx.c  | 57 +++++++++++++++++++++++++++++++
 4 files changed, 135 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index d7e7043f9eab..927115dc2526 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1324,6 +1324,79 @@ qla2x00_beacon_store(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+qla2x00_beacon_config_show(struct device *dev, struct device_attribute *attr,
+    char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t led[3] = { 0 };
+
+	if (!IS_QLA2031(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		return -EPERM;
+
+	if (ql26xx_led_config(vha, 0, led))
+		return scnprintf(buf, PAGE_SIZE, "\n");
+
+	return scnprintf(buf, PAGE_SIZE, "%#04hx %#04hx %#04hx\n",
+	    led[0], led[1], led[2]);
+}
+
+static ssize_t
+qla2x00_beacon_config_store(struct device *dev, struct device_attribute *attr,
+    const char *buf, size_t count)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t options = BIT_0;
+	uint16_t led[3] = { 0 };
+	uint16_t word[4];
+	int n;
+
+	if (!IS_QLA2031(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		return -EPERM;
+
+	n = sscanf(buf, "%hx %hx %hx %hx", word+0, word+1, word+2, word+3);
+	if (n == 4) {
+		if (word[0] == 3) {
+			options |= BIT_3|BIT_2|BIT_1;
+			led[0] = word[1];
+			led[1] = word[2];
+			led[2] = word[3];
+			goto write;
+		}
+		return -EINVAL;
+	}
+
+	if (n == 2) {
+		/* check led index */
+		if (word[0] == 0) {
+			options |= BIT_2;
+			led[0] = word[1];
+			goto write;
+		}
+		if (word[0] == 1) {
+			options |= BIT_3;
+			led[1] = word[1];
+			goto write;
+		}
+		if (word[0] == 2) {
+			options |= BIT_1;
+			led[2] = word[1];
+			goto write;
+		}
+		return -EINVAL;
+	}
+
+	return -EINVAL;
+
+write:
+	if (ql26xx_led_config(vha, options, led))
+		return -EFAULT;
+
+	return count;
+}
+
+static ssize_t
 qla2x00_optrom_bios_version_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -2264,6 +2337,8 @@ static DEVICE_ATTR(zio_timer, S_IRUGO | S_IWUSR, qla2x00_zio_timer_show,
 		   qla2x00_zio_timer_store);
 static DEVICE_ATTR(beacon, S_IRUGO | S_IWUSR, qla2x00_beacon_show,
 		   qla2x00_beacon_store);
+static DEVICE_ATTR(beacon_config, 0644, qla2x00_beacon_config_show,
+		   qla2x00_beacon_config_store);
 static DEVICE_ATTR(optrom_bios_version, S_IRUGO,
 		   qla2x00_optrom_bios_version_show, NULL);
 static DEVICE_ATTR(optrom_efi_version, S_IRUGO,
@@ -2327,6 +2402,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_zio,
 	&dev_attr_zio_timer,
 	&dev_attr_beacon,
+	&dev_attr_beacon_config,
 	&dev_attr_optrom_bios_version,
 	&dev_attr_optrom_efi_version,
 	&dev_attr_optrom_fcode_version,
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ed32e9715794..b59643883ad1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1134,6 +1134,7 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
 #define MBC_GET_FIRMWARE_OPTION		0x28	/* Get Firmware Options. */
 #define MBC_GET_MEM_OFFLOAD_CNTRL_STAT	0x34	/* Memory Offload ctrl/Stat*/
 #define MBC_SET_FIRMWARE_OPTION		0x38	/* Set Firmware Options. */
+#define MBC_SET_GET_FC_LED_CONFIG	0x3b	/* Set/Get FC LED config */
 #define MBC_LOOP_PORT_BYPASS		0x40	/* Loop Port Bypass. */
 #define MBC_LOOP_PORT_ENABLE		0x41	/* Loop Port Enable. */
 #define MBC_GET_RESOURCE_COUNTS		0x42	/* Get Resource Counts. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 2a64729a2bc5..156ad11a15c4 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -844,6 +844,7 @@ extern void qla82xx_clear_pending_mbx(scsi_qla_host_t *);
 extern int qla82xx_read_temperature(scsi_qla_host_t *);
 extern int qla8044_read_temperature(scsi_qla_host_t *);
 extern int qla2x00_read_sfp_dev(struct scsi_qla_host *, char *, int);
+extern int ql26xx_led_config(scsi_qla_host_t *, uint16_t, uint16_t *);
 
 /* BSG related functions */
 extern int qla24xx_bsg_request(struct bsg_job *);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9e09964f5c0e..e1916bec5e36 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6688,3 +6688,60 @@ int qla2xxx_read_remote_register(scsi_qla_host_t *vha, uint32_t addr,
 
 	return rval;
 }
+
+int
+ql26xx_led_config(scsi_qla_host_t *vha, uint16_t options, uint16_t *led)
+{
+	struct qla_hw_data *ha = vha->hw;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int rval;
+
+	if (!IS_QLA2031(ha) && !IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx, vha, 0x7070, "Entered %s (options=%x).\n",
+	    __func__, options);
+
+	mcp->mb[0] = MBC_SET_GET_FC_LED_CONFIG;
+	mcp->mb[1] = options;
+	mcp->out_mb = MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	if (options & BIT_0) {
+		if (options & BIT_1) {
+			mcp->mb[2] = led[2];
+			mcp->out_mb |= MBX_2;
+		}
+		if (options & BIT_2) {
+			mcp->mb[3] = led[0];
+			mcp->out_mb |= MBX_3;
+		}
+		if (options & BIT_3) {
+			mcp->mb[4] = led[1];
+			mcp->out_mb |= MBX_4;
+		}
+	} else {
+		mcp->in_mb |= MBX_4|MBX_3|MBX_2;
+	}
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval) {
+		ql_dbg(ql_dbg_mbx, vha, 0x7071, "Failed %s %x (mb=%x,%x)\n",
+		    __func__, rval, mcp->mb[0], mcp->mb[1]);
+		return rval;
+	}
+
+	if (options & BIT_0) {
+		ha->beacon_blink_led = 0;
+		ql_dbg(ql_dbg_mbx, vha, 0x7072, "Done %s\n", __func__);
+	} else {
+		led[2] = mcp->mb[2];
+		led[0] = mcp->mb[3];
+		led[1] = mcp->mb[4];
+		ql_dbg(ql_dbg_mbx, vha, 0x7073, "Done %s (led=%x,%x,%x)\n",
+		    __func__, led[0], led[1], led[2]);
+	}
+
+	return rval;
+}
-- 
2.12.0

