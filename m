From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: bfa: bfad_attr.c:  Optimization of the Code
Date: Wed,  4 Jun 2014 20:08:08 +0200
Message-ID: <1401905288-32642-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36968 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaFDSHP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 14:07:15 -0400
Received: by mail-wi0-f179.google.com with SMTP id bs8so2011253wib.6
        for <linux-scsi@vger.kernel.org>; Wed, 04 Jun 2014 11:07:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Minimized the use of snprintf()
And removed a variable that was only used for the temporary storage.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/bfa/bfad_attr.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 40be670..5f5917a 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -839,12 +839,10 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 	struct bfa_lport_attr_s port_attr;
-	char symname[BFA_SYMNAME_MAXLEN];
 
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
-	strncpy(symname, port_attr.port_cfg.sym_name.symname,
-			BFA_SYMNAME_MAXLEN);
-	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			port_attr.port_cfg.sym_name.symname);
 }
 
 static ssize_t
@@ -865,7 +863,9 @@ static ssize_t
 bfad_im_drv_version_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_VERSION);
+	strncpy(buf, BFAD_DRIVER_VERSION  "\n" , PAGE_SIZE);
+	buf[PAGE_SIZE - 1] = '\0';
+	return strlen(buf);
 }
 
 static ssize_t
@@ -913,7 +913,9 @@ static ssize_t
 bfad_im_drv_name_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_NAME);
+	strncpy(buf, BFAD_DRIVER_NAME  "\n" , PAGE_SIZE);
+	buf[PAGE_SIZE - 1] = '\0';
+	return strlen(buf);
 }
 
 static ssize_t
-- 
1.7.10.4

