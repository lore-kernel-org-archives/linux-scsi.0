From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] 2.6.9-rc4mm1:badness in
	drivers/scsi/scsi_lib.c
Date: 26 Oct 2004 21:53:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098842044.1762.688.camel@mulgrave>
References: <Pine.LNX.4.44L0.0410211039420.2736-100000@ida.rowland.org>
	<Pine.GSO.4.58.0410260947280.22299@boromir> <417E9163.8010904@us.ibm.com>
	<417E92AB.5020406@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44230 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261529AbUJ0ByL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 21:54:11 -0400
In-Reply-To: <417E92AB.5020406@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: Mateusz.Blaszczyk@nask.pl, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Tue, 2004-10-26 at 14:08, Mike Christie wrote:
> > The null state and and oops are becuase of this
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=109733573729283&w=2
> 
> Oh yeah. that patch is not correct, but if you correctly modify it to
> use device_for_each_child per Christoph's suggestion, I seem to be
> getting some refcounting errors. For some reason the sdev will be
> released, but the sd.c still thinks it is there.

Actually, he suggested using shost_for_each_device.  The reason being
that you can't have nested device_for_each_child (because it takes the
bus semaphore).

The attached should do this, if someone would care to try it out.

James

===== hosts.c 1.102 vs edited =====
--- 1.102/drivers/scsi/hosts.c	2004-10-11 10:03:45 -05:00
+++ edited/hosts.c	2004-10-26 20:49:51 -05:00
@@ -50,11 +50,6 @@
 	.release	= scsi_host_cls_release,
 };
 
-static int scsi_device_cancel_cb(struct device *dev, void *data)
-{
-	return scsi_device_cancel(to_scsi_device(dev), *(int *)data);
-}
-
 /**
  * scsi_host_cancel - cancel outstanding IO to this host
  * @shost:	pointer to struct Scsi_Host
@@ -62,9 +57,12 @@
  **/
 void scsi_host_cancel(struct Scsi_Host *shost, int recovery)
 {
+	struct scsi_device *sdev;
+
 	set_bit(SHOST_CANCEL, &shost->shost_state);
-	device_for_each_child(&shost->shost_gendev, &recovery,
-			      scsi_device_cancel_cb);
+	shost_for_each_device(sdev, shost) {
+		scsi_device_cancel(sdev, recovery);
+	}
 	wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
 						&shost->shost_state)));
 }

