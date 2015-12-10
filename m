From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] hisi_sas: use platform_get_irq()
Date: Thu, 10 Dec 2015 14:08:42 -0600
Message-ID: <CAL_Jsq+TMtZ1H6itwwXDrmt2TPuM8c02WiM0mDj-AUVgwvBt7w@mail.gmail.com>
References: <1449759745-63498-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48282 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbbLJUJG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2015 15:09:06 -0500
In-Reply-To: <1449759745-63498-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, martin.petersen@oracle.com, Arnd Bergmann <arnd@arndb.de>, Linuxarm <linuxarm@huawei.com>, Zhangfei Gao <zhangfei.gao@linaro.org>, Wei Xu <xuwei5@hisilicon.com>, John Garry <john.garry2@mail.dcu.ie>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Dec 10, 2015 at 9:02 AM, John Garry <john.garry@huawei.com> wrote:
> It is preferred that drivers use platform_get_irq()
> instead of irq_of_parse_and_map(), so replace.

You may be able to stop including of_irq.h with this change. Otherwise,

Acked-by: Rob Herring <robh@kernel.org>

>
> Signed-off-by: John Garry <john.garry@huawei.com>
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index 89ae31d..e907758 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1673,19 +1673,16 @@ static irq_handler_t fatal_interrupts[HISI_SAS_MAX_QUEUES] = {
>
>  static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>  {
> -       struct device *dev = &hisi_hba->pdev->dev;
> -       struct device_node *np = dev->of_node;
> +       struct platform_device *pdev = hisi_hba->pdev;
> +       struct device *dev = &pdev->dev;
>         int i, j, irq, rc, idx;
>
> -       if (!np)
> -               return -ENOENT;
> -
>         for (i = 0; i < hisi_hba->n_phy; i++) {
>                 struct hisi_sas_phy *phy = &hisi_hba->phy[i];
>
>                 idx = i * HISI_SAS_PHY_INT_NR;
>                 for (j = 0; j < HISI_SAS_PHY_INT_NR; j++, idx++) {
> -                       irq = irq_of_parse_and_map(np, idx);
> +                       irq = platform_get_irq(pdev, idx);
>                         if (!irq) {
>                                 dev_err(dev,
>                                         "irq init: fail map phy interrupt %d\n",
> @@ -1706,7 +1703,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>
>         idx = hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
>         for (i = 0; i < hisi_hba->queue_count; i++, idx++) {
> -               irq = irq_of_parse_and_map(np, idx);
> +               irq = platform_get_irq(pdev, idx);
>                 if (!irq) {
>                         dev_err(dev, "irq init: could not map cq interrupt %d\n",
>                                 idx);
> @@ -1724,7 +1721,7 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>
>         idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + hisi_hba->queue_count;
>         for (i = 0; i < HISI_SAS_FATAL_INT_NR; i++, idx++) {
> -               irq = irq_of_parse_and_map(np, idx);
> +               irq = platform_get_irq(pdev, idx);
>                 if (!irq) {
>                         dev_err(dev, "irq init: could not map fatal interrupt %d\n",
>                                 idx);
> --
> 1.9.1
>
