From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] set_signalling is buggy
Date: Thu, 2 Dec 2004 20:09:47 +0000
Message-ID: <20041202200947.GB29370@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5604 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261744AbULBUJs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Dec 2004 15:09:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org


Looks like you got the test backwards.  It would only call set_signalling
if type was SPI_SIGNAL_UNKNOWN.

Index: drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.6
diff -u -p -r1.6 scsi_transport_spi.c
--- drivers/scsi/scsi_transport_spi.c	21 Oct 2004 18:59:23 -0000	1.6
+++ drivers/scsi/scsi_transport_spi.c	2 Dec 2004 20:03:50 -0000
@@ -361,9 +361,8 @@ static ssize_t store_spi_host_signalling
 	enum spi_signal_type type = spi_signal_to_value(buf);
 
 	if (type != SPI_SIGNAL_UNKNOWN)
-		return count;
+		i->f->set_signalling(shost, type);
 
-	i->f->set_signalling(shost, type);
 	return count;
 }
 static CLASS_DEVICE_ATTR(signalling, S_IRUGO | S_IWUSR,

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
