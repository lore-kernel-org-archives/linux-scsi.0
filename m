Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D8BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 13:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC15610FF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 13:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhJ1N2t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 09:28:49 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:41495 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhJ1N2t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 09:28:49 -0400
Received: by mail-ot1-f53.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so8546693ote.8;
        Thu, 28 Oct 2021 06:26:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o0MDpHg+qwd0y498s50siQnYNolrvZrYHlzVJE27GAg=;
        b=d18eGZ8m6jpKVZ+RF3kIrpRl+MBerG/ax7/IfKKasRwN8ab18E9kbb+50BhvwkJMdn
         atwlI3KncTpiOK3Rsdj9h8ifyk98OsxDuVWshquY3CzLQrTg9TGZS6blfjmiQmjTN6IB
         bPbXF/6HuMbJpp/S1bNGKl/s7mPsZskVMHihCPwp4VC/dbed5TOKqqTvD2Wi+A0fBHQZ
         dtNmBjR9pH2MMI/UOwF6EX1FnSbSm+fc5MhlwoyZfsl0ZM3fNqwlFqVdJQQAcEYq0230
         QPTgnJzUDTAxDCeBJY33ts5Ng37jJQJkRtz3a45Z6WvXWPY//ntWfqeyCiBfffYLmey4
         oCfg==
X-Gm-Message-State: AOAM531s1xcUUheo6pqlhc5yBoPiN3LQPYa9fSzYiwDTz6lQ+m9SK+Yk
        /ll9D9ShoXtmi4j/Ze9tUw==
X-Google-Smtp-Source: ABdhPJx8GxhOFybZeNIJ9I1YlzitTOglwBqkmOhK6xW55NMWkGGr4N0Khl1/mbtSZFPcRndSVUIuLQ==
X-Received: by 2002:a9d:2484:: with SMTP id z4mr3329118ota.183.1635427581781;
        Thu, 28 Oct 2021 06:26:21 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 3sm1038014oif.12.2021.10.28.06.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 06:26:21 -0700 (PDT)
Received: (nullmailer pid 4060901 invoked by uid 1000);
        Thu, 28 Oct 2021 13:26:20 -0000
Date:   Thu, 28 Oct 2021 08:26:20 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        Sowon Na <sowon.na@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v5 00/15] introduce exynosauto v9 ufs driver
Message-ID: <YXqk/DgEYh0y4YEm@robh.at.kernel.org>
References: <CGME20211018124505epcas2p31437a0fae6711edeb9db5b49eb420e56@epcas2p3.samsung.com>
 <20211018124216.153072-1-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018124216.153072-1-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 Oct 2021 21:42:01 +0900, Chanho Park wrote:
> In ExynosAuto(variant of the Exynos for automotive), the UFS Storage needs
> to be accessed from multiple VMs. Traditional virtualization solution
> provides para-virtualized block driver such as virtio-blk. However, they
> can be highly depends on the Dom0 where the backend of the PV is
> located. When the system gets high cpu pressure, the performance of
> guest VMs are also affected. To overcome this, the SoC implements the
> virtualization concept as the H/W controller level.
> 
> Below figure is a conceptual design of the UFS Multi Host architecture.
> 
>     +------+          +------+
>     | OS#1 |          | OS#2 |
>     +------+          +------+
>        |                 |
>  +------------+     +------------+
>  |  Physical  |     |   Virtual  |
>  |    Host    |     |    Host    |
>  +------------+     +------------+
>    |      |              | <-- UTP_CMD_SAP, UTP_TM_SAP
>    |   +-------------------------+
>    |   |    Function Arbiter     |
>    |   +-------------------------+
>  +-------------------------------+
>  |           UTP Layer           |
>  +-------------------------------+
>  +-------------------------------+
>  |           UIC Layer           |
>  +-------------------------------+
> 
> There are two types of host controllers of the UFS host controller
> that we designed. The controller has a Function Arbiter that arranges
> commands of each hosts. It will arrange the doorbells among the PH and
> VHs as Round-Robin. When each host transmits a command to the Arbiter,
> the Arbiter transmits it to the UTP layer. Physical Host(PH) support all
> UFSHCI functions(all SAPs) same as conventional UFSHCI.
> Virtual Hosts(VHs) support only data transfer function(UTP_CMD_SAP and
> UTP_TM_SAP).
> 
> In an environment where multiple VMs are used, the OS that has the
> leadership of the system is called System OS(Dom0). This system OS will
> own the PH and has a responsibility to handle UIC errors.
> 
> VHs can only supports data transfer functions compared with the PH,
> they're necessary to send a request to the PH for error handling of VHs.
> To interface among the PH and VHs, the UFSHCI controller supports mailbox.
> The mailbox register has 8 bit fields and they can be used as
> arguments of the mailbox protocol. In this initial patchset, the PH
> ready message is supported and they will be implemented to the next
> steps.
> 
> To support this virtual host type controller which only supports data
> transfer function (TP_CMD_SAP and UTP_TM_SAP), we need to add below two
> quirks.
> - UFSHCD_QUIRK_BROKEN_UIC_CMD
> - UFSHCD_QUIRK_SKIP_PH_CONFIGURATION
> 
> First two patches, I picked them up from Jonmin's patchset[1] and the third
> patch has been dropped because it's not necessary anymore.
> 
> [1]: https://lore.kernel.org/linux-scsi/20210527030901.88403-1-jjmin.jeong@samsung.com/
> 
> Patch 0003 ~ 0010, they are changes of exynos7 ufs driver to apply
> exynosauto v9 variant and PH/VH capabilities.
> Patch 0011 ~ 0015, the patches introduce the exynosauto v9 ufs MHCI which
> includes the PH and VHs.
> 
> Changes from v4:
> - s/Arbitor/Arbiter/g of cover-letter.
> - Rephrase descriptions of cover letter from original patchset.
> - Except 0007-scsi-ufs-ufs-exynos-correct-timeout-value-setting-re.patch
>   from this patchset and sent it independently
> - Patch11/12: Consolidate sysreg and samsung,ufs-shareability-reg-offset
>   property.
> - Patch14:
>   Drop wlun_dev_clr_ua configuration
>   Add TODO: tag for further implementations
> 
> Changes from v3:
> - Drop "[PATCH v3 06/17] scsi: ufs: ufs-exynos: get sysreg regmap for
>   io-coherency" and squash it to Patch12
> - Patch12: Use macro to avoid raw value usage and describe the value of M-Phy setting
> - Patch13: Add dma-coherent property
> - Patch14: Use macro to avoid raw value and describe the value of HCI_MH_ALLOWABLE_TRAN_OF_VH
> 
> Changes from v2:
> - Separate dt-binding patches on top of
>   https://lore.kernel.org/linux-devicetree/YUNdqnZ2kYefxFUC@robh.at.kernel.org/
> 
> Changes from v1:
> - Change quirk name from UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION to
>   UFSHCD_QUIRK_SKIP_PH_CONFIGURATION
> - Add compatibles to Documentation/devicetree/bindings/ufs/samsung,exynos-ufs.yaml
>   on top of https://lore.kernel.org/linux-scsi/20200613024706.27975-9-alim.akhtar@samsung.com/
> 
> Chanho Park (13):
>   scsi: ufs: ufs-exynos: change pclk available max value
>   scsi: ufs: ufs-exynos: simplify drv_data retrieval
>   scsi: ufs: ufs-exynos: add refclkout_stop control
>   scsi: ufs: ufs-exynos: add setup_clocks callback
>   scsi: ufs: ufs-exynos: support custom version of ufs_hba_variant_ops
>   scsi: ufs: ufs-exynos: add EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR option
>   scsi: ufs: ufs-exynos: factor out priv data init
>   scsi: ufs: ufs-exynos: add pre/post_hce_enable drv callbacks
>   scsi: ufs: ufs-exynos: support exynosauto v9 ufs driver
>   dt-bindings: ufs: exynos-ufs: add io-coherency property
>   scsi: ufs: ufs-exynos: multi-host configuration for exynosauto
>   scsi: ufs: ufs-exynos: introduce exynosauto v9 virtual host
>   dt-bindings: ufs: exynos-ufs: add exynosautov9 compatible
> 
> jongmin jeong (2):
>   scsi: ufs: add quirk to handle broken UIC command
>   scsi: ufs: add quirk to enable host controller without ph
>     configuration
> 
>  .../bindings/ufs/samsung,exynos-ufs.yaml      |  10 +
>  drivers/scsi/ufs/ufs-exynos.c                 | 354 +++++++++++++++++-
>  drivers/scsi/ufs/ufs-exynos.h                 |  27 +-
>  drivers/scsi/ufs/ufshcd.c                     |   6 +
>  drivers/scsi/ufs/ufshcd.h                     |  12 +
>  5 files changed, 386 insertions(+), 23 deletions(-)
> 
> --
> 2.33.0
> 
> 
> 
> 

Applied patches 12 and 15, thanks!
