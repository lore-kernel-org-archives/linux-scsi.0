From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 11/20] [SCSI] mpt3sas: Add branding string support for OEM
 custom HBA
Date: Thu, 18 Jun 2015 15:25:08 +0530
Message-ID: <CAK=zhgqQJj14dZwdHngeU+WGEyA=uHT+kJykfCeWs=PVaBWrtg@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-12-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37247 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbbFRJzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2015 05:55:09 -0400
Received: by wicgi11 with SMTP id gi11so8200098wic.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2015 02:55:08 -0700 (PDT)
In-Reply-To: <1434102153-38581-12-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Hi,

Any review comments on this patch. please let us known if any changes
are required.

Thanks,
Sreekanth

On Fri, Jun 12, 2015 at 3:12 PM, Sreekanth Reddy
<sreekanth.reddy@avagotech.com> wrote:
> Add the following OEM's branding to the mpt3sas driver.
>
> "VendorID"   "DeviceID"  "SubsystemVendor ID"   "SubsystemDevice ID"  Cisco Branding String
> 0x1000         0x97         SVID = 0x1137             0x014C          Cisco 9300-8E 12G SAS HBA
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 34 ++++++++++++++++++++++++++++++++++
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 11 +++++++++++
>  2 files changed, 45 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index db362cb..267e489 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2378,6 +2378,39 @@ _base_display_dell_branding(struct MPT3SAS_ADAPTER *ioc)
>         }
>  }
>
> +/**
> + * _base_display_cisco_branding - Display branding string
> + * @ioc: per adapter object
> + *
> + * Return nothing.
> + */
> +static void
> +_base_display_cisco_branding(struct MPT3SAS_ADAPTER *ioc)
> +{
> +       if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_CISCO)
> +               return;
> +
> +       switch (ioc->pdev->device) {
> +       case MPI25_MFGPAGE_DEVID_SAS3008:
> +               switch (ioc->pdev->subsystem_device) {
> +               case MPT3SAS_CISCO_12G_HBA_SSDID:
> +                       pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> +                               MPT3SAS_CISCO_12G_HBA_BRANDING);
> +                       break;
> +               default:
> +                       pr_info(MPT3SAS_FMT
> +                         "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
> +                         ioc->name, ioc->pdev->subsystem_device);
> +                       break;
> +               }
> +               break;
> +       default:
> +                pr_info(MPT3SAS_FMT
> +                       "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
> +                       ioc->name, ioc->pdev->subsystem_device);
> +               break;
> +       }
> +}
>
>  /**
>   * _base_display_ioc_capabilities - Disply IOC's capabilities.
> @@ -2410,6 +2443,7 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
>
>         _base_display_intel_branding(ioc);
>         _base_display_dell_branding(ioc);
> +       _base_display_cisco_branding(ioc);
>
>         pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index c4780c7..7cdbc65 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -163,6 +163,17 @@
>  #define MPT3SAS_DELL_12G_HBA_SSDID     0x1F46
>
>  /*
> + * Cisco HBA branding
> + */
> +#define MPT3SAS_CISCO_12G_HBA_BRANDING       \
> +       "Cisco 9300-8E 12G SAS HBA"
> +
> +/*
> + * Cisco HBA SSSDIDs
> + */
> + #define MPT3SAS_CISCO_12G_HBA_SSDID  0x14C
> +
> +/*
>   * status bits for ioc->diag_buffer_status
>   */
>  #define MPT3_DIAG_BUFFER_IS_REGISTERED (0x01)
> --
> 2.0.2
>



-- 

Regards,
Sreekanth
