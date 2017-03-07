From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] lpfc: Finalize Kconfig options for nvme
Date: Tue, 7 Mar 2017 13:23:51 -0800
Message-ID: <20170307212351.GA5697@infradead.org>
References: <1488914228-7289-1-git-send-email-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59445 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756217AbdCGVYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 16:24:08 -0500
Content-Disposition: inline
In-Reply-To: <1488914228-7289-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

> +#if defined(CONFIG_NVME_FC)
> +#define CONFIG_LPFC_NVME_INITIATOR
> +#endif
> +
> +#if defined(CONFIG_NVME_TARGET_FC)
> +#define CONFIG_LPFC_NVME_TARGET
> +#endif

The CONFIG_* namespace is reserved for Kconfig defined symbols.

Also I think the above is wrong if the nvme fc core code is built
modular.  I think you want to replace all occurances of

#ifdef CONFIG_LPFC_NVME_INITIATOR

with

if (IS_ENABLED(CONFIG_NVME_FC))

and vice versa for the taget.
