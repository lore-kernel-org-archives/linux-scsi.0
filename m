Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B463C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 15:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240557AbiAFPlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 10:41:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbiAFPlp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 10:41:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641483705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Rdwgz0CQlOzRHMovvYXy5MGRSx4SdMh0JUg/KZW/Vw=;
        b=MnDB9yvTLWVW53frgoGmn0Zf37Ni8Wff8gDIiMu5W16N8s+shLsQ3X4q3dgZA1+bo7lxNF
        DnalRM3hX66sJoF4INbhtFnDK0QbUcOFUNNxQenW4lsndzS0jIyczXxLFwl6ftCx4j91OP
        EKDqobbBb+/rV/t8dLhhTPKe4HtS5tU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-xTNa5uZnPl-QgvL8AB42fA-1; Thu, 06 Jan 2022 10:41:44 -0500
X-MC-Unique: xTNa5uZnPl-QgvL8AB42fA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4FC693922;
        Thu,  6 Jan 2022 15:41:42 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4959D6784B;
        Thu,  6 Jan 2022 15:41:37 +0000 (UTC)
Date:   Thu, 6 Jan 2022 23:41:33 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: mpt3sas fails to allocate budget_map and detects no devices
Message-ID: <YdcNrSJJGllQzWOB@T590>
References: <be78dc2cfeecaafd171060fbebda2d268d2a94e5.camel@suse.com>
 <YdZcABq/pxMMh3X0@T590>
 <5a450cdadbffed9c5ce39bc7d58bcf4e541f3b53.camel@suse.com>
 <YdcEJngPYrZk691Q@T590>
 <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97be83524e1ee6776a4c1261bf4c1b17a8b75f12.camel@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 06, 2022 at 03:22:53PM +0000, Martin Wilck wrote:
> On Thu, 2022-01-06 at 23:00 +0800, Ming Lei wrote:
> > On Thu, Jan 06, 2022 at 10:26:01AM +0000, Martin Wilck wrote:
> > 
> > > 
> > > Alternatively, we could inhibit increasing the device queue depth
> > > above
> > > a certain multiple of cmd_per_lun, and size the sbitmap by that
> > > limit.
> > > My gut feeling says that if cmd_per_lun == 7, it makes sense to use
> > > a
> > > limit of 32. That way the bitmap would fit into 2 pages; we'd still
> > > waste a lot, but it wouldn't matter much in absolute numbers. 
> > > Thus we could forbid increasing the queue depth to more than the
> > > power
> > > of 2 above 4*cmd_per_lun. Does this make sense?
> > 
> > I'd suggest to fix mpt3sas for avoiding this memory waste.
> 
> Let's wait for Sreekanth's comment on that.
> 
> mpt3sas is not the only driver using a low value. Qlogic drivers set
> cmd_per_lun=3, for example (with 3, our logic would use shift=6, so the
> issue I observed wouldn't occur - but it would be prone to cache line
> bouncing).

But qlogic has smaller .can_queue which looks at most 512, .can_queue is
the depth for allocating sbitmap, since each sdev->queue_depth is <=
.can_queue.

> 
> > > (*) this calculation ignores the use of sb->map[i].depth. Taking it
> > > into account wouldn't change much.
> > 
> > Yeah, I have actually one patch to remove sb->map[].depth, which can
> > reduce each map's size by 1/3.
> 
> That sounds like a great idea to me. I've also been wondering whether

I will post the patch after running some benchmark to make sure no
performance regression.

> it wouldn't be possible to use more than a single word in a cache line
> (given a high-enough number of cache lines).

It seems possible to use more than one single word in one map in case
that depth is high enough, so it is still nothing to with this case.


Thanks,
Ming

