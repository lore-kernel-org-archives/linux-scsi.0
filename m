From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] SG_SET_RESERVED_SIZE negative oops
Date: 20 Oct 2003 16:29:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066688955.2814.3.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:39657 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262873AbTJTW3Y
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 18:29:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

I propose the 2.6.0-test8 two-line patch below to teach
SG_SET_RESERVED_SIZE to reject a negative size, rather than oops-ing.

Whaddyathink?

I dreamed up this trivial patch after losing my console whenever I typed
something like:

sg_dd of=/dev/sg0 bs=2k bpt=

Courtesy some Red Hat automagic that does a `sudo chown `id -u`
/dev/sg0` to me, I find I can oops that way without involving full root
privilege.

My short nightmare appears detailed as the linux-scsi thread re "sg_dd
bpt= count=":
http://marc.theaimsgroup.com/?t=106617534400002

That thread tells us `sg_dd of=/dev/sg0 bs=2k bpt=-1` is a less
indeterminate way to cause such trouble.  Also a two-paragraph demo .c
app appears there to demo trouble even when you have an sg_dd patched to
stop passing thru negative lengths.

In place of the oops, this 2.6.0-test8 patch gives me:

$
$ sg_dd of=/dev/sg0 bs=2k bpt=
unrecognized multiplier
sg_dd: SG_SET_RESERVED_SIZE error: Invalid argument
Not enough user memory
$

Pat LaVarre

diff -Nur linux-2.6.0-test8/drivers/scsi/sg.c linux/drivers/scsi/sg.c
--- linux-2.6.0-test8/drivers/scsi/sg.c	2003-10-17 15:43:10.000000000 -0600
+++ linux/drivers/scsi/sg.c	2003-10-20 16:15:17.699475136 -0600
@@ -877,6 +877,8 @@
 		result = get_user(val, (int *) arg);
 		if (result)
 			return result;
+		if (val < 0)
+			return -EINVAL;
 		if (val != sfp->reserve.bufflen) {
 			if (sg_res_in_use(sfp) || sfp->mmap_called)
 				return -EBUSY;


