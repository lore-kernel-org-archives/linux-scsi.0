Return-Path: <SRS0=d1zv=2E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE69C43603
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 12:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D95F620706
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Dec 2019 12:33:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="MYHrXh5q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfLNMda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Dec 2019 07:33:30 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:36710 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbfLNMda (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Dec 2019 07:33:30 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5F91A41200;
        Sat, 14 Dec 2019 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1576326807;
         x=1578141208; bh=94OA89nMXIsmf+XkNB5AlmMLpSaErqIqZEBUPf3v4GI=; b=
        MYHrXh5q908hjx/tOyMcL0bvM83DbKu5XNB/gSiBUkRQzfxpUl7sWYLr6XCnJFm3
        aL57hjks0qqoeJxMSfNJoDw/F1w3QYFsom9Q+E6hqo6IxrrosPCaAWJHZybYo1M8
        nirl4tnsKlbitzNdYaOwUBtPwCLyGKaF9pJogU1msbY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zCNllUKENg8F; Sat, 14 Dec 2019 15:33:27 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6514C411F8;
        Sat, 14 Dec 2019 15:33:26 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 14
 Dec 2019 15:33:26 +0300
Date:   Sat, 14 Dec 2019 15:33:25 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 4/4] qla2xxx: Micro-optimize
 qla2x00_configure_local_loop()
Message-ID: <20191214123325.q6mvmke5htwit3l7@SPB-NB-133.local>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191209180223.194959-5-bvanassche@acm.org>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 09, 2019 at 10:02:23AM -0800, Bart Van Assche wrote:
> Instead of changing endianness in-place and copying the data in two steps,
> do this in one step. This patch makes is a preparation step for fixing the
> endianness warnings reported by 'sparse' for the qla2xxx driver.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  | 2 +-
>  drivers/scsi/qla2xxx/qla_init.c | 9 ++++-----
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index ab7424318ee8..cf23f10d27fe 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -414,7 +414,7 @@ struct els_logo_payload {
>  struct els_plogi_payload {
>  	uint8_t opcode;
>  	uint8_t rsvd[3];
> -	uint8_t data[112];
> +	__be32	data[112 / 4];
>  };
>  
>  struct ct_arg {
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 6c28f38f8021..ddd8bf7997a8 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5047,13 +5047,12 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  			rval = qla24xx_get_port_login_templ(vha,
>  			    ha->init_cb_dma, (void *)ha->init_cb, sz);
>  			if (rval == QLA_SUCCESS) {
> +				__be32 *q = &ha->plogi_els_payld.data[0];
> +
>  				bp = (uint32_t *)ha->init_cb;
> -				for (i = 0; i < sz/4 ; i++, bp++)
> -					*bp = cpu_to_be32(*bp);
> +				for (i = 0; i < sz/4 ; i++, bp++, q++)
> +					*q = cpu_to_be32(*bp);
>  

How about cpu_to_be32_array() instead of the hand-written loop?

> -				memcpy(&ha->plogi_els_payld.data,
> -				    (void *)ha->init_cb,
> -				    sizeof(ha->plogi_els_payld.data));
>  				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
>  			} else {
>  				ql_dbg(ql_dbg_init, vha, 0x00d1,

Thanks,
Roman
