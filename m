From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Wed, 24 Jun 2015 00:41:20 +0800
Message-ID: <CAGnHSEm89yFPPTVUtbk1s84wanKK6RTY5hdZCMdbw+a+vwecDA@mail.gmail.com>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	<yq1616f796w.fsf@sermon.lab.mkp.net>
	<CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
	<yq1bng65te8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:34513 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbbFWQlV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2015 12:41:21 -0400
In-Reply-To: <yq1bng65te8.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On 23 June 2015 at 23:36, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>
> You haven't given us any reason to. We are not aware of any ATA drives
> that put constraints on the range block count.
>

What I have been doing is trying to show you example of those
constraints. When I talked about the block count limit of the SanDisk
Extreme USB, I am not asking you to fix anything for the drive I HAVE
(because I can only use hdparm to TRIM it anyway), but to show you
that some devices MIGHT have such limit. I just can't be 100% sure of
it, even though from what I see in the different results on payload
size and range sector count, I don't think the bridge is intervening
at all (but just the limit of the SATA controller behind).

But for my Intel 530 SSD, the granularity problem is obvious and solid
enough because it's connected directly with SATA. Currently what the
kernel does is assume all devices support 1 sector granularity. And
the problem doesn't even lie on the current "hardcoded" granularity in
libata, because blkdev_issue_discard() only does "mod check" against
the granularity on the maximum sector counts, so even if it's allowed
to be configured, it wouldn't really help. And I have yet to see
anything which actually does "mod check" against ANY granularity on
the sector count per range. This is what the example in my last mail
was about.

And the only info I have ever saw about TRIM block limit of a SATA
drive is in `hdparm -I`. For my Intel SSD, which actually has a lower
limit of 8 sectors, it shows:
Data Set Management TRIM supported (limit 1 block)
while for the SanDisk Extreme USB, which actually has a lower limit of
256 sectors, it shows:
Data Set Management TRIM supported (limit 8 blocks)
Inspite of the accuracy, I don't see the kernel actually read this limit.
