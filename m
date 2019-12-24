Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB41C2D0CF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 05:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11AFC20706
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 05:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xk8/entG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbfLXFno (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 00:43:44 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43230 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfLXFno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 00:43:44 -0500
Received: by mail-ot1-f65.google.com with SMTP id p8so24978477oth.10
        for <linux-scsi@vger.kernel.org>; Mon, 23 Dec 2019 21:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=X9kKOIlHeT2ihB72YT665o/9Gpkm00ecVAFub60YPaE=;
        b=Xk8/entGiJZtCworz6U2oa897hWUtXXvOGZgok8ZsIIuBBpTl08N+HE+sODHDrQElg
         PjSo75r2QBW0+jtf8SF1munEOogD/2P9rYiOwsik4fCD/KNfGtYbYNZK1S42zRauMyLc
         6jHLwY0DJOH8GohjS2ORH8uDxEBKeg+moElMDk3+C5ytlHXJ8WVkZBqU2EQB6Z4ZhvNa
         xa5T4m6klIQYIhRAYRm/u0ZdwCy/mGazyJ+qjcacVg+NXQERDHtO/wwrzTadnFKH78tx
         02uy865wckrPz2XIF46jhRnjRjls67lGlAy8l2nR/sSVNA0+u/2xC7f7MktuSVfzELEl
         IfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=X9kKOIlHeT2ihB72YT665o/9Gpkm00ecVAFub60YPaE=;
        b=eOHlGSMsXXmtsb9Bhxr5/yD6cm+I9c81Gv+a61EUx0MTyfTdvku+IvFdsFjfLN/Jnb
         yM/2SA77KRDZ0JqC+ePYceGv/50pcfyw34gXsjq8CkEi9ZZd9otBd7EP7Heo5GlgnUVU
         7Zb+s+toIIdOZHBTcSdCGf96dPsQuNtAtILoku0ldTWD4QaPZG2AOhFCG/EBvAIimaWl
         3SS3I8Qgwj41yVEN3jj7jMo1FTT1G6Tez/yGo8NkBU7Q8rmmedDfP7lS7KH8l6XeOUC6
         PrOFjTnnZR07weIMb777M/Xqeid48/fB2a9gK4E03LAgjYR0s5WbNExjUAKxwSksr7u/
         Y7eA==
X-Gm-Message-State: APjAAAUjWHisRbvFc37zQcvES5YlJVudn7SsyF2Up5WRrAu79LU2db6f
        YgwGlmWf1qsqgRVF5G9iSdKLrlIK
X-Google-Smtp-Source: APXvYqz4d38L1Q8eFctmn0TSttTVcF5ekPhNt2SXmCjsnoX7KpE35HLNGR1w0++G4zq+5C22aTrEgA==
X-Received: by 2002:a9d:1d02:: with SMTP id m2mr34329276otm.45.1577166223191;
        Mon, 23 Dec 2019 21:43:43 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id q18sm7416914otk.38.2019.12.23.21.43.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Dec 2019 21:43:42 -0800 (PST)
Date:   Mon, 23 Dec 2019 22:43:40 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 02/10] mpt3sas: Add support for NVMe shutdown.
Message-ID: <20191224054340.GA55348@ubuntu-m2-xlarge-x86>
References: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
 <20191220103210.43631-3-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220103210.43631-3-suganath-prabu.subramani@broadcom.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 20, 2019 at 05:32:02AM -0500, Suganath Prabu S wrote:
<snip>

Hi Suganath,

We received an email from the 0day bot about this patch (see below)
about this patch. Would you look into addressing it?

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index a038be8..c451e57 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -1049,6 +1049,34 @@ mpt3sas_get_pdev_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
>  	return pcie_device;
>  }
>  
> +/**
> + * _scsih_set_nvme_max_shutdown_latency - Update max_shutdown_latency.
> + * @ioc: per adapter object
> + * Context: This function will acquire ioc->pcie_device_lock
> + *
> + * Update ioc->max_shutdown_latency to that NVMe drives RTD3 Entry Latency
> + * which has reported maximum among all available NVMe drives.
> + * Minimum max_shutdown_latency will be six seconds.
> + */
> +static void
> +_scsih_set_nvme_max_shutdown_latency(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	struct _pcie_device *pcie_device;
> +	unsigned long flags;
> +	u16 shutdown_latency = IO_UNIT_CONTROL_SHUTDOWN_TIMEOUT;
> +
> +	spin_lock_irqsave(&ioc->pcie_device_lock, flags);
> +	list_for_each_entry(pcie_device, &ioc->pcie_device_list, list) {
> +		if (pcie_device->shutdown_latency) {
> +			if (shutdown_latency < pcie_device->shutdown_latency)
> +				shutdown_latency =
> +					pcie_device->shutdown_latency;
> +		}
> +	}
> +	ioc->max_shutdown_latency = shutdown_latency;
> +	spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
> +}
> +
>  /**
>   * _scsih_pcie_device_remove - remove pcie_device from list.
>   * @ioc: per adapter object
> @@ -1063,6 +1091,7 @@ _scsih_pcie_device_remove(struct MPT3SAS_ADAPTER *ioc,
>  {
>  	unsigned long flags;
>  	int was_on_pcie_device_list = 0;
> +	u8 update_latency;

This should be initialized to 0 like the remove_by_handle function
below.

Cheers,
Nathan

On Tue, Dec 24, 2019 at 05:13:52AM +0800, kbuild test robot wrote:
> CC: kbuild-all@lists.01.org
> In-Reply-To: <20191220103210.43631-3-suganath-prabu.subramani@broadcom.com>
> References: <20191220103210.43631-3-suganath-prabu.subramani@broadcom.com>
> TO: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> CC: linux-scsi@vger.kernel.org, martin.petersen@oracle.com
> CC: sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> Hi Suganath,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on scsi/for-next]
> [also build test WARNING on mkp-scsi/for-next v5.5-rc3 next-20191220]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Suganath-Prabu-S/mpt3sas-Enhancements-of-phase14/20191223-182859
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: arm64-defconfig (attached as .config)
> compiler: clang version 10.0.0 (git://gitmirror/llvm_project 891e25b02d760d0de18c7d46947913b3166047e7)
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> >> drivers/scsi/mpt3sas/mpt3sas_scsih.c:1114:6: warning: variable 'update_latency' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>            if (pcie_device->shutdown_latency == ioc->max_shutdown_latency)
>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/scsi/mpt3sas/mpt3sas_scsih.c:1128:6: note: uninitialized use occurs here
>            if (update_latency)
>                ^~~~~~~~~~~~~~
>    drivers/scsi/mpt3sas/mpt3sas_scsih.c:1114:2: note: remove the 'if' if its condition is always true
>            if (pcie_device->shutdown_latency == ioc->max_shutdown_latency)
>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/scsi/mpt3sas/mpt3sas_scsih.c:1094:19: note: initialize the variable 'update_latency' to silence this warning
>            u8 update_latency;
>                             ^
>                              = '\0'
>    1 warning generated.
