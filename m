Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F248C34026
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 15:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C5FD207FD
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 15:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seagate.com header.i=@seagate.com header.b="Pd8TlXxr";
	dkim=pass (2048-bit key) header.d=seagate.com header.i=@seagate.com header.b="Ona4IlGE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgBRPzx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 10:55:53 -0500
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:40140 "EHLO
        mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726403AbgBRPzw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Feb 2020 10:55:52 -0500
Received: from pps.filterd (m0075552.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IFtpT0027302
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 10:55:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type; s=proofpoint;
 bh=kSDqbBAaWJOPcd7RVa5GGBLqUbqCfZEQDaf8+NwB1Nc=;
 b=Pd8TlXxrRMOfmLTHuJsp2iJVyPTeke5+u0mwVxNXf+bKYpNlKQ2PwniZy8NOzupiV7dq
 tNzJLOM5TnpewPQNA/ttBAuowmjz8MqhaUS3CUr4I4W/W/3LgXRkMr/iHH92HcuVbF9T
 xIHqI03bScVyktpfGp1E902Koz1iK4e8rDzw/xga1pnGnxqiAIXl83UZltbxxPaGo+tV
 Zm19QrO4PLKa4xg3hmYxFEy7Q9fW/aX0MTNx0PnmBAhTL2E812PkXNYiMuHY3lzyxD0C
 neP1cfO/meSy1IjFye62pA+O1Wx0LMkIa3pKYE27evlXwBo3B2gKZXEE/dzyPt6ObHnp YA== 
Authentication-Results: seagate.com;
        dkim=pass header.d=seagate.com header.s=google
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        by mx0a-00003501.pphosted.com with ESMTP id 2y6xxhbv1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 10:55:51 -0500
Received: by mail-wm1-f71.google.com with SMTP id b205so245636wmh.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 07:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=seagate.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kSDqbBAaWJOPcd7RVa5GGBLqUbqCfZEQDaf8+NwB1Nc=;
        b=Ona4IlGEcWZfh6ckDkpNYiNAcM2nQ7bwfAeS48H8KPa2P0iukl4xAXOENVc/XNfbrn
         afmuQNGns01izKW0uYNYYIfCtdkYzZxwtAbcUBQzl3HjMoJxZ7jm7BEKW+DILBxfTLpT
         w0h07QcLENsXoz3Omv9EeIxaHIThy3KPJzWqPXj1BHhrRCV18cn8LhgZs8WRT428OUt2
         3JXrKNcIAWrUp1YAN1a5QG/0xKYJkyYVSsp5d7FM50esKgIk0gmnKrj77yAKYjgUqKzT
         fuXxdo0J7ApMUdMGmiL8JXHuVHddwvPhzf6yobCQtWTQzVrQzvjwmGDiQkIt2O/PRWcM
         tB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kSDqbBAaWJOPcd7RVa5GGBLqUbqCfZEQDaf8+NwB1Nc=;
        b=doVmBA81/kpE1zGoPohe+ri+OxaHPLJeixXvbj5oL9qNBtG8IrPoa04KJrQpEgJXPn
         ni05TYLb/qUBg7JaWrAVRUFLSxCi9Es750XOVnn0FdbvEmY7igQHPpH+utRbBH8AXNQF
         830uqVbc1cqrJMwSM/b2Y0DSihBKwndS+vaY5su53n7hb6b4s2yMIlRTWDXaM1ER+IGy
         sRnnVqkfs6THhWmjE1paIirPLBbKERBlkVmHTTM1U8JjYrW1Ayuh2dD5W/TakpMtZlK6
         hW4nGpFMSQg7fVGDWY8yGEovMl+nVeZ6NBudlPtPjuBjzrz10Knb1CywsARWbRw4VPPN
         uWPA==
X-Gm-Message-State: APjAAAW5d8kM+yDKaodtJKTsgaq0g2/6tUWvjhdpBtO+U14uLmkvvBtV
        /p9f2Sr/XEJL7Q24oE9DLfwOR/JOW+orFRDVM+H3KXSLM6xn/jz4yHbVQcFop8eeQBVqRivGDvY
        C4LlV+HJQB2xFFd/DsoXvLeRmYz6mDYGoT9IZy6QUdFBm5r66TLlcPXRW6b9nF/g=
X-Received: by 2002:a7b:c152:: with SMTP id z18mr3848786wmi.70.1582041306535;
        Tue, 18 Feb 2020 07:55:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqx7kjtcwQBU6hxW2ktpZzuRb16b7GW1dpbZK+0FbadMiM6j4qD6QT740JsUZrXMIpAxofZZ3R6I5bUS+Tr8rZ8=
X-Received: by 2002:a7b:c152:: with SMTP id z18mr3848736wmi.70.1582041306110;
 Tue, 18 Feb 2020 07:55:06 -0800 (PST)
MIME-Version: 1.0
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p> <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1blq3rxzj.fsf@oracle.com> <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com> <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
 <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com> <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
 <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com>
In-Reply-To: <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com>
From:   Tim Walker <tim.t.walker@seagate.com>
Date:   Tue, 18 Feb 2020 10:54:54 -0500
Message-ID: <CANo=J17Rve2mMLb_yJNFK5m8wt5Wi4c+b=-a5BJ5kW3RaWuQVg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
To:     Keith Busch <kbusch@kernel.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-PolicyRoute: Outbound
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_04:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 suspectscore=1 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002180120
X-Proofpoint-Spam-Policy: Default Domain Policy
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 14, 2020 at 12:05 PM Keith Busch <kbusch@kernel.org> wrote:
>
> On Fri, Feb 14, 2020 at 05:04:25PM +0100, Hannes Reinecke wrote:
> > On 2/14/20 3:40 PM, Keith Busch wrote:
> > > On Fri, Feb 14, 2020 at 08:32:57AM +0100, Hannes Reinecke wrote:
> > > > On 2/13/20 5:17 AM, Martin K. Petersen wrote:
> > > > > People often artificially lower the queue depth to avoid timeouts. The
> > > > > default timeout is 30 seconds from an I/O is queued. However, many
> > > > > enterprise applications set the timeout to 3-5 seconds. Which means that
> > > > > with deep queues you'll quickly start seeing timeouts if a drive
> > > > > temporarily is having issues keeping up (media errors, excessive spare
> > > > > track seeks, etc.).
> > > > >
> > > > > Well-behaved devices will return QF/TSF if they have transient resource
> > > > > starvation or exceed internal QoS limits. QF will cause the SCSI stack
> > > > > to reduce the number of I/Os in flight. This allows the drive to recover
> > > > > from its congested state and reduces the potential of application and
> > > > > filesystem timeouts.
> > > > >
> > > > This may even be a chance to revisit QoS / queue busy handling.
> > > > NVMe has this SQ head pointer mechanism which was supposed to handle
> > > > this kind of situations, but to my knowledge no-one has been
> > > > implementing it.
> > > > Might be worthwhile revisiting it; guess NVMe HDDs would profit from that.
> > >
> > > We don't need that because we don't allocate enough tags to potentially
> > > wrap the tail past the head. If you can allocate a tag, the queue is not
> > > full. And convesely, no tag == queue full.
> > >
> > It's not a problem on our side.
> > It's a problem on the target/controller side.
> > The target/controller might have a need to throttle I/O (due to QoS settings
> > or competing resources from other hosts), but currently no means of
> > signalling that to the host.
> > Which, incidentally, is the underlying reason for the DNR handling
> > discussion we had; NetApp tried to model QoS by sending "Namespace not
> > ready" without the DNR bit set, which of course is a totally different
> > use-case as the typical 'Namespace not ready' response we get (with the DNR
> > bit set) when a namespace was unmapped.
> >
> > And that is where SQ head pointer updates comes in; it would allow the
> > controller to signal back to the host that it should hold off sending I/O
> > for a bit.
> > So this could / might be used for NVMe HDDs, too, which also might have a
> > need to signal back to the host that I/Os should be throttled...
>
> Okay, I see. I think this needs a new nvme AER notice as Martin
> suggested. The desired host behavior is simiilar to what we do with a
> "firmware activation notice" where we temporarily quiesce new requests
> and reset IO timeouts for previously dispatched requests. Perhaps tie
> this to the CSTS.PP register as well.
Hi all-

With regards to our discussion on queue depths, it's common knowledge
that an HDD choses commands from its internal command queue to
optimize performance. The HDD looks at things like the current
actuator position, current media rotational position, power
constraints, command age, etc to choose the best next command to
service. A large number of commands in the queue gives the HDD a
better selection of commands from which to choose to maximize
throughput/IOPS/etc but at the expense of the added latency due to
commands sitting in the queue.

NVMe doesn't allow us to pull commands randomly from the SQ, so the
HDD should attempt to fill its internal queue from the various SQs,
according to the SQ servicing policy, so it can have a large number of
commands to choose from for its internal command processing
optimization.

It seems to me that the host would want to limit the total number of
outstanding commands to an NVMe HDD for the same latency reasons they
are frequently limited today. If we assume the HDD would have a
relatively deep (perhaps 256) internal queue (which is deeper than
most latency-sensitive customers would want to run) then the SQ would
be empty most of the time. To me it seems that only when the host's
number of outstanding commands fell below the threshold should the
host add commands to the SQ. Since the drive internal command queue
would not be full, the HDD would immediately pull the commands from
the SQ and put them into its internal command queue.

I can't think of any advantage to running a deep SQ in this scenario.

When the host requests to delete a SQ the HDD should abort the
commands it is holding in its internal queue that came from the SQ to
be deleted, then delete the SQ.

Best regards,
-Tim

-- 
Tim Walker
Product Design Systems Engineering, Seagate Technology
(303) 775-3770
