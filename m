From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: megaraid_mbox: garbage in file
Date: Fri, 05 May 2006 10:59:22 -0500
Message-ID: <1146844763.9848.17.camel@mulgrave.il.steeleye.com>
References: <445A4C8F.5030204@sw.ru>
	 <1146783568.22932.105.camel@mulgrave.il.steeleye.com>
	 <445AE4A5.8070202@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:37351 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751148AbWEEQAD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 May 2006 12:00:03 -0400
In-Reply-To: <445AE4A5.8070202@sw.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>
Cc: linux-scsi@vger.kernel.org, Neela.Kolli@engenio.com, Atul Mukker <Atul.Mukker@lsil.com>, Seokmann.Ju@lsil.com, sreenib@lsil.com, devel@openvz.org

On Fri, 2006-05-05 at 09:37 +0400, Vasily Averin wrote:
> The issue is that the correctly finished scsi read command return me garbage
> (repeated 0 ...127 -- see hexdump in my first letter) instead correct file content.
> "attempt to access beyond end of device" messages occurs due the same garbage
> readed from the Indirect block. I found this garbage present in data buffers
> beginning at megaraid driver functions.
> 
> I would note that if I read the same file by using dd with bs=1024 or bs=512 --
> I get correct file content.
> 
> When I use kernel with 4Gb memory limit -- the same cat command return me
> correct file content too, without any garbage.
> 
> Question is what it is the strange garbage? Have you seen it earlier?
> Is it possible that it is some driver-related issue or it is broken hardware?
> And why I can workaround this issue by using only 4Gb memory?

This is really odd ... if the controller can't reach *any* memory above
32 bits, then, on an 8GB machine you'd expect corruption all over the
place since most user pages come from the top of highmem.

The first thing to try, since you have an opteron system, is to get rid
of highmem entirely and use a 64 bit kernel (just to make sure we're not
running into some annoying dma_addr_t conversion problem).  Then, I
suppose if that doesn't work, try printing out the actual contents of
the sg list to see what the physical memory location of the page
containing the corrupt block is.

This could also be a firmware problem, I suppose, but I haven't seen any
similar reports.

James


