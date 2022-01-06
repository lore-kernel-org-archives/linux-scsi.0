Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F83C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 00:55:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344228AbiAFAzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 19:55:51 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13730 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344468AbiAFAz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 19:55:27 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 205N5pJA024955
        for <linux-scsi@vger.kernel.org>; Wed, 5 Jan 2022 16:55:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=DYRBOEEQ3/LX01SRVa0RSu/IKHaGjztpLGFkuHiCQVs=;
 b=M1+PKC1+O33rzOkW1x4oOwEAF8jUwvtNFeVWGZmbB8iBFNzeL9PcCYIkOaZA1s0SbWF/
 FkbFGNO1dMWVr2DWbV0hVEFoGZJv+mN86dnWjGnWHFFeg9+oFTXcYdzhM32UE9oeW2Vh
 tTACMTc7aJb+fcN878k/uPwPHpLmL2VyOALOwgXPXChg5+7sIJjz/ZZLOR8GHPwEjRw1
 ikqJWSYgPwMi6VisTwdRAnOPiA402UPf25/NAXojiVCMEW2eiJ4qbCUQrd0KFWX4q9SF
 x+iL7PPmOYUmd36er8ZvSlo/16C7/k2QAqpklPtyi9feNSX7lZrtuNerd9ppBaMXoC1A Ig== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ddmpv8s4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jan 2022 16:55:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 Jan
 2022 16:55:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 5 Jan 2022 16:55:24 -0800
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id C16583F7058;
        Wed,  5 Jan 2022 16:55:24 -0800 (PST)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 2060tOaQ007959;
        Wed, 5 Jan 2022 16:55:24 -0800
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 5 Jan 2022 16:55:24 -0800
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 14/16] qla2xxx: Add devid's and conditionals for 28xx
In-Reply-To: <46AAF253-04F5-4B3D-AD45-FFAE1FD43D4F@oracle.com>
Message-ID: <alpine.LRH.2.21.9999.2201051651400.6962@irv1user01.caveonetworks.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-15-njavali@marvell.com>
 <46AAF253-04F5-4B3D-AD45-FFAE1FD43D4F@oracle.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: mEX9Qsb8ahIp1VZKGz3TwEE7zoxKVN5J
X-Proofpoint-ORIG-GUID: mEX9Qsb8ahIp1VZKGz3TwEE7zoxKVN5J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_08,2022-01-04_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Himanshu,

On Sun, 2 Jan 2022, 4:52pm, Himanshu Madhani wrote:

> 
> 
> > On Dec 23, 2021, at 11:07 PM, Nilesh Javali <njavali@marvell.com> wrote:
> > 
> > From: Arun Easi <aeasi@marvell.com>
> > 
> > 28XX adapters are capable of detecting both T10 PI tag escape values
> > as well as IP guard. This was missed due to the adapter type missed
> > in the corresponding macros. Fix this by adding support for 28xx in
> > those macros.
> > 
> 
> This patch seems to fix more than just IP guard macros. 
> Can you please seperate T10 PI fix with other fixes from this patch.
> 

Thanks for the review. You are right. This is actually a mixup of the 
descriptions. This patch is a bunch of short changes for the 28xx 
enablement, which somehow was missed sending initially; will send an 
update.

Regards,
-Arun
