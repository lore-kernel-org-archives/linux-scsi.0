From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as445] Fix reference to deallocated memory in sd.c
Date: Fri, 14 Jan 2005 11:05:45 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501141052040.1341-100000@ida.rowland.org>
References: <200501121941.18058.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:8452 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262014AbVANQFq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 11:05:46 -0500
In-Reply-To: <200501121941.18058.david-b@pacbell.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Brownell <david-b@pacbell.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch of yours:

http://linux-scsi.bkbits.net:8080/scsi-for-linus-2.6/cset@1.2034.95.5?nav=index.html|src/|src/drivers|src/drivers/scsi|related/drivers/scsi/sd.c

 --- 1.162/drivers/scsi/sd.c	2005-01-14 07:53:59 -08:00
 +++ 1.163/drivers/scsi/sd.c	2005-01-14 07:53:59 -08:00
 @@ -198,8 +198,8 @@
  static void scsi_disk_put(struct scsi_disk *sdkp)
  {
  	down(&sd_ref_sem);
 -	scsi_device_put(sdkp->device);
  	kref_put(&sdkp->kref, scsi_disk_release);
 +	scsi_device_put(sdkp->device);
  	up(&sd_ref_sem);
  }

is causing almost as much trouble as it fixed.  If kref_put() drops the
last reference to the scsi_disk (this happens when the device file is
closed after the device has been hot-unplugged) then the call to
scsi_device_put() will take its argument from an area of memory that has
been deallocated.

The patch below should fix things.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== drivers/scsi/sd.c 1.75 vs edited =====
--- 1.75/drivers/scsi/sd.c	2004-12-22 11:18:12 -05:00
+++ edited/drivers/scsi/sd.c	2005-01-14 11:01:14 -05:00
@@ -197,9 +197,11 @@
 
 static void scsi_disk_put(struct scsi_disk *sdkp)
 {
+	struct scsi_device *sdev = sdkp->device;
+
 	down(&sd_ref_sem);
 	kref_put(&sdkp->kref, scsi_disk_release);
-	scsi_device_put(sdkp->device);
+	scsi_device_put(sdev);
 	up(&sd_ref_sem);
 }


 
On Wed, 12 Jan 2005, David Brownell wrote:

> I didn't realize FC3 was mounting this drive, else I might have done
> things differently ... but I think everyone will agree that oopsing
> is not OK.  See the following dmesg trace.
> 
> I've seen a lot of messages about similar failures lately, as if
> maybe more distros are automounting removable drives.  But I also
> remember seeing a lot of fixes go by; does this oops have a fix?
> 
> - Dave
> 
> 
> ============================================================================
> 
> 	Connect drive to NEC EHCI

> 	Erm, FC3 must be automatically mounting this for me.
> 	I didn't ask it to, but I suppose that could be OK ...

> 	... except that when I then unplug the drive ...

> 	... then things go completely haywire ...
> 
> lost page write due to I/O error on sda1
> Unable to handle kernel paging request at virtual address 6b6b6b6b
>  printing eip:
> c027169b
> *pde = 00000000
> Oops: 0000 [#1]
> SMP 
> Modules linked in: usb_storage ohci_hcd ehci_hcd
> CPU:    1
> EIP:    0060:[<c027169b>]    Not tainted VLI
> EFLAGS: 00010286   (2.6.11-rc1-helium) 
> EIP is at scsi_device_put+0x7/0x48
> eax: 0000000f   ebx: 6b6b6b6b   ecx: 00000000   edx: c14efbdc
> esi: cd3f2360   edi: d12b3148   ebp: cd241ee4   esp: cd241ee0
> ds: 007b   es: 007b   ss: 0068
> Process umount (pid: 3497, threadinfo=cd240000 task=ccd71ac0)
> Stack: cd3f2360 cd241efc c0278852 6b6b6b6b cd3f2360 c0279e4e cd2f05b8 cd241f10 
>        c0278bf2 cd3f2360 c14df02c c14df02c cd241f34 c01519c3 c14df0a0 00000000 
>        c14df0a0 00000000 00000000 dfc695d4 d12b3148 cd241f54 c0151a69 c14df02c 
> Call Trace:
>  [<c0102f63>] show_stack+0x74/0x7c
>  [<c0103077>] show_registers+0xf4/0x15e
>  [<c010323e>] die+0xd8/0x157
>  [<c010fe9a>] do_page_fault+0x43d/0x5cc
>  [<c0102c2b>] error_code+0x2b/0x30
>  [<c0278852>] scsi_disk_put+0x38/0x4d
>  [<c0278bf2>] sd_release+0x46/0x4f
>  [<c01519c3>] blkdev_put+0x69/0x137
>  [<c0151a69>] blkdev_put+0x10f/0x137
>  [<c014fdc7>] deactivate_super+0x59/0x78
>  [<c0161ffa>] sys_umount+0x6b/0x73
>  [<c0102155>] sysenter_past_esp+0x52/0x75
> Code: 06 8d 04 02 ff 80 00 01 00 00 eb 0d 56 e8 3a 8c fd ff ba fa ff ff ff eb 02 31 d2 8d 65 f8 89 d0 5b 5e c9 c3 55 89 e5 53 8b 5d 08 <8b> 03 8b 40 74 8b 10 85 d2 74 26 b8 00 e0 ff ff 21 e0 8b 40 10 
>  <7>hub 2-0:1.0: debounce: port 5: total 100ms stable 100ms status 0x100


