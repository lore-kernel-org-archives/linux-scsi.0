From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 12:26:11 -0600
Message-ID: <20080729182611.GB24924@parisc-linux.org>
References: <488F524F.6020905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45624 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYG2S0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2008 14:26:13 -0400
Content-Disposition: inline
In-Reply-To: <488F524F.6020905@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>

On Tue, Jul 29, 2008 at 01:24:31PM -0400, Ric Wheeler wrote:
> Jim pinged me about the use case for having our tool chain (parted 
> specifically) support devices with non-512 bytes sectors.

Matt Domsch spoke with me about this at OLS.  I took that opportunity,
and I'll take this one, to pimp my ata-ram driver which allows you to
alter the sector sizse to whatever you want:

http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=ata-ram

I'll admit to having not tested it with anything other than 512, but it
ought to support 4096 byte sectors just fine.  I haven't looked at what
would be required to support 520-byte sectors.

Jeff, any interest in merging ata-ram soon?  I've got some users inside
Intel, and Zab persuaded me to add the multiple port support last night,
so it's not just useful for me.  I think it's also a nice template to
have around to show how to write a minimal libata driver.

> Off the top of my head, the following is the list of existing or soon to 
> appear devices that could use this (taken from our thread last year, at
> http://kerneltrap.org/mailarchive/linux-fsdevel/2007/3/11/317183):
> 
>    (1) R/W optical drives
>    (2) S390 dasd devices have a 4096 byte sector
>    (3) new 4096 byte disks (which intend to export a virtual 512 byte 
> sector)
> 
> Anything else pop into mind? Any idea if SSD or FLASH devices have 
> thoughts to use a non-512 byte sector size? What tools are most critical 
> to support?
> 
> Thanks!
> 
> Ric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
