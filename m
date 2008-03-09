From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
Date: Sun, 09 Mar 2008 15:55:03 +0300
Message-ID: <47D3DE27.5050707@msgid.tls.msk.ru>
References: <47D3C8A1.6040409@msgid.tls.msk.ru> <20080309212916T.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:21626 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbYCIMzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 08:55:06 -0400
In-Reply-To: <20080309212916T.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> On Sun, 09 Mar 2008 14:23:13 +0300
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>> Just got quite.. bad situation on a production server
>> here.  The machine locked up hard several times in a
>> row (required hard reboot).  So I finally enabled watchdog
>> subsystem which helped.
>>
>> Now I see the following (over netconsole):
>>
>> DMA: Out of SW-IOMMU space for 65536 bytes at device 0000:08:07.0
>> ------------[ cut here ]------------
>> kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
> 
> Seems that you was out of swiommu space (and aic79xx can't handle it
> though it should). This happened because:
> 
> a) you produced more I/Os than swiommu can handle.

Well, this makes little sense, right?  I mean, if just a normal
filesystem I/O produces more I/O requests than the machine can
handle, - it means the kernel is broken.  It shouldn't let the
queue to grow without bounds.

The hardware is quite capable - 14-drives raid10 array works
pretty fast, that is.

> b) swiommu space leaks due to bugs.

which should be quite huge leakage, as it happens almost immediately,
on a freshly booted system.

> If you hit this problem due to a), the following boot option might
> help:
> 
> swiotlb=65536

Just tried this option.  Gzip is working for 15 minutes already, --
previously the system hanged within a first minute, usually first
10 secs.  It seems it will survive the test.

> The same machine run well with old kernels? If so, probably, 2.6.24
> has new bugs that lead to swiommu space leak.

It's difficult to say if it was ok with older kernels.  I'll try anyway.
The thing is that this very workload is new for this machine.  Once
upon a time it hanged in a very similar way, but we had no time to debug
the issue and just ignored it, in a hope for the best.

By the way, is there something to look at, for swiommu space leaks --
like slabinfo for example...?

Thanks!

/mjt
