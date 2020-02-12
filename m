Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE4C8C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 22:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A06120848
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 22:03:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J0T7PsSR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgBLWDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 17:03:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40663 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727564AbgBLWDn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2020 17:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581545021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D8jRtKLNTMzQ9F4ovRApdC2gkFDizflEZtluJFlDclQ=;
        b=J0T7PsSRNP9NSwLTbZh/KFIrcyqpiHD3lCfxki4Y6r2bhwtTY4YdMcvvgUDrrrFK09n8OD
        At/alrw83kSOvht1OmUz7HoMW+sG3/4fz4iqFbyh3kcTMdbGkDJdWFSbWyfaSEvXbkauzy
        GQ6mVfpUqh3CCHlZCHg9wlzyT2JJh/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-lyrdfM_wMwaDWqk7cPTnxw-1; Wed, 12 Feb 2020 17:03:39 -0500
X-MC-Unique: lyrdfM_wMwaDWqk7cPTnxw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38ED08017CC;
        Wed, 12 Feb 2020 22:03:38 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A89FB90069;
        Wed, 12 Feb 2020 22:03:32 +0000 (UTC)
Date:   Thu, 13 Feb 2020 06:03:28 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Tim Walker <tim.t.walker@seagate.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200212220328.GB25314@ming.t460p>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 12, 2020 at 01:47:53AM +0000, Damien Le Moal wrote:
> On 2020/02/12 4:01, Tim Walker wrote:
> > On Tue, Feb 11, 2020 at 7:28 AM Ming Lei <ming.lei@redhat.com> wrote:
> >>
> >> On Mon, Feb 10, 2020 at 02:20:10PM -0500, Tim Walker wrote:
> >>> Background:
> >>>
> >>> NVMe specification has hardened over the decade and now NVMe device=
s
> >>> are well integrated into our customers=E2=80=99 systems. As we look=
 forward,
> >>> moving HDDs to the NVMe command set eliminates the SAS IOC and driv=
er
> >>> stack, consolidating on a single access method for rotational and
> >>> static storage technologies. PCIe-NVMe offers near-SATA interface
> >>> costs, features and performance suitable for high-cap HDDs, and
> >>> optimal interoperability for storage automation, tiering, and
> >>> management. We will share some early conceptual results and propose=
d
> >>> salient design goals and challenges surrounding an NVMe HDD.
> >>
> >> HDD. performance is very sensitive to IO order. Could you provide so=
me
> >> background info about NVMe HDD? Such as:
> >>
> >> - number of hw queues
> >> - hw queue depth
> >> - will NVMe sort/merge IO among all SQs or not?
> >>
> >>>
> >>>
> >>> Discussion Proposal:
> >>>
> >>> We=E2=80=99d like to share our views and solicit input on:
> >>>
> >>> -What Linux storage stack assumptions do we need to be aware of as =
we
> >>> develop these devices with drastically different performance
> >>> characteristics than traditional NAND? For example, what schedular =
or
> >>> device driver level changes will be needed to integrate NVMe HDDs?
> >>
> >> IO merge is often important for HDD. IO merge is usually triggered w=
hen
> >> .queue_rq() returns STS_RESOURCE, so far this condition won't be
> >> triggered for NVMe SSD.
> >>
> >> Also blk-mq kills BDI queue congestion and ioc batching, and causes
> >> writeback performance regression[1][2].
> >>
> >> What I am thinking is that if we need to switch to use independent I=
O
> >> path for handling SSD and HDD. IO, given the two mediums are so
> >> different from performance viewpoint.
> >>
> >> [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kern=
el.org_linux-2Dscsi_Pine.LNX.4.44L0.1909181213141.1507-2D100000-40iolanth=
e.rowland.org_&d=3DDwIFaQ&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8s=
OGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3DpSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjG=
SM&s=3DtsnFP8bQIAq7G66B75LTe3vo4K14HbL9JJKsxl_LPAw&e=3D
> >> [2] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kern=
el.org_linux-2Dscsi_20191226083706.GA17974-40ming.t460p_&d=3DDwIFaQ&c=3DI=
GDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3D=
pSnHpt_uQQ73JV4VIQg1C_PVAcLvqBBtmyxQHwWjGSM&s=3DGJwSxXtc_qZHKnrTqSbytUjuR=
rrQgZpvV3bxZYFDHe4&e=3D
> >>
> >>
> >> Thanks,
> >> Ming
> >>
> >=20
> > I would expect the drive would support a reasonable number of queues
> > and a relatively deep queue depth, more in line with NVMe practices
> > than SAS HDD's typical 128. But it probably doesn't make sense to
> > queue up thousands of commands on something as slow as an HDD, and
> > many customers keep queues < 32 for latency management.
>=20
> Exposing an HDD through multiple-queues each with a high queue depth is
> simply asking for troubles. Commands will end up spending so much time
> sitting in the queues that they will timeout. This can already be obser=
ved
> with the smartpqi SAS HBA which exposes single drives as multiqueue blo=
ck
> devices with high queue depth. Exercising these drives heavily leads to
> thousands of commands being queued and to timeouts. It is fairly easy t=
o
> trigger this without a manual change to the QD. This is on my to-do lis=
t of
> fixes for some time now (lacking time to do it).

Just wondering why smartpqi SAS won't set one proper .cmd_per_lun for
avoiding the issue, looks the driver simply assigns .can_queue to it,
then it isn't strange to see the timeout issue. If .can_queue is a bit
big, HDD. is easily saturated too long.

>=20
> NVMe HDDs need to have an interface setup that match their speed, that =
is,
> something like a SAS interface: *single* queue pair with a max QD of 25=
6 or
> less depending on what the drive can take. Their is no TASK_SET_FULL
> notification on NVMe, so throttling has to come from the max QD of the =
SQ,
> which the drive will advertise to the host.
>=20
> > Merge and elevator are important to HDD performance. I don't believe
> > NVMe should attempt to merge/sort across SQs. Can NVMe merge/sort
> > within a SQ without driving large differences between SSD & HDD data
> > paths?
>=20
> As far as I know, there is no merging going on once requests are passed=
 to
> the driver and added to an SQ. So this is beside the point.
> The current default block scheduler for NVMe SSDs is "none". This is
> decided based on the number of queues of the device. For NVMe drives th=
at
> have only a single queue *AND* the QUEUE_FLAG_NONROT flag cleared in th=
eir
> request queue will can fallback to the default spinning rust mq-deadlin=
e
> elevator. That will achieve command merging and LBA ordering needed for
> good performance on HDDs.

mq-deadline basically won't merge IO if STS_RESOURCE isn't returned from
.queue_rq(), or blk_mq_get_dispatch_budget always return true. NVMe's
.queue_rq() basically always returns STS_OK.


Thanks,=20
Ming

