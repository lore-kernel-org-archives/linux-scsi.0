From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Checkin 7404ad3b6d04efbd918e9e2e776bf560fbedf47d breaks boot
	on KVM
Date: Tue, 14 Oct 2008 09:23:29 -0400
Message-ID: <1223990609.12440.8.camel@localhost.localdomain>
References: <48F3E1C9.6030007@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56324 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYJNNXf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 09:23:35 -0400
In-Reply-To: <48F3E1C9.6030007@zytor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jejb@steeleye.com>

On Mon, 2008-10-13 at 17:03 -0700, H. Peter Anvin wrote:
> I just tried a top of tree i386 kernel under KVM, and found that it 
> fails to boot with a hang during initialization, right after:
> 
> console [netcon0] enabled 
> 
> netconsole: network logging started 
> 
> Uniform Multi-Platform E-IDE driver 
> 
> ide-floppy driver 1.00 
> 
> Driver 'sd' needs updating - please use bus_type methods 
> 
> scsi0 : ata_piix 
> 
> scsi1 : ata_piix 
> 
> ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14 
> 
> ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15 
> 
> ata1.00: ATA-7: QEMU HARDDISK, 0.9.1, max UDMA/100 
> 
> ata1.00: 16777216 sectors, multi 16: LBA48 
> 
> ata1.00: configured for MWDMA2 
> 
> ata2.00: ATAPI: QEMU DVD-ROM, 0.9.1, max UDMA/100 
> 
> ata2.00: configured for MWDMA2 
> 
> scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 
> ANSI: 5
> 
> Bisection fingered the following commit:
> 
> 7404ad3b6d04efbd918e9e2e776bf560fbedf47d is first bad commit 
> 
> commit 7404ad3b6d04efbd918e9e2e776bf560fbedf47d 
> 
> Author: James Bottomley <James.Bottomley@HansenPartnership.com> 
> 
> Date:   Sun Aug 31 10:41:52 2008 -0500 
> 
> 
>      [SCSI] sd: use generic helper to print capacities in both binary
> and SI
> 
>      Signed-off-by: James Bottomley
> <James.Bottomley@HansenPartnership.com>
> 
> :040000 040000 98fc7ae95211b8d16e2e8ca46997be660ad9ba93 
> 2d35d0a2b6232411b840a9ccf6a52b946172566e M      drivers
> 
> However, simply reverting this commit caused a panic on boot (not 
> entirely surprising.)

Actually, it is surprising.  That patch takes the default arithmetic for
calculating the disk size out of sd and uses a routine to do it more
efficiently in lib/string_helpers.c

So there are two problems:  Why does it panic on revert (could you post
the oops) and what does kvm object to in string_get_size ... it's a
fairly innocuous routine as I read it ... your symptoms sound like the
for loop isn't terminating.

James


