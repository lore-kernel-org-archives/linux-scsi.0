Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FD0C001E0
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 16:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbjJWQa1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 12:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjJWQaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 12:30:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08091722
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 09:30:09 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ca74e77aecso32719565ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 09:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698078608; x=1698683408; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JCTUhnkp8BfIf0+VHOy2mczZq79A4ZVsByr98RfEeM0=;
        b=gsUvVQdqt2PqAd5jheAEZg7osBDUmfE+n4ltI3d1XOOdDKU/s4Hby0xm902NqpVTsw
         L+tPZHLFZ3qDBrULpcfVDg5D3e0/MG0O0rvhyoqpShqxABkZkwnTSPJcc/0kFcaRgL1O
         SYTarwTHOLF7Q6QWko6iV5K3Tifetec1R0xfw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698078608; x=1698683408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JCTUhnkp8BfIf0+VHOy2mczZq79A4ZVsByr98RfEeM0=;
        b=dPHJukp2pVXgQ98SueMiXTkoUXrqssvlXX7ztGuXGrlbPFvM9PpXfb0ZkKsGLEI+I/
         eup77fW+XOn4xypGFV3BYbd0tbi1+59g43gsI4SVMEU1o/1qTLUC3UagRTflprkM8fKM
         EQu/BBtTwPjIQGtbGbAApqUevzbBK2i9L/esrZkNd4x6tHRnB+2DGQ0MGZcpUlOmynMN
         MKcLlXwYqjfTZ0gVmuCKcqqPhkdWZISRF2F9lSyaGxGyQN6Xg4f4vBNWxw0SQ8QpWlEz
         Gw2pkUPxAHHJeVR1QhrhDjbSLVLdYG17cPmVahcATsi9LlsPEQ6qI8FMBDVUHb6kmcc5
         iySw==
X-Gm-Message-State: AOJu0Yy6uwAFYBSPb2GYkexjITjeEcZ1vvlLGZvrVxTjELt9ceJeBE39
        bdTigoUgK3oI5U3w2TblyG1FpA==
X-Google-Smtp-Source: AGHT+IFdJSIMCNoyECotk2Az+bQFsSMXHbPz9816qzECRqjwW5St5+gabzjnF1X6Abp43P2IybkKkA==
X-Received: by 2002:a17:903:2304:b0:1b8:a67f:1c15 with SMTP id d4-20020a170903230400b001b8a67f1c15mr15277922plh.25.1698078608431;
        Mon, 23 Oct 2023 09:30:08 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j6-20020a170902da8600b001c9c8d761a3sm6042522plx.131.2023.10.23.09.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 09:30:07 -0700 (PDT)
Date:   Mon, 23 Oct 2023 09:30:07 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        James Seo <james@equiv.tech>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] scsi: mpt3sas: Use flexible arrays and do a few
 cleanups
Message-ID: <202310230929.494FD6E14E@keescook>
References: <20230806170604.16143-1-james@equiv.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230806170604.16143-1-james@equiv.tech>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 06, 2023 at 10:05:52AM -0700, James Seo wrote:
> Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") has
> resulted in the only arrays that UBSAN_BOUNDS considers unbounded
> being trailing arrays declared with [] as the last member of a
> struct. Unbounded trailing arrays declared with [1] are common in
> mpt3sas, which is causing spurious warnings to appear in some
> situations, e.g. when more than one physical disk is connected:
> 
>   UBSAN: array-index-out-of-bounds in drivers/scsi/mpt3sas/mpt3sas_scsih.c:6810:36
>   index 1 is out of range for type 'MPI2_SAS_IO_UNIT0_PHY_DATA [1]'
> 
> which relates to this unbounded array access:
> 
>   port_id = sas_iounit_pg0->PhyData[i].Port;
> 
> and is just one example of 10 similar warnings currently occurring
> for me during boot.
> 
> This series converts most trailing arrays declared with [1] in mptsas
> into proper C99 flexible array members. Those that are not unbounded
> and really are fixed-length arrays of length 1 are left alone.
> 
> I didn't find any conversions that required further source edits
> besides changing [1] to [], and everything seems to work with my
> SAS2008-based add-in card, but please look things over in case I
> missed something subtle.
> 
> Rounding out the series are some opportunistic cleanups.
> 
> The only dependency is that patch 7 ("Use struct_size() for struct
> size calculations") depends on patches 3-5.
> 
> History:
> v1: https://lore.kernel.org/linux-scsi/20230725161331.27481-1-james@equiv.tech/
> 
> Changes v1->v2:
> - Slightly reword and add Reviewed-by: tags to commit messages
> - Split up a commit that was resulting in many binary changes
> - Remove the iounit_pg8 member of the per-adapter struct
> - Replace more dynamic allocations with local variables

Here's a tested-by: from Boris:

https://lore.kernel.org/all/20231023135615.GBZTZ7fwRh48euq3ew@fat_crate.local

-Kees

> 
> James Seo (12):
>   scsi: mpt3sas: Use flexible arrays when obviously possible
>   scsi: mpt3sas: Make MPI2_CONFIG_PAGE_IO_UNIT_8::Sensor[] a flexible
>     array
>   scsi: mpt3sas: Make MPI2_CONFIG_PAGE_RAID_VOL_0::PhysDisk[] a flexible
>     array
>   scsi: mpt3sas: Make MPI2_CONFIG_PAGE_SASIOUNIT_0::PhyData[] a flexible
>     array
>   scsi: mpt3sas: Make MPI2_CONFIG_PAGE_SASIOUNIT_1::PhyData[] a flexible
>     array
>   scsi: mpt3sas: Make MPI26_CONFIG_PAGE_PIOUNIT_1::PhyData[] a flexible
>     array
>   scsi: mpt3sas: Use struct_size() for struct size calculations
>   scsi: mpt3sas: Remove the iounit_pg8 member of the per-adapter struct
>   scsi: mpt3sas: Fix an outdated comment
>   scsi: mpt3sas: Fix typo of "TRIGGER"
>   scsi: mpt3sas: Replace a dynamic allocation with a local variable
>   scsi: mpt3sas: Replace dynamic allocations with local variables
> 
>  drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h         | 231 ++++++-------------
>  drivers/scsi/mpt3sas/mpi/mpi2_image.h        |  32 +--
>  drivers/scsi/mpt3sas/mpi/mpi2_ioc.h          |  27 +--
>  drivers/scsi/mpt3sas/mpt3sas_base.c          |  35 ++-
>  drivers/scsi/mpt3sas/mpt3sas_base.h          |   2 -
>  drivers/scsi/mpt3sas/mpt3sas_config.c        |   6 +-
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c         |  55 ++---
>  drivers/scsi/mpt3sas/mpt3sas_transport.c     |   9 +-
>  drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h |  44 ++--
>  drivers/scsi/mpt3sas/mpt3sas_warpdrive.c     |   3 +-
>  10 files changed, 151 insertions(+), 293 deletions(-)
> 
> 
> base-commit: 6cae9a3910ac1b5daf5ac3db9576b78cc4eff5aa
> -- 
> 2.39.2
> 

-- 
Kees Cook
