From: sumit.saxena@avagotech.com
Subject: [PATCH v3 7/10] megaraid_sas : Print critical fw event message
Date: Mon, 31 Aug 2015 17:23:51 +0530
Message-ID: <201508311159.t7VBxK5W031425@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sgpsmtp1.avagotech.com ([202.86.248.61]:41236 "EHLO
	sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbHaLy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 07:54:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Print firmware event in readable format. This will help user to track any
critical firmware event without any application support.

sample syslogd output -

megaraid_sas 0000:02:00.0: 8619 (491648347s/0x0020/WARN) - Controller temperature threshold exceeded. This may indicate inadequate system cooling. Switching to low performance mode

Format of print is - "<pci_dev_id>: <sequence_number> (<timestamp>/<locale>/<class>) - <description>"

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |   10 +++++
 drivers/scsi/megaraid/megaraid_sas_base.c |   61 +++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5db31c6..ccda60d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -273,6 +273,16 @@ enum MFI_STAT {
 	MFI_STAT_INVALID_STATUS = 0xFF
 };
 
+enum mfi_evt_class {
+	MFI_EVT_CLASS_DEBUG =		-2,
+	MFI_EVT_CLASS_PROGRESS =	-1,
+	MFI_EVT_CLASS_INFO =		0,
+	MFI_EVT_CLASS_WARNING =		1,
+	MFI_EVT_CLASS_CRITICAL =	2,
+	MFI_EVT_CLASS_FATAL =		3,
+	MFI_EVT_CLASS_DEAD =		4
+};
+
 /*
  * Crash dump related defines
  */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 1943c14..3a824cb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -260,6 +260,66 @@ megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 
 }
 
+static const char *
+format_timestamp(uint32_t timestamp)
+{
+	static char buffer[32];
+
+	if ((timestamp & 0xff000000) == 0xff000000)
+		snprintf(buffer, sizeof(buffer), "boot + %us", timestamp &
+		0x00ffffff);
+	else
+		snprintf(buffer, sizeof(buffer), "%us", timestamp);
+	return buffer;
+}
+
+static const char *
+format_class(int8_t class)
+{
+	static char buffer[6];
+
+	switch (class) {
+	case MFI_EVT_CLASS_DEBUG:
+		return "debug";
+	case MFI_EVT_CLASS_PROGRESS:
+		return "progress";
+	case MFI_EVT_CLASS_INFO:
+		return "info";
+	case MFI_EVT_CLASS_WARNING:
+		return "WARN";
+	case MFI_EVT_CLASS_CRITICAL:
+		return "CRIT";
+	case MFI_EVT_CLASS_FATAL:
+		return "FATAL";
+	case MFI_EVT_CLASS_DEAD:
+		return "DEAD";
+	default:
+		snprintf(buffer, sizeof(buffer), "%d", class);
+		return buffer;
+	}
+}
+
+/**
+  * megasas_decode_evt: Decode FW AEN event and print critical event
+  * for information.
+  * @instance:			Adapter soft state
+  */
+static void
+megasas_decode_evt(struct megasas_instance *instance)
+{
+	struct megasas_evt_detail *evt_detail = instance->evt_detail;
+	union megasas_evt_class_locale class_locale;
+	class_locale.word = le32_to_cpu(evt_detail->cl.word);
+
+	if (class_locale.members.class >= MFI_EVT_CLASS_CRITICAL)
+		dev_info(&instance->pdev->dev, "%d (%s/0x%04x/%s) - %s\n",
+			le32_to_cpu(evt_detail->seq_num),
+			format_timestamp(le32_to_cpu(evt_detail->time_stamp)),
+			(class_locale.members.locale),
+			format_class(class_locale.members.class),
+			evt_detail->description);
+}
+
 /**
 *	The following functions are defined for xscale
 *	(deviceid : 1064R, PERC5) controllers
@@ -6602,6 +6662,7 @@ megasas_aen_polling(struct work_struct *work)
 	instance->ev = NULL;
 	host = instance->host;
 	if (instance->evt_detail) {
+		megasas_decode_evt(instance);
 
 		switch (le32_to_cpu(instance->evt_detail->code)) {
 		case MR_EVT_PD_INSERTED:
-- 
1.7.1

