From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: READ CAPACITY 16
Date: Thu, 18 Dec 2008 15:41:31 -0500
Message-ID: <494AB57B.1000606@interlog.com>
References: <20081217164210.GC19967@parisc-linux.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46360 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYLRUlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 15:41:51 -0500
In-Reply-To: <20081217164210.GC19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> I'm looking at the UNMAP support again, and we now have a bit that tells
> us whether the device supports UNMAP or not, it's called TPE (Thin
> Provisioning Enabled) and is found in byte 14 of the result from READ
> CAPACITY 16.  The problem is that we do our best to avoid calling READ
> CAPACITY 16.
> 
> Presumably, there are many devices which do not support RC16.  That
> isn't a problem, we can try RC16 and fall back to RC10 if the device
> returns an error.  The question is what to do about devices that either
> hang or take a long time to respond to an RC16 command.
> 
> This kind of problem isn't going to be limited to UNMAP.  DIF/DIX
> already has to use RC16 to get the protection type.  Once 4k sector size
> drives become common, we're going to want the "LOGICAL BLOCKS PER
> PHYSICAL BLOCK EXPONENT" and the "LOWEST ALIGNED LOGICAL BLOCK ADDRESS"
> information that RC16 returns and RC10 doesn't.  There's another 16
> bytes and a couple of reserved 4-bit fields to be assigned too, and I
> can imagine them getting used for new features in the future.
> 
> So what strategy should we adopt for trying harder to issue RC16?
> 
> Algorithm A (a perfect world):
> 
> Issue RC16
>  -> If it fails, issue RC10
>  -> If it times out, reset the device, issue RC10
> 
> Algorithm B:
> 
> Issue RC10
> Issue RC16
>  -> If it succeeds, use its results in preference to those from RC10
>  -> If it fails, carry on with the results from RC10
>  -> If it times out, reset the device, carry on with the results from RC10
> 
> Algorithm C:
> 
> As algorithm B, except:
>  -> If it succeeds, use the RC10 results for LBA unless the LBA is 0xffffffff
>     but use the RC16 results for TPE, PROT, etc.
> 
> Algorithm D:
> 
> Go back to T10 and say "Excuse me, kind sirs, would you mind adding an
> INQUIRY bit to indicate that the device supports UNMAP?  I know you've
> added a bit to RC16, but there's this nasty real world out there where
> devices are apt to blow up if you send them an RC16 when they're not
> expecting it."

T10 proposal 08-149r7 on thin provisioning does add two
extra fields to the Block Limits VPD page. A value greater
than zero in the first extra field ("Maximum UNMAP LBA
count") indicates that thin provisioning is supported.

In my experience it is reasonably safe to fire a "36 byte"
INQUIRY command with the EVPD bit set (with a page code of
B0h in this case) and examine the response. Crappy devices
just ignore the EVPD bit and respond as if it was a standard
INQUIRY, and this is easy to detect. The chances of such
devices supporting thin provisioning are extremely remote.

So if a properly formatted Block Limits VPD page is returned
with "Maximum UNMAP LBA count" > 0 then do a READ CAPACITY 16.

It wouldn't be a bad idea if the block subsystem used some
of the other fields in the Block Limits VPD page.

Doug Gilbert

