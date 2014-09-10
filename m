From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH V3 10/16] scsi: ufs: add UFS power management support
Date: Wed, 10 Sep 2014 22:58:01 +0900
Message-ID: <CAC5umyiXWw6n3Dd+cngHmrXsZEsc8_Vfg9Yp22cMy_MQ0uZrLw@mail.gmail.com>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
	<1410350063-23267-11-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:43792 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaIJN6E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 09:58:04 -0400
In-Reply-To: <1410350063-23267-11-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>

2014-09-10 20:54 GMT+09:00 Dolev Raviv <draviv@codeaurora.org>:
> +static inline void ufshcd_enable_irq(struct ufs_hba *hba)
> +{
> +       if (!hba->is_irq_enabled) {
> +               enable_irq(hba->irq);
> +               hba->is_irq_enabled = true;
> +       }
> +}
> +
> +static inline void ufshcd_disable_irq(struct ufs_hba *hba)
> +{
> +       if (hba->is_irq_enabled) {
> +               disable_irq(hba->irq);
> +               hba->is_irq_enabled = false;
> +       }
> +}

This IRQ could be shared among several devices because it is requested
with IRQF_SHARED.  So enable_irq()/disable_irq() should be replaced with
request_irq()/free_irq()?  Otherwise other devices which share the same
IRQ will be malfunction while disabling IRQ.
