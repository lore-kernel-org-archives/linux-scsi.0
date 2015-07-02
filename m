From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] cxlflash: Base superpipe support
Date: Thu, 2 Jul 2015 11:57:23 -0500
Message-ID: <B0A9DA87-21F9-4C48-B535-13F222612F5B@linux.vnet.ibm.com>
References: <1434753473-6218-1-git-send-email-mrochs@linux.vnet.ibm.com> <1435819179.28784.41.camel@neuling.org>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:54671 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbbGBQ6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2015 12:58:16 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 2 Jul 2015 12:58:15 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 8F4BB38C8026
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2015 12:58:06 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t62Gw6YH57999598
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jul 2015 16:58:06 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t62Gw3VH026394
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jul 2015 12:58:06 -0400
In-Reply-To: <1435819179.28784.41.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, "brking@linux.vnet.ibm.com King" <brking@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, "imunsie@au1.ibm.com Munsie" <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Mikey,

Thanks for reviewing. Responses are inline below.


-matt

On Jul 2, 2015, at 1:39 AM, Michael Neuling wrote:
> On Fri, 2015-06-19 at 17:37 -0500, Matthew R. Ochs wrote:
>> 
>> --- a/drivers/scsi/cxlflash/common.h
>> +++ b/drivers/scsi/cxlflash/common.h
>> @@ -103,6 +103,14 @@ struct cxlflash_cfg {
>> 	struct pci_pool *cxlflash_cmd_pool;
>> 	struct pci_dev *parent_dev;
>> 
>> +	spinlock_t ctx_tbl_slock;
> 
> From the code, it's not clear to me what this lock is actually
> protecting.  Writes to the pointers can be atomic.  Are two pointers
> needed to be written atomically?
> 
> So is it the contents of what it's pointing to?  That doesn't seem
> correct ether as the contents are written outside of the lock

So this lock is serving two purposes:

First, we use it to serialize updates to the table. There are cases (not included in
this patch) where we want to clear the entire table while avoiding updates to it.

Second, by using it to serialize the table in conjunction with an atomic run count,
it allows us to obtain a context reference without having to worry about a removal
thread yanking the memory from under us. When we return from get_context() with
a non-NULL reference, we are guaranteed that reference will not be freed until
that thread of execution completes (the run count [nrefs] in the context is atomically
decremented). 

>> +#include "sislite.h"
>> +#include "common.h"
>> +#include "superpipe.h"
>> +
>> +struct cxlflash_global global;
> 
> Can this be static?

Why yes it can...done!

>> +		/*
>> +		 * Increment the reference count under lock so the context
>> +		 * is not yanked from under us on a removal thread.
>> +		 */
>> +		atomic_inc(&ctx_info->nrefs);
>> +		spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
> 
> There is no memory barrier here to ensure ctx_info->pid has been
> flushed.

I don't think we need one. The pid is only set when the context is created,
thus, the user won't be trying to issue other ioctls using this context until
after a successful return from attach. 

> 
>> +		ctxpid = ctx_info->pid;
>> +		if (likely(!(ctx_ctrl & CTX_CTRL_NOPID)))
>> +			if (pid != ctxpid)
>> +				goto denied;


>> +
>> +	/* Free the context; note that rht_lun was allocated at same time */
>> +	kfree(ctx_info);
>> +	cfg->num_user_contexts--;
> 
> This seems racey. If two people are calling the destroy ioctl at the
> same time they will race on updating cfg->num_user_contexts;

Sure, we can make this atomic.

>> +	ctx_info->pid = current->tgid; /* tgid = pid */
>> +	ctx_info->ctx = ctx;
>> +	INIT_LIST_HEAD(&ctx_info->luns);
>> +	INIT_LIST_HEAD(&ctx_info->luns);
> 
> Why this twice?

Because I goofed. Will fix.

> 
> 
>> +	atomic_set(&ctx_info->nrefs, 1);
>> +
>> +	cfg->num_user_contexts++;
> 
> Does this need to be atomic too?  Can't two people call this ioctl at
> the same time?

Yep.

>> +		spin_lock_irqsave(&cfg->ctx_tbl_slock, flags);
>> +		cfg->ctx_tbl[ctxid] = NULL;
>> +		spin_unlock_irqrestore(&cfg->ctx_tbl_slock, flags);
> 
> Not sure you need a lock here.  This NULL write should be atomic.

Covered in earlier comments.

>> +
>> +	/* Translate read/write O_* flags from fcntl.h to AFU permission bits */
>> +	perms = SISL_RHT_PERM(attach->hdr.flags + 1);
>> +
>> +	ctx_info = create_context(cfg, ctx, ctxid, fd, perms);
> 
> I don't see a memory barrier between this create context and the
> insertion in the cfg->ctx_tbl table.  It concerns me we could have a
> race when accessing it.  same on the read side 

Regarding race conditions with the slot in the array, we're protected so long
as your code doesn't have a bug in doling out process elements (context id). =)

Regarding a memory barrier, aren't we not covered implicitly because of access
being tucked under a spin lock? Or was this concern in the context of us not
using a lock (per your previous comments).

>> 
>> +	/*
>> +	 * No error paths after this point. Once the fd is installed it's
>> +	 * visible to user space and can't be undone safely on this thread.
>> +	 */
>> +	list_add(&lun_access->list, &ctx_info->luns);
>> +	cfg->ctx_tbl[ctxid] = ctx_info;

To be consistent we should be locking here.

>> +	fd_install(fd, file);
>> +
>> +out_attach:
>> +	attach->hdr.return_flags = 0;
>> +	attach->context_id = ctx_info->ctxid;
>> +	attach->block_size = lun_info->blk_len;
>> +	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
>> +	attach->last_lba = lun_info->max_lba;
>> +	attach->max_xfer = (sdev->host->max_sectors * 512) / lun_info->blk_len;

>> +	/*
>> +	 * No error paths after this point. Once the fd is installed it's
>> +	 * visible to user space and can't be undone safely on this thread.
>> +	 */
>> +	ctx_info->ctxid = ENCODE_CTXID(ctx_info, ctxid);
>> +	ctx_info->lfd = fd;
>> +	ctx_info->ctx = ctx;
> 
> No memory barrier here.  Seem like we could race in get_context() when
> we dereference ctx_info;
> 
>> +	cfg->ctx_tbl[ctxid] = ctx_info;

Same comment as in attach, I should be under lock here.

>> +
>> +#ifndef _CXLFLASH_SUPERPIPE_H
>> +#define _CXLFLASH_SUPERPIPE_H
>> +
>> +extern struct cxlflash_global global;
> 
> Can this be static to superpipe.c?

Done.

>> diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
>> new file mode 100644
>> index 0000000..dd1f954
>> --- /dev/null
>> +++ b/include/uapi/scsi/cxlflash_ioctl.h
> 
> You need to add this to the kbuild file so that "make headers" will
> export it.

Done.

>> + */
>> +#define DK_CXLFLASH_ATTACH_REUSE_CONTEXT	0x8000000000000000ULL
>> +
> 
> We might want to create some flags and padding to allow for expansion of
> these later. 

So the common header struct has a place for lots of flags and some expansion but
I can see where it would be helpful to add some reserved space to each of the individual
ioctls. I think our current thinking was that we'd just handle that with versioning but I'm fine
with growing these structs a bit now.

> 
> I'd also suggest reading
> http://blog.ffwll.ch/2013/11/botching-up-ioctls.html
> 

Looks like a good read, thanks!

