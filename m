From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [ PATCH 2/4 ] mpt fusion disable hard resets for 53C1030 based
 devices
Date: Mon, 6 Oct 2008 17:07:00 +0800
Message-ID: <6A4D764DC1BDE14495DA8DC60A3D69531E967A0642@hkgmail01.lsi.com>
References: <200809231530.06967.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:47879 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYJFJHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 05:07:17 -0400
In-Reply-To: <200809231530.06967.bs@q-leap.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Hi Bernd,
There are some cases where we MUST need hardreset for the firmware to recover. So we can not completely avoid SoftReset, That is the main purpose of our design of first to try softreset and if it is failing then to go for hard reset.

So I would suggest it is better not to remove the hard reset. If you think the latest LSI provided driver has some cases of avoiding hard reset like the one in this patch. Please let me know I will check and revert back.

Thanks
Sathya


-----Original Message-----
From: Bernd Schubert [mailto:bs@q-leap.de]
Sent: Tuesday, September 23, 2008 7:00 PM
To: Linux SCSI Mailing List
Cc: Moore, Eric; Prakash, Sathya; James Bottomley; DL-MPT Fusion Linux
Subject: Re: [ PATCH 2/4 ] mpt fusion disable hard resets for 53C1030 based devices

This is patch 2/4 ...

On Tuesday 23 September 2008 15:26:30 Bernd Schubert wrote:
> For 53C1030 based dual port HBAs the hard reset handler will cause
> trouble on the second channel with innocent devices. It is then better
> to fail the device which activated the error handler than to fail
> cause errors on unrelated devices. Of course, the real solutions would
> be to figure out why the hard reset handler cause trouble on the
> second channel. Probably only LSI can do, though.
>
> Signed-off-by: Bernd Schubert <bs@q-leap.de>
>
>  drivers/message/fusion/mptbase.c |   42 ++++++++++++++++++++++++++++-
>  drivers/message/fusion/mptspi.c  |   31 +++++++++++++++++++++
>  2 files changed, 72 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.26/drivers/message/fusion/mptbase.c
> ===================================================================
> --- linux-2.6.26.orig/drivers/message/fusion/mptbase.c
> +++ linux-2.6.26/drivers/message/fusion/mptbase.c
> @@ -59,6 +59,7 @@
>  #include <linux/interrupt.h>         /* needed for in_interrupt() proto */
>  #include <linux/dma-mapping.h>
>  #include <asm/io.h>
> +#include <scsi/scsi_device.h>
>  #ifdef CONFIG_MTRR
>  #include <asm/mtrr.h>
>  #endif
> @@ -6452,6 +6453,33 @@ mpt_HardResetHandler(MPT_ADAPTER *ioc, i  }
>
>  /**
> +  * Check if there are devices connected to the second (alt) ioc.
> +  * Return 1 if there is at least on device and 0 if there are
> +  * none or no alt_ioc.
> +  */
> +static int
> +alt_ioc_with_dev(MPT_ADAPTER *ioc)
> +{
> +     struct Scsi_Host        *shost;
> +     struct scsi_device      *sdev;
> +     int                     have_devices = 0;
> +
> +     if (!ioc->alt_ioc)
> +             return 0;
> +
> +     shost = ioc->alt_ioc->sh;
> +
> +     shost_for_each_device(sdev, shost) {
> +             /* when we are here, we know there is is a device
> +              * attached to this host, which is all we need to know */
> +             have_devices = 1;
> +             break;
> +     }
> +
> +     return have_devices;
> +}
> +
> +/**
>   *   mpt_SoftHardResetHandler - Generic reset handler
>   *   @ioc: Pointer to MPT_ADAPTER structure
>   *   @sleepFlag: Indicates if sleep or schedule must be called.
> @@ -6466,7 +6494,19 @@ mpt_SoftHardResetHandler(MPT_ADAPTER *io
>
>       rc = mpt_SoftResetHandler(ioc, sleepFlag);
>       if (rc) {
> -             rc = mpt_HardResetHandler(ioc, sleepFlag);
> +             if (ioc->no_hard_reset && alt_ioc_with_dev(ioc)) {
> +                     /* On dual port HBAs based on the 53C1030 chip the
> +                     * hard reset handler will cause DID_SOFT_ERROR on
> +                     * the second (in principle independent) port.
> +                     * Almost always this error cannot be recovered
> +                     * causing entire device failures. So it better not
> +                     * to call the hard reset handler at all in order to
> +                     * prevent failures of independent devices */
> +                     printk(MYIOC_s_INFO_FMT "Skipping hard reset in "
> +                             "order to prevent failures on %s.\n",
> +                             ioc->name, ioc->alt_ioc->name);
> +             } else
> +                     rc = mpt_HardResetHandler(ioc, sleepFlag);
>       }
>
>       return rc;
> Index: linux-2.6.26/drivers/message/fusion/mptspi.c
> ===================================================================
> --- linux-2.6.26.orig/drivers/message/fusion/mptspi.c
> +++ linux-2.6.26/drivers/message/fusion/mptspi.c
> @@ -1301,6 +1301,33 @@ mptspi_resume(struct pci_dev *pdev)  #endif
>
>
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
>-=*/ +/**
> +  * avoid_hard_reset - check if hard resets should be avoided
> +  * @pdev: Pointer to pci_dev structure
> +  *
> +  * Hard resets will cause trouble on the the secondary IOC of
> +  * 53C1030 based devices.
> +  *
> +  * Returns 1 if affected chip is found and 1 for unaffected chips
> +  */
> +static int
> +avoid_hard_reset(struct pci_dev *pdev)
> +{
> +     int avoid;
> +
> +     switch (pdev->device) {
> +     case MPI_MANUFACTPAGE_DEVID_53C1030:
> +     case MPI_MANUFACTPAGE_DEVID_53C1030ZC:
> +             /* TODO: which chips are affected as well? */
> +             avoid = 1;
> +             break;
> +     default:
> +             avoid = 0;
> +     }
> +
> +     return avoid;
> +}
> +
>
> /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
>-=*/ /*
>   *   mptspi_probe - Installs scsi devices per bus.
> @@ -1509,6 +1536,10 @@ mptspi_probe(struct pci_dev *pdev, const
>               goto out_mptspi_probe;
>       }
>
> +     /* hard resets on 53C1030 HBAs will cause trouble on secondaray (alt)
> +      * IOCs, so better no hard reset on these */
> +     ioc->no_hard_reset = avoid_hard_reset(pdev);
> +
>       /*
>        * issue internal bus reset
>        */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Bernd Schubert
Q-Leap Networks GmbH
