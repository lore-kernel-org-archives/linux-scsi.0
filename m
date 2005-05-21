From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sat, 21 May 2005 10:24:37 -0500
Message-ID: <1116689077.4999.9.camel@mulgrave>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2258 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261595AbVEUPYx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 11:24:53 -0400
In-Reply-To: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

Here's a tiny update that means we print the correct ASCII type
information

James

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -111,6 +111,7 @@ const char *const scsi_device_types[MAX_
 	"Unknown          ",
 	"RAID             ",
 	"Enclosure        ",
+	"Direct-Access-RBC",
 };
 EXPORT_SYMBOL(scsi_device_types);
 
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -28,7 +28,7 @@ extern const unsigned char scsi_command_
  *	SCSI device types
  */
 
-#define MAX_SCSI_DEVICE_CODE 14
+#define MAX_SCSI_DEVICE_CODE 15
 extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
 
 /*
@@ -211,8 +211,8 @@ static inline int scsi_status_is_good(in
 				     * - treated as TYPE_DISK */
 #define TYPE_MEDIUM_CHANGER 0x08
 #define TYPE_COMM           0x09    /* Communications device */
-#define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RAID           0x0c
+#define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RBC	    0x0e
 #define TYPE_NO_LUN         0x7f
 


