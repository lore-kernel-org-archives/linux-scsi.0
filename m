From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: (added subject) RE: USB oops in scsi_host_cancel
Date: 18 Nov 2004 17:40:41 -0600
Message-ID: <1100821249.1574.42.camel@mulgrave>
References: <200411181952.46993.chrivers@iversen-net.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44724 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261209AbUKRXk5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 18:40:57 -0500
In-Reply-To: <200411181952.46993.chrivers@iversen-net.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Iversen <chrivers@iversen-net.dk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2004-11-18 at 12:52, Christian Iversen wrote:
> I have a bug to report. I previously wrote (on linux-usb-devel) about problems 
> with http://bugme.osdl.org/show_bug.cgi?id=3728, which has now been fixed. 
> However, the world is not trouble-free yet, as linux still crashes in certain 
> situations on 2.6.10-rc2 with SMP systems. (UP systems are fine).
> 
> The new bug is http://bugme.osdl.org/show_bug.cgi?id=3761, which I marked as 
> "blocking" because it's very easy to bring the whole system down.
> 
> Could someone smart please take a look at the dmesg I attached 
> to the bug post? Particularly, what the foo is going on here: ?
> 
> usb 4-2: USB disconnect, address 2
> usb 4-2.3: USB disconnect, address 5
>  target5:0:0: Illegal state transition <NULL>->cancel
> Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1717
>  [<b0324d16>] scsi_device_set_state+0xc6/0x130
>  [<b031fcaa>] scsi_device_cancel+0x2a/0x106
>  [<b031fe10>] scsi_device_cancel_cb+0x0/0x20
>  [<b02f128e>] device_for_each_child+0x3e/0x70

Well, Oops.  The I posted the patch to fix this a while ago (it was
subsequently modified by Mike Christie).  Apparently I put Mike's update
in the BK tree, but not my own initial patch (I suppose dropping other
people's patches can be considered unfortunate, but dropping your own
looks like carelessness).

Anyway, the attached should fix it, if you give it a whirl.

James

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/18 17:00:19-06:00 jejb@mulgrave.(none) 
#   SCSI: fix USB forced remove oops
#   
#   Because of the changes to add the target in to the
#   driver model, the cancellation method no-longer works
#   correctly.
#   
#   Fix it by iterating using shost_for_each_device instead.
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# drivers/scsi/hosts.c
#   2004/11/18 16:59:11-06:00 jejb@mulgrave.(none) +5 -7
#   SCSI: fix USB forced remove oops
# 
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	2004-11-18 17:38:59 -06:00
+++ b/drivers/scsi/hosts.c	2004-11-18 17:38:59 -06:00
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

