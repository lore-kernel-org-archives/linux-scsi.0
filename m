From: taco <tacoee@gmail.com>
Subject: Re: kernel cant access SATA adapter device
Date: Thu, 17 Oct 2013 23:59:24 +0800
Message-ID: <20131017155924.GA31331@taco-ThinkPad-X220>
References: <20131016154651.7280ce92@kvm171.vb.futz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54922 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab3JQP7c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2013 11:59:32 -0400
Received: by mail-pa0-f50.google.com with SMTP id fa1so2928277pad.23
        for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2013 08:59:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131016154651.7280ce92@kvm171.vb.futz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Story <rstory@tislabs.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

What is the version of mptsas driver?

It seems that the mptsas's driver can't recognize the the type of SD
card and treat it as normal hard disk drive.

On Wed, Oct 16, 2013 at 03:46:51PM -0400, Robert Story wrote:
> Hi,
> 
> I've got a SATA adapter for a SD card in a Dell Poweredge R610. The BIOS
> can see and boot the sdcard, (to Windows, or using syslinux/extlinux), but
> when it hands over control to the Linux kernel, the kernel cannot access it.
> 
> Here's an excerpt from dmesg:
> 
> scsi 0:0:2:0: Direct-Access     ATA      FC-1307 SD to CF 1.1  PQ: 0 ANSI: 5
> sd 0:0:2:0: Attached scsi generic sg3 type 0
> mptsas: ioc0: mptsas_free_fw_event: kfree (fw_event=0xffff8801ab1ad8c0)
> sd 0:0:2:0: [sdc] Spinning up disk .....................not responding...
> sd 0:0:2:0: [sdc] READ CAPACITY(16) failed
> sd 0:0:2:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 0:0:2:0: [sdc] Sense Key : Not Ready [current]
> sd 0:0:2:0: [sdc] Add. Sense: Logical unit not ready, initializing command required
> sd 0:0:2:0: [sdc] READ CAPACITY failed
> sd 0:0:2:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 0:0:2:0: [sdc] Sense Key : Not Ready [current]
> sd 0:0:2:0: [sdc] Add. Sense: Logical unit not ready, initializing command required
> sd 0:0:2:0: [sdc] Test WP failed, assume Write Enabled
> sd 0:0:2:0: [sdc] Asking for cache data failed
> sd 0:0:2:0: [sdc] Assuming drive cache: write through
> 
> After booting and running 'sdparm --command=start /dev/sdc' I can get a
> read capacity to work, but cannot access the drive (e.g. fdisk -l /dev/sdc).
> 
> If I put the SD card in a USB adapter, it works, and I was able to access
> the SD card via the SD adapter in another machine. But our production
> machines are dell's, so I really want to get it working there.
> 
> I've attached more complete debug info from booting and existing CentOS 6.4
> install with the card installed, and a rdsosreport from an attempt to boot
> Fedora 20 Alpha.
> 
> Any help or suggestions greatly appreciated.
> 
> 
> Robert
> 
> --
> Senior Software Engineer
> Parsons Government Services , National Security & Defense Division
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
