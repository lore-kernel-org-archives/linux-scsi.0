Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A08C3B188
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 07:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3D7C2168B
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 07:54:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7+X89kH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgBMHyF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 02:54:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20832 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729692AbgBMHyF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Feb 2020 02:54:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581580443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DhtNmiDUJW+7rS6fmiAxhTic8+FFuDLHqobM66ey41E=;
        b=L7+X89kHj9y0ySCeEHf4Rb3RekkJB9xYkmgCDZdN5wXPyNoQX5aK+aHRY157l9V/93W8XS
        KmBVn+9g75ljBn8FEGcNY1/RcVgg9EYJyGuFg+eMUTo729v7Yt7fsiMJTVjqN8OPySQ6mb
        aj43MZA1FjTkhdYLZxeKHOr3sdpnE5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-djjvqUcvMreLcUHNiznM5A-1; Thu, 13 Feb 2020 02:53:59 -0500
X-MC-Unique: djjvqUcvMreLcUHNiznM5A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0DD2101FC66;
        Thu, 13 Feb 2020 07:53:58 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DA425DA7B;
        Thu, 13 Feb 2020 07:53:52 +0000 (UTC)
Date:   Thu, 13 Feb 2020 15:53:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Tim Walker <tim.t.walker@seagate.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200213075348.GA9144@ming.t460p>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200212220328.GB25314@ming.t460p>
 <BYAPR04MB581622DDD1B8B56CEFF3C23AE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR04MB581622DDD1B8B56CEFF3C23AE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 13, 2020 at 02:40:41AM +0000, Damien Le Moal wrote:
> Ming,
>=20
> On 2020/02/13 7:03, Ming Lei wrote:
> > On Wed, Feb 12, 2020 at 01:47:53AM +0000, Damien Le Moal wrote:
> >> On 2020/02/12 4:01, Tim Walker wrote:
> >>> On Tue, Feb 11, 2020 at 7:28 AM Ming Lei <ming.lei@redhat.com> wrot=
e:
> >>>>
> >>>> On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:
> >>>>> Background:
> >>>>>
> >>>>> NVMe specification has hardened over the decade and now NVMe devi=
ces
> >>>>> are well integrated into our customers=E2=80=99 systems. As we lo=
ok forward,
> >>>>> moving HDDs to the NVMe command set eliminates the SAS IOC and dr=
iver
> >>>>> stack, consolidating on a single access method for rotational and
> >>>>> static storage technologies. PCIe-NVMe offers near-SATA interface
> >>>>> costs, features and performance suitable for high-cap HDDs, and
> >>>>> optimal interoperability for storage automation, tiering, and
> >>>>> management. We will share some early conceptual results and propo=
sed
> >>>>> salient design goals and challenges surrounding an NVMe HDD.
> >>>>
> >>>> HDD. performance is very sensitive to IO order. Could you provide =
some
> >>>> background info about NVMe HDD? Such as:
> >>>>
> >>>> - number of hw queues
> >>>> - hw queue depth
> >>>> - will NVMe sort/merge IO among all SQs or not?
> >>>>
> >>>>>
> >>>>>
> >>>>> Discussion Proposal:
> >>>>>
> >>>>> We=E2=80=99d like to share our views and solicit input on:
> >>>>>
> >>>>> -What Linux storage stack assumptions do we need to be aware of a=
s we
> >>>>> develop these devices with drastically different performance
> >>>>> characteristics than traditional NAND? For example, what schedula=
r or
> >>>>> device driver level changes will be needed to integrate NVMe HDDs=
?
> >>>>
> >>>> IO merge is often important for HDD. IO merge is usually triggered=
 when
> >>>> .queue_rq() returns STS_RESOURCE, so far this condition won't be
> >>>> triggered for NVMe SSD.
> >>>>
> >>>> Also blk-mq kills BDI queue congestion and ioc batching, and cause=
s
> >>>> writeback performance regression[1][2].
> >>>>
> >>>> What I am thinking is that if we need to switch to use independent=
 IO
> >>>> path for handling SSD and HDD. IO, given the two mediums are so
> >>>> different from performance viewpoint.
> >>>>
> >>>> [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.ke=
rnel.org_linux-2Dscsi_Pine.LNX.4.44L0.1909181213141.1507-2D100000-40iolan=
the.rowland.org_&d=3DDwIFaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ=
8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwW=
jGSM&s=3DtsnFP8bQIAq7G66B75LTe3vo4K14HbL9JJKsxl_LPAw&e=3D
> >>>> [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.ke=
rnel.org_linux-2Dscsi_20191226083706.GA17974-40ming.t460p_&d=3DDwIFaQ&c=3D=
IGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3D=
pSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3DGJwSxXtc_qZHKnrTqSbytUjuR=
rrQgZpvV3bxZYFDHe4&e=3D
> >>>>
> >>>>
> >>>> Thanks,
> >>>> Ming
> >>>>
> >>>
> >>> I would expect the drive would support a reasonable number of queue=
s
> >>> and a relatively deep queue depth, more in line with NVMe practices
> >>> than SAS HDD's typical 128. But it probably doesn't make sense to
> >>> queue up thousands of commands on something as slow as an HDD, and
> >>> many customers keep queues < 32 for latency management.
> >>
> >> Exposing an HDD through multiple-queues each with a high queue depth=
 is
> >> simply asking for troubles. Commands will end up spending so much ti=
me
> >> sitting in the queues that they will timeout. This can already be ob=
served
> >> with the smartpqi SAS HBA which exposes single drives as multiqueue =
block
> >> devices with high queue depth. Exercising these drives heavily leads=
 to
> >> thousands of commands being queued and to timeouts. It is fairly eas=
y to
> >> trigger this without a manual change to the QD. This is on my to-do =
list of
> >> fixes for some time now (lacking time to do it).
> >=20
> > Just wondering why smartpqi SAS won't set one proper .cmd_per_lun for
> > avoiding the issue, looks the driver simply assigns .can_queue to it,
> > then it isn't strange to see the timeout issue. If .can_queue is a bi=
t
> > big, HDD. is easily saturated too long.
> >=20
> >>
> >> NVMe HDDs need to have an interface setup that match their speed, th=
at is,
> >> something like a SAS interface: *single* queue pair with a max QD of=
 256 or
> >> less depending on what the drive can take. Their is no TASK_SET_FULL
> >> notification on NVMe, so throttling has to come from the max QD of t=
he SQ,
> >> which the drive will advertise to the host.
> >>
> >>> Merge and elevator are important to HDD performance. I don't believ=
e
> >>> NVMe should attempt to merge/sort across SQs. Can NVMe merge/sort
> >>> within a SQ without driving large differences between SSD & HDD dat=
a
> >>> paths?
> >>
> >> As far as I know, there is no merging going on once requests are pas=
sed to
> >> the driver and added to an SQ. So this is beside the point.
> >> The current default block scheduler for NVMe SSDs is "none". This is
> >> decided based on the number of queues of the device. For NVMe drives=
 that
> >> have only a single queue *AND* the QUEUE_FLAG_NONROT flag cleared in=
 their
> >> request queue will can fallback to the default spinning rust mq-dead=
line
> >> elevator. That will achieve command merging and LBA ordering needed =
for
> >> good performance on HDDs.
> >=20
> > mq-deadline basically won't merge IO if STS_RESOURCE isn't returned f=
rom
> > .queue_rq(), or blk_mq_get_dispatch_budget always return true. NVMe's
> > .queue_rq() basically always returns STS_OK.
>=20
> I am confused: when an elevator is set, ->queue_rq() is called for requ=
ests
> obtained from the elevator (with e->type->ops.dispatch_request()), afte=
r
> the requests went through it. And merging will happen at that stage whe=
n
> new requests are inserted in the elevator.

When request is queued to lld via .queue_rq(), the request has been
removed from scheduler queue. And IO merge is just done inside or
against scheduler queue.

>=20
> If the ->queue_rq() returns BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE, t=
he
> request is indeed requeued which offer more chances of further merging,=
 but
> that is not the same as no merging happening.
> Am I missing your point here ?

BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE or getting no budget can be
thought as device saturation feedback, then more requests can be
gathered in scheduler queue since we don't dequeue request from
scheduler queue when that happens, then IO merge is possible.

Without any device saturation feedback from driver, block layer just
dequeues request from scheduler queue with same speed of submission to
hardware, then no IO can be merged.

If you observe sequential IO on NVMe PCI, you will see no IO merge
basically.

=20
Thanks,
Ming

