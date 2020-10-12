Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981D1C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 16:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50B6E2078E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 16:07:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="f3r+dEZ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390427AbgJLQHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 12:07:22 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25870 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389068AbgJLQHV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Oct 2020 12:07:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CG5GIR031007;
        Mon, 12 Oct 2020 09:07:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=BP3BVCMCCqHQdQd5oJqR+pD+fhRIgp9mzZVOt3kVJgk=;
 b=f3r+dEZ0zfLT/4kck3qoFrCNcHgaIK4EFSZ3RIVsxkLGmnzlo892gVQstvf0W1NvmCPE
 FrvhauXfGHpmnK5BwPl3Zmm0UE3TK/Bj+P6GCRr6Hp6QXTHuB1cYpzIDuWLSNgLpp+Qz
 iC2bsB82HokWvhtfh2kCV8febs9M1akaS8ye43L/oJ6zWmTsbfjr6tkbE0UTn1+9YxVu
 +//W8TBcRiVRZ/SekmSRZO7QE04fs565EMHxb17HaknzKw6PQPBlwOc2mle3RVpUvzfv
 91MHy/gbR/XLFsFe3vBR62Ac+1VFUqQHyUdjjwEQY9ljahnAURGrcfY0MywbGXVZlHDo wg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 343cfj6bdp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 09:07:18 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 09:07:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 09:07:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Oct 2020 09:07:16 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 48F643F703F;
        Mon, 12 Oct 2020 09:07:16 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 09CG7GPx003221;
        Mon, 12 Oct 2020 09:07:16 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 12 Oct 2020 09:07:15 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     Nilesh Javali <njavali@marvell.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] qla2xxx: Return EBUSY on fcport deletion
In-Reply-To: <20201012091100.55305-1-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2010120904230.28578@irv1user01.caveonetworks.com>
References: <20201012091100.55305-1-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_12:2020-10-12,2020-10-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 12 Oct 2020, 2:11am, Daniel Wagner wrote:

> When the fcport is about to be deleted we should return EBUSY instead
> of ENODEV. Only for EBUSY the request will be requeued in a multipath
> setup.
> 
> Also in case we have a valid qpair but the firmware has not yet
> started return EBUSY to avoid dropping the request.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> Hi,
> 
> During port bounce and fail tests we observed that requests get
> dropped on a failing path because the driver returned ENODEV and thus
> the multipath code didn't requeue the request.
> 
> The tests were done with only the 'fcport && fcport->deleted' condition
> but Hannes suggested we might as well do the same for 'qpair &&
> !qpair->fw_started'.
> 
> Thanks,
> Daniel
> 
>  drivers/scsi/qla2xxx/qla_nvme.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 5cc1bbb1ed74..db8b802b147c 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -555,8 +555,11 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
>  
>  	fcport = qla_rport->fcport;
>  
> -	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
> +	if ((qpair && !qpair->fw_started) ||
>  	    (fcport && fcport->deleted))
> +		return -EBUSY;
> +
> +	if (!qpair || !fcport)
>  		return rval;
>  
>  	vha = fcport->vha;
> 

This does not appear to be cut against the latest for-next/staging; "rval" 
is not used there for the initial set of returns.

Anyway, returning EBUSY is the right way to go.

Regards,
-Arun
