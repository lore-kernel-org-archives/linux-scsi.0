From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 16/20] [SCSI] mpt3sas: Added support for customer specific branding
Date: Thu, 18 Jun 2015 15:23:58 +0530
Message-ID: <CAK=zhgri5a9fu0x7OmO5jVkpcMQPPGNpZys-jQWCaWBELJgn1Q@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-17-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434102153-38581-17-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

Any review comments on this patch. please let us known if any changes
are required.

Thanks,
Sreekanth

On Fri, Jun 12, 2015 at 3:12 PM, Sreekanth Reddy
<sreekanth.reddy@avagotech.com> wrote:
> Added support for below customer specific brandings
>
> "VendorID"   "DeviceID"  "SubsystemVendor ID"   "SubsystemDevice ID"  Cisco Branding String
> 0x1000         0x97           0x1137                 0x154           Cisco 9300-8i 12Gbps SAS HBA
> 0x1000         0x97           0x1137                 0x155           Cisco 12G Modular SAS Pass through Controller
> 0x1000         0x97           0x1137                 0x156           UCS C3X60 12G SAS Pass through Controller
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 29 +++++++++++++++++++++++++++--
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 16 ++++++++++++----
>  2 files changed, 39 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 0b26c8d..2f2c331 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2393,9 +2393,17 @@ _base_display_cisco_branding(struct MPT3SAS_ADAPTER *ioc)
>         switch (ioc->pdev->device) {
>         case MPI25_MFGPAGE_DEVID_SAS3008:
>                 switch (ioc->pdev->subsystem_device) {
> -               case MPT3SAS_CISCO_12G_HBA_SSDID:
> +               case MPT3SAS_CISCO_12G_8E_HBA_SSDID:
>                         pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                               MPT3SAS_CISCO_12G_HBA_BRANDING);
> +                               MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
> +                       break;
> +               case MPT3SAS_CISCO_12G_8I_HBA_SSDID:
> +                       pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> +                               MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
> +                       break;
> +               case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
> +                       pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> +                               MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
>                         break;
>                 default:
>                         pr_info(MPT3SAS_FMT
> @@ -2404,6 +2412,23 @@ _base_display_cisco_branding(struct MPT3SAS_ADAPTER *ioc)
>                         break;
>                 }
>                 break;
> +       case MPI25_MFGPAGE_DEVID_SAS3108_1:
> +               switch (ioc->pdev->subsystem_device) {
> +               case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
> +                       pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> +                       MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
> +                       break;
> +               case MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID:
> +                       pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> +                       MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING);
> +                       break;
> +               default:
> +                       pr_info(MPT3SAS_FMT
> +                        "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
> +                        ioc->name, ioc->pdev->subsystem_device);
> +                       break;
> +               }
> +               break;
>         default:
>                  pr_info(MPT3SAS_FMT
>                         "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index a89c752..b97039b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -165,13 +165,21 @@
>  /*
>   * Cisco HBA branding
>   */
> -#define MPT3SAS_CISCO_12G_HBA_BRANDING       \
> -       "Cisco 9300-8E 12G SAS HBA"
> -
> +#define MPT3SAS_CISCO_12G_8E_HBA_BRANDING              \
> +               "Cisco 9300-8E 12G SAS HBA"
> +#define MPT3SAS_CISCO_12G_8I_HBA_BRANDING              \
> +               "Cisco 9300-8i 12G SAS HBA"
> +#define MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING   \
> +               "Cisco 12G Modular SAS Pass through Controller"
> +#define MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING                \
> +               "UCS C3X60 12G SAS Pass through Controller"
>  /*
>   * Cisco HBA SSSDIDs
>   */
> - #define MPT3SAS_CISCO_12G_HBA_SSDID  0x14C
> +#define MPT3SAS_CISCO_12G_8E_HBA_SSDID  0x14C
> +#define MPT3SAS_CISCO_12G_8I_HBA_SSDID  0x154
> +#define MPT3SAS_CISCO_12G_AVILA_HBA_SSDID  0x155
> +#define MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID  0x156
>
>  /*
>   * status bits for ioc->diag_buffer_status
> --
> 2.0.2
>



-- 

Regards,
Sreekanth
