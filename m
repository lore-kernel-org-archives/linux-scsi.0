From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] scsicam_getgeo_odd_sector_size
Date: Wed, 13 Oct 2004 09:25:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416D3ABE.6030107@us.ibm.com>
References: <200408192303.i7JN3cv9110958@northrelay02.pok.ibm.com> <416D3536.5030501@us.ibm.com> <20041013140439.GI16153@parcelfarce.linux.theplanet.co.uk>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:42425 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269723AbUJMOZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 10:25:05 -0400
In-Reply-To: <20041013140439.GI16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Looks like the code in fs/buffer.c has changed since I originally submitted this.
The BUG()s appear to have been moved directly into __getblk_slow. The patch is
still appropriate and needed, but the text at the beginning is now incorrect.
Here was the backtrace of the original failure.


GPR24: C0000000CCC9BB00 C0000000CF7B3C20 0000000000001050 0000000000001050
GPR28: 0000000000000000 C0000000CCC9BB00 C0000000005E1480 C0000000CCC9BB00
NIP [c0000000000c479c] .__getblk_slow+0xa8/0x484
LR [c0000000000c474c] .__getblk_slow+0x58/0x484
Call Trace:
[c0000000cf7b3520] [c0000000000c474c] .__getblk_slow+0x58/0x484 (unreliable)
[c0000000cf7b35e0] [c0000000000c4bdc] .__getblk+0x64/0x6c
[c0000000cf7b3680] [c0000000000c7b3c] .__bread+0x20/0x14c
[c0000000cf7b3710] [d000000000098044] .scsi_bios_ptable+0x50/0xd4 [scsi_mod]
[c0000000cf7b37a0] [d0000000000980f8] .scsicam_bios_param+0x30/0x18c [scsi_mod]
[c0000000cf7b3840] [d000000000063118] .sd_ioctl+0x240/0x274 [sd_mod]
[c0000000cf7b38f0] [c000000000258a64] .blkdev_ioctl+0xd0/0x9e4
[c0000000cf7b3a50] [c0000000000cbbc8] .block_ioctl+0x18/0x2c
[c0000000cf7b3ad0] [c0000000000dd3d4] .sys_ioctl+0x450/0x690
[c0000000cf7b3bb0] [c00000000002715c] .hdio_getgeo+0x40/0xcc
[c0000000cf7b3c50] [c0000000000fc57c] .compat_sys_ioctl+0x178/0x32c
[c0000000cf7b3d10] [c00000000001045c] .ret_from_syscall_1+0x0/0xa4

-Brian

Matthew Wilcox wrote:
> On Wed, Oct 13, 2004 at 09:01:26AM -0500, Brian King wrote:
> 
>>grow_buffers(struct block_device *bdev, sector_t block, int size)
>>{
>>        struct page *page;
>>        pgoff_t index;
>>        int sizebits;
>>
>>        /* Size must be multiple of hard sectorsize */
>>        if (size & (bdev_hardsect_size(bdev)-1))
>>                BUG();
>>        if (size < 512 || size > PAGE_SIZE)
>>                BUG();                      <----- line 1271 is here
> 
> 
> What tree is this in?  Neither of these BUG()s appear in 2.6.9-rc4.
> 

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

