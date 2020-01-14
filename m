Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA36C33CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 10:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D026207FF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 10:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="CIvEP5kq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731295AbgANKJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:09:15 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:40146 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729040AbgANKJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 05:09:13 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5890543F93;
        Tue, 14 Jan 2020 10:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1578996551;
         x=1580810952; bh=VB+rgJ1BdMDBSaf1j+lbIMdpNwaBY7N28XPCN7g8oo0=; b=
        CIvEP5kqZT4rk/DzR4x9L3Sz0fdyawC0i2sJah+EwHa1naVsXz5JXiVsoJBzG5zK
        CXIIMaicFUQuKNGs824iTA7PiTBGWciDBnYqGezPI4lrT2DmQ3OHY32sKmpFhB5q
        9g/wS3rXyHpf7THTGUvgow8OrQDw9qS4j1NYpHsxGzM=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZPbrj2Ij0E-F; Tue, 14 Jan 2020 13:09:11 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id DAEFD42001;
        Tue, 14 Jan 2020 13:09:09 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 14
 Jan 2020 13:09:09 +0300
Date:   Tue, 14 Jan 2020 13:09:08 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] qla2xxx: Fix a NULL pointer dereference in an error path
Message-ID: <20200114100908.d6ch4u7krhvixaqa@SPB-NB-133.local>
References: <20200112210846.13421-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200112210846.13421-1-bvanassche@acm.org>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 12, 2020 at 01:08:46PM -0800, Bart Van Assche wrote:
> This patch fixes the following Coverity complaint:
> 
> FORWARD_NULL
> 
> qla_init.c: 5275 in qla2x00_configure_local_loop()
> 5269
> 5270     		if (fcport->scan_state == QLA_FCPORT_FOUND)
> 5271     			qla24xx_fcport_handle_login(vha, fcport);
> 5272     	}
> 5273
> 5274     cleanup_allocation:
> >>>     CID 353340:    (FORWARD_NULL)
> >>>     Passing null pointer "new_fcport" to "qla2x00_free_fcport", which dereferences it.
> 5275     	qla2x00_free_fcport(new_fcport);
> 5276
> 5277     	if (rval != QLA_SUCCESS) {
> 5278     		ql_dbg(ql_dbg_disc, vha, 0x2098,
> 5279     		    "Configure local loop error exit: rval=%x.\n", rval);
> 5280     	}
> 
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index c4e087217484..6560908ed50e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4895,6 +4895,8 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
>  void
>  qla2x00_free_fcport(fc_port_t *fcport)
>  {
> +	if (!fcport)
> +		return;
>  	if (fcport->ct_desc.ct_sns) {
>  		dma_free_coherent(&fcport->vha->hw->pdev->dev,
>  			sizeof(struct ct_sns_pkt), fcport->ct_desc.ct_sns,

Hi Bart,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

There was another attempt to fix the issue a week ago:
https://patchwork.kernel.org/patch/11319315/

CC'ing Colin.

Thanks,
Roman
