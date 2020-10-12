Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D62FC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 16:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18ADE2087E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 16:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QKQujlJu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390725AbgJLQy5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 12:54:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52746 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390705AbgJLQy5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Oct 2020 12:54:57 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09CGioWs000804;
        Mon, 12 Oct 2020 09:54:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=i+XH48QeOQjsexb49NBlrZ3T/4puq8Cjpltdejn9FKM=;
 b=QKQujlJuP+J1ga8OCLYjE+CiIm3ESuci5LA2PVEJ0rTtUWfy9NxzUe0uTf6pFb2R87CR
 icgTJph1WjiFBnDYJAks/tS2w5OK6meFjHwoqaz4cJvHWI8SDdpNkMf0Kb5X89w4tx8r
 eaViCnbixRBoSdVL/9RJhOXDOTQ6SBNrepaqjzFs1EuFhwfy2bav/efqmw6MJbgpT7ag
 sBItFAGVFW0E5YFstELnN1+ZZU3v0xDk+8BVkbz8aE5F1oRUOlXR/90cDEaommHgjcx3
 1fs8zMhHvmu7E3dsPSjPKqgPNYB1oWYFdg8nEuYABe16K2BWPpF/1if4Heo5PyIYVilh bg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 343aanexnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 12 Oct 2020 09:54:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 09:54:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Oct 2020 09:54:53 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 7BD4E3F703F;
        Mon, 12 Oct 2020 09:54:53 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 09CGsr7T004955;
        Mon, 12 Oct 2020 09:54:53 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 12 Oct 2020 09:54:53 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     Nilesh Javali <njavali@marvell.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] qla2xxx: Return EBUSY on fcport deletion
In-Reply-To: <20201012164148.42962-1-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2010120951560.28578@irv1user01.caveonetworks.com>
References: <20201012164148.42962-1-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-12_14:2020-10-12,2020-10-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 12 Oct 2020, 9:41am, Daniel Wagner wrote:

> When the fcport is about to be deleted we should return EBUSY instead
> of ENODEV. Only for EBUSY the request will be requeued in a multipath
> setup.
> 
> Also in case we have a valid qpair but the firmware has not yet
> started return EBUSY to avoid dropping the request.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> 
> v2: rebased on mkp/staging
> 
>  drivers/scsi/qla2xxx/qla_nvme.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 2cd9bd288910..fded1e3bc9e0 100644
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
>  		return -ENODEV;
>  
>  	vha = fcport->vha;
> 

Please move up the "(!qpair || !fcport)" check; you can avoid the 
qpair/fcport check in the first "if" condition, then.

Regards,
-Arun
