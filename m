From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 23 Aug 2004 10:05:50 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4D36722F-F51E-11D8-BFA2-00039398BB5E@ieee.org>
References: <20040731141240.GE23697@suse.de> <1092678938.4235.37.camel@patli
	 nux.iomegacorp.com> <20040823154648.GB2301@suse.de>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:8900 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265999AbUHWQFr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 12:05:47 -0400
In-Reply-To: <20040823154648.GB2301@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

>> Is there an ide-cd option to allow more bytes/CDB?
> ...
> ATAPI cannot do more than 128KiB per command. And
> that is what q->max_sectors is set to, if you try and submit more than
> this through SG_IO, bio_add_user() will complain and command will be
> failed as you experienced.

Wow.

Please reply to confirm - you are saying 128 KiB data bytes per command  
is a Linux PATAPI design limit?

I know even twelve-byte-packet PATAPI itself as defined at t13.org and  
t10.org can do xFFFF = (64 Ki - 1) LBA's via such ten-byte per CDB ops  
as x28 "READ (10)" and x2A "WRITE (10)".  At 2 KiB/LBA, that's 128 MiB  
minus 2 KiB.  That's the kind of limit I expected, when instead in  
Linux I saw limits like 120 KiB in SCSI over USB.  Also I hear  
sixteen-byte-packet PATAPI can itself pass xFFFF:FFFF data blocks per  
command.

In parallel, I'll click thru to bio_add_user to read the limits there.

> As I'm sure you know,

I didn't know, thank you, sorry I have no clue, I'm not trying to  
pretend I do, I got into this at the request of a friend who needs 256  
KiB data per command.

I specifically have Not yet tried patching the Linux kernel to persuade  
PATAPI to allow more data bytes per command.  I did try USB.  So far  
I've failed.  At:

Subject: [usb-storage] faq max_sectors
https://lists.one-eyed-alien.net/pipermail/usb-storage/2004-August/ 
000680.html

I have reported that raising SCSI_DEFAULT_MAX_SECTORS alone does not  
actually allow more data bytes per command in USB.

> max_sectors should be fully exposed so you don't have to guess.

Yes please.

Pat LaVarre
http://linux-pel.blog-city.com/read/752705.htm

