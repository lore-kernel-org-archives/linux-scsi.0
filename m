From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v4 2/3] cxlflash: Superpipe support
Date: Tue, 11 Aug 2015 15:29:15 +1000
Message-ID: <1439270955.14448.91.camel@kernel.crashing.org>
References: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:34154 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbbHKFaK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 01:30:10 -0400
In-Reply-To: <1439226588-7886-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On Mon, 2015-08-10 at 12:09 -0500, Matthew R. Ochs wrote:
> Add superpipe supporting infrastructure to device driver for the IBM CXL
> Flash adapter. This patch allows userspace applications to take advantage
> of the accelerated I/O features that this adapter provides and bypass the
> traditional filesystem stack.

 So in a similar vein to the previous review, I am missing a lot of
context here but a few things did spring to me eyes:

> +/**
> + * lookup_local() - find a local LUN information structure by WWID
> + * @cfg:	Internal structure associated with the host.
> + * @wwid:	WWID associated with LUN.
> + *
> + * Return: Found local lun_info structure on success, NULL on failure
> + */
> +static struct llun_info *lookup_local(struct cxlflash_cfg *cfg, u8 *wwid)
> +{
> +	struct llun_info *lli, *temp;
> +	ulong lock_flags;
> +
> +	spin_lock_irqsave(&cfg->slock, lock_flags);
> +
> +	list_for_each_entry_safe(lli, temp, &cfg->lluns, list)
> +		if (!memcmp(lli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN)) {
> +			lli->newly_created = false;

This is weird ... a lookup effectively changes the state of the object
looked up... what for ? There is something oddball here.

It might be legit but in that case, you should really add a comment
explaining the logic around that 'newly_created' field.

Also you drop the lock right below but you have no refcounting, are
these objects ever disposed of ?

In general, can you provide a clearer explanation of what are "global"
vs "local" LUNs ?

> +			spin_unlock_irqrestore(&cfg->slock, lock_flags);
> +			return lli;
> +		}
> +
> +	spin_unlock_irqrestore(&cfg->slock, lock_flags);
> +	return NULL;
> +}
> +
> +/**
> + * lookup_global() - find a global LUN information structure by WWID
> + * @wwid:	WWID associated with LUN.
> + *
> + * Return: Found global lun_info structure on success, NULL on failure
> + */
> +static struct glun_info *lookup_global(u8 *wwid)
> +{
> +	struct glun_info *gli, *temp;
> +	ulong lock_flags;
> +
> +	spin_lock_irqsave(&global.slock, lock_flags);
> +
> +	list_for_each_entry_safe(gli, temp, &global.gluns, list)
> +		if (!memcmp(gli->wwid, wwid, DK_CXLFLASH_MANAGE_LUN_WWID_LEN)) {
> +			spin_unlock_irqrestore(&global.slock, lock_flags);
> +			return gli;
> +		}
> +
> +	spin_unlock_irqrestore(&global.slock, lock_flags);
> +	return NULL;
> +}

Same ...

> +/**
> + * lookup_lun() - find or create a local LUN information structure
> + * @sdev:	SCSI device associated with LUN.
> + * @wwid:	WWID associated with LUN.
> + *
> + * When a local LUN is not found and a global LUN is also not found, both
> + * a global LUN and local LUN are created. The global LUN is added to the
> + * global list and the local LUN is returned.

Make the function name more explicit: find_or_create_lun() for example.
I very much dislike a function called "lookup" that has side effects.

> + * Return: Found/Allocated local lun_info structure on success, NULL on failure
> + */
> +static struct llun_info *lookup_lun(struct scsi_device *sdev, u8 *wwid)
> +{
> +	struct llun_info *lli = NULL;
> +	struct glun_info *gli = NULL;
> +	struct Scsi_Host *shost = sdev->host;
> +	struct cxlflash_cfg *cfg = shost_priv(shost);
> +	ulong lock_flags;
> +
> +	if (unlikely(!wwid))
> +		goto out;
> +
> +	lli = lookup_local(cfg, wwid);
> +	if (lli)
> +		goto out;
> +
> +	lli = create_local(sdev, wwid);
> +	if (unlikely(!lli))
> +		goto out;

Similar question to earlier, you have no refcounting, should I assume
these things never get removed ?

> +	gli = lookup_global(wwid);
> +	if (gli) {
> +		lli->parent = gli;
> +		spin_lock_irqsave(&cfg->slock, lock_flags);
> +		list_add(&lli->list, &cfg->lluns);
> +		spin_unlock_irqrestore(&cfg->slock, lock_flags);
> +		goto out;
> +	}
> +
> +	gli = create_global(sdev, wwid);
> +	if (unlikely(!gli)) {
> +		kfree(lli);
> +		lli = NULL;
> +		goto out;
> +	}
> +
> +	lli->parent = gli;
> +	spin_lock_irqsave(&cfg->slock, lock_flags);
> +	list_add(&lli->list, &cfg->lluns);
> +	spin_unlock_irqrestore(&cfg->slock, lock_flags);
> +
> +	spin_lock_irqsave(&global.slock, lock_flags);
> +	list_add(&gli->list, &global.gluns);
> +	spin_unlock_irqrestore(&global.slock, lock_flags);

Your locks are extremely fine grained... too much ? Any reason why you
don't have a simple/single lock handling all these ? IE, do you expect
frequent accesses ?

Also, a function called "lookup_something" that has the side effect of
adding that something to two lists doesn't look great to me. You may
want to review the function naming a bit.

Finally, what happens if two processes call this trying to effectively
create the same global LUN simultaneously ?

IE, can't you have a case where both lookup fail, then they both hit the
create_global() case for the same WWID ? Should you have a single lock
or a mutex wrapping the whole thing ? That would make the code a lot
simpler to review as well...

> +out:
> +	pr_debug("%s: returning %p\n", __func__, lli);
> +	return lli;
> +}
> +
> +/**
> + * cxlflash_term_luns() - Delete all entries from local lun list, free.
> + * @cfg:	Internal structure associated with the host.
> + */
> +void cxlflash_term_luns(struct cxlflash_cfg *cfg)
> +{
> +	struct llun_info *lli, *temp;
> +	ulong lock_flags;
> +
> +	spin_lock_irqsave(&cfg->slock, lock_flags);
> +	list_for_each_entry_safe(lli, temp, &cfg->lluns, list) {
> +		list_del(&lli->list);
> +		kfree(lli);
> +	}
> +	spin_unlock_irqrestore(&cfg->slock, lock_flags);
> +}
> +
> +/**
> + * cxlflash_list_init() - initializes the global LUN list
> + */
> +void cxlflash_list_init(void)
> +{
> +	INIT_LIST_HEAD(&global.gluns);
> +	spin_lock_init(&global.slock);
> +	global.err_page = NULL;
> +}

Wouldn't it make the code nicer to have all that LUN management in a
separate file ?

> +/**
> + * cxlflash_list_terminate() - frees resources associated with global LUN list
> + */
> +void cxlflash_list_terminate(void)
> +{
> +	struct glun_info *gli, *temp;
> +	ulong flags = 0;
> +
> +	spin_lock_irqsave(&global.slock, flags);
> +	list_for_each_entry_safe(gli, temp, &global.gluns, list) {
> +		list_del(&gli->list);
> +		kfree(gli);
> +	}
> +
> +	if (global.err_page) {
> +		__free_page(global.err_page);
> +		global.err_page = NULL;
> +	}
> +	spin_unlock_irqrestore(&global.slock, flags);
> +}
> +
> +/**
> + * cxlflash_stop_term_user_contexts() - stops/terminates known user contexts
> + * @cfg:	Internal structure associated with the host.
> + *
> + * When the host needs to go down, all users must be quiesced and their
> + * memory freed. This is accomplished by putting the contexts in error
> + * state which will notify the user and let them 'drive' the teardown.
> + * Meanwhile, this routine camps until all user contexts have been removed.
> + */
> +void cxlflash_stop_term_user_contexts(struct cxlflash_cfg *cfg)
> +{
> +	int i, found;
> +
> +	cxlflash_mark_contexts_error(cfg);
> +
> +	while (true) {
> +		found = false;
> +
> +		for (i = 0; i < MAX_CONTEXT; i++)
> +			if (cfg->ctx_tbl[i]) {
> +				found = true;
> +				break;
> +			}
> +
> +		if (!found && list_empty(&cfg->ctx_err_recovery))
> +			return;
> +
> +		pr_debug("%s: Wait for user context to quiesce...\n", __func__);
> +		wake_up_all(&cfg->limbo_waitq);
> +		ssleep(1);
> +	}
> +}
> +
> +/**
> + * find_error_context() - locates a context by cookie on the error recovery list
> + * @cfg:	Internal structure associated with the host.
> + * @rctxid:	Desired context by id.
> + * @file:	Desired context by file.
> + *
> + * Return: Found context on success, NULL on failure
> + */
> +static struct ctx_info *find_error_context(struct cxlflash_cfg *cfg, u64 rctxid,
> +					   struct file *file)
> +{
> +	struct ctx_info *ctxi;
> +
> +	list_for_each_entry(ctxi, &cfg->ctx_err_recovery, list)
> +		if ((ctxi->ctxid == rctxid) || (ctxi->file == file))
> +			return ctxi;
> +
> +	return NULL;
> +}
> +
> +/**
> + * get_context() - obtains a validated and locked context reference
> + * @cfg:	Internal structure associated with the host.
> + * @rctxid:	Desired context (raw, undecoded format).
> + * @arg:	LUN information or file associated with request.
> + * @ctx_ctrl:	Control information to 'steer' desired lookup.
> + *
> + * NOTE: despite the name pid, in linux, current->pid actually refers
> + * to the lightweight process id (tid) and can change if the process is
> + * multi threaded. The tgid remains constant for the process and only changes
> + * when the process of fork. For all intents and purposes, think of tgid
> + * as a pid in the traditional sense.
> + *
> + * Return: Validated context on success, NULL on failure
> + */
> +struct ctx_info *get_context(struct cxlflash_cfg *cfg, u64 rctxid,
> +			     void *arg, enum ctx_ctrl ctx_ctrl)
> +{
> +	struct ctx_info *ctxi = NULL;
> +	struct lun_access *lun_access = NULL;
> +	struct file *file = NULL;
> +	struct llun_info *lli = arg;
> +	u64 ctxid = DECODE_CTXID(rctxid);
> +	int rc;
> +	pid_t pid = current->tgid, ctxpid = 0;
> +
> +	if (ctx_ctrl & CTX_CTRL_FILE) {
> +		lli = NULL;
> +		file = (struct file *)arg;
> +	}
> +
> +	if (ctx_ctrl & CTX_CTRL_CLONE)
> +		pid = current->parent->tgid;
> +
> +	if (likely(ctxid < MAX_CONTEXT)) {
> +retry:
> +		rc = mutex_lock_interruptible(&cfg->ctx_tbl_list_mutex);
> +		if (rc)
> +			goto out;

This can be interrupted by any signal, I assume your userspace deals
with it ?

> +		ctxi = cfg->ctx_tbl[ctxid];
> +		if (ctxi)
> +			if ((file && (ctxi->file != file)) ||
> +			    (!file && (ctxi->ctxid != rctxid)))
> +				ctxi = NULL;
> +
> +		if ((ctx_ctrl & CTX_CTRL_ERR) ||
> +		    (!ctxi && (ctx_ctrl & CTX_CTRL_ERR_FALLBACK)))
> +			ctxi = find_error_context(cfg, rctxid, file);
> +		if (!ctxi) {
> +			mutex_unlock(&cfg->ctx_tbl_list_mutex);
> +			goto out;
> +		}
> +
> +		/*
> +		 * Need to acquire ownership of the context while still under
> +		 * the table/list lock to serialize with a remove thread. Use
> +		 * the 'try' to avoid stalling the table/list lock for a single
> +		 * context.
> +		 */
> +		rc = mutex_trylock(&ctxi->mutex);
> +		mutex_unlock(&cfg->ctx_tbl_list_mutex);
> +		if (!rc)
> +			goto retry;

Ouch.. that's a nasty one. Are you using the above construct to avoid
an A->B/B->A deadlock scenario where somebody else might be taking
the list mutex while holding the context one ?

I'm running out of time for today, but at least here is a partial
review.

Cheers,
Ben.



