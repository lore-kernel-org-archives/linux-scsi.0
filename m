Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA23C388F9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 19:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B792098B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 19:46:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GETOLZlO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509916AbgJVTq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Oct 2020 15:46:28 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2508766AbgJVTq1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Oct 2020 15:46:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09MJiuLX027962;
        Thu, 22 Oct 2020 12:46:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=syTatktNJj218s4w8i0vH5DjvlhLYwwOkkKzR/GTeIM=;
 b=GETOLZlOfC7FJYoQalB4Oc1pmpKNgMAW81Qpyl52VAj5sc4rYrmlp0CLnlWrASLv7SGv
 YX1U/95TqIwF7gnYKMoUBLtm4ex6GhwmSLZ6dDLfoRF/MNM7eXYk5knNvI8ZXzXE7cdi
 J1c9qIMs4v8nR9hgd1z6EucR/AD62UNylwTLUWqLptTygHBlzGEChPKXppY9D5r5amKW
 rYza0pRw3EWfi1BTopQqM/ArAj7g68e5+TnbTnqVotpBeyl/NGTqEWYFGPd5nE2iMMHD
 +0qzUgN9whSbSMd0j+V3OgzV3xHWLbnS5DTMwRTmmU0WnlMv5iT77o3i85fhfB8cVjEQ Tg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 34asbe5451-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Oct 2020 12:46:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Oct
 2020 12:46:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Oct 2020 12:46:23 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 210803F7041;
        Thu, 22 Oct 2020 12:46:23 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 09MJkL4L026377;
        Thu, 22 Oct 2020 12:46:22 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Thu, 22 Oct 2020 12:46:21 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     Nilesh Javali <njavali@marvell.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [EXT] [PATCH v4] qla2xxx: Return EBUSY on fcport deletion
In-Reply-To: <20201014073048.36219-1-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2010221245090.28578@irv1user01.caveonetworks.com>
References: <20201014073048.36219-1-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-22_15:2020-10-20,2020-10-22 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Oct 2020, 12:30am, Daniel Wagner wrote:

> External Email
> 
> ----------------------------------------------------------------------
> When the fcport is about to be deleted we should return EBUSY instead
> of ENODEV. Only for EBUSY the request will be requeued in a multipath
> setup.
> 
> Also when the firmware has not yet started return EBUSY to avoid
> dropping the request.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Arun Easi <aeasi@marvell.com>
> ---
> 
> v4: updated commit message as suggested by Finn
> v3: simplify and changed test logic as suggested by Arun
> v2: rebased on mkp/staging
> 
>  drivers/scsi/qla2xxx/qla_nvme.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 2cd9bd288910..1fa457a5736e 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -555,10 +555,12 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
>  
>  	fcport = qla_rport->fcport;
>  
> -	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
> -	    (fcport && fcport->deleted))
> +	if (!qpair || !fcport)
>  		return -ENODEV;
>  
> +	if (!qpair->fw_started || fcport->deleted)
> +		return -EBUSY;
> +
>  	vha = fcport->vha;
>  
>  	if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
> 

Looks good to me.

Regards,
-Arun
