Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1609DC4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 16:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD2822081B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 16:55:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="drARdr6+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfILQzd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 12:55:33 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53902 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729855AbfILQzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 12:55:33 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 388084193F;
        Thu, 12 Sep 2019 16:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        user-agent:in-reply-to:content-disposition:content-type
        :content-type:mime-version:references:message-id:subject:subject
        :from:from:date:date:received:received:received; s=mta-01; t=
        1568307331; x=1570121732; bh=sj6xn6A7d34M02Q3Sx90MFkkfsYRNrkIJLx
        EoeLpjEM=; b=drARdr6+00QVEZzMwth0gbHN+3NiLVqmwFAGx24qLeF4nqgH8QG
        FF1iJ2rY9KUVZ1YgjHpZr/e5yE8jyGOSaQ3uki8IwobUWmR8XKy2nSmLVF5adzt2
        jaZRdc0HlZzlL54zj629O0m042+K9wQcj1QKZOSWQIuBtcxMVpj/wfDw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Bs52Kv-RPSKg; Thu, 12 Sep 2019 19:55:31 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0274E435D5;
        Thu, 12 Sep 2019 19:55:30 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Sep 2019 19:55:29 +0300
Date:   Thu, 12 Sep 2019 19:55:28 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Himanshu Madhani <hmadhani@marvell.com>
CC:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 07/14] qla2xxx: Fix Nport ID display value
Message-ID: <20190912165528.pbe5wip7ywst3x6a@SPB-NB-133.local>
References: <20190912151949.2348-1-hmadhani@marvell.com>
 <20190912151949.2348-8-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190912151949.2348-8-hmadhani@marvell.com>
User-Agent: NeoMutt/20180716
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 12, 2019 at 08:19:42AM -0700, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> For N2N, the NPort ID is assigned by driver in the PLOGI ELS.
> According to FW Spec the byte order for SID is not the same as
> DID.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 1886de92034c..5c279449ca1c 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2696,9 +2696,10 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
>  	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
>  	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
>  	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
> -	els_iocb->s_id[0] = vha->d_id.b.al_pa;
> -	els_iocb->s_id[1] = vha->d_id.b.area;
> -	els_iocb->s_id[2] = vha->d_id.b.domain;
> +	/* For SID the byte order is different than DID */
> +	els_iocb->s_id[1] = vha->d_id.b.al_pa;
> +	els_iocb->s_id[2] = vha->d_id.b.area;
> +	els_iocb->s_id[0] = vha->d_id.b.domain;
>  	els_iocb->control_flags = 0;
>  
>  	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
> -- 
> 2.12.0
> 

Hi,

This one doesn't apply to 5.4/scsi-queue, the hunk lines should be:
@@ -2656,9 +2656,10 @@

Best regards,
Roman
