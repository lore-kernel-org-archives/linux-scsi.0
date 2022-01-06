Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 856AAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 15:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbiAFPBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 10:01:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43411 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240274AbiAFPBK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 10:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641481269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6wiDPhVilpsI7z5s2ufrl4VWXcGYyJazVed9MxpqocQ=;
        b=Q3JmiTq0SzrlFWFoQes92sGfrbwEZyXUq16zBxOqype4Yr1LSz8FTxoYoHakYGGnaubSar
        5q1fC8JZGg+mh089vOzLXo4Jl1Vuc6TTJBQsprn6wyowd0auwC1OcwXCp++ah4Nx+MsMBT
        Y/GHM4inSKYBwIV8xPkWJhEA2FOxf1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-465-GvNrwfXFNf-JD0hMn9NMdQ-1; Thu, 06 Jan 2022 10:01:06 -0500
X-MC-Unique: GvNrwfXFNf-JD0hMn9NMdQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B89388015CD;
        Thu,  6 Jan 2022 15:01:04 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 721F778AB8;
        Thu,  6 Jan 2022 15:00:58 +0000 (UTC)
Date:   Thu, 6 Jan 2022 23:00:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Message-ID: <YdcEJngPYrZk691Q@T590>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
 <YdZcABq/pxMMh3X0@T590>
 <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 06, 2022 at 10:26:01AM +0000, Martin Wilck wrote:
> On Thu, 2022-01-06 at 11:03 +0800, Ming Lei wrote:
> > On Wed, Jan 05, 2022 at 06:00:41PM +0000, Martin Wilck wrote:
> > > Hello Ming, Sreekanth,
> > > 
> > > I'm observing a problem where mpt3sas fails to allocate the
> > > budget_map
> > > for any SCSI device, because attempted allocation is larger than
> > > the
> > > maximum possible. The issue is caused by the logic used in
> > > 020b0f0a3192
> > > ("scsi: core: Replace sdev->device_busy with sbitmap") 
> > > to calculate the bitmap size. This is observed with 5.16-rc8.
> > > 
> > > The controller at hand has properties can_queue=29865 and
> > > cmd_per_lun=7. The way these parameters are used in
> > > scsi_alloc_sdev()->
> > 
> > That two parameter looks bad, can_queue is too big, however
> > cmd_per_lun
> > is so small.
> 
> Right. @Sreekanth, can you comment on that?
> 
> > > sbitmap_init_node(), this results in an sbitmap with 29865 maps,
> > > where
> > > only a single bit is used per map. On x86_64, this results in an
> > > attempt to allocate 29865 * 192 =  5734080 bytes for the sbitmap,
> > > which
> > > is larger than  PAGE_SIZE * (1 << (MAX_ORDER - 1)), and fails.
> > 
> > Bart has posted one patch for fixing the issue:
> > 
> > https://lore.kernel.org/linux-scsi/20211203231950.193369-2-bvanassche@acm.org/
> > 
> > but it isn't merged yet.
> 
> Thanks a lot for pointing that out. I had a faint remembrance of it but
> failed to locate it yesterday.
> 
> This fixes the allocation failure, but not the fact that for
> cmd_per_lun = 7 (hard-coded in mpt3sas) only a single bit per sbitmap
> is used and the resulting relation between allocated and used memory is
> ridiculous. We'd still allocate 200kiB or 48 contiguous pages, out of
> which no more than 2048 bits / 256 bytes would be used (*); iow at
> least 99.87% of the allocated memory would be wasted. In the default
> case (queue depth left unchanged), we'd use only 2 bytes, and waste
> 99.9989%.

The problem is that mpt3sas uses very weird .can_queue and .cmd_per_lun,
which shouldn't be common.

If .cmd_per_lun is too small, we have to spread the bits among as much
as possible cache lines for avoiding cache line ping-pong, and this kind
of sbitmap principle isn't wrong.

Also we may reduce max queue depth of 1024 too, usually we don't need so
big queue depth to saturate one SSD, and the number should be based on
nvme's setting.

> 
> When calculating the sbitmap shift, would you agree that it makes sense
> to start with the desired number of separate cache lines, as my
> proposed patch did? The core sbitmap code assumes that 4-8 separate
> cache lines are a reasonable value for moderate (4 <= d <= 512) bitmap
> depth. I believe we should aim for that in the SCSI code, too.

Here the actual depth is .cmd_per_lun(7) which is too small, so each
bit may have to consume one standalone cache line.

> Admittedly, the backside of that is that in the default case (queue
> depth unchaged), only a single cache line would be used in the mpt3sas
> scenario.
> 
> Alternatively, we could inhibit increasing the device queue depth above
> a certain multiple of cmd_per_lun, and size the sbitmap by that limit.
> My gut feeling says that if cmd_per_lun == 7, it makes sense to use a
> limit of 32. That way the bitmap would fit into 2 pages; we'd still
> waste a lot, but it wouldn't matter much in absolute numbers. 
> Thus we could forbid increasing the queue depth to more than the power
> of 2 above 4*cmd_per_lun. Does this make sense?

I'd suggest to fix mpt3sas for avoiding this memory waste.

> 
> Regards
> Martin
> 
> (*) this calculation ignores the use of sb->map[i].depth. Taking it
> into account wouldn't change much.

Yeah, I have actually one patch to remove sb->map[].depth, which can
reduce each map's size by 1/3.



Thanks,
Ming

