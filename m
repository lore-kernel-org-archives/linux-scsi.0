From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Always do write-protect check
Date: Fri, 9 Dec 2005 11:34:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0512091132050.6477-100000@iolanthe.rowland.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01EE9ECB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43175 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932406AbVLIQet
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 11:34:49 -0500
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01EE9ECB@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Dmitry Antipov <antipov@ru.mvista.com>

James:

Since nobody has offered an explanation for why the sd driver makes a 
write-protect check only for devices with removable media, I'm submitting 
this patch (as620) to get rid of the removable-media test.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1509,9 +1509,7 @@ static int sd_revalidate_disk(struct gen
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, disk->disk_name, buffer);
-		if (sdp->removable)
-			sd_read_write_protect_flag(sdkp, disk->disk_name,
-						   buffer);
+		sd_read_write_protect_flag(sdkp, disk->disk_name, buffer);
 		sd_read_cache_type(sdkp, disk->disk_name, buffer);
 	}
 		

