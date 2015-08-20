From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 7/8] scsi: ufs-qcom: add debug prints for test bus
Date: Fri, 21 Aug 2015 08:42:16 +0900
Message-ID: <CAC5umyhRBDW0OxmDiw9TMHNm-kz1f_wcE0iZ3dY=MkfnMywUNw@mail.gmail.com>
References: <1440079144-26461-1-git-send-email-ygardi@codeaurora.org>
	<1440079144-26461-8-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:33266 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbHTXmR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2015 19:42:17 -0400
In-Reply-To: <1440079144-26461-8-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

2015-08-20 22:59 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> @@ -30,6 +48,14 @@ static void ufs_qcom_get_speed_mode(struct ufs_pa_layer_attr *p, char *result);
>  static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
>                 const char *speed_mode);
>  static int ufs_qcom_set_bus_vote(struct ufs_qcom_host *host, int vote);
> +static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
> +static void ufs_qcom_dump_regs(struct ufs_hba *hba, int offset, int len,
> +               char *prefix)
> +{
> +       print_hex_dump(KERN_ERR, prefix,
> +                       len > 4 ? DUMP_PREFIX_OFFSET : DUMP_PREFIX_NONE,
> +                       16, 4, hba->mmio_base + offset, len * 4, false);
> +}

This causes a sparse warning as __iomem pointer is passed to
print_hex_dump().
