From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [BUG] scsi / genhd badness
Date: Mon, 28 Oct 2002 10:05:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028180541.GB1234@beaverton.ibm.com>
References: <1035818430.3dbd55be25447@imp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1035818430.3dbd55be25447@imp.free.fr>
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: linux-scsi@vger.kernel.org

christophe.varoqui@free.fr [christophe.varoqui@free.fr] wrote:
> Hello, 
>  
> I'd like to report an annoying behaviour : 
>  
> On a server with scsi disk behind an aic7xxx, kernel 2.5.44-ac4, each time I 
> remove a disk from the linux scsi subsystem (echo "scsi remove-single-device a 
> b c d">/proc/scsi/scsi) I get the following oops (server survive) : 
>  
> Badness in put_device at drivers/base/core.c:139 
> Call Trace: 
>  [<c01d12ae>] put_device+0xde/0xf0 
>  [<c022c1ff>] sg_detach+0x8f/0x1f0 
>  [<c02121d8>] proc_scsi_gen_write+0x338/0x4b0 
>  [<c014d6c6>] open_namei+0xa6/0x400 
>  [<c01658e0>] proc_file_write+0x40/0x50 
>  [<c014047c>] vfs_write+0xdc/0x150 
>  [<c014058e>] sys_write+0x3e/0x60 
>  [<c010772b>] syscall_call+0x7/0xb 
>  

This problem is do to a put_device still left in sg.c. The patch below
is against ac5 to replace put_device with device_unregister which should
remove this Badness.

> the block event gets passed to the hotplug layer. 
> Driverfs loose the $driverfs/bus/block/device/ (and $driverfs/root/) disk entry 
> : right 
>  
> On the other hand, when I re-add this disk, hotplug is not notified and disk 
> entry does not re-appear in driverfs. 
>  
> Other sybsystems are not similarily affected : device-mapper gives the oops on 
> device map removal but devmap addition get rightly notified to userspace. 
>  
> Is it a known short-coming ? 

The 2.5.44 SCSI subsystem still has some gaps in driverfs support. We
currently do not have a hotplug function defined for scsi_bus. The call
is still suppose to happen even if a bus does not define one, but I do
not believe I have seen this happen.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 sg.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)
------

--- 1.30/drivers/scsi/sg.c	Fri Oct 18 11:27:30 2002
+++ edited/drivers/scsi/sg.c	Mon Oct 28 09:38:44 2002
@@ -1607,7 +1607,7 @@
 		sdp->de = NULL;
 		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_type);
 		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_kdev);
-		put_device(&sdp->sg_driverfs_dev);
+		device_unregister(&sdp->sg_driverfs_dev);
 		if (NULL == sdp->headfp)
 			vfree((char *) sdp);
 	}

