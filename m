Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6D7C43331
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 11:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 012922067B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 11:28:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="Sj9wcD2v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfKKL2J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 06:28:09 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:32852 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726810AbfKKL2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 06:28:09 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 40001411F9;
        Mon, 11 Nov 2019 11:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        user-agent:in-reply-to:content-disposition:content-type
        :content-type:mime-version:references:message-id:subject:subject
        :from:from:date:date:received:received:received; s=mta-01; t=
        1573471686; x=1575286087; bh=UkjpHeNgnyvBsjwsklOgunm4nPi7pq7MIOi
        wzCTpWcA=; b=Sj9wcD2vkOaP3UKhxM/ELME1OPkgAvoSGWs/a90bXHDYvQuX9lm
        wY6gLBC7QlX3AiVglUYTkczyeSMkG3dUZRAWYDEtABG9XDWXmi+l2JHn13TZqhjH
        m9GNAUyRJHhl9J1WKTIP/wZtTSeBBWoaF/DQXfbzGPpnfHNlAQ5yKjBk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CS400qkO8rxQ; Mon, 11 Nov 2019 14:28:06 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 66932411D9;
        Mon, 11 Nov 2019 14:28:05 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 11
 Nov 2019 14:28:04 +0300
Date:   Mon, 11 Nov 2019 14:28:04 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
Message-ID: <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
References: <20191109042135.12125-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191109042135.12125-1-bvanassche@acm.org>
User-Agent: NeoMutt/20180716
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 08, 2019 at 08:21:35PM -0800, Bart Van Assche wrote:
> The commit mentioned in the subject breaks point-to-point mode for at least
> the QLE2562 HBA. Restore point-to-point support by reverting that commit.
> 
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value") > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index b25f87ff8cde..cfd686fab1b1 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2656,10 +2656,9 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
>  	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
>  	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
>  	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
> -	/* For SID the byte order is different than DID */
> -	els_iocb->s_id[1] = vha->d_id.b.al_pa;
> -	els_iocb->s_id[2] = vha->d_id.b.area;
> -	els_iocb->s_id[0] = vha->d_id.b.domain;
> +	els_iocb->s_id[0] = vha->d_id.b.al_pa;
> +	els_iocb->s_id[1] = vha->d_id.b.area;
> +	els_iocb->s_id[2] = vha->d_id.b.domain;
>  
>  	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
>  		els_iocb->control_flags = 0;
> -- 
> 2.23.0
> 

The original commit definitely fixes P2P mode for QLE2700, the lowest
byte is domain, followed by AL_PA, followed by area. However the
fields are reserved in ELS IOCB for QLE2500, according to FW spec.

Perhaps we should have a switch here for 2500 and the other one for
2600/2700? Or, we should only set the fields only for QLE2700, to comply
with both specs.

Thank you,
Roman
