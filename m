Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF16CC3B187
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5FC7206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:53:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cczI1ISe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgBLVxJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:53:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38716 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727791AbgBLVxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2020 16:53:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581544388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uUNF4mFLDeL4hFAUJm3ZVfVA2T7sNbN4BswQ0XSOhjI=;
        b=cczI1ISe5Ksh9ixOR/Ukrk7qGuPGPVfKQ1rChGTl+szbgJaScr6IYGCxGuCPTCpYs/vNKa
        fs2OTVS5umPgd0wGg8q8vvaPAtNslTQA/58lYEeSIvW9mJIJjEtRVoQayv0Mn/44O1g5N+
        8A8H+ngkJIo1hqc3XEr/utiGbwc8e+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-f9KzPxWqMUykbjOQIliW3w-1; Wed, 12 Feb 2020 16:53:03 -0500
X-MC-Unique: f9KzPxWqMUykbjOQIliW3w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42634107ACCA;
        Wed, 12 Feb 2020 21:53:02 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 424D05C12E;
        Wed, 12 Feb 2020 21:52:55 +0000 (UTC)
Date:   Thu, 13 Feb 2020 05:52:51 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Tim Walker <tim.t.walker@seagate.com>
Cc:     linux-block@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200212215251.GA25314@ming.t460p>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 11, 2020 at 02:01:18PM -0500, Tim Walker wrote:
> On Tue, Feb 11, 2020 at 7:28 AM Ming Lei <ming.lei@redhat.com> wrote:
> >
> > On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:
> > > Background:
> > >
> > > NVMe specification has hardened over the decade and now NVMe device=
s
> > > are well integrated into our customers=E2=80=99 systems. As we look=
 forward,
> > > moving HDDs to the NVMe command set eliminates the SAS IOC and driv=
er
> > > stack, consolidating on a single access method for rotational and
> > > static storage technologies. PCIe-NVMe offers near-SATA interface
> > > costs, features and performance suitable for high-cap HDDs, and
> > > optimal interoperability for storage automation, tiering, and
> > > management. We will share some early conceptual results and propose=
d
> > > salient design goals and challenges surrounding an NVMe HDD.
> >
> > HDD. performance is very sensitive to IO order. Could you provide som=
e
> > background info about NVMe HDD? Such as:
> >
> > - number of hw queues
> > - hw queue depth
> > - will NVMe sort/merge IO among all SQs or not?
> >
> > >
> > >
> > > Discussion Proposal:
> > >
> > > We=E2=80=99d like to share our views and solicit input on:
> > >
> > > -What Linux storage stack assumptions do we need to be aware of as =
we
> > > develop these devices with drastically different performance
> > > characteristics than traditional NAND? For example, what schedular =
or
> > > device driver level changes will be needed to integrate NVMe HDDs?
> >
> > IO merge is often important for HDD. IO merge is usually triggered wh=
en
> > .queue_rq() returns STS_RESOURCE, so far this condition won't be
> > triggered for NVMe SSD.
> >
> > Also blk-mq kills BDI queue congestion and ioc batching, and causes
> > writeback performance regression[1][2].
> >
> > What I am thinking is that if we need to switch to use independent IO
> > path for handling SSD and HDD. IO, given the two mediums are so
> > different from performance viewpoint.
> >
> > [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kerne=
l.org_linux-2Dscsi_Pine.LNX.4.44L0.1909181213141.1507-2D100000-40iolanthe=
.rowland.org_&d=3DDwIFaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sO=
GXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGS=
M&s=3DtsnFP8bQIAq7G66B75LTe3vo4K14HbL9JJKsxl_LPAw&e=3D
> > [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kerne=
l.org_linux-2Dscsi_20191226083706.GA17974-40ming.t460p_&d=3DDwIFaQ&c=3DIG=
Dlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3D=
pSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3DGJwSxXtc_qZHKnrTqSbytUjuR=
rrQgZpvV3bxZYFDHe4&e=3D
> >
> >
> > Thanks,
> > Ming
> >
>=20
> I would expect the drive would support a reasonable number of queues
> and a relatively deep queue depth, more in line with NVMe practices
> than SAS HDD's typical 128. But it probably doesn't make sense to
> queue up thousands of commands on something as slow as an HDD, and
> many customers keep queues < 32 for latency management.

MQ & deep queue depth will cause trouble for HDD., as Damien mentioned,=20
IO timeout may be caused. Then looks you need to add per-ns queue depth,
just like what sdev->device_busy does for avoiding IO timeout. On the
other hand, with per-ns queue depth, you may prevent IO submitted to NVMe
when this ns is saturated, then block layer's IO merge can be triggered.

>=20
> Merge and elevator are important to HDD performance. I don't believe
> NVMe should attempt to merge/sort across SQs. Can NVMe merge/sort
> within a SQ without driving large differences between SSD & HDD data
> paths?

If NVMe doesn't sort/merge across SQs, it should be better to just use
single queue for HDD. Otherwise, it is easy to break IO order & merge.

Even someone complains that sequential IO becomes dis-continuous on
NVMe(SSD) when arbitration burst is less than IO queue depth. It is said
fio performance is hurt, but I don't understand how that can happen on
SSD.


Thanks,
Ming

