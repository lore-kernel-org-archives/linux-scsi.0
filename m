Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C8EC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7682D20738
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:18:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5XZg9ok"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHQISV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgHQISO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:18:14 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5B0C061388;
        Mon, 17 Aug 2020 01:18:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id a79so7852400pfa.8;
        Mon, 17 Aug 2020 01:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z+N51puImyhHxFx5Dm61lcPlZbEFuwK8jmWOAVp7Ph8=;
        b=K5XZg9ok4JjG3ct1sm9nhp9P1f1FppDczGCfLdNzfKpPuz++jIfBtakngC7NDdg9SV
         /0qXDp3CtBQvq2UJOciQrZdnscHe5oVUcB/ha1H9vdV6SmbrYpib1Uy9kgwZui5i+g4Q
         juHlIW8G1oNmOQrVOrhK7p5P2kcNR8fFqF74H7+zMg6nxLIpWSP5NmJzdq9ViVlyUati
         g8LB7o2+URT0tBDZsX6uXK/CcMI2/5jO6+J/jcJhVWNG/2gt3E9GAQqsmV5dhV44u93q
         g7/gWNzluJrxNicWYmCeId492BEGRpw2TeTsktBLONgzIMYqjaBEKQynwuH9wkau0+X6
         epAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z+N51puImyhHxFx5Dm61lcPlZbEFuwK8jmWOAVp7Ph8=;
        b=ZFFDZb1mMzClMW8I15nio6Oqok/PCCC1arwmVFjTA+F0MIaUeZw08XnIh1AJWMYEgc
         gtBffQYVyunrHiurPQtxBx7kyNxraCIOrbRlksbYievRRyZX2MQjT2srTloD3eohTIyz
         Lb4WVDYCjXXKZAGhCySWbr2sieMeLEaZh2DWA01SXwQH0HdE0TnBFuh5PL5mwmU+/JF1
         2KJEpazUYLutAVfPfdw2yuPhr2RFaukabQhKbuZOvAlR/PxK7WtTjmv5vfVuO0YRFWG0
         vwxVdyRo4ckdDFIsJS/C3CSCvcboHGd4pdqD+mpOPnvI4/AasarTaSXMHSvHrl0am9op
         UZpQ==
X-Gm-Message-State: AOAM5322MX9GyZI7LEz28Xc6p3gWxIe/0BEMZmdwW8SVk4VRxeIMkPST
        AQYFIq0MEaWAbYhyp33nS7g=
X-Google-Smtp-Source: ABdhPJwaKRxVVpxObpt2jqteoMYfRRZZpAZmMGLvpTaseq2out4O7d+yilUaXa9D5vSOLFl1pRsV3Q==
X-Received: by 2002:a63:6e01:: with SMTP id j1mr9130334pgc.147.1597652293814;
        Mon, 17 Aug 2020 01:18:13 -0700 (PDT)
Received: from gmail.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id q6sm16833689pjc.47.2020.08.17.01.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:18:13 -0700 (PDT)
Date:   Mon, 17 Aug 2020 13:46:32 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v2 00/15] scsi: use generic power management
Message-ID: <20200817081632.GI5869@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 07:04:13PM +0530, Vaibhav Gupta wrote:
> Linux Kernel Mentee: Remove Legacy Power Management.
> 
> The purpose of this patch series is to upgrade power management in scsi
> drivers. This has been done by upgrading .suspend() and .resume() callbacks.
> 
> The upgrade makes sure that the involvement of PCI Core does not change the
> order of operations executed in a driver. Thus, does not change its behavior.
> 
> In general, drivers with legacy PM, .suspend() and .resume() make use of PCI
> helper functions like pci_request/release_regions(), pci_set_power_state(),
> pci_save/restore_state(), pci_enable/disable_device(), etc. to complete
> their job.
> 
> The conversion requires the removal of those function calls, change the
> callbacks' definition accordingly and make use of dev_pm_ops structure.
> 
> v2: kbuild error in v1.
> 
> All patches are compile-tested only.
> 
> Test tools:
>     - Compiler: gcc (GCC) 10.1.0
>     - allmodconfig build: make -j$(nproc) W=1 all
> 
> Vaibhav Gupta (15):
>   scsi: megaraid_sas: use generic power management
>   scsi: aacraid: use generic power management
>   scsi: aic7xxx: use generic power management
>   scsi: aic79xx: use generic power management
>   scsi: arcmsr: use generic power management
>   scsi: esas2r: use generic power management
>   scsi: hisi_sas_v3_hw: use generic power management
>   scsi: mpt3sas_scsih: use generic power management
>   scsi: lpfc: use generic power management
>   scsi: pm_8001: use generic power management
>   scsi: hpsa: use generic power management
>   scsi: 3w-9xxx: use generic power management
>   scsi: 3w-sas: use generic power management
>   scsi: mvumi: use generic power management
>   scsi: pmcraid: use generic power management
> 
>  drivers/scsi/3w-9xxx.c                    |  30 ++-----
>  drivers/scsi/3w-sas.c                     |  31 ++-----
>  drivers/scsi/aacraid/linit.c              |  34 ++------
>  drivers/scsi/aic7xxx/aic79xx.h            |  12 +--
>  drivers/scsi/aic7xxx/aic79xx_core.c       |   8 +-
>  drivers/scsi/aic7xxx/aic79xx_osm_pci.c    |  43 +++-------
>  drivers/scsi/aic7xxx/aic79xx_pci.c        |   6 +-
>  drivers/scsi/aic7xxx/aic7xxx.h            |  10 +--
>  drivers/scsi/aic7xxx/aic7xxx_core.c       |   6 +-
>  drivers/scsi/aic7xxx/aic7xxx_osm_pci.c    |  46 +++-------
>  drivers/scsi/aic7xxx/aic7xxx_pci.c        |   4 +-
>  drivers/scsi/arcmsr/arcmsr_hba.c          |  35 +++-----
>  drivers/scsi/esas2r/esas2r.h              |   5 +-
>  drivers/scsi/esas2r/esas2r_init.c         |  48 +++--------
>  drivers/scsi/esas2r/esas2r_main.c         |   3 +-
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  32 +++----
>  drivers/scsi/hpsa.c                       |  12 +--
>  drivers/scsi/lpfc/lpfc_init.c             | 100 +++++++---------------
>  drivers/scsi/megaraid/megaraid_sas_base.c |  61 ++++---------
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  36 +++-----
>  drivers/scsi/mvumi.c                      |  49 +++--------
>  drivers/scsi/pm8001/pm8001_init.c         |  46 ++++------
>  drivers/scsi/pmcraid.c                    |  44 +++-------
>  23 files changed, 212 insertions(+), 489 deletions(-)
> 
> -- 
> 2.27.0
> 
