From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 06 Oct 2003 13:50:31 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065469831.5185.44.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
	 <1064847281.24854.2.camel@patehci2> <1064850600.25057.7.camel@patehci2>
	 <20030929164654.GS15415@suse.de> <1064855570.3184.3.camel@patehci2>
	 <1064865746.4262.63.camel@patehci2> <1065460336.10804.1.camel@patehci2>
	 <1065463946.5185.8.camel@patehci2> <20031006182223.GF972@suse.de>
	 <20031006182510.GG972@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:26829 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261585AbTJFTul
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 15:50:41 -0400
In-Reply-To: <20031006182510.GG972@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

> assuming this has to do with misdetected hardware?

Seemingly so, aye.

> hardware?

I'm plugging in a pre-production sample of a new device.

Seemingly I cannot mkudffs its disks except by patching the kernel.

That's normal for yet another new kind of dvd/cd, yes?

Via sg I see 35 GB of 64 KiB/block writes, 2 KiB/block reads, with
writable profile x0002 removable_disk of the 1999 mmc 2 standard.  Yes
pdt x05 dvd/cd, yes feature x0020 random_writable, no not the cd_r,
cd_rw, dvd, dvd_r, and dvd_ram enumerated in the obsolete legacy 1997
mmc 1 mode page x2A Capabilities.

Previously near here we discussed some as-yet-ineffective alternatives
to my patch: the Andy Polyakov patch for mount -w of dvd+rw, the Jens
Axboe patch for mount -w of cd-rw, and blockdev --setrw.

> The uniform layer uses CDC_DVD_RAM as meaning
> randomly writable media,

When I try setting CDC_DVD_RAM for a device, I see
/proc/sys/dev/cdrom/info erroneously reports:

Can write DVD-RAM:      1

I conclude we wish to express the discovery of feature x0020
random_writable differently.  Wrong?

In weak confirmation, earlier I did see the usb-storage folk reject a
patch to tweak mode page x2A to appear to have mode page x2A byte 3 mask
x20 dvd_ram_write set.  Should I submit a patch like that for sr_mod.ko
and ide-cd.ko?

> Calling read-only media failing to be opened
> read-write as "uncooperative" is confusing,

Clear now?  I mean to say, sg_dd shows the real disk of the real device
is randomly rewritable.  But cdrom.ko and sr_mod.ko refuse to pass
writes thru.

> screws threading of decent mailers

Sorry.  I'm pleased to mention people have kindly volunteered offline to
help me avoid repeating that.

Pat LaVarre


