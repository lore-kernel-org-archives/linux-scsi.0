Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 262E0C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 04:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E04206C3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 04:54:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KGecksqT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfLLEyC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 23:54:02 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35913 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfLLEyC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 23:54:02 -0500
Received: by mail-pl1-f194.google.com with SMTP id d15so56162pll.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2019 20:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tHc0PSlg2ACU7A0C5ZEBVhN6RrL2muH9eFVp0rXdeDE=;
        b=KGecksqTN7aH5WaT4X+s+x+aP+a7i7w6cLgxIRgN33sxCXMSyEKJciRD7d/6ihcDUC
         3I7wQbAZt3iZaal81RY6v0Mz/zczvfg2SA89GwuuNHw/n5vU16vI+ifvJ4sk57OdNpC4
         V7o/+FbQ5JPLui0wRjqlbtUqJnAPzFtU3kxSFs1S77k8ZxHhaXFGiL/v5WdCohFCtEhm
         I3GcCjNIfmKbF9pTxosH5OQKs0cdqxvRMvgrvLuRD8L0i/5M8im/Y4Zz+x40EJIy5H5n
         mCoRBfNjnZtvP/6mWS6NBxuykK0aGwULL22KIeyDDXsixKKhun7vD+mqKM5cBwMxdK1q
         knIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tHc0PSlg2ACU7A0C5ZEBVhN6RrL2muH9eFVp0rXdeDE=;
        b=J4XVlNFbwWouWob2UzIxvXx0VBkk/jQfKk+RbIyL/8swYWVYkSA9ec1YEC9wMqA9pl
         xhcAL57ABgEbfDzZQKxjElag7yqJrkCdV/Bg8B/nR0TrEbYpRhDlbYYyN9yWrOwHLcNv
         ReGlr+iV4yAn0z4UmyFwbSKlvXTGcg/xMtK2iPJGFjZxcr0lAYF/wKMMhfnPklbjYFE1
         exGHpSCCpRHHe38b5oDVmxtYGRH9s3QGuWzFYqYySa5KULfQxeAK2oxBDF6PM1WO7gPH
         JZkeeP6r6l61N/0m1hawZT/9d80eLG7AFZQIN2CbFeqQMb8wGcxd/1DwBg6yICwFD7GH
         JtpA==
X-Gm-Message-State: APjAAAX+bR7zChK9xluP5OriMzaCxpbSrfllX7sTOtnrWMB7fwGzyBEs
        k8PhKyhq8j4/ISIkUS2RQvnPcg==
X-Google-Smtp-Source: APXvYqzrRHnZ5q4I4LzpDUl67+uqmLMUk4wBwLzuaNFK6ZHjHGq/Wky7eTDvRsCnfnIfsl0moHl/Qw==
X-Received: by 2002:a17:90a:a48c:: with SMTP id z12mr7859371pjp.38.1576126441010;
        Wed, 11 Dec 2019 20:54:01 -0800 (PST)
Received: from yoga (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id 81sm4853330pfx.73.2019.12.11.20.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 20:54:00 -0800 (PST)
Date:   Wed, 11 Dec 2019 20:53:57 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Modulize ufs-bsg
Message-ID: <20191212045357.GA415177@yoga>
References: <1576054123-16417-1-git-send-email-cang@codeaurora.org>
 <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0101016ef425ef65-5c4508cc-5e76-4107-bb27-270f66acaa9a-000000@us-west-2.amazonses.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 11 Dec 00:49 PST 2019, Can Guo wrote:

> In order to improve the flexibility of ufs-bsg, modulizing it is a good
> choice. This change introduces tristate to ufs-bsg to allow users compile
> it as an external module.

Can you please elaborate on what this "flexibility" is and why it's a
good thing?

> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/Kconfig   |  3 ++-
>  drivers/scsi/ufs/Makefile  |  2 +-
>  drivers/scsi/ufs/ufs_bsg.c | 49 +++++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/ufs/ufs_bsg.h |  8 --------
>  drivers/scsi/ufs/ufshcd.c  | 36 ++++++++++++++++++++++++++++++----
>  drivers/scsi/ufs/ufshcd.h  |  7 ++++++-
>  6 files changed, 87 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index d14c224..72620ce 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -38,6 +38,7 @@ config SCSI_UFSHCD
>  	select PM_DEVFREQ
>  	select DEVFREQ_GOV_SIMPLE_ONDEMAND
>  	select NLS
> +	select BLK_DEV_BSGLIB

Why is this needed?

>  	---help---
>  	This selects the support for UFS devices in Linux, say Y and make
>  	  sure that you know the name of your UFS host adapter (the card
> @@ -143,7 +144,7 @@ config SCSI_UFS_TI_J721E
>  	  If unsure, say N.
>  
>  config SCSI_UFS_BSG
> -	bool "Universal Flash Storage BSG device node"
> +	tristate "Universal Flash Storage BSG device node"
>  	depends on SCSI_UFSHCD
>  	select BLK_DEV_BSGLIB
>  	help
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 94c6c5d..904eff1 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -6,7 +6,7 @@ obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>  ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
> -ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
> +obj-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
>  obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
>  obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>  obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
> diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
> index 3a2e68f..302222f 100644
> --- a/drivers/scsi/ufs/ufs_bsg.c
> +++ b/drivers/scsi/ufs/ufs_bsg.c
> @@ -164,13 +164,15 @@ static int ufs_bsg_request(struct bsg_job *job)
>   */
>  void ufs_bsg_remove(struct ufs_hba *hba)
>  {
> -	struct device *bsg_dev = &hba->bsg_dev;
> +	struct device *bsg_dev = hba->bsg_dev;
>  
>  	if (!hba->bsg_queue)
>  		return;
>  
>  	bsg_remove_queue(hba->bsg_queue);
>  
> +	hba->bsg_dev = NULL;
> +	hba->bsg_queue = NULL;
>  	device_del(bsg_dev);
>  	put_device(bsg_dev);
>  }
> @@ -178,6 +180,7 @@ void ufs_bsg_remove(struct ufs_hba *hba)
>  static inline void ufs_bsg_node_release(struct device *dev)
>  {
>  	put_device(dev->parent);
> +	kfree(dev);
>  }
>  
>  /**
> @@ -186,14 +189,19 @@ static inline void ufs_bsg_node_release(struct device *dev)
>   *
>   * Called during initial loading of the driver, and before scsi_scan_host.
>   */
> -int ufs_bsg_probe(struct ufs_hba *hba)
> +static int ufs_bsg_probe(struct ufs_hba *hba)
>  {
> -	struct device *bsg_dev = &hba->bsg_dev;
> +	struct device *bsg_dev;
>  	struct Scsi_Host *shost = hba->host;
>  	struct device *parent = &shost->shost_gendev;
>  	struct request_queue *q;
>  	int ret;
>  
> +	bsg_dev = kzalloc(sizeof(*bsg_dev), GFP_KERNEL);
> +	if (!bsg_dev)
> +		return -ENOMEM;
> +
> +	hba->bsg_dev = bsg_dev;
>  	device_initialize(bsg_dev);
>  
>  	bsg_dev->parent = get_device(parent);
> @@ -217,6 +225,41 @@ int ufs_bsg_probe(struct ufs_hba *hba)
>  
>  out:
>  	dev_err(bsg_dev, "fail to initialize a bsg dev %d\n", shost->host_no);
> +	hba->bsg_dev = NULL;
>  	put_device(bsg_dev);
>  	return ret;
>  }
> +
> +static int __init ufs_bsg_init(void)
> +{
> +	struct list_head *hba_list = NULL;
> +	struct ufs_hba *hba;
> +	int ret = 0;
> +
> +	ufshcd_get_hba_list_lock(&hba_list);
> +	list_for_each_entry(hba, hba_list, list) {
> +		ret = ufs_bsg_probe(hba);
> +		if (ret)
> +			break;
> +	}

So what happens if I go CONFIG_SCSI_UFS_BSG=y and
CONFIG_SCSI_UFS_QCOM=y?

Wouldn't that mean that ufs_bsg_init() is called before ufshcd_init()
has added the controller to the list? And even in the even that they are
both =m, what happens if they are invoked in the "wrong" order?

> +	ufshcd_put_hba_list_unlock();
> +
> +	return ret;
> +}
> +
> +static void __exit ufs_bsg_exit(void)
> +{
> +	struct list_head *hba_list = NULL;
> +	struct ufs_hba *hba;
> +
> +	ufshcd_get_hba_list_lock(&hba_list);
> +	list_for_each_entry(hba, hba_list, list)
> +		ufs_bsg_remove(hba);
> +	ufshcd_put_hba_list_unlock();
> +}
> +
> +late_initcall_sync(ufs_bsg_init);
> +module_exit(ufs_bsg_exit);
> +
> +MODULE_ALIAS("ufs-bsg");

The purpose of MODULE_ALIAS() is to facilitate module autoloading, but
as you probe the bsg device from the initcall of the bsg driver itself I
don't see how that would happen, and as such I don't think this alias
has a purpose.

> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/scsi/ufs/ufs_bsg.h b/drivers/scsi/ufs/ufs_bsg.h
> index d099187..9d922c0 100644
> --- a/drivers/scsi/ufs/ufs_bsg.h
> +++ b/drivers/scsi/ufs/ufs_bsg.h
> @@ -12,12 +12,4 @@
>  #include "ufshcd.h"
>  #include "ufs.h"
>  
> -#ifdef CONFIG_SCSI_UFS_BSG
> -void ufs_bsg_remove(struct ufs_hba *hba);
> -int ufs_bsg_probe(struct ufs_hba *hba);
> -#else
> -static inline void ufs_bsg_remove(struct ufs_hba *hba) {}
> -static inline int ufs_bsg_probe(struct ufs_hba *hba) {return 0; }
> -#endif
> -
>  #endif /* UFS_BSG_H */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a86b0fd..7a83a8f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -108,6 +108,22 @@
>  		       16, 4, buf, __len, false);                        \
>  } while (0)
>  
> +static LIST_HEAD(ufs_hba_list);
> +static DEFINE_MUTEX(ufs_hba_list_lock);
> +
> +void ufshcd_get_hba_list_lock(struct list_head **list)
> +{
> +	mutex_lock(&ufs_hba_list_lock);
> +	*list = &ufs_hba_list;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_get_hba_list_lock);
> +
> +void ufshcd_put_hba_list_unlock(void)
> +{
> +	mutex_unlock(&ufs_hba_list_lock);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_put_hba_list_unlock);
> +
>  int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
>  		     const char *prefix)
>  {
> @@ -2093,6 +2109,7 @@ int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
>  	ufshcd_release(hba);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_send_uic_cmd);
>  
>  /**
>   * ufshcd_map_sg - Map scatter-gather list to prdt
> @@ -6024,6 +6041,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>  
>  	return err;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_exec_raw_upiu_cmd);
>  
>  /**
>   * ufshcd_eh_device_reset_handler - device reset handler registered to
> @@ -7043,9 +7061,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>  			}
>  			hba->clk_scaling.is_allowed = true;
>  		}
> -
> -		ufs_bsg_probe(hba);
> -
>  		scsi_scan_host(hba->host);
>  		pm_runtime_put_sync(hba->dev);
>  	}
> @@ -8248,7 +8263,16 @@ int ufshcd_shutdown(struct ufs_hba *hba)
>   */
>  void ufshcd_remove(struct ufs_hba *hba)
>  {
> -	ufs_bsg_remove(hba);
> +	struct device *bsg_dev = hba->bsg_dev;
> +
> +	mutex_lock(&ufs_hba_list_lock);
> +	list_del(&hba->list);
> +	if (hba->bsg_queue) {
> +		bsg_remove_queue(hba->bsg_queue);
> +		device_del(bsg_dev);

Am I reading this correct in that you probe the bsg_dev form initcall
and you delete it as the ufshcd instance is removed? That's not okay.

Regards,
Bjorn

> +		put_device(bsg_dev);
> +	}
> +	mutex_unlock(&ufs_hba_list_lock);
>  	ufs_sysfs_remove_nodes(hba->dev);
>  	scsi_remove_host(hba->host);
>  	scsi_host_put(hba->host);
> @@ -8494,6 +8518,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	async_schedule(ufshcd_async_scan, hba);
>  	ufs_sysfs_add_nodes(hba->dev);
>  
> +	mutex_lock(&ufs_hba_list_lock);
> +	list_add_tail(&hba->list, &ufs_hba_list);
> +	mutex_unlock(&ufs_hba_list_lock);
> +
>  	return 0;
>  
>  out_remove_scsi_host:
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 2740f69..893debc 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -74,6 +74,9 @@
>  
>  struct ufs_hba;
>  
> +void ufshcd_get_hba_list_lock(struct list_head **list);
> +void ufshcd_put_hba_list_unlock(void);
> +
>  enum dev_cmd_type {
>  	DEV_CMD_TYPE_NOP		= 0x0,
>  	DEV_CMD_TYPE_QUERY		= 0x1,
> @@ -473,6 +476,7 @@ struct ufs_stats {
>  
>  /**
>   * struct ufs_hba - per adapter private structure
> + * @list: Anchored at ufs_hba_list
>   * @mmio_base: UFSHCI base register address
>   * @ucdl_base_addr: UFS Command Descriptor base address
>   * @utrdl_base_addr: UTP Transfer Request Descriptor base address
> @@ -527,6 +531,7 @@ struct ufs_stats {
>   * @scsi_block_reqs_cnt: reference counting for scsi block requests
>   */
>  struct ufs_hba {
> +	struct list_head list;
>  	void __iomem *mmio_base;
>  
>  	/* Virtual memory reference */
> @@ -734,7 +739,7 @@ struct ufs_hba {
>  	struct ufs_desc_size desc_size;
>  	atomic_t scsi_block_reqs_cnt;
>  
> -	struct device		bsg_dev;
> +	struct device		*bsg_dev;
>  	struct request_queue	*bsg_queue;
>  };
>  
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 
