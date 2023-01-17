Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B14DC54E76
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 21:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjAQVDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 16:03:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjAQVCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 16:02:38 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DD64A1F3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 11:29:44 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id d8so2270362pjc.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 11:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gRpqq+2LxugqpZNX3s+wDiUYVm6GWNq9r7NcJVznttI=;
        b=DDL10rALn1z1FRoOFnw2dnP+4blUFM0iSm4tQ+rKvADmrEBfKO4DE+cHNhsOUk/lZM
         2xlZ5mLD71Pan3w8wL/z1Z3QPjnt3q+svnrggrB32gsUHn7e+LA1RgeXFKfKp60gvb0c
         3BYQ+iVZEa1Ulyahd4XWoCOV7Yat17xcCUUXrfNxxqhTR2+tza0X6jlZ6grUng+a/y1y
         iY+FHGeS5IDHLwUsft7YY/YHKIsFpq8qKQPNSDdaWabVD1GEMZNexuHF3nx1sur5GuO4
         yYrwdnSb9kbKnEJ/wwYeoNqyRIgTVT1WOwHluYP/L902eOEFRKQ13yP5sfQSMYdqSDoB
         Djcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRpqq+2LxugqpZNX3s+wDiUYVm6GWNq9r7NcJVznttI=;
        b=fbaeH45DznBlF3ehXuyH0mU29vimEkw2gz3aiUS7BQB243ajAE5TdkZJjrESIZFfTS
         3IfTOKwE+0GGvdzEec0Ih2OTRhjDyvHIzOQEqDUYmRBGr0q/I9SqMS6DIQ4sUiyvopbi
         QMltmrhqniNZM0paIYYYbl1YBfWTWGrZgkmgGI/66Xi9esbPrNCtSdxR5Qa7scmEnbEb
         +FZN/H3cBNfH26eRzYxFB8ISjeFxNzMX532mYom/tVdiRfCoehVVh5dQOgla9e/WV1iT
         odXo5OLkR1FrCcDBQnrpKtNu/4IGGEE1zvi86w7SFSQ46mZZBUJ11/Wm2yaNjHvrlhuq
         nBXg==
X-Gm-Message-State: AFqh2kpHk26msFPyIkCuty2DAJG0qtYqf3YDOXv23yO18jK+P7coai/N
        s07uK5t5me5pJBi6uP+7uXNuFw==
X-Google-Smtp-Source: AMrXdXs5jEoPdwvpIvhpWsoNZ3dwLlPfm/N/TqJwrTUTJCQIR/xEnhuSGfUHyd3nbcshsUxFjBAa6w==
X-Received: by 2002:a17:902:ec82:b0:194:9874:7ece with SMTP id x2-20020a170902ec8200b0019498747ecemr5863503plg.29.1673983783644;
        Tue, 17 Jan 2023 11:29:43 -0800 (PST)
Received: from google.com ([2620:15c:2d1:203:c3b2:a57d:8316:74e6])
        by smtp.gmail.com with ESMTPSA id j2-20020a170902da8200b00188ea79fae0sm21625839plx.48.2023.01.17.11.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 11:29:43 -0800 (PST)
Date:   Tue, 17 Jan 2023 11:29:38 -0800
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>, Arnd Bergmann <arnd@arndb.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tom Rix <trix@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] qla2xxx: fix printk format string
Message-ID: <20230117192938.nryt2tlgjymkr5ux@google.com>
References: <20230117170029.2387516-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117170029.2387516-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 17, 2023 at 06:00:15PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Printing a size_t value that is the result of the sizeof() operator requires
> using the %z format string modifier to avoid a warning on 32-bit architectures:
> 
> drivers/scsi/qla2xxx/qla_mid.c: In function 'qla_create_buf_pool':
> drivers/scsi/qla2xxx/qla_mid.c:1094:51: error: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Werror=format=]
>  1094 |                     "Failed to allocate buf_map(%ld).\n", sz * sizeof(unsigned long));
>       |                                                 ~~^       ~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                                                   |          |
>       |                                                   long int   unsigned int
>       |                                                 %d
> 
> Fixes: 82d8dfd2a238 ("scsi: qla2xxx: edif: Fix performance dip due to lock contention")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for the patch!

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Link: https://lore.kernel.org/llvm/63c4ddba.170a0220.1547e.db75@mx.google.com/

> ---
>  drivers/scsi/qla2xxx/qla_mid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index c6ca39b8e23d..1483f6258f92 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -1091,7 +1091,7 @@ int qla_create_buf_pool(struct scsi_qla_host *vha, struct qla_qpair *qp)
>  	qp->buf_pool.buf_map   = kcalloc(sz, sizeof(long), GFP_KERNEL);
>  	if (!qp->buf_pool.buf_map) {
>  		ql_log(ql_log_warn, vha, 0x0186,
> -		    "Failed to allocate buf_map(%ld).\n", sz * sizeof(unsigned long));
> +		    "Failed to allocate buf_map(%zd).\n", sz * sizeof(unsigned long));
>  		return -ENOMEM;
>  	}
>  	sz = qp->req->length * sizeof(void *);
> -- 
> 2.39.0
> 
> 
