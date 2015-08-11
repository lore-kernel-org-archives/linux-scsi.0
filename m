From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] cxlflash: Superpipe support
Date: Tue, 11 Aug 2015 17:21:56 -0500
Message-ID: <55CA7584.4020505@linux.vnet.ibm.com>
References: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439270955.14448.91.camel@kernel.crashing.org>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:41486 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbbHKWV7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 18:21:59 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Tue, 11 Aug 2015 16:21:58 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id F2CE61FF002D
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 16:13:05 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7BML18R42926300
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:21:02 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7BMLsRB000301
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 16:21:56 -0600
In-Reply-To: <1439270955.14448.91.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

Ben:

Comments inline below.


On 8/11/2015 12:29 AM, Benjamin Herrenschmidt wrote:
>   So in a similar vein to the previous review, I am missing a lot of
> context here but a few things did spring to me eyes:

Thanks for your review.

>> +	list_for_each_entry_safe(lli, temp, &cfg->lluns, list)
>> +		if (!memcmp(lli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN)) {
>> +			lli->newly_created = false;
>
> This is weird ... a lookup effectively changes the state of the object
> looked up... what for ? There is something oddball here.
>
> It might be legit but in that case, you should really add a comment
> explaining the logic around that 'newly_created' field.

As suggested later, will rename these functions in v5.

> Also you drop the lock right below but you have no refcounting, are
> these objects ever disposed of ?

These objects are long lived. The local lun info structure lives as
long as the card is available, and the global lun info is kept around
as long as the module is loaded.

> In general, can you provide a clearer explanation of what are "global"
> vs "local" LUNs ?

This is a good idea. Will clarify in v5.

> Same ...

Same as above. Will address by renaming.

> Make the function name more explicit: find_or_create_lun() for example.
> I very much dislike a function called "lookup" that has side effects.

Good point. Will rename in v5.


>> +	lli = create_local(sdev, wwid);
>> +	if (unlikely(!lli))
>> +		goto out;
>
> Similar question to earlier, you have no refcounting, should I assume
> these things never get removed ?

Right, these are long lived.


>> +	lli->parent = gli;
>> +	spin_lock_irqsave(&cfg->slock, lock_flags);
>> +	list_add(&lli->list, &cfg->lluns);
>> +	spin_unlock_irqrestore(&cfg->slock, lock_flags);
>> +
>> +	spin_lock_irqsave(&global.slock, lock_flags);
>> +	list_add(&gli->list, &global.gluns);
>> +	spin_unlock_irqrestore(&global.slock, lock_flags);
>
> Your locks are extremely fine grained... too much ? Any reason why you
> don't have a simple/single lock handling all these ? IE, do you expect
> frequent accesses ?
>
> Also, a function called "lookup_something" that has the side effect of
> adding that something to two lists doesn't look great to me. You may
> want to review the function naming a bit.
>
> Finally, what happens if two processes call this trying to effectively
> create the same global LUN simultaneously ?
>
> IE, can't you have a case where both lookup fail, then they both hit the
> create_global() case for the same WWID ? Should you have a single lock
> or a mutex wrapping the whole thing ? That would make the code a lot
> simpler to review as well...

Good catch. Will look into simplifying to a mutex in v5, wrapping the
whole lookup/create sequence.


>> +void cxlflash_list_init(void)
>> +{
>> +	INIT_LIST_HEAD(&global.gluns);
>> +	spin_lock_init(&global.slock);
>> +	global.err_page = NULL;
>> +}
>
> Wouldn't it make the code nicer to have all that LUN management in a
> separate file ?

Good suggestion. Will look at moving these LUN management to a separate
file.

>> +		rc = mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex);
>> +		if (rc)
>> +			goto out;
>
> This can be interrupted by any signal, I assume your userspace deals
> with it ?

That is correct. We do want to be interrupted by any signal (SIGTERM, 
SIGKILL, SIGINT etc.) at this point. We fail the context validation, and 
ultimately the ioctl and leave it to user-space to deal with it.


>> +		rc = mutex_trylock(&ctxi->mutex);
>> +		mutex_unlock(&cfg->ctx_tbl_list_mutex);
>> +		if (!rc)
>> +			goto retry;
>
> Ouch.. that's a nasty one. Are you using the above construct to avoid
> an A->B/B->A deadlock scenario where somebody else might be taking
> the list mutex while holding the context one ?

No, this is not addressing a lock ordering issue. Will clarify with a
comment why the list mutex is being released and reacquired in the
retry loop.


