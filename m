From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH V3 7/9] aacraid: Fix AIF triggered IOP_RESET
Date: Wed, 20 Jan 2016 20:32:23 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1F6AA9@BBYEXM01.pmc-sierra.internal>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1452842182-684-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <569E60E4.4000903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.241.235.117] ([216.241.235.117]:58745 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755020AbcATUcz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 15:32:55 -0500
In-Reply-To: <569E60E4.4000903@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>, zzzDavid Carroll <David.Carroll@pmcs.com>



> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, January 19, 2016 8:14 AM
> To: Raghava Aditya Renukunta; James.Bottomley@HansenPartnership.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Mahesh Rajashekhara; Murthy Bhat; Gana Sridaran; aacraid@pmc-
> sierra.com; Scott Benesh; jthumshirn@suse.de; shane.seymour@hpe.com;
> David Carroll
> Subject: Re: [PATCH V3 7/9] aacraid: Fix AIF triggered IOP_RESET
> 
> On 15.1.2016 08:16, Raghava Aditya Renukunta wrote:
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
> 
> Hi,
> I don't think that an atomic variable can change it, imagine that
> thread just passed your test in aac_cfg_ioctl and another thread
> enter a bit later the adapter_shutdown so both - an I/O and your shutdown
> code
> will run in parallel.
> Also you need to fix your compat_ioctl path too.
> 
> --tm

Hello Tomas,
Yes that would not solve this problem.
I can think of 2 solutions

1.Place a delay after setting adapter_shutdown and before sending the actual
shutdown command in aac_send_shutdown. This way any impending commands will be 
processed before the adapter  actually receives the shutdown command. Since management 
commands are sync only , shutdown command will be sent last. This solution uses an
estimation of the delay

2.Since  commands are sync , place a check in aac_fib_send to block 
 commands once adapter_shutdown is set(only shutdown command will be sent thru)

I am more inclined to go with option 2.

Regards,
Raghava Aditya

> >
> > Signed-off-by: Raghava Aditya Renukunta
> <raghavaaditya.renukunta@pmcs.com>
> > ---
> >  drivers/scsi/aacraid/aacraid.h  |  2 +-
> >  drivers/scsi/aacraid/comminit.c |  6 +++---
> >  drivers/scsi/aacraid/linit.c    | 15 ++++++++-------
> >  3 files changed, 12 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> > index 2916288..3473668 100644
> > --- a/drivers/scsi/aacraid/aacraid.h
> > +++ b/drivers/scsi/aacraid/aacraid.h
> > @@ -1234,7 +1234,7 @@ struct aac_dev
> >  	int			msi_enabled;	/* MSI/MSI-X enabled */
> >  	struct msix_entry	msixentry[AAC_MAX_MSIX];
> >  	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
> > -	u8			adapter_shutdown;
> > +	atomic_t		adapter_shutdown;
> >  	u32			handle_pci_error;
> >  };
> >
> > diff --git a/drivers/scsi/aacraid/comminit.c
> b/drivers/scsi/aacraid/comminit.c
> > index 0e954e3..d361673 100644
> > --- a/drivers/scsi/aacraid/comminit.c
> > +++ b/drivers/scsi/aacraid/comminit.c
> > @@ -212,8 +212,9 @@ int aac_send_shutdown(struct aac_dev * dev)
> >  		return -ENOMEM;
> >  	aac_fib_init(fibctx);
> >
> > -	cmd = (struct aac_close *) fib_data(fibctx);
> > +	atomic_set(&dev->adapter_shutdown, 1);
> >
> > +	cmd = (struct aac_close *) fib_data(fibctx);
> >  	cmd->command = cpu_to_le32(VM_CloseAll);
> >  	cmd->cid = cpu_to_le32(0xfffffffe);
> >
> > @@ -229,7 +230,6 @@ int aac_send_shutdown(struct aac_dev * dev)
> >  	/* FIB should be freed only after getting the response from the F/W
> */
> >  	if (status != -ERESTARTSYS)
> >  		aac_fib_free(fibctx);
> > -	dev->adapter_shutdown = 1;
> >  	if ((dev->pdev->device == PMC_DEVICE_S7 ||
> >  	     dev->pdev->device == PMC_DEVICE_S8 ||
> >  	     dev->pdev->device == PMC_DEVICE_S9) &&
> > @@ -468,7 +468,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev
> *dev)
> >  	}
> >  	dev->max_msix = 0;
> >  	dev->msi_enabled = 0;
> > -	dev->adapter_shutdown = 0;
> > +	atomic_set(&dev->adapter_shutdown, 0);
> >  	if ((!aac_adapter_sync_cmd(dev,
> GET_COMM_PREFERRED_SETTINGS,
> >  	  0, 0, 0, 0, 0, 0,
> >  	  status+0, status+1, status+2, status+3, status+4))
> > diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> > index 6944560..27b3fcd 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -706,7 +706,7 @@ static long aac_cfg_ioctl(struct file *file,
> >  	int ret;
> >  	struct aac_dev *aac;
> >  	aac = (struct aac_dev *)file->private_data;
> > -	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
> > +	if (!capable(CAP_SYS_RAWIO) || atomic_read(&aac-
> >adapter_shutdown))
> >  		return -EPERM;
> >  	mutex_lock(&aac_mutex);
> >  	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
> > @@ -1078,6 +1078,8 @@ static void __aac_shutdown(struct aac_dev * aac)
> >  	int i;
> >  	int cpu;
> >
> > +	aac_send_shutdown(aac);
> > +
> >  	if (aac->aif_thread) {
> >  		int i;
> >  		/* Clear out events first */
> > @@ -1089,7 +1091,7 @@ static void __aac_shutdown(struct aac_dev * aac)
> >  		}
> >  		kthread_stop(aac->thread);
> >  	}
> > -	aac_send_shutdown(aac);
> > +
> >  	aac_adapter_disable_int(aac);
> >  	cpu = cpumask_first(cpu_online_mask);
> >  	if (aac->pdev->device == PMC_DEVICE_S6 ||
> > @@ -1474,7 +1476,7 @@ static int aac_resume(struct pci_dev *pdev)
> >  	* reset this flag to unblock ioctl() as it was set at
> >  	* aac_send_shutdown() to block ioctls from upperlayer
> >  	*/
> > -	aac->adapter_shutdown = 0;
> > +	atomic_set(&aac->adapter_shutdown, 0);
> >  	scsi_unblock_requests(shost);
> >
> >  	return 0;
> > @@ -1553,9 +1555,8 @@ static pci_ers_result_t
> aac_pci_error_detected(struct pci_dev *pdev,
> >  	case pci_channel_io_normal:
> >  		return PCI_ERS_RESULT_CAN_RECOVER;
> >  	case pci_channel_io_frozen:
> > -
> >  		aac->handle_pci_error = 1;
> > -		aac->adapter_shutdown = 1;
> > +		atomic_set(&aac->adapter_shutdown, 1);
> >
> >  		scsi_block_requests(aac->scsi_host_ptr);
> >  		aac_flush_ios(aac);
> > @@ -1567,7 +1568,7 @@ static pci_ers_result_t
> aac_pci_error_detected(struct pci_dev *pdev,
> >  		return PCI_ERS_RESULT_NEED_RESET;
> >  	case pci_channel_io_perm_failure:
> >  		aac->handle_pci_error = 1;
> > -		aac->adapter_shutdown = 1;
> > +		atomic_set(&aac->adapter_shutdown, 1);
> >
> >  		aac_flush_ios(aac);
> >  		return PCI_ERS_RESULT_DISCONNECT;
> > @@ -1636,7 +1637,7 @@ static void aac_pci_resume(struct pci_dev *pdev)
> >  	 * reset this flag to unblock ioctl() as it was set
> >  	 * at aac_send_shutdown() to block ioctls from upperlayer
> >  	 */
> > -	aac->adapter_shutdown = 0;
> > +	atomic_set(&aac->adapter_shutdown, 0);
> >  	aac->handle_pci_error = 0;
> >
> >  	shost_for_each_device(sdev, shost)

