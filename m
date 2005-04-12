From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] drivers/scsi/sg.c: fix problems when sg_remove is called
 	before sg_release
Date: Tue, 12 Apr 2005 21:03:33 +1000
Message-ID: <425BAB05.5060804@torque.net>
References: <92952AEF1F064042B6EF2522E0EEF437348251@EXNA.corp.stratus.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010309010403000001080500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:37532 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262260AbVDLLHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 07:07:30 -0400
In-Reply-To: <92952AEF1F064042B6EF2522E0EEF437348251@EXNA.corp.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dailey, Nate" <Nate.Dailey@stratus.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010309010403000001080500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dailey, Nate wrote:
> This is my first attempt at submitting a patch, so I hope I'm not making any
> mistakes...
> 
> This patch fixes two problems I came across in sg, both of which occur when
> sg_remove is called on a disk which hasn't yet been sg_release'd:
> 
> 1. I got the following Oops in sg_remove:
> 
> --
> Unable to handle kernel paging request at virtual address e0a58020
>  printing eip:
> e0a7ceba
> *pde = 1c245c8b
> Oops: 0000 [#1]
> SMP
> CPU:    3
> EIP:    0060:[<e0a7ceba>]    Tainted: G  U
> EFLAGS: 00210246   (2.6.5-7.139-bigsmp )
> EIP is at sg_remove+0xba/0x240 [sg]
> eax: dfee0500   ebx: 00000000   ecx: dfeefa50   edx: dfee05a8
> esi: 00000000   edi: c7beb000   ebp: e0a58000   esp: daf4bec0
> ds: 007b   es: 007b   ss: 0068
> Process bash (pid: 27436, threadinfo=daf4a000 task=dbcd3350)
> Stack: c10c1840 000000d0 00000001 01500002 00000000 00200246 df844000
> e0a84d08
>        df844240 e0857ec0 e0857f24 c0263dff e0857f0c df844240 df9d3028
> df9d3000
>        fffffffa c0263e78 df844000 e08449be df9d3000 df844000 00000000
> fffffffa
> Call Trace:
>  [<c0263dff>] class_device_del+0x5f/0xd0
>  [<c0263e78>] class_device_unregister+0x8/0x10
>  [<e08449be>] scsi_remove_device+0x3e/0xc0 [scsi_mod]
>  [<e0845b59>] proc_scsi_write+0x269/0x2a0 [scsi_mod]
>  [<c0176136>] vfs_write+0xc6/0x160
>  [<c011057d>] do_mmap2+0xdd/0x170
>  [<c01763e1>] sys_write+0x91/0xf0
>  [<c0109199>] sysenter_past_esp+0x52/0x71
> 
> Code: 8b 45 20 e8 ce 2a 70 df c7 45 20 00 00 00 00 8b 45 1c e8 ef
> --
> 
> It looks like sg_remove needs to hold the sg_dev_arr_lock a little longer.
> After sg_remove dropped the lock, sg_release/sg_remove_sfp came along and
> freed the sdp... and then sg_remove tried to do cdev_del(sdp->cdev). I made
> a change to get what we need from the sdp while holding the lock, and it
> fixed the problem for me.
> 
> 2. Scsi_device references are never released: after sg_remove sets the
> detached flag, sg_release won't call scsi_device_put. But someone needs to
> release the reference obtained in sg_open. A change also needs to be made in
> sg_remove_sfp to call scsi_device_put if freeing sdp--since sg_release
> wouldn't be able to do it in that case. I verified (by sticking a printk in
> scsi_device_dev_release) that the scsi_device wasn't freed in this case,
> without my change in place.
> 
> 
> To provoke these, I used a few 'dd if=/dev/sg2 of=/dev/null' commands to
> hold the device open. I then did 'echo "scsi remove-single-device 1 0 0 0" >
> /proc/scsi/scsi' to trigger the sg_remove.
> 
> This patch is against 2.6.12-rc2, though I actually found/fixed the problems
> in 2.6.5-7.139 (SLES9 SP1).
> 
> Do these look okay?

Nate,

Thanks for the analysis and the patch.

I'm starting to look at this patch and will do more
testing shortly. The changes look sound. The patch
had some line wrap problems so attached is my version
of it (against lk 2.6.12-rc2). It also applies over
my patch sent to this list on 28/3/2005 with a little
harmless "fuzz".

Doug Gilbert

--------------010309010403000001080500
Content-Type: text/x-patch;
 name="sg2612rc2nd2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg2612rc2nd2.diff"

--- linux/drivers/scsi/sg.c	2005-03-19 11:38:32.000000000 +1000
+++ linux/drivers/scsi/sg.c2612rc2nd2	2005-04-12 20:52:40.000000000 +1000
@@ -318,9 +318,7 @@
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 	sg_fasync(-1, filp, 0);	/* remove filp from async notification list */
 	if (0 == sg_remove_sfp(sdp, sfp)) {	/* Returns 1 when sdp gone */
-		if (!sdp->detached) {
-			scsi_device_put(sdp->device);
-		}
+		scsi_device_put(sdp->device);
 		sdp->exclude = 0;
 		wake_up_interruptible(&sdp->o_excl_wait);
 	}
@@ -1574,19 +1572,29 @@
 		sg_nr_dev--;
 		break;
 	}
-	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 
 	if (sdp) {
-		sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
-		class_simple_device_remove(MKDEV(SCSI_GENERIC_MAJOR, k));
-		cdev_del(sdp->cdev);
+		struct cdev *tmp_cdev;
+		struct gendisk *tmp_disk;
+		int free_sdp = 0;
+
+		tmp_cdev = sdp->cdev;
 		sdp->cdev = NULL;
-		devfs_remove("%s/generic", scsidp->devfs_name);
-		put_disk(sdp->disk);
+		tmp_disk = sdp->disk;
 		sdp->disk = NULL;
 		if (NULL == sdp->headfp)
+			free_sdp = 1;
+		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+
+		sysfs_remove_link(&scsidp->sdev_gendev.kobj, "generic");
+		class_simple_device_remove(MKDEV(SCSI_GENERIC_MAJOR, k));
+		cdev_del(tmp_cdev);
+		devfs_remove("%s/generic", scsidp->devfs_name);
+		put_disk(tmp_disk);
+		if (free_sdp)
 			kfree((char *) sdp);
-	}
+	} else
+		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 
 	if (delay)
 		msleep(10);	/* dirty detach so delay device destruction */
@@ -2550,6 +2558,7 @@
 			}
 			if (k < maxd)
 				sg_dev_arr[k] = NULL;
+			scsi_device_put(sdp->device);
 			kfree((char *) sdp);
 			res = 1;
 		}

--------------010309010403000001080500--
