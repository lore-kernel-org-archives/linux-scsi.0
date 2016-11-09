From: Rameshwar Sahu <rsahu@apm.com>
Subject: Re: [PATCH] ata: xgene: Enable NCQ support for APM X-Gene SATA
 controller hardware v1.1
Date: Wed, 9 Nov 2016 17:09:14 +0530
Message-ID: <CAFd313yibujm+yzeVUZFrLwT8vwbDYN+DJmsAQ7rWUNXUb2ixw@mail.gmail.com>
References: <1476962064-8775-1-git-send-email-rsahu@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1476962064-8775-1-git-send-email-rsahu@apm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Olof Johansson <olof@lixom.net>, tj@kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: Devicetree List <devicetree@vger.kernel.org>, mlangsdo@redhat.com, linux-scsi@vger.kernel.org, Jon Masters <jcm@redhat.com>, Rameshwar Prasad Sahu <rsahu@apm.com>, patches <patches@apm.com>, linux-ide@vger.kernel.org, linux-arm <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi Olof/Tejun,

On Thu, Oct 20, 2016 at 4:44 PM, Rameshwar Prasad Sahu <rsahu@apm.com> wrote:
>
> This patch enables NCQ support for APM X-Gene SATA controller
> hardware v1.1 that was broken with hardware v1.0.
>
> Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
> ---
>  drivers/ata/ahci_xgene.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
> index 73b19b2..8b88be9 100644
> --- a/drivers/ata/ahci_xgene.c
> +++ b/drivers/ata/ahci_xgene.c
> @@ -87,6 +87,7 @@
>
>  enum xgene_ahci_version {
>         XGENE_AHCI_V1 = 1,
> +       XGENE_AHCI_V1_1,
>         XGENE_AHCI_V2,
>  };
>
> @@ -734,6 +735,7 @@ static struct scsi_host_template ahci_platform_sht = {
>  #ifdef CONFIG_ACPI
>  static const struct acpi_device_id xgene_ahci_acpi_match[] = {
>         { "APMC0D0D", XGENE_AHCI_V1},
> +       { "APMC0D67", XGENE_AHCI_V1_1},
>         { "APMC0D32", XGENE_AHCI_V2},
>         {},
>  };
> @@ -742,6 +744,7 @@ MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);
>
>  static const struct of_device_id xgene_ahci_of_match[] = {
>         {.compatible = "apm,xgene-ahci", .data = (void *) XGENE_AHCI_V1},
> +       {.compatible = "apm,xgene-ahci-v1-1", .data = (void *) XGENE_AHCI_V1_1},
>         {.compatible = "apm,xgene-ahci-v2", .data = (void *) XGENE_AHCI_V2},
>         {},
>  };
> @@ -755,8 +758,7 @@ static int xgene_ahci_probe(struct platform_device *pdev)
>         struct resource *res;
>         const struct of_device_id *of_devid;
>         enum xgene_ahci_version version = XGENE_AHCI_V1;
> -       const struct ata_port_info *ppi[] = { &xgene_ahci_v1_port_info,
> -                                             &xgene_ahci_v2_port_info };
> +       const struct ata_port_info *ppi;
>         int rc;
>
>         hpriv = ahci_platform_get_resources(pdev);
> @@ -821,8 +823,6 @@ static int xgene_ahci_probe(struct platform_device *pdev)
>                                 dev_warn(&pdev->dev, "%s: Error reading device info. Assume version1\n",
>                                         __func__);
>                                 version = XGENE_AHCI_V1;
> -                       } else if (info->valid & ACPI_VALID_CID) {
> -                               version = XGENE_AHCI_V2;
>                         }
>                 }
>         }
> @@ -858,18 +858,20 @@ skip_clk_phy:
>
>         switch (version) {
>         case XGENE_AHCI_V1:
> +               ppi = &xgene_ahci_v1_port_info;
>                 hpriv->flags = AHCI_HFLAG_NO_NCQ;
>                 break;
>         case XGENE_AHCI_V2:
> +               ppi = &xgene_ahci_v2_port_info;
>                 hpriv->flags |= AHCI_HFLAG_YES_FBS;
>                 hpriv->irq_handler = xgene_ahci_irq_intr;
>                 break;
>         default:
> +               ppi = &xgene_ahci_v1_port_info;
>                 break;
>         }
>
> -       rc = ahci_platform_init_host(pdev, hpriv, ppi[version - 1],
> -                                    &ahci_platform_sht);
> +       rc = ahci_platform_init_host(pdev, hpriv, ppi, &ahci_platform_sht);
>         if (rc)
>                 goto disable_resources;
>
> --
> 1.7.1


Any comment on above patch ??
