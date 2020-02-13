Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358E6C2BA83
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 08:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA2362173E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 08:34:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N2Tf0P4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgBMIea (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 03:34:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36354 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbgBMIea (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2020 03:34:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581582868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6P1v3Iu+hoMwyAvZnsnqaeTi9OyAbNLGVDD6m0DAybk=;
        b=N2Tf0P4duagF2amXm/qw/wLKuFwB58SzaSjukR7V5QIRd7NYUBPuAeyhYd8AZX6o59XxRn
        WVDeL2ts/DCDl9EZRiPVHufNLhMWOr2gDiEWdxRpnhIfxh54RhIhmcTj1MNauJ+dgYsxZJ
        z6rYic+SJ4waaR8rwSgARFdYkihs9nc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-rJ6TtbbAOv-cPsU2696GIw-1; Thu, 13 Feb 2020 03:34:25 -0500
X-MC-Unique: rJ6TtbbAOv-cPsU2696GIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82C5D802568;
        Thu, 13 Feb 2020 08:34:23 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA4AF1001B28;
        Thu, 13 Feb 2020 08:34:17 +0000 (UTC)
Date:   Thu, 13 Feb 2020 16:34:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Tim Walker <tim.t.walker@seagate.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200213083413.GC9144@ming.t460p>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200212220328.GB25314@ming.t460p>
 <BYAPR04MB581622DDD1B8B56CEFF3C23AE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200213075348.GA9144@ming.t460p>
 <BYAPR04MB58160C04182D5FE3A15842BBE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR04MB58160C04182D5FE3A15842BBE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 13, 2020 at 08:24:36AM +0000, Damien Le Moal wrote:
> On 2020/02/13 16:54, Ming Lei wrote:
> > On Thu, Feb 13, 2020 at 02:40:41AM +0000, Damien Le Moal wrote:
> >> Ming,
> >>
> >> On 2020/02/13 7:03, Ming Lei wrote:
> >>> On Wed, Feb 12, 2020 at 01:47:53AM +0000, Damien Le Moal wrote:
> >>>> On 2020/02/12 4:01, Tim Walker wrote:
> >>>>> On Tue, Feb 11, 2020 at 7:28 AM Ming Lei <ming.lei@redhat.com> wr=
ote:
> >>>>>>
> >>>>>> On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:
> >>>>>>> Background:
> >>>>>>>
> >>>>>>> NVMe specification has hardened over the decade and now NVMe de=
vices
> >>>>>>> are well integrated into our customers=E2=80=99 systems. As we =
look forward,
> >>>>>>> moving HDDs to the NVMe command set eliminates the SAS IOC and =
driver
> >>>>>>> stack, consolidating on a single access method for rotational a=
nd
> >>>>>>> static storage technologies. PCIe-NVMe offers near-SATA interfa=
ce
> >>>>>>> costs, features and performance suitable for high-cap HDDs, and
> >>>>>>> optimal interoperability for storage automation, tiering, and
> >>>>>>> management. We will share some early conceptual results and pro=
posed
> >>>>>>> salient design goals and challenges surrounding an NVMe HDD.
> >>>>>>
> >>>>>> HDD. performance is very sensitive to IO order. Could you provid=
e some
> >>>>>> background info about NVMe HDD? Such as:
> >>>>>>
> >>>>>> - number of hw queues
> >>>>>> - hw queue depth
> >>>>>> - will NVMe sort/merge IO among all SQs or not?
> >>>>>>
> >>>>>>>
> >>>>>>>
> >>>>>>> Discussion Proposal:
> >>>>>>>
> >>>>>>> We=E2=80=99d like to share our views and solicit input on:
> >>>>>>>
> >>>>>>> -What Linux storage stack assumptions do we need to be aware of=
 as we
> >>>>>>> develop these devices with drastically different performance
> >>>>>>> characteristics than traditional NAND? For example, what schedu=
lar or
> >>>>>>> device driver level changes will be needed to integrate NVMe HD=
Ds?
> >>>>>>
> >>>>>> IO merge is often important for HDD. IO merge is usually trigger=
ed when
> >>>>>> .queue_rq() returns STS_RESOURCE, so far this condition won't be
> >>>>>> triggered for NVMe SSD.
> >>>>>>
> >>>>>> Also blk-mq kills BDI queue congestion and ioc batching, and cau=
ses
> >>>>>> writeback performance regression[1][2].
> >>>>>>
> >>>>>> What I am thinking is that if we need to switch to use independe=
nt IO
> >>>>>> path for handling SSD and HDD. IO, given the two mediums are so
> >>>>>> different from performance viewpoint.
> >>>>>>
> >>>>>> [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.=
kernel.org_linux-2Dscsi_Pine.LNX.4.44L0.1909181213141.1507-2D100000-40iol=
anthe.rowland.org_&d=3DDwIFaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEl=
uZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQH=
wWjGSM&s=3DtsnFP8bQIAq7G66B75LTe3vo4K14HbL9JJKsxl_LPAw&e=3D
> >>>>>> [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.=
kernel.org_linux-2Dscsi_20191226083706.GA17974-40ming.t460p_&d=3DDwIFaQ&c=
=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU=
&m=3DpSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3DGJwSxXtc_qZHKnrTqSby=
tUjuRrrQgZpvV3bxZYFDHe4&e=3D
> >>>>>>
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Ming
> >>>>>>
> >>>>>
> >>>>> I would expect the drive would support a reasonable number of que=
ues
> >>>>> and a relatively deep queue depth, more in line with NVMe practic=
es
> >>>>> than SAS HDD's typical 128. But it probably doesn't make sense to
> >>>>> queue up thousands of commands on something as slow as an HDD, an=
d
> >>>>> many customers keep queues < 32 for latency management.
> >>>>
> >>>> Exposing an HDD through multiple-queues each with a high queue dep=
th is
> >>>> simply asking for troubles. Commands will end up spending so much =
time
> >>>> sitting in the queues that they will timeout. This can already be =
observed
> >>>> with the smartpqi SAS HBA which exposes single drives as multiqueu=
e block
> >>>> devices with high queue depth. Exercising these drives heavily lea=
ds to
> >>>> thousands of commands being queued and to timeouts. It is fairly e=
asy to
> >>>> trigger this without a manual change to the QD. This is on my to-d=
o list of
> >>>> fixes for some time now (lacking time to do it).
> >>>
> >>> Just wondering why smartpqi SAS won't set one proper .cmd_per_lun f=
or
> >>> avoiding the issue, looks the driver simply assigns .can_queue to i=
t,
> >>> then it isn't strange to see the timeout issue. If .can_queue is a =
bit
> >>> big, HDD. is easily saturated too long.
> >>>
> >>>>
> >>>> NVMe HDDs need to have an interface setup that match their speed, =
that is,
> >>>> something like a SAS interface: *single* queue pair with a max QD =
of 256 or
> >>>> less depending on what the drive can take. Their is no TASK_SET_FU=
LL
> >>>> notification on NVMe, so throttling has to come from the max QD of=
 the SQ,
> >>>> which the drive will advertise to the host.
> >>>>
> >>>>> Merge and elevator are important to HDD performance. I don't beli=
eve
> >>>>> NVMe should attempt to merge/sort across SQs. Can NVMe merge/sort
> >>>>> within a SQ without driving large differences between SSD & HDD d=
ata
> >>>>> paths?
> >>>>
> >>>> As far as I know, there is no merging going on once requests are p=
assed to
> >>>> the driver and added to an SQ. So this is beside the point.
> >>>> The current default block scheduler for NVMe SSDs is "none". This =
is
> >>>> decided based on the number of queues of the device. For NVMe driv=
es that
> >>>> have only a single queue *AND* the QUEUE_FLAG_NONROT flag cleared =
in their
> >>>> request queue will can fallback to the default spinning rust mq-de=
adline
> >>>> elevator. That will achieve command merging and LBA ordering neede=
d for
> >>>> good performance on HDDs.
> >>>
> >>> mq-deadline basically won't merge IO if STS_RESOURCE isn't returned=
 from
> >>> .queue_rq(), or blk_mq_get_dispatch_budget always return true. NVMe=
's
> >>> .queue_rq() basically always returns STS_OK.
> >>
> >> I am confused: when an elevator is set, ->queue_rq() is called for r=
equests
> >> obtained from the elevator (with e->type->ops.dispatch_request()), a=
fter
> >> the requests went through it. And merging will happen at that stage =
when
> >> new requests are inserted in the elevator.
> >=20
> > When request is queued to lld via .queue_rq(), the request has been
> > removed from scheduler queue. And IO merge is just done inside or
> > against scheduler queue.
>=20
> Yes, for incoming new BIOs, not for requests passed to the LLD.
>=20
> >> If the ->queue_rq() returns BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE=
, the
> >> request is indeed requeued which offer more chances of further mergi=
ng, but
> >> that is not the same as no merging happening.
> >> Am I missing your point here ?
> >=20
> > BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE or getting no budget can be
> > thought as device saturation feedback, then more requests can be
> > gathered in scheduler queue since we don't dequeue request from
> > scheduler queue when that happens, then IO merge is possible.
> >=20
> > Without any device saturation feedback from driver, block layer just
> > dequeues request from scheduler queue with same speed of submission t=
o
> > hardware, then no IO can be merged.
>=20
> Got it. And since queue full will mean no more tags, submission will bl=
ock
> on get_request() and there will be no chance in the elevator to merge
> anything (aside from opportunistic merging in plugs), isn't it ?
> So I guess NVMe HDDs will need some tuning in this area.

scheduler queue depth is usually 2 times of hw queue depth, so requests
ar usually enough for merging.

For NVMe, there isn't ns queue depth, such as scsi's device queue depth,
meantime the hw queue depth is big enough, so no chance to trigger merge.

Thanks,
Ming

