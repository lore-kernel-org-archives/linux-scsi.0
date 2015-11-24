From: Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] scsi: hisi_sas: remove dependency on of_irq_count
Date: Tue, 24 Nov 2015 08:37:49 -0600
Message-ID: <CAL_Jsq+kLy1kWq6DQOZ9vFc_O5HEEPUGQmUtvUD-8S=Ej8x=pQ@mail.gmail.com>
References: <1447935839-212872-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447935839-212872-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, martin.petersen@oracle.com, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, John Garry <john.garry2@mail.dcu.ie>, Wei Xu <xuwei5@hisilicon.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 19, 2015 at 6:23 AM, John Garry <john.garry@huawei.com> wrote:
> Originally the driver would use of_irq_count to
> calculate how much memory is required for storing the
> interrupt names, since the number of interrupt sources
> for the controller is variable.
> Since of_irq_count cannot be used by the driver, use
> fixed names.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Acked-by: Rob Herring <robh@kernel.org>

>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index 5b790c9..30a9ab9 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -38,8 +38,6 @@
>  #define HISI_SAS_MAX_SSP_RESP_SZ (sizeof(struct ssp_frame_hdr) + 1024)
>  #define HISI_SAS_MAX_SMP_RESP_SZ 1028
>
> -#define HISI_SAS_NAME_LEN 32
> -
>  struct hisi_hba;
>
>  enum {
> @@ -178,7 +176,6 @@ struct hisi_hba {
>
>         int     queue_count;
>         int     queue;
> -       char    *int_names;
>         struct hisi_sas_slot    *slot_prep;
>
>         struct dma_pool *sge_page_pool;
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 1377625..2929018 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -1160,7 +1160,6 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
>         struct device *dev = &pdev->dev;
>         struct device_node *np = pdev->dev.of_node;
>         struct property *sas_addr_prop;
> -       int num;
>
>         shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
>         if (!shost)
> @@ -1197,13 +1196,6 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
>         if (of_property_read_u32(np, "queue-count", &hisi_hba->queue_count))
>                 goto err_out;
>
> -       num = of_irq_count(np);
> -       hisi_hba->int_names = devm_kcalloc(dev, num,
> -                                          HISI_SAS_NAME_LEN,
> -                                          GFP_KERNEL);
> -       if (!hisi_hba->int_names)
> -               goto err_out;
> -
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         hisi_hba->regs = devm_ioremap_resource(dev, res);
>         if (IS_ERR(hisi_hba->regs))
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index e29b7c7..0ed2f92 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1660,18 +1660,6 @@ static irqreturn_t fatal_axi_int_v1_hw(int irq, void *p)
>         return IRQ_HANDLED;
>  }
>
> -static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
> -       {"Bcast"},
> -       {"Phy Up"},
> -       {"Abnormal"},
> -};
> -
> -static const char cq_int_name[32] = "cq";
> -static const char fatal_int_name[HISI_SAS_FATAL_INT_NR][32] = {
> -       "fatal ecc",
> -       "fatal axi"
> -};
> -
>  static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
>         int_bcast_v1_hw,
>         int_phyup_v1_hw,
> @@ -1687,7 +1675,6 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>  {
>         struct device *dev = &hisi_hba->pdev->dev;
>         struct device_node *np = dev->of_node;
> -       char *int_names = hisi_hba->int_names;
>         int i, j, irq, rc, idx;
>
>         if (!np)
> @@ -1706,13 +1693,8 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>                                 return -ENOENT;
>                         }
>
> -                       (void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
> -                                      HISI_SAS_NAME_LEN,
> -                                      "%s %s:%d", dev_name(dev),
> -                                      phy_int_names[j], i);
>                         rc = devm_request_irq(dev, irq, phy_interrupts[j], 0,
> -                                       &int_names[idx * HISI_SAS_NAME_LEN],
> -                                       phy);
> +                                             DRV_NAME " phy", phy);
>                         if (rc) {
>                                 dev_err(dev, "irq init: could not request "
>                                         "phy interrupt %d, rc=%d\n",
> @@ -1730,12 +1712,9 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>                                 idx);
>                         return -ENOENT;
>                 }
> -               (void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
> -                              HISI_SAS_NAME_LEN,
> -                              "%s %s:%d", dev_name(dev), cq_int_name, i);
> +
>                 rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
> -                                     &int_names[idx * HISI_SAS_NAME_LEN],
> -                                     &hisi_hba->cq[i]);
> +                                     DRV_NAME " cq", &hisi_hba->cq[i]);
>                 if (rc) {
>                         dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
>                                 irq, rc);
> @@ -1751,12 +1730,9 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
>                                 idx);
>                         return -ENOENT;
>                 }
> -               (void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
> -                              HISI_SAS_NAME_LEN,
> -                              "%s %s:%d", dev_name(dev), fatal_int_name[i], i);
> +
>                 rc = devm_request_irq(dev, irq, fatal_interrupts[i], 0,
> -                                     &int_names[idx * HISI_SAS_NAME_LEN],
> -                                     hisi_hba);
> +                                     DRV_NAME " fatal", hisi_hba);
>                 if (rc) {
>                         dev_err(dev,
>                                 "irq init: could not request fatal interrupt %d, rc=%d\n",
> --
> 1.9.1
>
