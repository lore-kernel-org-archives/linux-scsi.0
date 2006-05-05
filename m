From: Vasily Averin <vvs@sw.ru>
Subject: Re: megaraid_mbox: garbage in file
Date: Fri, 05 May 2006 09:37:41 +0400
Message-ID: <445AE4A5.8070202@sw.ru>
References: <445A4C8F.5030204@sw.ru> <1146783568.22932.105.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:33432 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S932472AbWEEFe3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2006 01:34:29 -0400
In-Reply-To: <1146783568.22932.105.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Neela.Kolli@engenio.com, Atul Mukker <Atul.Mukker@lsil.com>, Seokmann.Ju@lsil.com, sreenib@lsil.com, devel@openvz.org

James Bottomley wrote:
> On Thu, 2006-05-04 at 22:48 +0400, Vasily Averin wrote:
>>attempt to access beyond end of device
>>sda6: rw=0, want=1044134458, limit=951401367
>>Buffer I/O error on device sda6, logical block 522067228
> 
> That's not a SCSI error.  It's coming from the block layer and it means
> that the filesystem tried to access beyond the end of the listed
> partition.   Why that happened is anyone's guess.  I suspect the actual
> filesystem is corrupt somehow, but how it came to be, I don't know.

James,

The issue is that the correctly finished scsi read command return me garbage
(repeated 0 ...127 -- see hexdump in my first letter) instead correct file content.
"attempt to access beyond end of device" messages occurs due the same garbage
readed from the Indirect block. I found this garbage present in data buffers
beginning at megaraid driver functions.

I would note that if I read the same file by using dd with bs=1024 or bs=512 --
I get correct file content.

When I use kernel with 4Gb memory limit -- the same cat command return me
correct file content too, without any garbage.

Question is what it is the strange garbage? Have you seen it earlier?
Is it possible that it is some driver-related issue or it is broken hardware?
And why I can workaround this issue by using only 4Gb memory?

Thank you,
	Vasily Averin

SWsoft Virtuozzo/OpenVZ Linux kernel team
