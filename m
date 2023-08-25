Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD45C3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 20:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjHYUhk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 16:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjHYUhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 16:37:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78932129
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 13:37:10 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-68a520dba33so1118250b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 13:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692995830; x=1693600630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TPFsDM2aS22oJkp4VKW1ExTBHZejf9jyFe0+feyfd/8=;
        b=mVu8QcoKmRZGFyMEw5zhhZB9hgAkvVpPZgwSNIdByZWsNEpUoP6zjccLbvAPnGaHMf
         XlsE7Ri967gFlG05B6gHkZ5MhJwjIW85r8Gv1x1n/hCCNu5YRnNKxYoqQ4j8fq2SXg6h
         U5WQass8Y5x6l2yyFVNmqIu87TdSUqYnxntH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692995830; x=1693600630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPFsDM2aS22oJkp4VKW1ExTBHZejf9jyFe0+feyfd/8=;
        b=LrPAHnWYcampxl4njzj32PGGF3f5eorHAAbmjOP9HzQVF8YJSOsMiD09ZSuPeT0oR2
         tEmyjDofIusTu/9ojcyG3vbT+M8O5xC68X61IyVtyeFyzrm56rcVpp9lkBbYU6oEvIR4
         xK6yG/nRlGiMd8S2PhL8qe3yPH991DLPOAoaPUDR1aJPxqtBOMegQyn+T8o/udzk+5kt
         xWc2q98zgpOZ2zs1/9JeSRAEiMYMbCEnaRpn59H3/gqlSIOWRdtlymfozUhoEDYo6+1z
         pL+N5i9yC1nkaSDG9NXZq2O6ox+qbna9p2Dk7oxWmVs2C6NmPceGMzwxf78dnpaTqHmq
         cZWw==
X-Gm-Message-State: AOJu0Yy4zsZwamREa1ie9MJSfEPdZfzEWeka1s+p8QIPnm+IlO+w8CFn
        6T0K4dgLwYXxQpLzwtmJrrB5SA==
X-Google-Smtp-Source: AGHT+IHZeULT+i0DWpVrCSGuQ58y7gjL44hyK89F2DmJUhpzLU7kjzmSUnoK42OQIsZSrnZP5t77tg==
X-Received: by 2002:a05:6a00:a13:b0:68a:3c7a:129e with SMTP id p19-20020a056a000a1300b0068a3c7a129emr20589880pfh.27.1692995830400;
        Fri, 25 Aug 2023 13:37:10 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id m9-20020aa79009000000b00688435a9915sm1949344pfo.189.2023.08.25.13.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 13:37:09 -0700 (PDT)
Date:   Fri, 25 Aug 2023 13:37:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     James Seo <james@equiv.tech>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/12] scsi: mpt3sas: Make
 MPI2_CONFIG_PAGE_IO_UNIT_8::Sensor[] a flexible array
Message-ID: <202308251334.A4A10C2@keescook>
References: <20230806170604.16143-1-james@equiv.tech>
 <20230806170604.16143-3-james@equiv.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230806170604.16143-3-james@equiv.tech>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 06, 2023 at 10:05:54AM -0700, James Seo wrote:
> This terminal 1-length variable array can be directly converted into
> a C99 flexible array member.
> 
> As all users of MPI2_CONFIG_PAGE_IO_UNIT_8 (Mpi2IOUnitPage8_t) do not
> use Sensor[], no further source changes are required to accommodate
> its reduced sizeof():
> 
> - mpt3sas_config.c:mpt3sas_config_get_iounit_pg8() fetches a
>   Mpi2IOUnitPage8_t into a caller-provided buffer, assuming
>   sizeof(Mpi2IOUnitPage8_t) as the buffer size. It has one caller:
> 
>   - mpt3sas_base.c:_base_static_config_pages() passes the address of
>     the Mpi2IOUnitPage8_t iounit_pg8 member of the per-adapter struct
>     (struct MPT3SAS_ADAPTER *ioc) as the buffer. The assumed buffer
>     size is therefore correct.
> 
>     However, the only subsequent use in mpt3sas of the thus populated
>     ioc->iounit_pg8 is a little further on in the same function, and
>     this use does not involve ioc->iounit_pg8.Sensor[].
> 
>     Note that iounit_pg8 occurs in the middle of the per-adapter
>     struct, not at the end. The per-adapter struct is extensively

This is especially bad/weird. Flex arrays aren't supposed to live there,
so I think it'd be best to avoid this conversion (see below).

>     used throughout mpt3sas even if its iounit_pg8 member isn't,
>     resulting in an especially large amount of noise when comparing
>     binary changes attributable to this commit.

Since the size reduction makes it hard to validate, how about just
leaving it alone? Since nothing is using Sensor[], you could just make
it a single instance:

-     MPI2_IOUNIT8_SENSOR
-             Sensor[MPI2_IOUNITPAGE8_SENSOR_ENTRIES];/*0x10 */
+     MPI2_IOUNIT8_SENSOR     Sensor;                 /*0x10 */


or leave it as-is (i.e. drop this patch).

> 
> Signed-off-by: James Seo <james@equiv.tech>
> ---
>  drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> index 42d820159c44..12b656bd883d 100644
> --- a/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> +++ b/drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h
> @@ -1200,12 +1200,9 @@ typedef struct _MPI2_IOUNIT8_SENSOR {
>  #define MPI2_IOUNIT8_SENSOR_FLAGS_T0_ENABLE         (0x0001)
>  
>  /*
> - *Host code (drivers, BIOS, utilities, etc.) should leave this define set to
> - *one and check the value returned for NumSensors at runtime.
> + *Host code (drivers, BIOS, utilities, etc.) should check the value returned
> + *for NumSensors at runtime before using Sensor[].
>   */
> -#ifndef MPI2_IOUNITPAGE8_SENSOR_ENTRIES
> -#define MPI2_IOUNITPAGE8_SENSOR_ENTRIES     (1)
> -#endif
>  
>  typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_8 {
>  	MPI2_CONFIG_PAGE_HEADER Header;                 /*0x00 */
> @@ -1214,8 +1211,7 @@ typedef struct _MPI2_CONFIG_PAGE_IO_UNIT_8 {
>  	U8                      NumSensors;             /*0x0C */
>  	U8                      PollingInterval;        /*0x0D */
>  	U16                     Reserved3;              /*0x0E */
> -	MPI2_IOUNIT8_SENSOR
> -		Sensor[MPI2_IOUNITPAGE8_SENSOR_ENTRIES];/*0x10 */
> +	MPI2_IOUNIT8_SENSOR     Sensor[];               /*0x10 */
>  } MPI2_CONFIG_PAGE_IO_UNIT_8,
>  	*PTR_MPI2_CONFIG_PAGE_IO_UNIT_8,
>  	Mpi2IOUnitPage8_t, *pMpi2IOUnitPage8_t;
> -- 
> 2.39.2
> 

-- 
Kees Cook
