From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH V5 08/10] aacraid: Fix AIF triggered IOP_RESET
Date: Wed, 3 Feb 2016 22:50:20 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1FDFD0@BBYEXM01.pmc-sierra.internal>
References: <1454461088-32482-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1454461088-32482-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <56B1DC77.8060208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:56855 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154AbcBCWuW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Feb 2016 17:50:22 -0500
In-Reply-To: <56B1DC77.8060208@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>

Hello Tomas,

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Wednesday, February 3, 2016 2:55 AM
> To: Raghava Aditya Renukunta; James.Bottomley@HansenPartnership.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Gana Sridaran; aacraid@pmc-
> sierra.com; Scott Benesh; jthumshirn@suse.de; shane.seymour@hpe.com
> Subject: Re: [PATCH V5 08/10] aacraid: Fix AIF triggered IOP_RESET
> 
> On 3.2.2016 01:58, Raghava Aditya Renukunta wrote:
> > From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
> >
> > while driver removal is in progress or PCI shutdown is invoked, driver
> > kills AIF aacraid thread, but IOCTL requests from the management tools
> > re-start AIF thread leading to IOP_RESET.
> >
> > Fixed by setting adapter_shutdown flag when PCI shutdown is invoked.
> >
> > Changes in V2:
> > Set adapter_shutdown flag before shutdown command is sent to \
> > controller
> >
> > Changes in V3:
> > Call aac_send_shut_shutdown first thing in __aac_shutdown
> > Convert adapter_shutdown to atomic_t variable to prevent \
> > SMP coherency issues(race conditions)
> >
> > Changes in V4:
> > Used mutex to protect ioctl path and adapter_shutdown to prevent \
> > race conditions.
> >
> > Changes in V5:
> > Moved replacement of aac_mutex with ioctl_mutex to previous patch
> >
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@pmcs.com>
> > Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
> > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> > Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> > ---
> >  drivers/scsi/aacraid/commctrl.c | 3 +++
> >  drivers/scsi/aacraid/comminit.c | 6 ++++--
> >  drivers/scsi/aacraid/linit.c    | 5 +++--
> >  3 files changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/commctrl.c
> b/drivers/scsi/aacraid/commctrl.c
> > index 4d5f4e7..f6692d1 100644
> > --- a/drivers/scsi/aacraid/commctrl.c
> > +++ b/drivers/scsi/aacraid/commctrl.c
> > @@ -857,6 +857,9 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void
> __user *arg)
> >
> >  	mutex_lock(&dev->ioctl_mutex);
> >
> > +	if (dev->adapter_shutdown)
> > +		return -EACCES;
> 
> and here too - mutex_unlock please
> 
> -tm

Will do.

Regards,
Raghava Aditya
> 
> > +
> >  	/*
> >  	 *	HBA gets first crack
> >  	 */
> > diff --git a/drivers/scsi/aacraid/comminit.c
> b/drivers/scsi/aacraid/comminit.c
> > index 0e954e3..2b4e753 100644
> > --- a/drivers/scsi/aacraid/comminit.c
> > +++ b/drivers/scsi/aacraid/comminit.c
> > @@ -212,8 +212,11 @@ int aac_send_shutdown(struct aac_dev * dev)
> >  		return -ENOMEM;
> >  	aac_fib_init(fibctx);
> >
> > -	cmd = (struct aac_close *) fib_data(fibctx);
> > +	mutex_lock(&dev->ioctl_mutex);
> > +	dev->adapter_shutdown = 1;
> > +	mutex_unlock(&dev->ioctl_mutex);
> >
> > +	cmd = (struct aac_close *) fib_data(fibctx);
> >  	cmd->command = cpu_to_le32(VM_CloseAll);
> >  	cmd->cid = cpu_to_le32(0xfffffffe);
> >
> > @@ -229,7 +232,6 @@ int aac_send_shutdown(struct aac_dev * dev)
> >  	/* FIB should be freed only after getting the response from the F/W
> */
> >  	if (status != -ERESTARTSYS)
> >  		aac_fib_free(fibctx);
> > -	dev->adapter_shutdown = 1;
> >  	if ((dev->pdev->device == PMC_DEVICE_S7 ||
> >  	     dev->pdev->device == PMC_DEVICE_S8 ||
> >  	     dev->pdev->device == PMC_DEVICE_S9) &&
> > diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> > index 5f08bcf..2c7405a 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -703,7 +703,7 @@ static int aac_cfg_open(struct inode *inode, struct
> file *file)
> >  static long aac_cfg_ioctl(struct file *file,
> >  		unsigned int cmd, unsigned long arg)
> >  {
> > -	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
> > +	if (!capable(CAP_SYS_RAWIO))
> >  		return -EPERM;
> >  	return aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
> >  }
> > @@ -1069,6 +1069,8 @@ static void __aac_shutdown(struct aac_dev * aac)
> >  	int i;
> >  	int cpu;
> >
> > +	aac_send_shutdown(aac);
> > +
> >  	if (aac->aif_thread) {
> >  		int i;
> >  		/* Clear out events first */
> > @@ -1080,7 +1082,6 @@ static void __aac_shutdown(struct aac_dev * aac)
> >  		}
> >  		kthread_stop(aac->thread);
> >  	}
> > -	aac_send_shutdown(aac);
> >  	aac_adapter_disable_int(aac);
> >  	cpu = cpumask_first(cpu_online_mask);
> >  	if (aac->pdev->device == PMC_DEVICE_S6 ||

