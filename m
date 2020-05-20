Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC30EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 16:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B67A920759
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 16:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="EIohkh+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgETQDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 12:03:17 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:42756 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726596AbgETQDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 May 2020 12:03:17 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 52E284C847;
        Wed, 20 May 2020 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1589990593;
         x=1591804994; bh=idBMmOoQhQZ9y8tz7rHU4Qzec8bsOe0w9RnyvmN/GSY=; b=
        EIohkh+PJGTBRTmBWNh8NjZQwwXP2Y5RQISaDmAc16WK4lJ1oPZinwYXl/+MhViZ
        oUZaJgeCj6cF3ZllGe4br7ozOSoVC3q21sW+MYiuMTnEqdNPQ4I1h/0LBntXr6RU
        nCvr/EY1PdvW97DfoOt37W4SeCwkMYqCwqWa4Y00qFU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id F_RzgQpOMhFm; Wed, 20 May 2020 19:03:13 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 31B7B4525F;
        Wed, 20 May 2020 19:03:12 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 20
 May 2020 19:03:13 +0300
Date:   Wed, 20 May 2020 19:03:13 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>, Arun Easi <aeasi@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] qla2xxx: Remove return value from qla_nvme_ls()
Message-ID: <20200520160313.GI75422@SPB-NB-133.local>
References: <20200520130819.90625-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200520130819.90625-1-dwagner@suse.de>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 20, 2020 at 03:08:19PM +0200, Daniel Wagner wrote:
> The function always returns QLA_SUCCESS and the caller
> qla2x00_start_sp() doesn't even evalute the return value. So there is
> no point in returning a status.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_iocb.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index b039bd83f947..8865c35d3421 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -3607,11 +3607,10 @@ static void qla2x00_send_notify_ack_iocb(srb_t *sp,
>  /*
>   * Build NVME LS request
>   */
> -static int
> +static void
>  qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
>  {
>  	struct srb_iocb *nvme;
> -	int     rval = QLA_SUCCESS;
>  
>  	nvme = &sp->u.iocb_cmd;
>  	cmd_pkt->entry_type = PT_LS4_REQUEST;
> @@ -3631,8 +3630,6 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
>  	cmd_pkt->rx_byte_count = cpu_to_le32(nvme->u.nvme.rsp_len);
>  	cmd_pkt->dsd[1].length = cpu_to_le32(nvme->u.nvme.rsp_len);
>  	put_unaligned_le64(nvme->u.nvme.rsp_dma, &cmd_pkt->dsd[1].address);
> -
> -	return rval;
>  }
>  
>  static void
> -- 
> 2.16.4
> 

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
