Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0290C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B711161405
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 16:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbhDVQPL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 12:15:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236333AbhDVQPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 12:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619108075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=klNHNXgBNFV10IrNMsdHSzWtz6kOuR6tPbKS179ZLWw=;
        b=H4w1oW7yOrAKd0fAGYuFLq9mwMo0VcSIdnysIdkajznK8/X/cZP3QF4HS/qvjl5WuowWGc
        XBp277KPIwHrqPCiBTTaVxqCWphWv1k5u0rLjpeilF5PlrDpxiZW2whgUM0nYKrM2RcKEx
        m1bct6kN8bmmrPXEguAXLqn7+wApyCY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-kKbe-5bpNsq6aH64OBRHSQ-1; Thu, 22 Apr 2021 12:14:30 -0400
X-MC-Unique: kKbe-5bpNsq6aH64OBRHSQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71CA718397AC;
        Thu, 22 Apr 2021 16:14:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5E0B5B4A0;
        Thu, 22 Apr 2021 16:14:23 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
        by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 13MGELPs010060;
        Thu, 22 Apr 2021 11:14:21 -0500
Received: (from bmarzins@localhost)
        by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 13MGEKaM010059;
        Thu, 22 Apr 2021 11:14:20 -0500
Date:   Thu, 22 Apr 2021 11:14:20 -0500
From:   Benjamin Marzinski <bmarzins@redhat.com>
To:     Martin Wilck <martin.wilck@suse.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>
Subject: Re: RFC: one more time: SCSI device identification
Message-ID: <20210422161420.GF20773@octiron.msp.redhat.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
 <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
 <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
 <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
 <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 22, 2021 at 09:07:15AM +0000, Martin Wilck wrote:
> On Wed, 2021-04-21 at 22:46 -0400, Martin K. Petersen wrote:
> > 
> > Martin,
> > 
> > > Hm, it sounds intriguing, but it has issues in its own right. For
> > > years to come, user space will have to probe whether these attribute
> > > exist, and fall back to the current ones ("wwid", "vpd_pg83")
> > > otherwise. So user space can't be simplified any time soon. Speaking
> > > for an important user space consumer of WWIDs (multipathd), I doubt
> > > that this would improve matters for us. We'd be happy if the kernel
> > > could just pick the "best" designator for us. But I understand that
> > > the kernel can't guarantee a good choice (user space can't either).
> > 
> > But user space can be adapted at runtime to pick one designator over
> > the
> > other (ha!).
> 
> And that's exactly the problem. Effectively, all user space relies on
> udev today, because that's where this "adaptation" is taking place. It
> happens
> 
>  1) either in systemd's scsi_id built-in 
>    (https://github.com/systemd/systemd/blob/7feb1dd6544d1bf373dbe13dd33cf563ed16f891/src/udev/scsi_id/scsi_serial.c#L37)
>  2) or in the udev rules coming with sg3_utils 
>    (https://github.com/hreinecke/sg3_utils/blob/master/scripts/55-scsi-sg3_id.rules)
> 
> 1) is just as opaque and un-"adaptable" as the kernel, and the logic is
> suboptimal. 2) is of course "adaptable", but that's a problem in
> practice, if udev fails to provide a WWID. multipath-tools go through
> various twists for this case to figure out "fallback" WWIDs, guessing
> whether that "fallback" matches what udev would have returned if it had
> worked.
> 
> That's the gist of it - the general frustration about udev among some
> of its heaviest users (talk to the LVM2 maintainers).
> 
> I suppose 99.9% of users never bother with customizing the udev rules.
> IOW, these users might as well just use a kernel-provided value. But
> the remaining 0.1% causes headaches for user-space applications, which
> can't make solid assumptions about the rules. Thus, in a way, the
> flexibility of the rules does more harm than it helps.
> 
> > We could do that in the kernel too, of course, but I'm afraid what
> > the
> > resulting BLIST changes would end up looking like over time.
> 
> That's something we want to avoid, sure.
> 
> But we can actually combine both approaches. If "wwid" yields a good
> value most of the time (which is true IMO), we could make user space
> rely on it by default, and make it possible to set an udev property
> (e.g. ENV{ID_LEGACY}="1") to tell udev rules to determine WWID
> differently. User-space apps like multipath could check the ID_LEGACY
> property to determine whether or not reading the "wwid" attribute would
> be consistent with udev. That would simplify matters a lot for us (Ben,
> do you agree?), without the need of adding endless BLIST entries.
> 

Yeah, as long as ID_LEGACY was changed in a careful manner, so WWIDs
didn't simply change without warning because of an upgrade, a path out
of this complexity is a definitely helpful.

-Ben

> 
> > I am also very concerned about changing what the kernel currently
> > exports in a given variable like "wwid". A seemingly innocuous change
> > to
> > the reported value could lead to a system no longer booting after
> > updating the kernel.
> 
> AFAICT, no major distribution uses "wwid" for this purpose (yet). I
> just recently realized that the kernel's ALUA code refers to it. (*)
> 
> In a recent discussion with Hannes, the idea came up that the priority
> of "SCSI name string" designators should actually depend on their
> subtype. "naa." name strings should map to the respective NAA
> descriptors, and "eui.", likewise (only "iqn." descriptors have no
> binary counterpart; we thought they should rather be put below NAA,
> prio-wise).
> 
> I wonder if you'd agree with a change made that way for "wwid". I
> suppose you don't. I'd then propose to add a new attribute following
> this logic. It could simply be an additional attribute with a different
> name. Or this new attribute could be a property of the block device
> rather than the SCSI device, like NVMe does it
> (/sys/block/nvme0n2/wwid).
> 
> I don't like the idea of having separate sysfs attributes for
> designators of different types, that's impractical for user space.
> 
> > But taking a step back: Other than "it's not what userland currently
> > does", what specifically is the problem with designator_prio()? We've
> > picked the priority list once and for all. If we promise never to
> > change
> > it, what is the issue?
> 
> If the prioritization in kernel and user space was the same, we could
> migrate away from udev more easily without risking boot failure.
> 
> Thanks,
> Martin
> 
> (*) which is an argument for using "wwid" in user space too - just to
> be consitent with the kernel's internal logic.
> 
> -- 
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Software Solutions Germany GmbH
> HRB 36809, AG Nürnberg GF: Felix Imendörffer
> 

