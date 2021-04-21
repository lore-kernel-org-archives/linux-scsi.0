Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66580C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 00:26:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F656141D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 00:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhDUA0i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 20:26:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1308 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233807AbhDUA0h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 20:26:37 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L0FJH9030887;
        Tue, 20 Apr 2021 17:25:55 -0700
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3828xv036f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 20 Apr 2021 17:25:55 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 17:25:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 20 Apr 2021 17:25:54 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 129433F703F;
        Tue, 20 Apr 2021 17:25:54 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 13L0Pq71031473;
        Tue, 20 Apr 2021 17:25:53 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Tue, 20 Apr 2021 17:25:52 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     Roman Bolshakov <r.bolshakov@yadro.com>,
        <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-nvme@lists.infradead.org>, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        "James Smart" <james.smart@broadcom.com>
Subject: Re: [EXT] Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module
 options
In-Reply-To: <20210420182830.fbipix3l7hwlyfx3@beryllium.lan>
Message-ID: <alpine.LRH.2.21.9999.2104201642290.24132@irv1user01.caveonetworks.com>
References: <20210419100014.47144-1-dwagner@suse.de>
 <YH8QzgWiec8vka20@SPB-NB-133.local>
 <20210420182830.fbipix3l7hwlyfx3@beryllium.lan>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: V9XXs5SRMPbv1PKldr62adnaO7Jz7EI6
X-Proofpoint-ORIG-GUID: V9XXs5SRMPbv1PKldr62adnaO7Jz7EI6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_11:2021-04-20,2021-04-20 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

On Tue, 20 Apr 2021, 11:28am, Daniel Wagner wrote:

> ----------------------------------------------------------------------
> Hi Roman,
> 
> On Tue, Apr 20, 2021 at 08:35:10PM +0300, Roman Bolshakov wrote:
> > + James S.
> > 
> > Daniel, WRT to your patch I don't think we should add one more approach
> > to set dev_loss_tmo via kernel module parameter as NVMe adopters are
> > going to be even more confused about the parameter. Just imagine
> > knowledge bases populated with all sorts of the workarounds, that apply
> > to kernel version x, y, z, etc :)
> 
> Totally agree. I consider this patch just a hack and way to get the
> discussion going, hence the RFC :) Well, maybe we are going to add it
> downstream in our kernels until we have a better way for setting the
> dev_loss_tmo.
> 
> As explained the debugfs interface is not working (okay, that's
> something which could be fixed) and it has the big problem that it is
> not under control by udevd. Not sure if we with some new udev rules the
> debugfs could automatically discovered or not.

Curious, which udev script does this today for FC SCSI?

In theory, the exsting fc nvmediscovery udev event has enough information 
to find out the right qla2xxx debugfs node and set dev_loss_tmo.

> 
> > What exists for FCP/SCSI is quite clear and reasonable. I don't know why
> > FC-NVMe rports should be way too different.
> 
> The lpfc driver does expose the FCP/SCSI and the FC-NVMe rports nicely
> via the fc_remote_ports and this is what I would like to have from the
> qla2xxx driver as well. qla2xxx exposes the FCP/SCSI rports but not the
> FC-NVMe rports.
> 

Given that FC NVME does not have sysfs hierarchy like FC SCSI, I see 
utility in making FC-NVME ports available via fc_remote_ports. If, though, 
a FC target port is dual protocol aware this would leave with only one 
knob to control both.

I think, going with fc_remote_ports is better than introducing one more 
way (like this patch) to set this.

Regards,
-Arun
