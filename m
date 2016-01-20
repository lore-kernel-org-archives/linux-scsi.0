From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH V3 8/9] aacraid: Fix character device re-initialization
Date: Wed, 20 Jan 2016 20:43:41 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1F6AE0@BBYEXM01.pmc-sierra.internal>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452842182-684-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <569F8E7A.7090703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.241.235.117] ([216.241.235.117]:59639 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750781AbcATUoN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 15:44:13 -0500
In-Reply-To: <569F8E7A.7090703@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>, zzzDavid Carroll <David.Carroll@pmcs.com>


Hello Tomas,

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Wednesday, January 20, 2016 5:41 AM
> To: Raghava Aditya Renukunta; James.Bottomley@HansenPartnership.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Gana Sridaran; aacraid@pmc-
> sierra.com; Scott Benesh; jthumshirn@suse.de; shane.seymour@hpe.com;
> zzzDavid Carroll
> Subject: Re: [PATCH V3 8/9] aacraid: Fix character device re-initialization
> 
> On 15.1.2016 08:16, Raghava Aditya Renukunta wrote:
> > From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
> >
> > During EEH PCI hotplug activity kernel unloads and loads the driver,
> > causing character device to be unregistered(aac_remove_one).When the
> > driver is loaded back using aac_probe_one the character device needs
> > to be registered again for the AIF management tools to work.
> >
> > Fixed by adding code to register character device in aac_probe_one if
> > it is unregistered in aac_remove_one.
> >
> > Changes in V2:
> > Added macros to track character device state
> >
> > Changes in V3:
> > None
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@pmcs.com>
> > Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
> 
> Hi Raghava,
> when aacraid is loaded (modprobe) without an controller attached to the
> system
> the driver loads and creates the character device. Later when you hotplug a
> device and remove again we see the driver loaded but now without the
> char device. I'd prefer consistency here - either create the char device
> when the first controller is probed (preferred) or do not remove it
> until the driver exits.
> This is not a nack, just a wish that you changed it in next series.
> 
> --tm


Yes I will make the necessary changes  so that character device is created when
The controller is probed, and when the driver is removed (aac_remove_one),delete 
the character device. I will keep the character device during resume and suspend.

Do you want to do this in the next version of the patches or the next series of patches after this one is 
Accepted. ?
 
Regards,
Raghava Aditya


> > ---
> >  drivers/scsi/aacraid/aacraid.h |  7 +++++++
> >  drivers/scsi/aacraid/linit.c   | 21 ++++++++++++++-------
> >  2 files changed, 21 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> > index 3473668..4b669ef 100644
> > --- a/drivers/scsi/aacraid/aacraid.h
> > +++ b/drivers/scsi/aacraid/aacraid.h
> > @@ -94,6 +94,13 @@ enum {
> >  #define aac_phys_to_logical(x)  ((x)+1)
> >  #define aac_logical_to_phys(x)  ((x)?(x)-1:0)
> >
> > +/*
> > + * These macros are for keeping track of
> > + * character device state.
> > + */
> > +#define AAC_CHARDEV_UNREGISTERED	(-1)
> > +#define AAC_CHARDEV_NEEDS_REINIT	(-2)
> > +
> >  /* #define AAC_DETAILED_STATUS_INFO */
> >
> >  struct diskparm
> > diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> > index 27b3fcd..057c07c 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -80,7 +80,7 @@ MODULE_VERSION(AAC_DRIVER_FULL_VERSION);
> >
> >  static DEFINE_MUTEX(aac_mutex);
> >  static LIST_HEAD(aac_devices);
> > -static int aac_cfg_major = -1;
> > +static int aac_cfg_major = AAC_CHARDEV_UNREGISTERED;
> >  char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
> >
> >  /*
> > @@ -1125,6 +1125,13 @@ static void __aac_shutdown(struct aac_dev *
> aac)
> >  	else if (aac->max_msix > 1)
> >  		pci_disable_msix(aac->pdev);
> >  }
> > +static void aac_init_char(void)
> > +{
> > +	aac_cfg_major = register_chrdev(0, "aac", &aac_cfg_fops);
> > +	if (aac_cfg_major < 0) {
> > +		pr_err("aacraid: unable to register \"aac\" device.\n");
> > +	}
> > +}
> >
> >  static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id
> *id)
> >  {
> > @@ -1182,6 +1189,9 @@ static int aac_probe_one(struct pci_dev *pdev,
> const struct pci_device_id *id)
> >  	shost->max_cmd_len = 16;
> >  	shost->use_cmd_list = 1;
> >
> > +	if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
> > +		aac_init_char();
> > +
> >  	aac = (struct aac_dev *)shost->hostdata;
> >  	aac->base_start = pci_resource_start(pdev, 0);
> >  	aac->scsi_host_ptr = shost;
> > @@ -1519,7 +1529,7 @@ static void aac_remove_one(struct pci_dev
> *pdev)
> >  	pci_disable_device(pdev);
> >  	if (list_empty(&aac_devices)) {
> >  		unregister_chrdev(aac_cfg_major, "aac");
> > -		aac_cfg_major = -1;
> > +		aac_cfg_major = AAC_CHARDEV_NEEDS_REINIT;
> >  	}
> >  }
> >
> > @@ -1681,11 +1691,8 @@ static int __init aac_init(void)
> >  	if (error < 0)
> >  		return error;
> >
> > -	aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops);
> > -	if (aac_cfg_major < 0) {
> > -		printk(KERN_WARNING
> > -			"aacraid: unable to register \"aac\" device.\n");
> > -	}
> > +	aac_init_char();
> > +
> >
> >  	return 0;
> >  }

