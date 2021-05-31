Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A49C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 09:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0A7060FDA
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 09:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhEaJIb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 05:08:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25578 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230337AbhEaJIP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 05:08:15 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14V96NSM014845;
        Mon, 31 May 2021 02:06:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=vJD3FC7L7Iq4KIkXJn86baeDLcjGa8hZW/EM6OIxen4=;
 b=freR52Z/V6uNlyR3JwDFIkQsYL1R5LW9QH0toDBPu1bfvPQcju1gHQdhyxU+5m9VJhTZ
 Jhsmfc/sg65zO1XG+tVpakQByYEyDbsXKNAGBzqPNQ/OcVYfDvsMEWvAHeUan+HLx0Ca
 fnaZFAtMQOhkN6e6oYgxQuPxLpVhIIZGHFE66WoNr6Yy4HvmVqJtlq42l2kyV/eUvoZ4
 kiU5jKYenb2RkmkEqQgDPKAt8SZ0RpcZFS/cIqkniQk1kSdQPCb/aj9kyyErtrcVs0wX
 akXZdj6gvDVSNgXaemIU5sGIFG9Py6puapNVojPPajZIfH8y92pOZs2AnKkJMtoUJfvT gA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnj8cyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 02:06:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 02:06:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 31 May 2021 02:06:26 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id B577D3F703F;
        Mon, 31 May 2021 02:06:25 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 14V96O82001639;
        Mon, 31 May 2021 02:06:25 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 31 May 2021 02:06:24 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-kernel@vger.kernel.org>, Nilesh Javali <njavali@marvell.com>
Subject: Re: [EXT] [RFC 0/2] Serialize timeout handling and done callback.
In-Reply-To: <20210507123103.10265-1-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2105310148300.17918@irv1user01.caveonetworks.com>
References: <20210507123103.10265-1-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-GUID: UXdAua8R7xiGaB5RyXsu5-vHqQymrCUx
X-Proofpoint-ORIG-GUID: UXdAua8R7xiGaB5RyXsu5-vHqQymrCUx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_07:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 7 May 2021, 5:31am, Daniel Wagner wrote:

> External Email
> 
> ----------------------------------------------------------------------
> Hi,
> 
> We got a customer report where qla2xxx was crashing only if the kernel
> was booting and ql2xextended_error_logging was set. Loading the module
> with the log option didn't trigger the crash.
> 
> After starring for a long time at the crash report I figured the
> problem might be a race between the timeout handler and done callback.
> I've come up with these patches here but unfortunatly, our customer is
> not able to reproduce the problem in the lab anymore (it was caused by
> a hardware issue which got fixed). So for these patches I don't have
> any feedback.

Thanks Daniel for the report and your effort here. Agree, this needs to be 
fixed.

> 
> Maybe they make sense to add the driver even if I don't have prove it
> really address the mentioned bug hence this is marked as RFC.

If you do not mind, can I take this from here? This touches quite a 
number of paths, and I would like to have this go through a full 
regression cycle before this is merged.

That said, I had some general comments:

1. I see sp->lock was introduced, but could not locate where it was used.
2. I did not see a release of lock after a successful kref_put_lock, maybe 
   that piece was missed out.
3. The sp->done should be invoked only once, and I do not see if this is
   taken care of.
4. sp->cmd_sp could be a SCSI IO too, where sp is not allocated 
   separately, so qla2x00_sp_release shall not be called for it.

Regards,
-Arun

> 
> Thanks,
> Daniel
> 
> Daniel Wagner (2):
>   qla2xxx: Refactor asynchronous command initialization
>   qla2xxx: Do not free resource to early in qla24xx_async_gpsc_sp_done()
> 
>  drivers/scsi/qla2xxx/qla_def.h    |  5 ++
>  drivers/scsi/qla2xxx/qla_gbl.h    |  4 +-
>  drivers/scsi/qla2xxx/qla_gs.c     | 86 ++++++++++-------------------
>  drivers/scsi/qla2xxx/qla_init.c   | 91 +++++++++++++------------------
>  drivers/scsi/qla2xxx/qla_iocb.c   | 54 +++++++++++++-----
>  drivers/scsi/qla2xxx/qla_mbx.c    | 11 ++--
>  drivers/scsi/qla2xxx/qla_mid.c    |  5 +-
>  drivers/scsi/qla2xxx/qla_mr.c     |  7 +--
>  drivers/scsi/qla2xxx/qla_target.c |  6 +-
>  9 files changed, 127 insertions(+), 142 deletions(-)
> 
> 
