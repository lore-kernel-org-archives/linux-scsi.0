From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 08/30] cxlflash: Fix to avoid CXL services during EEH
Date: Fri, 18 Sep 2015 18:54:52 -0500
Message-ID: <69F80CC5-8031-4CAE-AC49-373E9CB9419B@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com> <1442438877-49469-1-git-send-email-mrochs@linux.vnet.ibm.com> <55FC13A5.1080301@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:51875 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbbIRXy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2015 19:54:56 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 18 Sep 2015 17:54:56 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id B9EAB19D8040
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 17:45:47 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8INsssM62718116
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 16:54:54 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8INsq33024492
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 17:54:54 -0600
In-Reply-To: <55FC13A5.1080301@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 18, 2015, at 8:37 AM, Brian King <brking@linux.vnet.ibm.com> wrote:
> On 09/16/2015 04:27 PM, Matthew R. Ochs wrote:
>> 
>> /**
>> + * drain_ioctls() - wait until all currently executing ioctls have completed
>> + * @cfg:	Internal structure associated with the host.
>> + *
>> + * Obtain write access to read/write semaphore that wraps ioctl
>> + * handling to 'drain' ioctls currently executing.
>> + */
>> +static void drain_ioctls(struct cxlflash_cfg *cfg)
>> +{
>> +	down_write(&cfg->ioctl_rwsem);
>> +	up_write(&cfg->ioctl_rwsem);
>> +}
>> +
>> +/**
>>  * cxlflash_pci_error_detected() - called when a PCI error is detected
>>  * @pdev:	PCI device struct.
>>  * @state:	PCI channel state.
>> @@ -2383,16 +2397,14 @@ static pci_ers_result_t cxlflash_pci_error_detected(struct pci_dev *pdev,
>> 	switch (state) {
>> 	case pci_channel_io_frozen:
>> 		cfg->state = STATE_LIMBO;
>> -
>> -		/* Turn off legacy I/O */
>> 		scsi_block_requests(cfg->host);
>> +		drain_ioctls(cfg);
> 
> So, what kicks any outstanding ioctls back? Let's assume you are in the middle of disk_attach
> and you've sent the READ_CAP16 to the device. It appears as if what would happen here is we'd
> sit here in cxlflash_pci_error_detected. Eventually, the READ_CAP16 would timeout. This would
> wake the SCSI error handler, and end up calling your eh_device_reset handler, which would see that
> we are in STATE_LIMBO, where it would then do a wait_event, waiting for us to get out of STATE_LIMBO,
> and we would end up in a deadlock.
> 
> Rather than implementing a rw semaphore, would it be better to simply make the ioctls check the
> state we are in and either wait to get out of EEH state or fail themselves?

We do have the ioctls check the state and wait for EEH to complete
or fail completely in the event that the device is terminating (see
ioctl_common()). The drain exists to create a wait point for ioctls that
have already passed the state check and are active. The CXL services
cannot be called during the recovery window (maybe this requirement
will go away in a future release?), thus the reason for this 'drain'.

To handle it I considered 3 options:

 - add state check wraps to all CXL service calls
 - create a "running ioctls" count that could be evaluated
 - wrap the ioctl in read semaphore and obtain write access to 'wait'

I started with the first option and it quickly made the code very nasty. I then
began implementing the second option and as I was writing the code to wrap
the ioctl with increment/decrement statements, the third option entered my
mind and seemed like a much cleaner solution. Therefore I went with that
approach and did not look back.

With regard to your example, you bring up a good point and we'll need to
do something about that. One thought that comes to mind would be for us
to drop the semaphore before making this type of call (I believe there are
only 2 places like this), reacquiring it when we return, and then checking
the state to make sure we're not in a reset situation.

> 
>> 		rc = cxlflash_mark_contexts_error(cfg);
>> 		if (unlikely(rc))
>> 			dev_err(dev, "%s: Failed to mark user contexts!(%d)\n",
>> 				__func__, rc);
>> 		term_mc(cfg, UNDO_START);
>> 		stop_afu(cfg);
>> -
>> 		return PCI_ERS_RESULT_NEED_RESET;
>> 	case pci_channel_io_perm_failure:
>> 		cfg->state = STATE_FAILTERM;
>> diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
>> index cf2a85d..8a18230 100644
>> --- a/drivers/scsi/cxlflash/superpipe.c
>> +++ b/drivers/scsi/cxlflash/superpipe.c
>> @@ -1214,6 +1214,48 @@ static const struct file_operations null_fops = {
>> };
>> 
>> /**
>> + * check_state() - checks and responds to the current adapter state
>> + * @cfg:	Internal structure associated with the host.
>> + * @ioctl:	Indicates if on an ioctl thread.
>> + *
>> + * This routine can block and should only be used on process context.
>> + * When blocking on an ioctl thread, the ioctl read semaphore should be
>> + * let up to allow for draining actively running ioctls. Also note that
>> + * when waking up from waiting in reset, the state is unknown and must
>> + * be checked again before proceeding.
>> + *
>> + * Return: 0 on success, -errno on failure
>> + */
>> +static int check_state(struct cxlflash_cfg *cfg, bool ioctl)
> 
> All your callers appear to set the second parameter to true, so why bother having it?

That's a good point. I originally had a case where there was a need for this
but have since removed it. I can fix that in v3.

