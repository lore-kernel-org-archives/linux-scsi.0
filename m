Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7355C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8320021897
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Dq49Tofy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgIHGmk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:42:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:13026 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728759AbgIHGmj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:42:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0886fEUZ009895;
        Mon, 7 Sep 2020 23:42:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=AGPffl/YHuPDteRp3+NES37/v9a5o5RpIjeUWeZDR2w=;
 b=Dq49Tofyh+QjSvyGCn8ZUVAGoZddSjpoKoldiBdTkCprIYZX8MeqAqCtkyGOq5hl1UOS
 nSvtdAPKfXcOA1xRlwWtbo/5tZqFV6uSCPO3VtUuvn+h9TmnkNBzYi9t3cbZcB2dI0VQ
 uvPuvHmDOic4qm0tmw1z9bfDRHjDCLxT8uw38HCtHzj32e1WeaY2JJflasSs1/kehLSz
 t8ii9Dj/596CFcPLb0LAYNe7cyLq+G2baz9hZAGEBZkDMPx/H7hb7CaZgiWK5eP6P3Bv
 ZqKxa9MD6PklsQfkfpLb88/KURyg+hHk1Ja6jigRqYRoVyMrlv93e2gmQ9TC3jXiihZD tw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81ptfy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 23:42:33 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:42:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 23:42:32 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 92EC23F703F;
        Mon,  7 Sep 2020 23:42:32 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 0886gW3p019943;
        Mon, 7 Sep 2020 23:42:32 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 7 Sep 2020 23:42:32 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nilesh Javali" <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 1/4] qla2xxx: Warn if done() or free() are called on
 an already freed srb
In-Reply-To: <20200831161854.70879-2-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2009072341491.28578@irv1user01.caveonetworks.com>
References: <20200831161854.70879-1-dwagner@suse.de>
 <20200831161854.70879-2-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-08,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 Aug 2020, 9:18am, Daniel Wagner wrote:

> 
> Emit a warning when ->done or ->free are called on an already freed
> srb. There is a hidden use-after-free bug in the driver which corrupts
> the srb memory pool which originates from the cleanup callbacks. By
> explicitly resetting the callbacks to NULL, we workaround the memory
> corruption.
> 
> An extensive search didn't bring any lights on the real problem. The
> initial idea was to set both pointers to NULL and try to catch invalid
> accesses. But instead the memory corruption was gone and the driver
> didn't crash.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_init.c   | 10 ++++++++++
>  drivers/scsi/qla2xxx/qla_inline.h |  5 +++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 57a2d76aa691..9e9360a4aeb5 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -63,6 +63,16 @@ void qla2x00_sp_free(srb_t *sp)
>  	qla2x00_rel_sp(sp);
>  }
>  
> +void qla2xxx_rel_done_warning(srb_t *sp, int res)
> +{
> +	WARN_ONCE(1, "Calling done() of an already freed srb object\n");
> +}
> +
> +void qla2xxx_rel_free_warning(srb_t *sp)
> +{
> +	WARN_ONCE(1, "Calling free() of an already freed srb object\n");
> +}

Please print the address of srb too for the above two functions.
With that, looks good.

Regards,
-Arun
