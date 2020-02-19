Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B978BC34047
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 16:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7425A2067D
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 16:29:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seagate.com header.i=@seagate.com header.b="0YdfWtcy";
	dkim=pass (2048-bit key) header.d=seagate.com header.i=@seagate.com header.b="MLX9vbFb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgBSQ3H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 11:29:07 -0500
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:33844 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726712AbgBSQ3G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Feb 2020 11:29:06 -0500
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01JGSFHh030717
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 11:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=proofpoint;
 bh=1lxPn5J8l7sAgo/GHD0tAxkrMHXMjx4BXV7yqQDCzqc=;
 b=0YdfWtcyZRSlaV4APnz7JncVJr5FNIRt30VCaZRLupPXF6dA6F8/Xg9c9I+vFiEXD1rv
 KzJ0N2dikcpj7+AWVtdtaARosbeOa48awnxtfdW2zOjpMq4/BN7rggQHkYvN3SHvZf+s
 4NxQeSOQLIuXUPzR9l9v7Qp0DELBZhxZTT0NpU/937ZdQIly2MgeVrn2oty4ojQQBVph
 y+mcB0nfSZabqJL/8r5aE8zqSvCM+ZGMhotlyN6h/xNu7lCK7qkD6UZRPSPaCu8xNLZ3
 bprmLvCCExuOChX3kI42VKGyDxQcyxj9kE0NrWU2eWZLw35kreDPcodRKMUwaovwXkZ8 0w== 
Authentication-Results: seagate.com;
        dkim=pass header.s=google header.d=seagate.com
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        by mx0a-00003501.pphosted.com with ESMTP id 2y8ubkbke7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 11:29:04 -0500
Received: by mail-wr1-f69.google.com with SMTP id n23so313997wra.20
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 08:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=seagate.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1lxPn5J8l7sAgo/GHD0tAxkrMHXMjx4BXV7yqQDCzqc=;
        b=MLX9vbFbP65j85qKNvipcw9YLHTREF9ax9V+7I+oo8m0JvELcjUItp2Rt1s7EPiGlL
         7WRxk3feo/AdV/bzIqoojrVBpExiOh+jy8qhKCWMLQNdYUt0Ysc8QFhihFbEFyA1IHAr
         DgcyFotHHbjD4t1ycWeyHx1dvhZn0eCZRoTqxwnvAvDukbU/3HZjnfJVPBDJ5+PEo5Rs
         aRHZCffPq1lEovYxwVkY+nt7B4xFkBY/9pG9q251XbY+cVBvj94xtA7h7BTimKEbtdp4
         g2Oaz5FqR5gQKXkESBmTWxnt1EvwV7YiVAfk7pOfbvODkyD+CZ1DAqCyJkH3VVNggcNH
         VQ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1lxPn5J8l7sAgo/GHD0tAxkrMHXMjx4BXV7yqQDCzqc=;
        b=oClKRTbVhcV/Xq8BU0xiz/34EeiMQYO+q8UrnZ8bZx2H7H8e8EHWGXp2AtFql1oO5w
         fAVxFAhjhCv/gisRbc72dIe94QB7mr2e/E6HUPFk4RYHI1Hq++AT2cQkm+yco2hxleme
         UrrsYVzbODvzUZ8VAni+NmBST6D0iASOzhx7v3Q3wUWJDWAKH7uksFuPE7iy9b4/dX5d
         IYaQFwAU/mOnCMIXzdcYzUGl8ap3ZJxF8ffwKbq9toLTGjjoyhqLBZE/ZimjVzHTrMg7
         8LyUJgDuhsABF+6W7r4TOWDHJ5iRgs+PGBSoPDqt4cQ2L943Kdt5mQAtFn1f2RuyqShx
         2Bng==
X-Gm-Message-State: APjAAAXx9L9GZauERoQiKhPZ4Yp4clamrpqrbtv3hgiryTrSmfhqE3Y4
        A0HMdLFXLKrrgs8gCE/zvl5gObpPkOZWfcbg8InISMWQFlWkG6ugUolBG/TnGoR64dR43aXNUnU
        C09ROaJvwAWgl1FlemBw0i9DVoTOXk3/gNGYOmgHsYaGHsPwVPqVwS8uP6AahFEw=
X-Received: by 2002:a1c:5f8a:: with SMTP id t132mr11069676wmb.162.1582129739603;
        Wed, 19 Feb 2020 08:28:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwpZjopGkNRUbUmjFCRC/J5GZcSk0RT7uEgunWC5mKDJRnefetL+ahyCqNcjJoya29Md6LjRgQsTIKgBBDakj0=
X-Received: by 2002:a1c:5f8a:: with SMTP id t132mr11069640wmb.162.1582129739117;
 Wed, 19 Feb 2020 08:28:59 -0800 (PST)
MIME-Version: 1.0
References: <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com> <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
 <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com> <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
 <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com> <CANo=J17Rve2mMLb_yJNFK5m8wt5Wi4c+b=-a5BJ5kW3RaWuQVg@mail.gmail.com>
 <20200218174114.GA17609@redsun51.ssa.fujisawa.hgst.com> <20200219013137.GA31488@ming.t460p>
 <BYAPR04MB58165C6B400AE30986F988D5E7100@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200219021540.GC31488@ming.t460p> <BYAPR04MB5816DF16BC3720ABF286671EE7100@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CANo=J15Wvm2R+vuLj6QQ5Vete507cA==5Rw=4vn3Z8npZ=2vww@mail.gmail.com>
In-Reply-To: <CANo=J15Wvm2R+vuLj6QQ5Vete507cA==5Rw=4vn3Z8npZ=2vww@mail.gmail.com>
From:   Tim Walker <tim.t.walker@seagate.com>
Date:   Wed, 19 Feb 2020 11:28:46 -0500
Message-ID: <CANo=J14GM=Uu7qWirtvgzjEKVCzLV0nZLOOPqD9M+nwOKrv7yQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-PolicyRoute: Outbound
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-19_04:2020-02-19,2020-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002190125
X-Proofpoint-Spam-Policy: Default Domain Policy
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 18, 2020 at 9:56 PM Tim Walker <tim.t.walker@seagate.com> wrote=
:
>
> On Tue, Feb 18, 2020 at 9:32 PM Damien Le Moal <Damien.LeMoal@wdc.com> wr=
ote:
> >
> > On 2020/02/19 11:16, Ming Lei wrote:
> > > On Wed, Feb 19, 2020 at 01:53:53AM +0000, Damien Le Moal wrote:
> > >> On 2020/02/19 10:32, Ming Lei wrote:
> > >>> On Wed, Feb 19, 2020 at 02:41:14AM +0900, Keith Busch wrote:
> > >>>> On Tue, Feb 18, 2020 at 10:54:54AM -0500, Tim Walker wrote:
> > >>>>> With regards to our discussion on queue depths, it's common knowl=
edge
> > >>>>> that an HDD choses commands from its internal command queue to
> > >>>>> optimize performance. The HDD looks at things like the current
> > >>>>> actuator position, current media rotational position, power
> > >>>>> constraints, command age, etc to choose the best next command to
> > >>>>> service. A large number of commands in the queue gives the HDD a
> > >>>>> better selection of commands from which to choose to maximize
> > >>>>> throughput/IOPS/etc but at the expense of the added latency due t=
o
> > >>>>> commands sitting in the queue.
> > >>>>>
> > >>>>> NVMe doesn't allow us to pull commands randomly from the SQ, so t=
he
> > >>>>> HDD should attempt to fill its internal queue from the various SQ=
s,
> > >>>>> according to the SQ servicing policy, so it can have a large numb=
er of
> > >>>>> commands to choose from for its internal command processing
> > >>>>> optimization.
> > >>>>
> > >>>> You don't need multiple queues for that. While the device has to f=
ifo
> > >>>> fetch commands from a host's submission queue, it may reorder thei=
r
> > >>>> executuion and completion however it wants, which you can do with =
a
> > >>>> single queue.
> > >>>>
> > >>>>> It seems to me that the host would want to limit the total number=
 of
> > >>>>> outstanding commands to an NVMe HDD
> > >>>>
> > >>>> The host shouldn't have to decide on limits. NVMe lets the device =
report
> > >>>> it's queue count and depth. It should the device's responsibility =
to
> > >>>
> > >>> Will NVMe HDD support multiple NS? If yes, this queue depth isn't
> > >>> enough, given all NSs share this single host queue depth.
> > >>>
> > >>>> report appropriate values that maximize iops within your latency l=
imits,
> > >>>> and the host will react accordingly.
> > >>>
> > >>> Suppose NVMe HDD just wants to support single NS and there is singl=
e queue,
> > >>> if the device just reports one host queue depth, block layer IO sor=
t/merge
> > >>> can only be done when there is device saturation feedback provided.
> > >>>
> > >>> So, looks either NS queue depth or per-NS device saturation feedbac=
k
> > >>> mechanism is needed, otherwise NVMe HDD may have to do internal IO
> > >>> sort/merge.
> > >>
> > >> SAS and SATA HDDs today already do internal IO reordering and mergin=
g, a
> > >> lot. That is partly why even with "none" set as the scheduler, you c=
an see
> > >> iops increasing with QD used.
> > >
> > > That is why I asked if NVMe HDD will attempt to sort/merge IO among S=
Qs
> > > from the beginning, but Tim said no, see:
> > >
> > > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lore.kernel.or=
g_linux-2Dblock_20200212215251.GA25314-40ming.t460p_T_-23m2d0eff5ef8fcaced0=
f304180e571bb8fefc72e84&d=3DDwIFAg&c=3DIGDlg0lD0b-nebmJJ0Kp8A&r=3DNW1X0yRHN=
NEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=3DnUNT2_IvSlbeY_25S516HctZv4od6WK6h2q2=
_C4Q8SY&s=3DTTxCbaBVGOCBZROb7fqSBDCe9wIZrYdBDSCW2TqrLzM&e=3D
> > >
> > > It could be cheap for NVMe HDD to do that, given all queues/requests
> > > just stay in system's RAM.
> >
> > Yes. Keith also commented on that. SQEs have to be removed in order fro=
m
> > the SQ, but that does not mean that the disk has to execute them in ord=
er.
> > So I do not think this is an issue.
> >
> > > Also I guess internal IO sort/merge may not be good enough compared w=
ith
> > > SW's implementation:
> > >
> > > 1) device internal queue depth is often low, and the participated req=
uests won't
> > > be enough many, but SW's scheduler queue depth is often 2 times of
> > > device queue depth.
> >
> > Drive internal QD can actually be quite large to accommodate for intern=
al
> > house-keeping commands (e.g. ATI/FTI refreshes, media cache flushes, et=
c)
> > while simultaneously executing incoming user commands. These internal t=
ask
> > are often one of the reason for SAS drives to return QF at different
> > host-seen QD, and why in the end NVMe may need a mechanism similar to t=
ask
> > set full notifications in SAS.
> >
> > > 2) HDD drive doesn't have context info, so when concurrent IOs are ru=
n from
> > > multiple contexts, HDD internal reorder/merge can't work well enough.=
 blk-mq
> > > doesn't address this case too, however the legacy IO path does consid=
er that
> > > via IOC batch.>
> > >
> > > Thanks,
> > > Ming
> > >
> > >
> >
> >
> > --
> > Damien Le Moal
> > Western Digital Research
> [sorry for the duplicate mailing - forgot about plain text!]
>
> Hi Damien-
>
> You're right. The HDD needs those commands in its internal queue to
> sort and merge them, because commands are pulled from the SQ strictly
> FIFO which precludes any sorting or merging within the SQ. That being
> said, HDDs still work better with a good kernel scheduler to group
> commands into HDD-friendly sequences. So it would be helpful if we
> could devise a method to help the kernel sort/merge before loading the
> commands into the SQ, just as we do with SCSI today.
>
> Ming:
> Regarding sorting across SQs, I mean to say these two things:
> 1. The HDD would not try and reach up into the SQs and choose the next
> best command. I understand the SQs are FIFO, so that is why NVMe HDD
> has to pull them into our internal queue for sorting and merging. Our
> internal queue has historically been more than adequate (SAS-256,
> SATA-32) to provide pretty good optimization without excessive command
> latencies.
>
> 2. Also, I know NVMe specifically does not imply any completion order
> within the SQ, but an NVMe HDD will likely honor the submission order
> within any single SQ, but not try and correlate across multiple SQs
> (if the host sets up multiple SQs). I believe this is different from
> SSD. I think of this as being left over from SAS/SATA where we manage
> overlapped commands by command order-of-arrival.
>
> Many HDD customers spend a lot of time balancing workload and queue
> depth to reach the IOPS/throughput targets they desire. It's not
> straightforward since HDD command completion time is extremely
> workload-sensitive. Some more sophisticated customers dynamically
> control queue depth to keep all the command latencies within QOS. But
> that requires extensive workload characterization, plus knowledge of
> the upcoming workload, both of which makes it difficult for the HDD to
> auto-tune its own queue depth. I'm really interested to have this
> queue approach discussion at the conference - there seems to be areas
> where we can improve on legacy behavior.
>
> In all these scenarios, a single SQ/CQ pair is certainly more than
> adequate to keep an HDD busy. Multiple SQ/CQ pairs probably only
> assist driver or system architects to separate traffic classes into
> separate SQs. At any rate, the HDD won't mandate >1 SQ, but it will
> support it if desired.
>
> -Tim
> --
> Tim Walker
> Product Design Systems Engineering, Seagate Technology
> (303) 775-3770

Hi Ming-

>Will NVMe HDD support multiple NS?

At this point it doesn't seem like an NVMe HDD could benefit from
multiple namespaces. However, a multiple actuator HDD can present the
actuators as independent channels that are capable of independent
media access. It seems that we would want them on separate namespaces,
or sets. I'd like to discuss the pros and cons of each, and which
would be better for system integration.

Best regards,
-Tim

--=20
Tim Walker
Product Design Systems Engineering, Seagate Technology
(303) 775-3770
