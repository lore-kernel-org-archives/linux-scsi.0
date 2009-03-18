From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12893] Race condition can cause two devices to get assigned the same device minor number.
Date: Wed, 18 Mar 2009 14:28:10 -0700 (PDT)
Message-ID: <20090318212810.1FDC3108040@picon.linux-foundation.org>
References: <bug-12893-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbZCRV2s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 17:28:48 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2ILSAZM015421
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 14:28:46 -0700
In-Reply-To: <bug-12893-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12893





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2009-03-18 14:28 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2009-03-18 at 14:18 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12893
> 
>            Summary: Race condition can cause two devices to get assigned the
>                     same device minor number.
>            Product: IO/Storage
>            Version: 2.5
>      KernelVersion: 2.6.27
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: tdefeo@itsgames.com
> 
> 
> Latest working kernel version:
> Earliest failing kernel version:
> Distribution:
> Hardware Environment: x86
> Software Environment:
> Problem Description:
> There is a race condition in scsi/sd.c caused bu the call to ida_get_new() not
> being protected by a spinlock. If two devices appear at the same time (which
> can happen when booting with multiple USB flash drives installed), occasionally
> the timing will be just right such that two devices will get assigned the same
> device minor number and hence the same device inode (i.e. /dev/sda). This
> causes the scsi subsystem to crash.
> 
> Steps to reproduce: I can reproduce this by booting a system off of a USB flash
> drive, with one or more other USB flash drives plugged in. It is sporadic,
> depending on the timing, but it will eventually hang up when booting.
> 
> Here is a patch to add the proper locking and fix the problem:
> 
> --- ./linux-2.6.27.orignal/drivers/scsi/sd.c    2008-10-09 17:13:53.000000000
> -0
> 500
> +++ ./linux-2.6.27/drivers/scsi/sd.c    2009-03-18 14:19:42.000000000 -0600
> @@ -99,6 +99,7 @@
>  static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
>  static void sd_print_result(struct scsi_disk *, int);
> 
> +static DEFINE_SPINLOCK(sda_index_lock); // tpd - 3/18/09 - Added.
>  static DEFINE_IDA(sd_index_ida);
> 
>  /* This semaphore is used to mediate the 0->1 reference get in the
> @@ -1808,8 +1809,9 @@
>         do {
>                 if (!ida_pre_get(&sd_index_ida, GFP_KERNEL))
>                         goto out_put;
> -
> +               spin_lock(&sda_index_lock); // tpd - 3/18/09 - Added.
>                 error = ida_get_new(&sd_index_ida, &index);
> +               spin_unlock(&sda_index_lock); // tpd - 3/18/09 - Added.
>         } while (error == -EAGAIN);
> 
>         if (error)
> @@ -1883,7 +1885,9 @@
>         return 0;
> 
>   out_free_index:
> +       spin_lock(&sda_index_lock); // tpd - 3/18/09 - Added.
>         ida_remove(&sd_index_ida, index);
> +       spin_unlock(&sda_index_lock); // tpd - 3/18/09 - Added.
>   out_put:
>         put_disk(gd);
>   out_free:
> @@ -1933,7 +1937,9 @@
>         struct scsi_disk *sdkp = to_scsi_disk(dev);
>         struct gendisk *disk = sdkp->disk;
> 
> +       spin_lock(&sda_index_lock); // tpd - 3/18/09 - Added.
>         ida_remove(&sd_index_ida, sdkp->index);
> +       spin_unlock(&sda_index_lock); // tpd - 3/18/09 - Added.
> 
>         disk->private_data = NULL;
>         put_disk(disk);

Very similar patch already upstream and in both stable kernels:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4034cc68157bfa0b6622efe368488d3d3e20f4e6

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
