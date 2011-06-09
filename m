From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] ses: requesting a fault indication
Date: Thu, 09 Jun 2011 00:27:07 -0400
Message-ID: <4DF04B9B.7050509@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070404080202050704070001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44717 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1FIE10 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2011 00:27:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

This is a multi-part message in MIME format.
--------------070404080202050704070001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Noticed that when the sysfs interface of the SCSI SES
driver was used to request a fault indication the LED
flashed but the buzzer didn't sound. So it was doing
what REQUEST IDENT (locate) should do.

Changelog:
   - fix the setting of REQUEST FAULT for the device slot
     and array device slot elements in the enclosure control
     diagnostic page
   - note the potentially defective code that reads the
     FAULT SENSED and FAULT REQUESTED bits from the enclosure
     status diagnostic page

The attached patch is against git/scsi-misc-2.6

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------070404080202050704070001
Content-Type: text/x-patch;
 name="ses20110608.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ses20110608.patch"

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index eb7a3e8..eba183c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -160,6 +160,10 @@ static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
 	return NULL;
 }
 
+/* For device slot and array device slot elements, byte 3 bit 6
+ * is "fault sensed" while byte 3 bit 5 is "fault reqstd". As this
+ * code stands these bits are shifted 4 positions right so in
+ * sysfs they will appear as bits 2 and 1 respectively. Strange. */
 static void ses_get_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp)
 {
@@ -181,7 +185,7 @@ static int ses_set_fault(struct enclosure_device *edev,
 		/* zero is disabled */
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] = 0x02;
+		desc[3] = 0x20;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */

--------------070404080202050704070001--
