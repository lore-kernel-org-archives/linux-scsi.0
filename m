Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E32C2D0E9
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 22:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F6920737
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 22:13:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OpQYdnff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgCYWNz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 18:13:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1672 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727358AbgCYWNz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 18:13:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PMBMl5004335;
        Wed, 25 Mar 2020 15:13:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=n9CwG+lo+OIC9D8pRW35ylSag7oyThLG3+AQ1Rxk5x4=;
 b=OpQYdnffYu8i4pOWk+AD9bzZBFzNwI64xonEGpMK9TIJ6DS4zm3NdQLZROhyxwzEpqri
 q/JQRr7/SIN4AJL2EUyeCdujEzaqvYvaxN0wYwqM25G2nkKJVDVGdfHQMoBCgehWM4TH
 Heo1sA72VNFmqFVHrtuAa1oqbTyFeg1Owp7WZgtIN5E8Jed4vpzn+xkpIDvtvbqCivcJ
 NkPQoNRFPAYpIKf5YcAIC+irNNMV4laVpLVlIwHbPlSAdjap6v83siZbS2f/PQ2uvwbh
 VVk4HrxN1gWD6KEEFqau6pd3UMcvwXmIW2/gy1aHlJC3Uw6/Ib4EQsdipsxdRBfbckeZ mA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9ntn06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 15:13:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 15:13:46 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 15:13:46 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 15:13:45 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id BA22D3F703F;
        Wed, 25 Mar 2020 15:13:45 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02PMDjjO021584;
        Wed, 25 Mar 2020 15:13:45 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 25 Mar 2020 15:13:45 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Martin Wilck <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Daniel Wagner <dwagner@suse.de>,
        "James Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] scsi: qla2xxx: avoid sending mailbox commands if
 firmware is stopped
In-Reply-To: <940e20ba5d117b6fd181e0acdac14b7682ff2d64.camel@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2003251506260.12727@irv1user01.caveonetworks.com>
References: <20200205214422.3657-1-mwilck@suse.com>
         <20200205214422.3657-2-mwilck@suse.com>
         <alpine.LRH.2.21.9999.2003241648560.12727@irv1user01.caveonetworks.com>
         <dfbd88461ef4b5f56a83db7095c6e3f36b5a485e.camel@suse.com>
         <4fb2d29be88dbef2050cf51210d8e4e14a4b8ac2.camel@suse.com>
 <940e20ba5d117b6fd181e0acdac14b7682ff2d64.camel@suse.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_13:2020-03-24,2020-03-25 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 25 Mar 2020, 11:21am, Martin Wilck wrote:

> On Wed, 2020-03-25 at 18:20 +0100, Martin Wilck wrote:
> > Perhaps the (!fw_started) condition should be treated like
> > ABORT_ISP_ACTIVE in qla2x00_mailbox_command, i.e. execute only if
> > is_rom_cmd() returns true?
> 
> No, this won't be sufficient, as e.g. MBC_IOCB_COMMAND_A64 is in
> rom_cmds[], but has been found to hang (this is why I had the hunk in
> qla24xx_fabric_logout()). The list of mailbox commands
> that must be passed on when the FW is stopped has to be shorter than
> rom_cmds[].
> 

With your patch 2/3, where UNLOADING is set prior to the reset of chip, in 
place this issue should be largely addressed. Basically, paths that send 
out request to wire check UNLOADING bit (if any path is missing that, 
should add the check) before sending it out.

Now with UNLOADING set (with your patch 2/3), chip reset, and all 
outstanding command's completion called (qla2x00_abort_isp_cleanup) I see 
less chance of anything being sent out. If you see any issue with your 
patches 1 & 2 (addressing my comments) applied, let me know and we can 
tackle then. How about that?

Regards,
-Arun
