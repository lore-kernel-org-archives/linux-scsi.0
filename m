Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0916CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C40A964EEC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCQJFx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhCQJF1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:05:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B454C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:05:16 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id 61so968690wrm.12
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OcOkwCkyvLuke/iNw2LLAogSWUiyJtcxO/hC/X9eTec=;
        b=YYc0KLEbBxgH+ZUG7LiDYEtZcpBX4RqAPYmaegxRr+9NyuAkGQTaj9vShjjBp1kz4G
         xRjTbxsmGrK2E+8mvtXdJ/1lYYdR/lE/s5YzOBGfvtH/p2nb3GgXN9avsy/spkxpqP8l
         q1K4fnyloW5Al7EXVqZXBQKueUdoEM1Wl+9IUQMyiCCozmQjeXudZHHFEJZ1/3dVvyXi
         ZBSGjq8Wwq2ZoRTgheOFZV8Hjw9BT7LMD4gr6AlaCmCCqxHkHgWBKmnee6Wr0dHG31wD
         NYvtj0e9xx5DXQt+3YuFkZlKKNHMvZZSECEc+Ng5H8w55K2qTxzKie+GWL63tSdTMVfN
         mnhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OcOkwCkyvLuke/iNw2LLAogSWUiyJtcxO/hC/X9eTec=;
        b=JuNWphdGBbo0T4/JpnTryUVdnYN1sSy+d1GiI8L0wRtSGR8KT/OEEEdU6riQQsjIZN
         UpNooosSo8vgC/jUfGunIO+B5i9s4x1n9IVt0+1ru5NUspfUVyHeSQETqYhSnTmdhc2u
         OiabqhrpLyFuroA4CRV+iP6qbVuCshRvqOaz30CWsfeS2/CZcr30VweaId3R4k33ZjgC
         nBCwbLAJ/3MxOUWnWhpAOpI5wA/1pvcu3z/t80iS7eoQ6TV78Bw6e9Vdzb5F7J+/HDuj
         WCvOil05dwN92C9MUdMRtBESlt1X2Oyy21heAXAsMOvBe4REplLmwbY5b9Jc2FHKSmHe
         zCbg==
X-Gm-Message-State: AOAM532VFKRCPR45FZn29WYozlCgCUFDNsequlT+UV9vGzNmY+qNmXxF
        dw/ld8Ld/XaSJXcypeNLgT4QKA==
X-Google-Smtp-Source: ABdhPJxlU7tk/HVjonZcyAbzBtH+m2MESpX+2byaucGFATA64RJfU7n4jVMSy1FWKxWcitvmtWV8KA==
X-Received: by 2002:adf:f3c2:: with SMTP id g2mr3331553wrp.300.1615971915310;
        Wed, 17 Mar 2021 02:05:15 -0700 (PDT)
Received: from dell ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id o7sm24710724wrs.16.2021.03.17.02.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:05:14 -0700 (PDT)
Date:   Wed, 17 Mar 2021 09:05:12 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andre Hedrick <andre@suse.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        c by <James.Bottomley@steeleye.com>,
        Christoph Hellwig <hch@lst.de>,
        David Chaw <david_chaw@adaptec.com>,
        de Melo <acme@conectiva.com.br>,
        Doug Ledford <dledford@redhat.com>,
        GOTO Masanori <gotom@debian.or.jp>, gotom@debian.org,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Joel Jacobson <linux@3ware.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        Linux GmbH <hare@suse.com>, linux-scsi@vger.kernel.org,
        Luben Tuikov <luben_tuikov@adaptec.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com,
        Richard Hirst <richard@sleepie.demon.co.uk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: Re: [PATCH 00/18] [Set 3] Rid W=1 warnings in SCSI
Message-ID: <20210317090512.GI701493@dell>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Mar 2021, Lee Jones wrote:

> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> This set contains functional changes.
> 
> This set is part of a larger effort attempting to clean-up W=1
> kernel builds, which are currently overwhelmingly riddled with
> niggly little warnings.
> 
> Lee Jones (18):
>   scsi: aic94xx: aic94xx_dump: Remove code that has been unused for at
>     least 13 years
>   scsi: mpt3sas: mpt3sas_scs: Move a little data from the stack onto the
>     heap
>   scsi: bfa: bfa_fcs_lport: Move a large struct from the stack onto the
>     heap
>   scsi: esas2r: esas2r_log: Supply __printf(x, y) formatting for
>     esas2r_log_master()
>   scsi: BusLogic: Supply __printf(x, y) formatting for blogic_msg()
>   scsi: nsp32: Supply __printf(x, y) formatting for nsp32_message()
>   scsi: initio: Remove unused variable 'prev'
>   scsi: a100u2w: Remove unused variable 'bios_phys'
>   scsi: myrs: Remove a couple of unused 'status' variables
>   scsi: 3w-xxxx: Remove 2 unused variables 'response_que_value' and
>     'tw_dev'
>   scsi: 3w-9xxx: Remove a few set but unused variables
>   scsi: 3w-sas: Remove unused variables 'sglist' and 'tw_dev'
>   scsi: nsp32: Remove or exclude unused variables
>   scsi: FlashPoint: Remove unused variable 'TID' from
>     'FlashPoint_AbortCCB()'
>   scsi: sim710: Remove unused variable 'err' from sim710_init()
>   scsi: isci: port: Make local function 'port_state_name()' static
>   scsi: isci: remote_device: Make local function
>     isci_remote_device_wait_for_resume_from_abort() static
>   scsi: nsp32: Correct expected types in debug print formatting

Oh dear! Looks like I also took functional patches from sets that
have already been sent out.

Please silently disregard this set. Sorry for the noise.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
