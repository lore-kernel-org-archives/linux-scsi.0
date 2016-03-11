From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/1] sd: fix lbprz discard granularity as expected
Date: Fri, 11 Mar 2016 22:55:30 +0800
Message-ID: <CAGnHSEn-5=nzryFJ6wZU+f82kHqf6LJLfi6LbWCyq+qd+E1TWQ@mail.gmail.com>
References: <56e12d57.4b43620a.4c8c0.ffff9bc5@mx.google.com>
	<CAGnHSEkGybgU0KXGYg_RLvgbnKvAth4dyHuxMPsKzF7cQs7qgQ@mail.gmail.com>
	<yq11t7hn4i3.fsf@sermon.lab.mkp.net>
	<CAGnHSEn39bHTikNgvJUpoJBFVUFmX=bAuUe9ber9D0EUSgf8NQ@mail.gmail.com>
	<yq1bn6lkx71.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36336 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbcCKOzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 09:55:31 -0500
Received: by mail-yw0-f195.google.com with SMTP id p65so6256023ywb.3
        for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2016 06:55:31 -0800 (PST)
In-Reply-To: <yq1bn6lkx71.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Would min_not_zero() be more proper than max()?

On 11 March 2016 at 20:37, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:
>
> Tom,
>
> Tom> In that case, if the granularity only act as some sort of
> Tom> "reference" but has no real "binding" to the actual behaviour, why
> Tom> would the kernel even "make up" the granularity itself according to
> Tom> the physical block size of the device:
>
> Tom> q-> limits.discard_granularity = max(sdkp->physical_block_size,
> Tom>     sdkp-> unmap_granularity * logical_block_size);
>
> Many devices predate the UNMAP-related fields in the Block Limits
> VPD. There are also devices that do not report an OPTIMAL UNMAP
> GRANULARITY despite supporting UNMAP.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
