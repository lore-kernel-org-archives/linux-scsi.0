From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 07/25] scsi: hisi_sas: add ioremap for device HW
Date: Mon, 12 Oct 2015 17:21:53 +0200
Message-ID: <5285087.C8umupFr76@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-8-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444663237-238302-8-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Monday 12 October 2015 23:20:19 John Garry wrote:
> +int hisi_sas_ioremap(struct hisi_hba *hisi_hba)
> +{
> +       struct platform_device *pdev = hisi_hba->pdev;
> +       struct device *dev = &pdev->dev;
> +       struct resource *res;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       hisi_hba->regs = devm_ioremap(dev,
> +                                     res->start,
> +                                     resource_size(res));
> +       if (!hisi_hba->regs)
> +               return -ENOMEM;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +       hisi_hba->ctrl_regs = devm_ioremap(dev,
> +                                          res->start,
> +                                          resource_size(res));
> +       if (!hisi_hba->ctrl_regs)
> +               return -ENOMEM;
> +
> +       return 0;
> +}
>  
>  static const struct of_device_id sas_of_match[] = {
> 

Better use devm_ioremap_resource() here, which registers the resource so they
are checked for conflicts and listed in /proc/iomem.

	Arnd
