Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6FB9EE49A0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 21:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjHYVDt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 17:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjHYVD0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 17:03:26 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181A22114
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 14:03:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bf7a6509deso9827335ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Aug 2023 14:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692997404; x=1693602204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gUlxmH/dGUJclmdBEKi1Fz0Bb8RWQp73AiP7WLDESYs=;
        b=WvoNUjaWOJnbRajoU56mgqW/lItOF4Pc/05X8ZFZMmElxhb1DfAAhNksvc+VuMoyw8
         +3mAdBuH7p8OaiT0edExs4vUwHgK/lZB5OLvxMWZxcnbm9eH/ajUDdoljM/7L2sN6h+C
         JBxvbmA4ptVnbjGu7Jl14lGlzprTEOTC9hv1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692997404; x=1693602204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gUlxmH/dGUJclmdBEKi1Fz0Bb8RWQp73AiP7WLDESYs=;
        b=DTdycVeKjFWX/8ZJaSdMXfWfkzEsOV1y97xM24tY9uxsPKnfZcBQZhSUWv3mW8SCEo
         bQ5t2KTFZXObZ8iatJ1mRiaZtFtZoilbG5jY35XEJ06U0lbEpTqbUikQgBGYHm/flvbT
         KQSmndxiUQqvUetQE72oqc3Vg/Vm+Ir4GswqBC/lMhnoQyHl79jdwXtktPz9THpOVe3p
         RUP20ErAk/02V79Qfel8kH0jK42Ow7UWRyL92bghrRriTE16Dyu8KmYtOFEId62lsqrv
         EacvSVj0KWoL9A81cUCmTDY7dl9mBSSNcbXZ0WhaKEkSxrfSrteWfweq7d/k6OIgPeIg
         aK8w==
X-Gm-Message-State: AOJu0Yy/uPeE1cUy6vSzK6x+dd8LJO3Wihzfo1MglLLcvRs6qn/PqEVF
        dEatbR8tjsiBKjr9ztmrW1VfGA==
X-Google-Smtp-Source: AGHT+IEXNuyzFMSex8+HsXvaJyCHuZ8R/NSDeNZ8O0dtyFXKmAsfu74ZxXeo0Z8txaDNSsWHxuS5+g==
X-Received: by 2002:a17:902:a409:b0:1b9:c68f:91a5 with SMTP id p9-20020a170902a40900b001b9c68f91a5mr14598728plq.6.1692997404511;
        Fri, 25 Aug 2023 14:03:24 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j16-20020a170902da9000b001b9de2b905asm2193722plx.231.2023.08.25.14.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 14:03:23 -0700 (PDT)
Date:   Fri, 25 Aug 2023 14:03:23 -0700
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
Subject: Re: [PATCH v2 03/12] scsi: mpt3sas: Make
 MPI2_CONFIG_PAGE_RAID_VOL_0::PhysDisk[] a flexible array
Message-ID: <202308251357.38AF364@keescook>
References: <20230806170604.16143-1-james@equiv.tech>
 <20230806170604.16143-4-james@equiv.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230806170604.16143-4-james@equiv.tech>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 06, 2023 at 10:05:55AM -0700, James Seo wrote:
> This terminal 1-length variable array can be directly converted into
> a C99 flexible array member.
> 
> As all users of MPI2_CONFIG_PAGE_RAID_VOL_0 (Mpi2RaidVolPage0_t)
> either calculate its size without depending on its sizeof() or do not
> use PhysDisk[], no further source changes are required:

Tons of binary changes in this file too. I see this:

        Mpi2RaidVolPage0_t config_page;
	...
        r = _config_request(ioc, &mpi_request, &mpi_reply,
            MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, &config_page,
            sizeof(Mpi2RaidVolPage0_t));

So it's already changing this size (and possibly under-allocating now).

> - mpt3sas_config.c:mpt3sas_config_get_number_pds() fetches a
>   Mpi2RaidVolPage0_t for itself, but does not use PhysDisk[].

Is it certain that _config_request()'s use of mpt3sas_wait_for_ioc()
won't result in the hardware being upset that config_page_sz shrank?

> @@ -1826,8 +1823,7 @@ typedef struct _MPI2_CONFIG_PAGE_RAID_VOL_0 {
>  	U8                      Reserved2;         /*0x25 */
>  	U8                      Reserved3;         /*0x26 */
>  	U8                      InactiveStatus;    /*0x27 */
> -	MPI2_RAIDVOL0_PHYS_DISK
> -	PhysDisk[MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX]; /*0x28 */
> +	MPI2_RAIDVOL0_PHYS_DISK PhysDisk[];        /*0x28 */
>  } MPI2_CONFIG_PAGE_RAID_VOL_0,

Without the mpt3sas maintainers chiming in on this, I think the only
safe changes to make here are those with 0 binary differences. So for
things like this, it'll need to be:

-	MPI2_RAIDVOL0_PHYS_DISK
-	PhysDisk[MPI2_RAID_VOL_PAGE_0_PHYSDISK_MAX]; /*0x28 */
+	union {
+		MPI2_RAIDVOL0_PHYS_DISK legacy_padding;        /*0x28 */
+		DECLARE_FLEX_ARRAY(MPI2_RAIDVOL0_PHYS_DISK, PhysDisk);
+	};

-- 
Kees Cook
