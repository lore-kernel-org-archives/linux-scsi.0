From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 2/2  scsi-rc-fixes-2.6] FC Remote Port patch
Date: Thu, 10 Feb 2005 10:56:17 -0800
Message-ID: <20050210185617.GA13971@plap.san.rr.com>
References: <0B1E13B586976742A7599D71A6AC733C1FD1D9@xbl3.ma.emulex.com> <20050209230350.GA10297@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch02.qlogic.com ([198.70.193.200]:41010 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261761AbVBJVDO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2005 16:03:14 -0500
Content-Disposition: inline
In-Reply-To: <20050209230350.GA10297@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

On Wed, 09 Feb 2005, Andrew Vasquez wrote:
> On Wed, 09 Feb 2005, James.Smart@Emulex.Com wrote:
> 
> > > seems like sdev->shost is bogus when fc_remote_port_block() is
> > > called...
> > 
> > We haven't seen this in our testing....
> > 
> 
> Actually it's not the sdev->host that's bogus -- it appears the sdev
> is referenced after it's been freed -- a reference still present in
> the shost->__devices list.  Here's the scenario:
> 
...
> 	Unable to handle kernel paging request at virtual address 6b6b6be7
> 	 printing eip:
> 	c028ef06
> 	*pde = 00000000
> 	Oops: 0000 [#1]
> 	SMP
> 	Modules linked in: qla2322 qla2xxx
> 	CPU:    0
> 	EIP:    0060:[<c028ef06>]    Not tainted VLI
> 	EFLAGS: 00010086   (2.6.11-rport)
> 	EIP is at scsi_device_get+0x56/0xa0
> 	eax: 6b6b6b6b   ebx: dd2bc738   ecx: c035f844   edx: fffffffa
> 	esi: dd2bc8cc   edi: d36f0000   ebp: 00000001   esp: df693dd4
> 	ds: 007b   es: 007b   ss: 0068
> 	Process qla2322_1_dpc (pid: 11316, threadinfo=df692000 task=d9fa8530)
> 	Stack: c0341fcc dd2bc738 6b6b6b6b 6b6b6b6b dd2bc8cc dd2bc738 d76196f0 c028f011
> 	       c0341ff4 00000000 dd2bc738 6b6b6b6b 6b6b6b6b dd2bc8cc 6b6b6b6b 00000282
> 	       d76196e8 d76196e8 ddd7e790 d36f0000 c029af50 c028f0bd 00000000 dbe8512c
> 	Cale Trace:
> 	 [<c028f011>] __scsi_iterate_devices+0x71/0xb0
> 	 [<c029af50>] fc_device_block+0x0/0x10
> 	 [<c028f0bd>] starget_for_each_device+0x6d/0x80
> 	 [<c029afff>] fc_remote_port_block+0x3f/0x70
> 	 [<e08633d3>] qla2x00_mark_device_lost+0x53/0xe0 [qla2xxx]
> 

Ok, there seems to also be some sdev reference counting issues --
within scsi_alloc_sdev() we are never tearing-down the the
cooresponding starget references created within
scsi_sysfs_target_initialize().

> Another quirk when run with no storage connected to HBAs and the
> driver is loaded, then unloaded -- is a consistent BUG() hit in
> _raw_spin_lock() via scsi_forget_host():
> 
> 	kernel BUG at include/asm/spinlock.h:149!
> 	invalid operand: 0000 [#1]

this issue also appears to be fixed with the patch.

--
AV


diff -urd 1.8/drivers/scsi/scsi_scan.c edited/drivers/scsi/scsi_scan.c
--- 1.8/drivers/scsi/scsi_scan.c	2005-02-09 11:30:52 -08:00
+++ edited/drivers/scsi/scsi_scan.c	2005-02-10 10:16:44 -08:00
@@ -248,8 +248,10 @@
 
 	spin_lock_init(&sdev->sdev_lock);
 	sdev->request_queue = scsi_alloc_queue(sdev);
-	if (!sdev->request_queue)
-		goto out_free_dev;
+	if (!sdev->request_queue) {
+		kfree(sdev);
+		goto out;
+	}
 
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
@@ -284,8 +286,7 @@
 out_device_destroy:
 	transport_destroy_device(&sdev->sdev_gendev);
 	scsi_free_queue(sdev->request_queue);
-out_free_dev:
-	kfree(sdev);
+	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
