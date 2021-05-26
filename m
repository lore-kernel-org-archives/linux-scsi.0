Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE21DC4707F
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 00:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C94D961429
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 00:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhEZA5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 20:57:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53162 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231373AbhEZA5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 20:57:47 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q0shDR029693;
        Tue, 25 May 2021 17:56:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=wxenAkV1tMw7M32aV7mK5sIBBg3iM4RtcUwB2rhMyYw=;
 b=iPYqma4pZnxxteEhy5kh2/LMvsQlaYs7igICK0SWebb9Lk6EDRSgVrpnAWXgrAKl8Nle
 FQqODYTzGcOjAY/1VXJ+gfXeF0hVgD7g6M+txqHBTV/6szmL5UthqQRv65uCHN+L91rd
 Ot389rfH5s27cW5DJhXa1LWxZiWs34JkNsxjLOYaWR9uN82qMPrWO0N6n5LV81+bhXYp
 /I3DZOhcMgvdkgQIEcWsql2UKOOCJ/L2xHphq/L30uPWs252vKZJTMAQxHN3bVjtwj1O
 I99i9qR2TZoGW9i2QYvP3IrK0kHLkdeAHxO6gP7Zf79Bg6kp27snf6bag7+xnT3udw7S RA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38s0fetu2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 17:56:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 25 May
 2021 17:56:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 25 May 2021 17:56:12 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 0A8F73F703F;
        Tue, 25 May 2021 17:56:13 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 14Q0uCiH027284;
        Tue, 25 May 2021 17:56:12 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Tue, 25 May 2021 17:56:12 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-kernel@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>
Subject: Re: [EXT] Re: [RFC 0/2] Serialize timeout handling and done
 callback.
In-Reply-To: <20210525132604.dpn56mga2otyaxwl@beryllium.lan>
Message-ID: <alpine.LRH.2.21.9999.2105251755360.24132@irv1user01.caveonetworks.com>
References: <20210507123103.10265-1-dwagner@suse.de>
 <20210525132604.dpn56mga2otyaxwl@beryllium.lan>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-ORIG-GUID: W1yMh3XG33BL328smcIfhzp4tdaLXBbI
X-Proofpoint-GUID: W1yMh3XG33BL328smcIfhzp4tdaLXBbI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-25_09:2021-05-25,2021-05-25 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 25 May 2021, 6:26am, Daniel Wagner wrote:

> External Email
> 
> ----------------------------------------------------------------------
> Hi,
> 
> On Fri, May 07, 2021 at 02:31:00PM +0200, Daniel Wagner wrote:
> > Maybe they make sense to add the driver even if I don't have prove it
> > really address the mentioned bug hence this is marked as RFC.
> 
> Any feedback?
> 

Apologies for the delay, Daniel. I will review this by end of this week.

Regards,
-Arun
