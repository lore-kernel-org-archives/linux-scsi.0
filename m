From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Tue, 23 Jun 2015 22:16:22 +0800
Message-ID: <CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	<yq1616f796w.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36044 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350AbbFWOQX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2015 10:16:23 -0400
In-Reply-To: <yq1616f796w.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Still, I wonder if the kernel should allow the user to configure the
real granularity and send ATA commands that are rounded off by it
(which works just like --step in blkdiscard). For example,

(64 * 65535) % 8 = 0

but

65535 % 8 = 7

So the block count limit for the ATA commands would be 65535 - (65535
% real_gran) per range.


Also, by experimenting on my SanDisk Extreme USB with hdparm TRIM and
hexdump, I can see that the maximum block/sector allowed to be
discarded per ATA command is 65536, inspite of the payload size. I
don't know whether the USB bridging or the way hdparm does TRIM
matters, but it seems that some devices can't really handle limit like
0x3fffc0 blocks.

So I still think that the kernel should allow users to configure
limits that can make libata send reliable ATA TRIM commands.

On 23 June 2015 at 04:57, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>
> Tom> So it actually tells. And I hope that the kernel wouldn't "falsify"
> Tom> anything for devices which do provide some VPD(s). : \
>
> SATA doesn't have VPDs.
>

I know now, that's why I think it's "alright" for libata to do so. I
just don't know whether the kernel would tamper with them for devices
like USB or real SCSI drives.
