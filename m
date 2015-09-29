From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 08/32] cxlflash: Fix to avoid CXL services during EEH
Date: Tue, 29 Sep 2015 14:28:28 -0500
Message-ID: <84B83AB3-F812-416B-9B98-70F6A4EEC880@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443222852-9229-1-git-send-email-mrochs@linux.vnet.ibm.com> <87h9meuouw.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:53872 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964993AbbI2TdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 15:33:09 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 29 Sep 2015 15:33:08 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 853BD38C81EC
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:28:31 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8TJSV3751511460
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 19:28:31 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8TJSTks002414
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:28:31 -0400
In-Reply-To: <87h9meuouw.fsf@gamma.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>, Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Sep 28, 2015, at 6:05 PM, Daniel Axtens <dja@axtens.net> wrote:
> 
> You have two versions of check_state() below, which is a bit
> confusing. It looks like you've moved the function and also added the
> up/down of the read semaphore. I assume that's all that changed?

Correct.

It was originally moved to meet a dependency due to it being defined statically.

> 
>> 
>> /**
>> + * check_state() - checks and responds to the current adapter state
>> + * @cfg:	Internal structure associated with the host.
>> + *
>> + * This routine can block and should only be used on process context.
>> + * It assumes that the caller is an ioctl thread and holding the ioctl
>> + * read semaphore. This is temporarily let up across the wait to allow
>> + * for draining actively running ioctls. Also note that when waking up
>> + * from waiting in reset, the state is unknown and must be checked again
>> + * before proceeding.
>> + *
>> + * Return: 0 on success, -errno on failure
>> + */
>> +static int check_state(struct cxlflash_cfg *cfg)
>> +{
>> +	struct device *dev = &cfg->dev->dev;
>> +	int rc = 0;
>> +
>> +retry:
>> +	switch (cfg->state) {
>> +	case STATE_LIMBO:
>> +		dev_dbg(dev, "%s: Limbo state, going to wait...\n", __func__);
>> +		up_read(&cfg->ioctl_rwsem);
>> +		rc = wait_event_interruptible(cfg->limbo_waitq,
>> +					      cfg->state != STATE_LIMBO);
>> +		down_read(&cfg->ioctl_rwsem);
>> +		if (unlikely(rc))
>> +			break;
>> +		goto retry;
>> +	case STATE_FAILTERM:
>> +		dev_dbg(dev, "%s: Failed/Terminating!\n", __func__);
>> +		rc = -ENODEV;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return rc;
>> +}
>> +
>> +/**
>>  * cxlflash_disk_attach() - attach a LUN to a context
>>  * @sdev:	SCSI device associated with LUN.
>>  * @attach:	Attach ioctl data structure.
>> @@ -1523,41 +1563,6 @@ err1:
>> }
>> 
>> /**
>> - * check_state() - checks and responds to the current adapter state
>> - * @cfg:	Internal structure associated with the host.
>> - *
>> - * This routine can block and should only be used on process context.
>> - * Note that when waking up from waiting in limbo, the state is unknown
>> - * and must be checked again before proceeding.
>> - *
>> - * Return: 0 on success, -errno on failure
>> - */
>> -static int check_state(struct cxlflash_cfg *cfg)
>> -{
>> -	struct device *dev = &cfg->dev->dev;
>> -	int rc = 0;
>> -
>> -retry:
>> -	switch (cfg->state) {
>> -	case STATE_LIMBO:
>> -		dev_dbg(dev, "%s: Limbo, going to wait...\n", __func__);
>> -		rc = wait_event_interruptible(cfg->limbo_waitq,
>> -					      cfg->state != STATE_LIMBO);
>> -		if (unlikely(rc))
>> -			break;
>> -		goto retry;
>> -	case STATE_FAILTERM:
>> -		dev_dbg(dev, "%s: Failed/Terminating!\n", __func__);
>> -		rc = -ENODEV;
>> -		break;
>> -	default:
>> -		break;
>> -	}
>> -
>> -	return rc;
>> -}
>> -
>> -/**
>>  * cxlflash_afu_recover() - initiates AFU recovery
>>  * @sdev:	SCSI device associated with LUN.
>>  * @recover:	Recover ioctl data structure.
>> @@ -1646,9 +1651,14 @@ retry_recover:
>> 	/* Test if in error state */
>> 	reg = readq_be(&afu->ctrl_map->mbox_r);
>> 	if (reg == -1) {
>> -		dev_dbg(dev, "%s: MMIO read fail! Wait for recovery...\n",
>> -			__func__);
>> -		mutex_unlock(&ctxi->mutex);
>> +		dev_dbg(dev, "%s: MMIO fail, wait for recovery.\n", __func__);
>> +
>> +		/*
>> +		 * Before checking the state, put back the context obtained with
>> +		 * get_context() as it is no longer needed and sleep for a short
>> +		 * period of time (see prolog notes).
>> +		 */
>> +		put_context(ctxi);
> 
> Is this needed for the drain to work? It looks like it fixes a
> refcounting bug in the function, but I'm not sure I understand how it
> interacts with the rest of this patch.

This was simply some "while I'm here" refactoring as the commit originally
included a change here. The main point of this change was to replace the
mutex_unlock() with put_context(), which is a wrapper around the unlocking
of the context's mutex.
> 
> Anyway, the patch overall looks good to me, and makes your driver
> interact with CXL's EEH support in the way I intended when I wrote it.

Thanks for reviewing.

