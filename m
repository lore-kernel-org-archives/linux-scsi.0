Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E376CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0BD0610FC
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbhD0Wgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:36:44 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:29082 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235382AbhD0Wgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:36:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13RMVCPd027582;
        Tue, 27 Apr 2021 15:35:50 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 386tcrr6es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 15:35:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Apr
 2021 15:35:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Apr 2021 15:35:48 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 678803F7040;
        Tue, 27 Apr 2021 15:35:48 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 13RMZlGh010696;
        Tue, 27 Apr 2021 15:35:47 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Tue, 27 Apr 2021 15:35:47 -0700
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
In-Reply-To: <20210427095131.zf6c4siewnrhv7qd@beryllium.lan>
Message-ID: <alpine.LRH.2.21.9999.2104271531440.24132@irv1user01.caveonetworks.com>
References: <20210419100014.47144-1-dwagner@suse.de>
 <YH8QzgWiec8vka20@SPB-NB-133.local>
 <20210420182830.fbipix3l7hwlyfx3@beryllium.lan>
 <alpine.LRH.2.21.9999.2104201642290.24132@irv1user01.caveonetworks.com>
 <20210421075659.dwaz7gt6hyqlzpo4@beryllium.lan>
 <20210427095131.zf6c4siewnrhv7qd@beryllium.lan>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: LUWLFQulvNyKwWs_EhlnyiiH9jAd-9vm
X-Proofpoint-ORIG-GUID: LUWLFQulvNyKwWs_EhlnyiiH9jAd-9vm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_12:2021-04-27,2021-04-27 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Apr 2021, 2:51am, Daniel Wagner wrote:

> On Wed, Apr 21, 2021 at 09:56:59AM +0200, Daniel Wagner wrote:
> > Ah, didn't know about nvmediscovery until very recentetly. I try to get
> > it working with this approach (as this patch is not really a proper
> > solution).
> 
> Finally found some time to play with this. FTR, the nvmediscovery
> carries following information:
> 
>   UDEV  [65238.364677] change   /devices/virtual/fc/fc_udev_device (fc)
>   ACTION=change
>   DEVPATH=/devices/virtual/fc/fc_udev_device
>   FC_EVENT=nvmediscovery
>   NVMEFC_HOST_TRADDR=nn-0x20000024ff7fa448:pn-0x21000024ff7fa448
>   NVMEFC_TRADDR=nn-0x200200a09890f5bf:pn-0x203800a09890f5bf
>   SEQNUM=12357
>   SUBSYSTEM=fc
>   USEC_INITIALIZED=65238333374
> 
> The udev rule I came up is:
> 
>   ACTION=="change", SUBSYSTEM=="fc", ENV{FC_EVENT}=="nvmediscovery", \
>       ENV{NVMEFC_TRADDR}=="*", \
>       RUN+="/usr/local/sbin/qla2xxx_dev_loss_tmo.sh $env{NVMEFC_TRADDR} 4294967295"
> 
> and the script is:
> 
>   #!/bin/sh
> 
>   TRADDR=$1
>   TMO=$2
> 
>   id=$(echo $TRADDR | sed -n "s/.*pn-0x\([0-9a-f]\+\)/\1/p")
>   find /sys/kernel/debug/qla2xxx -name pn-$id -exec /bin/sh -c "echo $TMO > {}/dev_loss_tmo" \;
> 
> I am sure this can be done in a more elegant way. Anyway, I am testing
> this right now, the first 30 minutes look good...
> 

Looks ok to me. Just keep in mind that, with this you'd be setting all 
instances of pn-XXX (multiple initiator ports seeing the same target 
scenario). It looks like this is what you want, but thought I'd point that 
out.

Regards,
-Arun
