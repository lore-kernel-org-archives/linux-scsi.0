Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046C3C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Apr 2022 11:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiDBLyx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Apr 2022 07:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiDBLyw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2022 07:54:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C62915FCC
        for <linux-scsi@vger.kernel.org>; Sat,  2 Apr 2022 04:52:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d10so1001876edj.0
        for <linux-scsi@vger.kernel.org>; Sat, 02 Apr 2022 04:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:message-id:subject:to:cc:in-reply-to:references:mime-version
         :date:user-agent:content-transfer-encoding;
        bh=nE3hf1YCDJ6kEtg0m/qHzL1wDrtyteiqpEI9iRcSgrQ=;
        b=EFKNEmieblBRPj+Op+c+LkZw2/xxWuzzLI5k+fhm0SVfTwCjBv9tOouXDXpJAZMB9H
         LHx/+6LF8MU/K8uNcBsOvTz+hwhIYIJCGC4eNSUGt2vEs2UdZgFsGKIe5HYfjN2z6jV7
         W4JA0VjV92pS6uwN6tqHnvdD65PORhW9xeK56dgDRPDjhJjrZPFPSIiv3439Tq9JLipT
         +qVdQ/6HBU8447Rfi2ayEbSCxIsya3qGgyJKPu3fnizxJZrxzXDuCWA78Pd2pI2vbmoH
         jJl1ZZ0ObulcYp+56SWEg38sz14V2vCrYl55YUSxpYHovpLwlyIX9JjDahSLG+p5ZfF7
         uM4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:subject:to:cc:in-reply-to
         :references:mime-version:date:user-agent:content-transfer-encoding;
        bh=nE3hf1YCDJ6kEtg0m/qHzL1wDrtyteiqpEI9iRcSgrQ=;
        b=wHa/dqOT1NBls7dEZ0f5WILB+NhgiIPKXdLkacNxOh+/MDoWTWtGFQhjrRe4IKuACd
         MyglnUKMxWl0cIL/loVf+wPiM0g1wOaNwL7x8OtzWiMwiJyXdhPhDkOImCmsPe8Bsnhn
         EhSjrJgUzRgBYYAlTHtf+NvkuFz7hHDAXzQS/vgTyieZcILCRAh81/wP6K6znd9hKI5l
         FMJFU0iMtac6Lig2ev8IZL18Gsv9XzqIV/yNuc7DvhlQjXq/sg6jZM2iheLLsYwQogzY
         l0c4YbtBNCmt6sFANx1DK9FaElKHdpGzSmsuu0tZBq45lgFfPSBezlto/lMg7hWCH6hD
         71xg==
X-Gm-Message-State: AOAM533T7MqWsQUN7x7diqUAcAzw4ZOu03JQpMaMsosQf0vS7mgsYN7J
        C9WNh1+KkBzONV2aWiVoJto=
X-Google-Smtp-Source: ABdhPJzHBFhKK6kSqa+1WF1TvSgkt1FAJMbWclH5DOAxY0B7aRPBwVKAm9kXG0iJYSJaSIKBFyrlVw==
X-Received: by 2002:a05:6402:1385:b0:413:2bc6:4400 with SMTP id b5-20020a056402138500b004132bc64400mr25538852edv.94.1648900376068;
        Sat, 02 Apr 2022 04:52:56 -0700 (PDT)
Received: from p200300c58701842d31e8d5ae8453ebf8.dip0.t-ipconnect.de (p200300c58701842d31e8d5ae8453ebf8.dip0.t-ipconnect.de. [2003:c5:8701:842d:31e8:d5ae:8453:ebf8])
        by smtp.googlemail.com with ESMTPSA id rh26-20020a17090720fa00b006e0da7ef847sm2033194ejb.13.2022.04.02.04.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 04:52:55 -0700 (PDT)
From:   Bean Huo <christopher.lee.eu@gmail.com>
X-Google-Original-From: Bean Huo <huobean@gmail.com>
Message-ID: <abd8eb1700c3cf914af76bf767eff0877e2e82cf.camel@gmail.com>
Subject: Re: [PATCH 00/29] UFS patches for kernel v5.19
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Fri, 01 Apr 2022 11:28:30 +0200
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart,

Agree that the current UFS driver is messy, but I don't think there was
such a big structural change before UFS 4.0 was released, especially
the design of the UFS CQE driver. If you already have a plan for CQE,
it's best to state it in the patch. If you have made such a big change
in an environment that is now very stable, do we have to make changes
after UFS 4.0? ?


Kind regards,
Bean


On Thu, 2022-03-31 at 15:33 -0700, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series includes the following changes:
> - Separation of UFS core and UFS driver source code into separate
> directories.
> - Split the ufshcd.h header file into two header files - one file
> that
>   defines the interface with UFS drivers and another file with
> definitions
>   only used in the core.
> - Multiple source code cleanup patches.
> - A few patches with minor functional changes.
> 
> Please consider these changes for kernel v5.19.
> 
> Thank you,
> 
> Bart.
> 
> Bart Van Assche (29):
>   scsi: ufs: Declare ufshcd_wait_for_register() static
>   scsi: ufs: Remove superfluous boolean conversions
>   scsi: ufs: Simplify statements that return a boolean
>   scsi: ufs: Remove ufshcd_lrb.sense_bufflen
>   scsi: ufs: Remove ufshcd_lrb.sense_buffer
>   scsi: ufs: Use get_unaligned_be16() instead of be16_to_cpup()
>   scsi: ufs: Remove the UFS_FIX() and END_FIX() macros
>   scsi: ufs: Rename struct ufs_dev_fix into ufs_dev_quirk
>   scsi: ufs: Declare the quirks array const
>   scsi: ufs: Invert the return value of ufshcd_is_hba_active()
>   scsi: ufs: Remove unused constants and code
>   scsi: ufs: Switch to aggregate initialization
>   scsi: ufs: Remove the LUN quiescing code from ufshcd_wl_shutdown()
>   scsi: ufs: Make the config_scaling_param calls type safe
>   scsi: ufs: Remove the driver version
>   scsi: ufs: Rename sdev_ufs_device into ufs_device_wlun
>   scsi: ufs: Use an SPDX license identifier in the Kconfig file
>   scsi: ufs: Remove paths from source code comments
>   scsi: ufs: Remove the TRUE and FALSE definitions
>   scsi: ufs: Remove locking from around single register writes
>   scsi: ufs: Introduce ufshcd_clkgate_delay_set()
>   scsi: ufs: qcom: Fix ufs_qcom_resume()
>   scsi: ufs: Remove unnecessary ufshcd-crypto.h include directives
>   scsi: ufs: Fix kernel-doc syntax in ufshcd.h
>   scsi: ufs: Minimize #include directives
>   scsi: ufs: Split the ufshcd.h header file
>   scsi: ufs: Move the struct ufs_ref_clk definition
>   scsi: ufs: Move the ufs_is_valid_unit_desc_lun() definition
>   scsi: ufs: Split the drivers/scsi/ufs directory
> 
>  drivers/scsi/Kconfig                          |   3 +-
>  drivers/scsi/Makefile                         |   4 +-
>  drivers/scsi/ufs-core/Kconfig                 |  82 ++++
>  drivers/scsi/ufs-core/Makefile                |  10 +
>  drivers/scsi/{ufs => ufs-core}/ufs-debugfs.c  |   4 +-
>  drivers/scsi/{ufs => ufs-core}/ufs-debugfs.h  |   0
>  .../{ufs => ufs-core}/ufs-fault-injection.c   |   4 +-
>  .../{ufs => ufs-core}/ufs-fault-injection.h   |   0
>  drivers/scsi/{ufs => ufs-core}/ufs-hwmon.c    |   4 +-
>  drivers/scsi/{ufs => ufs-core}/ufs-sysfs.c    |   8 +-
>  drivers/scsi/{ufs => ufs-core}/ufs-sysfs.h    |   3 +-
>  drivers/scsi/{ufs => ufs-core}/ufs_bsg.c      |   6 +
>  drivers/scsi/{ufs => ufs-core}/ufs_bsg.h      |   7 +-
>  .../scsi/{ufs => ufs-core}/ufshcd-crypto.c    |   2 +-
>  .../scsi/{ufs => ufs-core}/ufshcd-crypto.h    |   7 +-
>  drivers/scsi/ufs-core/ufshcd-priv.h           | 296 ++++++++++++++
>  drivers/scsi/{ufs => ufs-core}/ufshcd.c       | 254 ++++++------
>  drivers/scsi/{ufs => ufs-core}/ufshpb.c       |  10 +-
>  drivers/scsi/{ufs => ufs-core}/ufshpb.h       |   0
>  drivers/scsi/ufs-drivers/Kconfig              | 118 ++++++
>  drivers/scsi/{ufs => ufs-drivers}/Makefile    |  12 -
>  .../scsi/{ufs => ufs-drivers}/cdns-pltfrm.c   |   5 +-
>  .../{ufs => ufs-drivers}/tc-dwc-g210-pci.c    |   8 +-
>  .../{ufs => ufs-drivers}/tc-dwc-g210-pltfrm.c |  10 +-
>  .../scsi/{ufs => ufs-drivers}/tc-dwc-g210.c   |   8 +-
>  .../scsi/{ufs => ufs-drivers}/tc-dwc-g210.h   |   2 +
>  .../scsi/{ufs => ufs-drivers}/ti-j721e-ufs.c  |   0
>  .../scsi/{ufs => ufs-drivers}/ufs-exynos.c    |  17 +-
>  .../scsi/{ufs => ufs-drivers}/ufs-exynos.h    |   8 +-
>  drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.c  |  17 +-
>  drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.h  |   0
>  .../{ufs => ufs-drivers}/ufs-mediatek-trace.h |   2 +-
>  .../scsi/{ufs => ufs-drivers}/ufs-mediatek.c  |  40 +-
>  .../scsi/{ufs => ufs-drivers}/ufs-mediatek.h  |   0
>  .../scsi/{ufs => ufs-drivers}/ufs-qcom-ice.c  |   3 +-
>  drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.c  |  49 +--
>  drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.h  |   6 +-
>  .../scsi/{ufs => ufs-drivers}/ufshcd-dwc.c    |   6 +-
>  .../scsi/{ufs => ufs-drivers}/ufshcd-dwc.h    |   2 +
>  .../scsi/{ufs => ufs-drivers}/ufshcd-pci.c    |  14 +-
>  .../scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.c |  35 +-
>  .../scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.h |   2 +-
>  .../scsi/{ufs => ufs-drivers}/ufshci-dwc.h    |   0
>  drivers/scsi/ufs/Kconfig                      | 211 ----------
>  {drivers/scsi/ufs => include/scsi}/ufs.h      |  35 --
>  .../scsi/ufs => include/scsi}/ufs_quirks.h    |  15 +-
>  {drivers/scsi/ufs => include/scsi}/ufshcd.h   | 366 ++++----------
> ----
>  {drivers/scsi/ufs => include/scsi}/ufshci.h   |   2 +
>  {drivers/scsi/ufs => include/scsi}/unipro.h   |  16 -
>  49 files changed, 856 insertions(+), 857 deletions(-)
>  create mode 100644 drivers/scsi/ufs-core/Kconfig
>  create mode 100644 drivers/scsi/ufs-core/Makefile
>  rename drivers/scsi/{ufs => ufs-core}/ufs-debugfs.c (99%)
>  rename drivers/scsi/{ufs => ufs-core}/ufs-debugfs.h (100%)
>  rename drivers/scsi/{ufs => ufs-core}/ufs-fault-injection.c (100%)
>  rename drivers/scsi/{ufs => ufs-core}/ufs-fault-injection.h (100%)
>  rename drivers/scsi/{ufs => ufs-core}/ufs-hwmon.c (98%)
>  rename drivers/scsi/{ufs => ufs-core}/ufs-sysfs.c (99%)
>  rename drivers/scsi/{ufs => ufs-core}/ufs-sysfs.h (95%)
>  rename drivers/scsi/{ufs => ufs-core}/ufs_bsg.c (97%)
>  rename drivers/scsi/{ufs => ufs-core}/ufs_bsg.h (77%)
>  rename drivers/scsi/{ufs => ufs-core}/ufshcd-crypto.c (99%)
>  rename drivers/scsi/{ufs => ufs-core}/ufshcd-crypto.h (94%)
>  create mode 100644 drivers/scsi/ufs-core/ufshcd-priv.h
>  rename drivers/scsi/{ufs => ufs-core}/ufshcd.c (98%)
>  rename drivers/scsi/{ufs => ufs-core}/ufshpb.c (99%)
>  rename drivers/scsi/{ufs => ufs-core}/ufshpb.h (100%)
>  create mode 100644 drivers/scsi/ufs-drivers/Kconfig
>  rename drivers/scsi/{ufs => ufs-drivers}/Makefile (56%)
>  rename drivers/scsi/{ufs => ufs-drivers}/cdns-pltfrm.c (99%)
>  rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210-pci.c (98%)
>  rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210-pltfrm.c (98%)
>  rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210.c (99%)
>  rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210.h (95%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ti-j721e-ufs.c (100%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-exynos.c (99%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-exynos.h (97%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.c (99%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.h (100%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek-trace.h (92%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek.c (97%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek.h (100%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom-ice.c (99%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.c (98%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.h (98%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-dwc.c (98%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-dwc.h (95%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pci.c (99%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.c (94%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.h (98%)
>  rename drivers/scsi/{ufs => ufs-drivers}/ufshci-dwc.h (100%)
>  delete mode 100644 drivers/scsi/ufs/Kconfig
>  rename {drivers/scsi/ufs => include/scsi}/ufs.h (93%)
>  rename {drivers/scsi/ufs => include/scsi}/ufs_quirks.h (94%)
>  rename {drivers/scsi/ufs => include/scsi}/ufshcd.h (82%)
>  rename {drivers/scsi/ufs => include/scsi}/ufshci.h (99%)
>  rename {drivers/scsi/ufs => include/scsi}/unipro.h (98%)
> 

