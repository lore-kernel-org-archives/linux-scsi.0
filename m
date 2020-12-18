Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4A8C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 15:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59C5523AFD
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 15:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgLRPSA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 10:18:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgLRPSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 10:18:00 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC872C0617A7;
        Fri, 18 Dec 2020 07:17:19 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ga15so3726606ejb.4;
        Fri, 18 Dec 2020 07:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=apAt9xundZHmJSgwp15nprTl70x9ZuCZUabeXQJw3as=;
        b=P73NPEKhXNv0vOZl1hhFHBQJDTK7gQ+EM59/UaHsASO5HIpJlRbvCR9z0CMM2NcyMv
         xbLMBH/qa/bGk7PDECJLoh9j7RnwOW9jhrMwU3Ie/XKKfvJoDMXy4QApyLSK44ekfUM0
         mCVKwjhRXUtOgA22UDMGWZGqi9WkaY6o5YXE+XuEvOTw2qFJP6TMCTYD5LvCOuc5Zh3J
         GHSaKBeeP0ntyLrWeR8C42jRv9bX4nfl0UQKVU3A+mzPypVqH97kSgWgq+ldLZmLc98Z
         MJCWqVXB85nxLYrK1WC3wDs1FqETGr9sJxzmLaW0UDbRIoo5dT8nL+ITU/B1YgV/+lgU
         Unaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=apAt9xundZHmJSgwp15nprTl70x9ZuCZUabeXQJw3as=;
        b=R53TnggoY6QafxF3Qes81mx/bmqYi0o0RcN2tm/sKfVyuDPulKQ8cWhbFvSyVFMLRM
         639PwMbgaUcbqn10smMvK6g08mIaz7MppkoNA7Xwf6+0r1W0HreSe+lI1l2vo9Tgj7fS
         xZb8RhIKQK3NxUC3LsS7JUFjHfKcFkay0SmKVH6j9fiVu3ZOjJXGiGi0UtV5Sreh5Gec
         EPLdUveMJkkHnnywpiD0jWMgdDWXdK6SZpmD/2idgYPEa2eXdhIbCx47ZHi1Bwb37huD
         4qR/Sl5vgl3zLxc0HRRuS7Z9O3mgQA3l/Nr1pYXt36KEUtzCWZ6Dt/jkYxk7lLwkKU5A
         ZK2w==
X-Gm-Message-State: AOAM5323gTStqK91aCDpCw9VQmgKZjoIXfFkTvCLuvZxQu3tdaVAFjO4
        Do4zKEGz8jo57Z5q8zuCd0k=
X-Google-Smtp-Source: ABdhPJymTc8tS/QqUhr6K6tcueWZu0FjIhYxstZZh6g2Xb6pVYQBNVjnAzc60mOKKsT3DywTSbylpg==
X-Received: by 2002:a17:906:3683:: with SMTP id a3mr4390776ejc.538.1608304637880;
        Fri, 18 Dec 2020 07:17:17 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id ef11sm5557130ejb.15.2020.12.18.07.17.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Dec 2020 07:17:17 -0800 (PST)
Message-ID: <de305f4d6034950908e8e889c4af5442431e7d15.camel@gmail.com>
Subject: Re: [PATCH V3] scsi: ufs-debugfs: Add error counters
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Fri, 18 Dec 2020 16:17:16 +0100
In-Reply-To: <20201218122027.27472-1-adrian.hunter@intel.com>
References: <20201218122027.27472-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-12-18 at 14:20 +0200, Adrian Hunter wrote:
> People testing have a need to know how many errors might be occurring
> over time. Add error counters and expose them via debugfs.
> 
> A module initcall is used to create a debugfs root directory for
> ufshcd-related items. In the case that modules are built-in, then
> initialization is done in link order, so move ufshcd-core to the top
> of
> the Makefile.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> ---
> 
> 
> Changes in V3:
> 	Fixed link order to ensure correct initcall ordering when
> 	modules are built-in.
> 	Amended commit message accordingly.
> 
> Changes in V2:
> 	Add missing '#include "ufs-debugfs.h"' in ufs-debugfs.c
> 	Reported-by: kernel test robot <lkp@intel.com>
> 
> 
>  drivers/scsi/ufs/Makefile      | 13 +++++---
>  drivers/scsi/ufs/ufs-debugfs.c | 56
> ++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-debugfs.h | 22 +++++++++++++
>  drivers/scsi/ufs/ufshcd.c      | 19 ++++++++++++
>  drivers/scsi/ufs/ufshcd.h      |  5 +++
>  5 files changed, 111 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufs-debugfs.c
>  create mode 100644 drivers/scsi/ufs/ufs-debugfs.h
> 
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 4679af1b564e..06f3a3fe4a44 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -1,5 +1,14 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # UFSHCD makefile
> +
> +# The link order is important here. ufshcd-core must initialize
> +# before vendor drivers.
> +obj-$(CONFIG_SCSI_UFSHCD)		+= ufshcd-core.o
> +ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
> +ufshcd-core-$(CONFIG_DEBUG_FS)		+= ufs-debugfs.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
> +ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO)	+= ufshcd-crypto.o
> +
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o
> tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o
> ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
> @@ -7,10 +16,6 @@ obj-$(CONFIG_SCSI_UFS_QCOM) += ufs_qcom.o
>  ufs_qcom-y += ufs-qcom.o
>  ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) += ufs-qcom-ice.o
>  obj-$(CONFIG_SCSI_UFS_EXYNOS) += ufs-exynos.o
> -obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
> -ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
> -ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
> -ufshcd-core-$(CONFIG_SCSI_UFS_CRYPTO) += ufshcd-crypto.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>  obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
> diff --git a/drivers/scsi/ufs/ufs-debugfs.c b/drivers/scsi/ufs/ufs-
> debugfs.c
> new file mode 100644
> index 000000000000..dee98dc72d29
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-debugfs.c
> @@ -0,0 +1,56 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2020 Intel Corporation
> +
> +#include <linux/debugfs.h>
> +
> +#include "ufs-debugfs.h"
> +#include "ufshcd.h"
> +
> +static struct dentry *ufs_debugfs_root;
> +
> +void __init ufs_debugfs_init(void)
> +{
> +	ufs_debugfs_root = debugfs_create_dir("ufshcd", NULL);
> +}
> +
> +void __exit ufs_debugfs_exit(void)
> +{
> +	debugfs_remove_recursive(ufs_debugfs_root);
> +}
> +
> +static int ufs_debugfs_stats_show(struct seq_file *s, void *data)
> +{
> +	struct ufs_hba *hba = s->private;
> +	struct ufs_event_hist *e = hba->ufs_stats.event;
> +
> +#define PRT(fmt, typ) \
> +	seq_printf(s, fmt, e[UFS_EVT_ ## typ].cnt)
> +
> +	PRT("PHY Adapter Layer errors (except LINERESET): %llu\n",
> PA_ERR);
> +	PRT("Data Link Layer errors: %llu\n", DL_ERR);
> +	PRT("Network Layer errors: %llu\n", NL_ERR);
> +	PRT("Transport Layer errors: %llu\n", TL_ERR);
> +	PRT("Generic DME errors: %llu\n", DME_ERR);
> +	PRT("Auto-hibernate errors: %llu\n", AUTO_HIBERN8_ERR);
> +	PRT("IS Fatal errors (CEFES, SBFES, HCFES, DFES): %llu\n",
> FATAL_ERR);
> +	PRT("DME Link Startup errors: %llu\n", LINK_STARTUP_FAIL);
> +	PRT("PM Resume errors: %llu\n", RESUME_ERR);
> +	PRT("PM Suspend errors : %llu\n", SUSPEND_ERR);
> +	PRT("Logical Unit Resets: %llu\n", DEV_RESET);
> +	PRT("Host Resets: %llu\n", HOST_RESET);
> +	PRT("SCSI command aborts: %llu\n", ABORT);
> +#undef PRT
> +	return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(ufs_debugfs_stats);
> +
> +void ufs_debugfs_hba_init(struct ufs_hba *hba)
> +{

I prefer adding:
	if (!ufs_debugfs_root)
		return;

> +	hba->debugfs_root = debugfs_create_dir(dev_name(hba->dev),
> ufs_debugfs_root);

> +	debugfs_create_file("stats", 0400, hba->debugfs_root, hba,
> &ufs_debugfs_stats_fops);

	if (!debugfs_create_file("stats", 0400, hba->debugfs_root, hba,
		&ufs_debugfs_stats_fops)) {
		debugfs_remove(hba->debugfs_root);
		return -ENOMEM;
	}


Thanks,
Bean

