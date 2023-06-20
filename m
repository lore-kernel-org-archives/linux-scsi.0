Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A196EB64D7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Jun 2023 09:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjFTJqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbjFTJqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jun 2023 05:46:13 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53DF10C
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jun 2023 02:46:11 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-311367a3e12so3347662f8f.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jun 2023 02:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687254370; x=1689846370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=52qn7S5H0DJ/OVNfPI7i/vY3Ezs8VvcT5G47wLVumi4=;
        b=RTeUBidVbGAKwwXEABRQbd/fTYeY0h6jaQPebUelSqsob+jYZKBW7p3wCYAXpi4WPi
         Llk0dQVPR+gnwhccYP0sQchzjxK4jVqHHao1IoKPVy4Xf8cp5Q5YT2QnGsWz1abYI1Kb
         Lr+xDO+rH9f7Zc1ud34Vg7xCkR6om5CrDhfPGRf2cEN9HDqdb0CU2UDT9W6l06HUbN4z
         yHmmnP9c8WTlFPpU/z6sHqmxUJhOsJlhxc0XGdSY0ZobutpXdiQS5f4YWSy08ZicspB9
         wFLJInrO1gq3yaNcqOM/myCBS0AoEMqpxxNHnoZQvhK0w91B6+MLL0/Ay6rP1O4ubL3b
         Ctug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687254370; x=1689846370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=52qn7S5H0DJ/OVNfPI7i/vY3Ezs8VvcT5G47wLVumi4=;
        b=GLDeqAmS25rHrGd9r2PTlxEldURlC6ZLBDTWznWs6B+JoyC3811bmoOQf9zS+Y47fS
         sIaaWgaAD3P/IemYPTmfH1MU9lSGWjszekbjc4UuTrDSeGe65iCvA2CpS6yLkfizofRZ
         7/5prjNbrphnAoU+zuB+XyJ/VIasd11OygWlDn5SPciSHyor8W2mT8T0pTHRPCnyV6vD
         TwJ6gNxwiFmMLtnA1vWknLZdbTHFIqqZ4WW5zKE5v2zhDJlK9iXwI9epz1FTyuohUqpl
         sFQc51XCCtNbr7L44odcN8bND/x4EWQb9HcoObDEx6P7Nv7+SL46w/8WTAcFk4GRG0mh
         b52Q==
X-Gm-Message-State: AC+VfDwKEC8ty132ySQ7S0GKnBC50U516SeSN01jCAqbN04maA7B+aM6
        ZbJXkQ+KzMY+0mHQCSye1w0WAg==
X-Google-Smtp-Source: ACHHUZ48uepgZCgbdc0HqkwijPGUg5rwXeoiJNVobk/8kRGzaIqlPu+W0NauFoKVVHM/8pCLgyEBcQ==
X-Received: by 2002:a5d:4909:0:b0:30f:bf71:501b with SMTP id x9-20020a5d4909000000b0030fbf71501bmr9956218wrq.61.1687254370292;
        Tue, 20 Jun 2023 02:46:10 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h17-20020a5d6891000000b0030497b3224bsm1599089wru.64.2023.06.20.02.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 02:46:09 -0700 (PDT)
Date:   Tue, 20 Jun 2023 12:46:04 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH v2 5/8] qla2xxx: klocwork - Fix buffer overrun
Message-ID: <38d406c9-8007-40dc-89dc-3cff828731ff@moroto.mountain>
References: <20230607113843.37185-1-njavali@marvell.com>
 <20230607113843.37185-6-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607113843.37185-6-njavali@marvell.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 07, 2023 at 05:08:40PM +0530, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Klocwork warning: Buffer Overflow - Array Index Out of Bounds
> 
> Driver uses fc_els_flogi to calculate size of buffer.
> The actual buffer is nested inside of fc_els_flogi
> which is smaller.

To be honest, I don't really understand where either fc_els_flogi or
fc_els_csp structs are involved in this.  Is that the source buffer?
We are copying data to ha->init_cb which is type init_cb_t.

The names "ha->init_cb" and "ha->init_cb_size" match and how the size
is set (in qla2x00_probe_one()) is like this:

        ha->init_cb_size = sizeof(init_cb_t);
                ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
                ha->init_cb_size = sizeof(struct mid_init_cb_24xx);
                ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
                ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
                ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
                ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
                ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
                ha->init_cb_size = sizeof(struct mid_init_cb_81xx);

I don't understand the Klocwork warning either...

> 
> Replace structure name to allow proper size calculation.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 0df6eae7324e..b0225f6f3221 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5549,7 +5549,7 @@ static void qla_get_login_template(scsi_qla_host_t *vha)
>  	__be32 *q;
>  
>  	memset(ha->init_cb, 0, ha->init_cb_size);
               ^^^^^^^^^^^

> -	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
> +	sz = min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);

It's strange that we are checking min_t() after a memset().  Normally
you check first then memset.

>  	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
>  					    ha->init_cb, sz);
                                            ^^^^^^^^^^^^^^^^
sz is used as the size of ha->init_cb here, and then again at the the
end of the function.

regards,
dan carpenter

