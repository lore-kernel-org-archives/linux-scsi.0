From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH V4 7/9] aacraid: Fix AIF triggered IOP_RESET
Date: Tue, 2 Feb 2016 01:18:20 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1FCBDC@BBYEXM01.pmc-sierra.internal>
References: <1454107550-24173-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1454107550-24173-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <56AF8B45.6030101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:56563 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734AbcBBBSV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 20:18:21 -0500
In-Reply-To: <56AF8B45.6030101@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>

Hello Tomas,

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Monday, February 1, 2016 8:44 AM
> To: Raghava Aditya Renukunta; James.Bottomley@HansenPartnership.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Gana Sridaran; aacraid@pmc-
> sierra.com; Scott Benesh; jthumshirn@suse.de; shane.seymour@hpe.com
> Subject: Re: [PATCH V4 7/9] aacraid: Fix AIF triggered IOP_RESET
> 
> On 29.1.2016 23:45, Raghava Aditya Renukunta wrote:
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
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@pmcs.com>
> > Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
> > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/aacraid/aacraid.h  |  2 +-
> >  drivers/scsi/aacraid/commctrl.c |  3 ++
> >  drivers/scsi/aacraid/comminit.c |  6 ++--
> >  drivers/scsi/aacraid/linit.c    | 63 +++++++++++++++++++++++++++++++--
> --------
> >  4 files changed, 56 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> > index 2916288..6c55749 100644
> > --- a/drivers/scsi/aacraid/aacraid.h
> > +++ b/drivers/scsi/aacraid/aacraid.h
> > @@ -1123,7 +1123,7 @@ struct aac_dev
> >
> >  	struct fib		*free_fib;
> >  	spinlock_t		fib_lock;
> > -
> > +	struct mutex		ioctl_mutex;
> >  	struct aac_queue_block *queues;
> >  	/*
> >  	 *	The user API will use an IOCTL to register itself to receive
> > diff --git a/drivers/scsi/aacraid/commctrl.c
> b/drivers/scsi/aacraid/commctrl.c
> > index 54195a1..8d3438c 100644
> > --- a/drivers/scsi/aacraid/commctrl.c
> > +++ b/drivers/scsi/aacraid/commctrl.c
> > @@ -855,6 +855,9 @@ int aac_do_ioctl(struct aac_dev * dev, int cmd, void
> __user *arg)
> >  {
> >  	int status;
> >
> > +	if (dev->adapter_shutdown)
> > +		return -EACCES;
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
> > index af8974e..9453e11 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -524,10 +524,17 @@ static struct device_attribute *aac_dev_attrs[] = {
> >
> >  static int aac_ioctl(struct scsi_device *sdev, int cmd, void __user * arg)
> >  {
> > -	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
> > +	int ret;
> > +	struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
> > +
> >  	if (!capable(CAP_SYS_RAWIO))
> >  		return -EPERM;
> > -	return aac_do_ioctl(dev, cmd, arg);
> > +
> > +	mutex_lock(&aac->ioctl_mutex);
> > +	ret = aac_do_ioctl(aac, cmd, arg);
> > +	mutex_unlock(&aac->ioctl_mutex);
> > +
> > +	return ret;
> >  }
> >
> >  static int aac_eh_abort(struct scsi_cmnd* cmd)
> > @@ -704,13 +711,14 @@ static long aac_cfg_ioctl(struct file *file,
> >  		unsigned int cmd, unsigned long arg)
> >  {
> >  	int ret;
> > -	struct aac_dev *aac;
> > -	aac = (struct aac_dev *)file->private_data;
> > -	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
> > +	struct aac_dev *aac = (struct aac_dev *)file->private_data;
> > +
> > +	if (!capable(CAP_SYS_RAWIO))
> >  		return -EPERM;
> > -	mutex_lock(&aac_mutex);
> > -	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
> > -	mutex_unlock(&aac_mutex);
> > +
> > +	mutex_lock(&aac->ioctl_mutex);
> > +	ret = aac_do_ioctl(aac, cmd, (void __user *)arg);
> > +	mutex_unlock(&aac->ioctl_mutex);
> >
> >  	return ret;
> >  }
> > @@ -719,7 +727,10 @@ static long aac_cfg_ioctl(struct file *file,
> >  static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd,
> unsigned long arg)
> >  {
> >  	long ret;
> > -	mutex_lock(&aac_mutex);
> > +
> > +	if (dev->adapter_shutdown)
> > +		return -EACCES;
> 
> There is another test for the same in aac_do_ioctl, this duplicated test is
> needless.

Will remove
 
> > +
> >  	switch (cmd) {
> >  	case FSACTL_MINIPORT_REV_CHECK:
> >  	case FSACTL_SENDFIB:
> > @@ -753,23 +764,37 @@ static long aac_compat_do_ioctl(struct aac_dev
> *dev, unsigned cmd, unsigned long
> >  		ret = -ENOIOCTLCMD;
> >  		break;
> >  	}
> > -	mutex_unlock(&aac_mutex);
> >  	return ret;
> >  }
> >
> >  static int aac_compat_ioctl(struct scsi_device *sdev, int cmd, void __user
> *arg)
> >  {
> > -	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
> > +	int ret;
> > +	struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
> > +
> >  	if (!capable(CAP_SYS_RAWIO))
> >  		return -EPERM;
> > -	return aac_compat_do_ioctl(dev, cmd, (unsigned long)arg);
> > +
> > +	mutex_lock(&aac->ioctl_mutex);
> > +	ret = aac_compat_do_ioctl(aac, cmd, (unsigned long)arg);
> > +	mutex_unlock(&aac->ioctl_mutex);
> > +
> > +	return ret;
> >  }
> >
> >  static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned
> long arg)
> >  {
> > +	int ret;
> > +	struct aac_dev *aac = (struct aac_dev *)file->private_data;
> > +
> >  	if (!capable(CAP_SYS_RAWIO))
> >  		return -EPERM;
> > -	return aac_compat_do_ioctl(file->private_data, cmd, arg);
> > +
> > +	mutex_lock(&aac->ioctl_mutex);
> > +	ret =  aac_compat_do_ioctl(aac, cmd, arg);
> > +	mutex_unlock(&aac->ioctl_mutex);
> > +
> > +	return ret;
> >  }
> >  #endif
> >
> > @@ -1078,6 +1103,8 @@ static void __aac_shutdown(struct aac_dev * aac)
> >  	int i;
> >  	int cpu;
> >
> > +	aac_send_shutdown(aac);
> > +
> >  	if (aac->aif_thread) {
> >  		int i;
> >  		/* Clear out events first */
> > @@ -1089,7 +1116,7 @@ static void __aac_shutdown(struct aac_dev * aac)
> >  		}
> >  		kthread_stop(aac->thread);
> >  	}
> > -	aac_send_shutdown(aac);
> > +
> >  	aac_adapter_disable_int(aac);
> >  	cpu = cpumask_first(cpu_online_mask);
> >  	if (aac->pdev->device == PMC_DEVICE_S6 ||
> > @@ -1193,7 +1220,7 @@ static int aac_probe_one(struct pci_dev *pdev,
> const struct pci_device_id *id)
> >  	if (!aac->fibs)
> >  		goto out_free_host;
> >  	spin_lock_init(&aac->fib_lock);
> > -
> > +	mutex_init(&aac->ioctl_mutex);
> >  	/*
> >  	 *	Map in the registers from the adapter.
> >  	 */
> > @@ -1474,7 +1501,10 @@ static int aac_resume(struct pci_dev *pdev)
> >  	* reset this flag to unblock ioctl() as it was set at
> >  	* aac_send_shutdown() to block ioctls from upperlayer
> >  	*/
> > +	mutex_lock(&aac->ioctl_mutex);
> >  	aac->adapter_shutdown = 0;
> > +	mutex_unlock(&aac->ioctl_mutex);
> 
> A mutex surrounding adapter_shutdown = 0; is needless.

Will Remove 

> > +
> >  	scsi_unblock_requests(shost);
> >
> >  	return 0;
> > @@ -1633,7 +1663,10 @@ static void aac_pci_resume(struct pci_dev
> *pdev)
> >  	 * reset this flag to unblock ioctl() as it was set
> >  	 * at aac_send_shutdown() to block ioctls from upperlayer
> >  	 */
> > +	mutex_lock(&aac->ioctl_mutex);
> >  	aac->adapter_shutdown = 0;
> > +	mutex_unlock(&aac->ioctl_mutex);
> 
> Same here.

Will Remove

> 
> aac_compat_do_ioctl and  aac_do_ioctl is surrounded by mutexes - that is
> fine,
> but by moving the mutex down to  aac_do_ioctl the code would be easier
> and more readable.
> 
> With the new mutex, you have changed the functionality so that a new patch
> is needed for that - before this patch there was no mutex in the main
> .ioctl path.
> 
> I have found no functional issues so regardless whether you follow
> my comments now, later or never -
> 
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> 
> Cheers
> Tomas

I will make the changes that you have suggested ,
Create  a new patch for the new mutex and apply this patch on top of it.

Thank you Tomas.

Regards,
Raghava Aditya

 

> 
> 
> 
> 
> 
> 
> 
> 
> > +
> >  	aac->handle_pci_error = 0;
> >
> >  	shost_for_each_device(sdev, shost)

