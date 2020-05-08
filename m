Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19A0C47257
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 10:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB78B21473
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 10:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YHTx8S84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgEHKIH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 06:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgEHKIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 06:08:07 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A16C05BD43;
        Fri,  8 May 2020 03:08:06 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l18so1184099wrn.6;
        Fri, 08 May 2020 03:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cMrXUnaCQ6nb0TNeDE3z+xWlmBXzCBLLvf7b5TeC00M=;
        b=YHTx8S84AjkknLST+QQrfc6FW2ngA/ciHZ2fjnf3DmCskDVE/lrfqCyF8og4Cj129z
         KsC822zLkQiWHFgK801nGelUuDMSOqH2WP8FHS6Fn/NtwGd34/ynSNDAlQXxJ1OZa29o
         hUpTZY7Djkyo/v9PAwLPWGJhm10Q608NpkiM1gsve2ObdiBRUdges4bi9p0aC2LDwCOn
         d3ersJJnNF/NeuL6lvR/GPlVtVxlIpfhQjHQv85bJsuypdFve/9CCnA1vdtxmm8hLX1G
         ymuexHRslUdJPEb1vbdjVVtpQMtanNyFyIu8AvfR0PhY4WgSw/mnWGniNlEPXyRFCWe5
         jadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMrXUnaCQ6nb0TNeDE3z+xWlmBXzCBLLvf7b5TeC00M=;
        b=jHeAvhswyAIZHeTJ/2MfmK+SgHnfcuoaG18Bp0qC4ZdjAXGYKjLqBpyGGI3vgQpyNi
         td7lFpBbWUyrPBvqu6f6xDbJAI1sGLmcl4fufKJBr0zywjNy3z5i2G/Ep0bSjXwh+GcD
         TryTSLu7BVTv6h5ZM+RI27IXNdjo713oDEJ5DUtoS1Dlr4aMQrGKnveoeC0zx2GkSMa1
         TfJ5kOTAJMymi+9v4BT4zOSF5UxjTUtw3m5hwufLdX+5ReHzWcPHjDx5+eePsaRLH86J
         +dDHQQFiOyabj2DxvOFpMHCdUZK4DLpV6Hvh6fZxQFXZuzWwPFX17/Sg0Y/7MnVgyU/D
         r6yA==
X-Gm-Message-State: AGi0PubMBNlygdLIdMj8wlMZ/uGGg6EF+2ecr0tzrWBHgfm0lklfWed7
        LHlLYlVelvg4zwAksr3aeME/EkuLfU4=
X-Google-Smtp-Source: APiQypLEt17JB/X+Fw/Poq8HAZrU3IhnvWhHS2sDpGd7T4Csm9vGWOiTN9ucEdO21bX1g+xV1ENvhw==
X-Received: by 2002:a5d:54c4:: with SMTP id x4mr2175403wrv.73.1588932485577;
        Fri, 08 May 2020 03:08:05 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id e21sm2178418wrc.1.2020.05.08.03.08.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 03:08:05 -0700 (PDT)
Message-ID: <201b31e72f545ef46a74c7aa8e9cad8a9a81727e.camel@gmail.com>
Subject: Re: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
From:   Bean Huo <huobean@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        hch@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cang@codeaurora.org
Date:   Fri, 08 May 2020 12:08:03 +0200
In-Reply-To: <38db2ee7-18ff-9263-1cc7-1b9c6f085632@infradead.org>
References: <20200504142032.16619-1-beanhuo@micron.com>
         <20200504142032.16619-6-beanhuo@micron.com>
         <38db2ee7-18ff-9263-1cc7-1b9c6f085632@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-05-07 at 18:34 -0700, Randy Dunlap wrote:
> Hi,
> 
> On 5/4/20 7:20 AM, huobean@gmail.com wrote:
> > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> > index e2005aeddc2d..0224f224a641 100644
> > --- a/drivers/scsi/ufs/Kconfig
> > +++ b/drivers/scsi/ufs/Kconfig
> > @@ -160,3 +160,65 @@ config SCSI_UFS_BSG
> >  
> >  	  Select this if you need a bsg device node for your UFS
> > controller.
> >  	  If unsure, say N.
> > +
> > +config SCSI_UFSHPB
> > +	bool "UFS Host Performance Booster (EXPERIMENTAL)"
> > +	depends on SCSI_UFSHCD
> > +	help
> > +	  NAND flash-based storage devices, including UFS, have
> > mechanisms to
> > +	  translate logical addresses of the IO requests to the
> > corresponding
> > +	  physical addresses of the flash storage. Traditionally, this
> > L2P
> > +	  mapping data is loaded to the internal SRAM in the storage
> > controller.
> > +	  When the capacity of storage is larger, a larger size of SRAM
> > for the
> > +	  L2P map data is required. Since increased SRAM size affects
> > the
> > +	  manufacturing cost significantly, it is not cost-effective to
> > allocate
> > +	  all the amount of SRAM needed to keep all the Logical-address 
> > to
> > +	  Physical-address (L2P) map data. Therefore, L2P map data,
> > which is
> > +	  required to identify the physical address for the requested
> > IOs, can
> > +	  only be partially stored in SRAM from NAND flash. Due to this
> > partial
> > +	  loading, accessing the flash address area where the L2P
> > information
> > +	  for that address is not loaded in the SRAM can result in
> > serious
> > +	  performance degradation.
> > +
> > +	  UFS Host Performance Booster (HPB) is a software solution for
> > the
> > +	  above problem, which uses the host side system memory as a
> > cache for
> > +	  the FTL L2P mapping table. It does not need additional
> > hardware
> > +	  support from the host side. By using HPB, the L2P mapping
> > table can be
> > +	  read from host memory and stored in host-side memory. when
> > performing
> 
> Should that be: from device memory and stored in host-side memory.
> ?
> 
> Also, s/when/When/
> 
> 
> > +	  the read operation, the corresponding L2P information will be
> > sent to
> > +	  the UFS device along with the reading request. Since the L2P
> > entry is
> 
> s/reading/read/
> 
> > +	  provided in the read request, UFS device does not have to
> > load L2P
> > +	  entry from flash memory to UFS internal SRAM. This will
> > significantly
> > +	  improve the read performance.
> > +
> > +	  When selected, this feature will be built in the UFS driver.
> > +
> > +	  If in doubt, say N.
> > +
> > +config UFSHPB_MAX_MEM_SIZE
> > +	int "UFS HPB maximum memory size per controller (in MiB)"
> > +	depends on SCSI_UFSHPB
> > +	default 128
> > +	range 0 65536
> > +	help
> > +	  This parameter defines the maximum UFS HPB memory/cache size
> > in the
> > +	  host system. The recommended HPB cache size by the UFS device
> > can be
> > +	  calculated from bHPBRegionSize and
> > wDeviceMaxActiveHPBRegions. The
> > +	  reference formula can be
> 
> s/can be/is/
> 
> > +
> > +		(bHPBRegionSize(in KB) / 4KB) * 8 *
> > wDeviceMaxActiveHPBRegions.
> > +
> > +	  The HPB cache in the host system is used to contain L2P
> > mapping
> > +	  entries. If the allocated HPB cache size is lower than what
> > calculated
> 
> 	                                                    than that
> 
> > +	  by the above formula, the use of HPB feature may provide
> > lower
> > +	  performance advantage. But the system memory resource has the
> > +	  limitation, we can not let HPB driver allocate its cache at
> > will
> > +	  according to the UFS device recommendation, so an appropriate
> > size of
> > +	  the cache for HPB should be specified before you choose to
> > use HPB,
> > +	  then please enter a non-zero positive integer value.
> > +
> > +	  Nevertheless, if you want to leave this to the HPB driver,
> > and let the
> > +	  HPB driver allocate the HPB cache based on the recommendation
> > of the
> > +	  UFS device. Just give 0 value to this parameter.
> > +
> > +	  Leave the default value if unsure.
> 
> thanks.


Hi Randy
Thanks for your review. I will change them based on your
comments.

thanks,

Bean

