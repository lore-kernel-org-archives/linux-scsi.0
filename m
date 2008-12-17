From: Grant Grundler <grundler@google.com>
Subject: Re: READ CAPACITY 16
Date: Wed, 17 Dec 2008 09:50:52 -0800
Message-ID: <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com>
References: <20081217164210.GC19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:14753 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYLQRu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 12:50:57 -0500
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id mBHHotgv016763
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 09:50:55 -0800
Received: from bwz14 (bwz14.prod.google.com [10.188.26.14])
	by wpaz17.hot.corp.google.com with ESMTP id mBHHoqoJ011535
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 09:50:53 -0800
Received: by bwz14 with SMTP id 14so25502bwz.23
        for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 09:50:52 -0800 (PST)
In-Reply-To: <20081217164210.GC19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 17, 2008 at 8:42 AM, Matthew Wilcox <matthew@wil.cx> wrote:
>
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

I fail to see an effective difference between Algo A and B.
The question really is one you already asked:
> ...The question is what to do about devices that either
> hang or take a long time to respond to an RC16 command.

A few ideas:
1) maintain a blacklist

2) anything in RC10 or IDENTIFY that would clue us about RC16 functionality?
    If so, then something like B or C would make sense.

3) How long does Read Capacity16 normally take?  e.g. at boot time with drive
   that isn't spun up yet or equivalent from RAID device.
   If it's not that long (e.g < 1sec or so) then just use a shorter
timeout in general?
   With parallel scanning, it should be tolerably painful.

hth,
grant

> Algorithm C:
>
> As algorithm B, except:
>  -> If it succeeds, use the RC10 results for LBA unless the LBA is 0xffffffff
>    but use the RC16 results for TPE, PROT, etc.
>
> Algorithm D:
>
> Go back to T10 and say "Excuse me, kind sirs, would you mind adding an
> INQUIRY bit to indicate that the device supports UNMAP?  I know you've
> added a bit to RC16, but there's this nasty real world out there where
> devices are apt to blow up if you send them an RC16 when they're not
> expecting it."
>
>
> Critiques should be expressed in the form of new algorithms.
>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
