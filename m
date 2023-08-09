Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E45C001B0
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 17:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjHIR2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 13:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjHIR2p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 13:28:45 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97781EE
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 10:28:42 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-58451f0fefeso1573127b3.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Aug 2023 10:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1691602122; x=1692206922;
        h=content-transfer-encoding:message-id:references:in-reply-to:subject
         :cc:to:from:date:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5GHkqllOrwa7dKjTHTMacksa/BCngUM75YVKngzb84=;
        b=e5LzrZn59/0i0VBuG6353Wmc/jFvdaVaQytmwbjSxYDCk34yEp8PDkhT2vGcnrcFnJ
         /b6ENtHApcz7MsGLKPoya22WAvN1w13LWZolIBeE2F7GqawZkdj00o8qBK2EDpu06hca
         N3EoRMrltIHmMZsx+Kvs+Us8njn5MwOXvvyBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691602122; x=1692206922;
        h=content-transfer-encoding:message-id:references:in-reply-to:subject
         :cc:to:from:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w5GHkqllOrwa7dKjTHTMacksa/BCngUM75YVKngzb84=;
        b=CeJJlBD0k/nR6XUa1sXW6C/yv2YIjXCajr8bAvmnYGBlNr6MJYOtaf8gVzgGKQfTNU
         oGtf8GVaVX4QNz1uu7zNkQfKO5rRIOd8zXaDEMoE56RuTfJGHW1vnRWXp/z0UC6BkuN3
         0zQIz6FrX3h78kgPH4H3ReDdazMeEzDxTQpL2fFfa0ohaQ7RZ0nrLajBTON05p7UgisQ
         vN5v6CB72WC+cvJcZicAND/dfS4+zcDCrUGJMysbwrfdxe3FhOAm4La8ZHRa5ybxLzb2
         JQRchgAwwEAGqNrYiAuNDTJtT6V5z6Tx3MwQs4NAwkbVnOIMFg3sLiHHbX+DFm844mP2
         M0JQ==
X-Gm-Message-State: AOJu0YxOHp6XKWRa7tP3UFrAl8EWMjvu2NHDTVPsLlbXnlYa9qZg/bQZ
        vU/Xd+3hR0K0IerfjijFNwXIJQ==
X-Google-Smtp-Source: AGHT+IHnuIrs3PweL9xunsuqoCKY17H82lE7cx9iaHFpRDYegJH258vHKi0V/9LAgF/GQyHIiowhsw==
X-Received: by 2002:a81:9282:0:b0:585:5fbf:1bf1 with SMTP id j124-20020a819282000000b005855fbf1bf1mr3438208ywg.48.1691602121836;
        Wed, 09 Aug 2023 10:28:41 -0700 (PDT)
Received: from sunraycer.home ([2601:246:5d81:5e3b::100])
        by smtp.gmail.com with ESMTPSA id u123-20020a818481000000b00559f1cb8444sm4066142ywf.70.2023.08.09.10.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:28:41 -0700 (PDT)
Received: from 10.10.2.100 (sunraycer [10.10.2.100])
        by sunraycer.home (Postfix) with ESMTPSA id E94F55C406E;
        Wed,  9 Aug 2023 12:28:40 -0500 (CDT)
MIME-Version: 1.0
Date:   Wed, 09 Aug 2023 12:28:40 -0500
From:   steve <magnani@ieee.org>
To:     Steve Magnani <magnani@ieee.org>
Cc:     Quinn Tran <qutran@marvell.com>, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Prevent firmware rejection of
 MBC_GET_RNID_PARAMS
In-Reply-To: <20230809141059.10790-1-magnani@ieee.org>
References: <20230809141059.10790-1-magnani@ieee.org>
Message-ID: <2f4214c089c0269786abe1695fe7adec@sunraycer.home>
X-Sender: steve@sunraycer.home
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please disregard. It looks like the original patch b68710a8094f reduced 
the amount of data copied off so much that port logins are broken even 
though with my patch the firmware now processes GET_RNID_PARAMS. The 
breakage has been introduced during 6.5 (and propagated into 5.x stable 
branches) so there is some urgency to getting a proper fix.

I will send a short series to revert b68710a8094f and replace it with 
what I think is the correct overrun fix. AFAICT the overrun is only a 
single dword.


--Steve


On 2023-08-09 09:10, Steve Magnani wrote:
> At least some firmware (for example, QLE2692 FW 8.08.231 (d0d5)) 
> returns
> MBS_COMMAND_PARAMETER_ERROR when 
> MBC_GET_RNID_PARAMS(RNID_TYPE_PORT_LOGIN)
> is issued with a transfer length of 4 (DWords). Correct the overrun fix 
> to
> issue a "normal" transfer length and instead limit copy-out of desired
> PLOGI data to the space available for it.
> 
> Fixes: b68710a8094f ("scsi: qla2xxx: Fix buffer overrun")
> Signed-off-by: "Steven J. Magnani" <magnani@ieee.org>
> ---
> --- a/drivers/scsi/qla2xxx/qla_init.c	2023-08-01 03:46:21.727114453 
> -0500
> +++ b/drivers/scsi/qla2xxx/qla_init.c	2023-08-08 23:18:46.475286995 
> -0500
> @@ -5549,7 +5549,8 @@ static void qla_get_login_template(scsi_
>  	__be32 *q;
> 
>  	memset(ha->init_cb, 0, ha->init_cb_size);
> -	sz = min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);
> +	/* At least some firmware requires sz > sizeof(fc_els_csp) */
> +	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
>  	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
>  					    ha->init_cb, sz);
>  	if (rval != QLA_SUCCESS) {
> @@ -5560,6 +5561,7 @@ static void qla_get_login_template(scsi_
>  	q = (__be32 *)&ha->plogi_els_payld.fl_csp;
> 
>  	bp = (uint32_t *)ha->init_cb;
> +	sz = min_t(u32, sizeof(struct fc_els_csp), sz);
>  	cpu_to_be32_array(q, bp, sz / 4);
>  	ha->flags.plogi_template_valid = 1;
>  }
