From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/3] scsi_transport_sas: add is_sas_attached() function
Date: Wed, 09 Dec 2015 11:12:03 -0800
Message-ID: <1449688323.2226.32.camel@HansenPartnership.com>
References: <1449688206.2226.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55096 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbbLITMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 14:12:05 -0500
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id AA4DC8EE0CC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 11:12:04 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B8rmGoQjhXFz for <linux-scsi@vger.kernel.org>;
	Wed,  9 Dec 2015 11:12:04 -0800 (PST)
Received: from [153.66.254.242] (unknown [184.11.141.41])
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3C8FD8EE04D
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 11:12:04 -0800 (PST)
In-Reply-To: <1449688206.2226.30.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adds a function designed to be callable any time (regardless of
whether the transport attributes are configured or not) which returns
true if the device is attached over a SAS transport.  The design of
this function is that transport specific functions can be embedded
within a

if (is_sas_attached(sdev)) {
	...
}

which would be compiled out (and thus eliminate the symbols) if SAS is
not configured.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_transport_sas.c |   16 ++++++++++++++++
 include/scsi/scsi_transport_sas.h |    9 +++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 30d26e3..b17f763 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -341,6 +341,22 @@ static int do_sas_phy_delete(struct device *dev, void *data)
 }
 
 /**
+ * is_sas_attached - check if device is SAS attached
+ * @sdev: scsi device to check
+ *
+ * returns true if the device is SAS attached
+ */
+int is_sas_attached(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+
+	return shost->transportt->host_attrs.ac.class ==
+		&sas_host_class.class;
+}
+EXPORT_SYMBOL(is_sas_attached);
+
+
+/**
  * sas_remove_children  -  tear down a devices SAS data structures
  * @dev:	device belonging to the sas object
  *
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index 0bd71e2..a8fdd10 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -10,6 +10,15 @@ struct scsi_transport_template;
 struct sas_rphy;
 struct request;
 
+#if !IS_ENABLED(CONFIG_SCSI_SAS_ATTRS)
+static inline int is_sas_attached(struct scsi_device *sdev)
+{
+	return 0;
+}
+#else
+extern int is_sas_attached(struct scsi_device *sdev);
+#endif
+
 static inline int sas_protocol_ata(enum sas_protocol proto)
 {
 	return ((proto & SAS_PROTOCOL_SATA) ||
-- 
1.7.4.1



