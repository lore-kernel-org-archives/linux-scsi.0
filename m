From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V4 3/4] Introduce XEN scsiback module
Date: Tue, 12 Aug 2014 14:29:48 +0200
Message-ID: <53EA08BC.90809@suse.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>	<1407484194-31876-4-git-send-email-jgross@suse.com> <20140811181436.GA14313@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140811181436.GA14313@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

On 08/11/2014 08:14 PM, Christoph Hellwig wrote:
>> +#include <scsi/scsi_dbg.h>

__scsi_print_sense()

>> +#include <scsi/scsi_eh.h>

struct scsi_sense_hdr

>> +#include <scsi/scsi_tcq.h>

SG_ALL

>
> What do you need these for?  Normally target drivers shouldn't need
> these.
>
>> +struct vscsibk_emulate {
>> +	void (*pre_function)(struct vscsibk_pend *, void *);
>> +	void (*post_function)(struct vscsibk_pend *, void *);
>> +};
>
> This doesn't seem to be used.

Correct. Will delete.

>
>> +#define scsiback_get(_b) (atomic_inc(&(_b)->nr_unreplied_reqs))
>> +#define scsiback_put(_b)				\
>> +	do {						\
>> +		if (atomic_dec_and_test(&(_b)->nr_unreplied_reqs))	\
>> +			wake_up(&(_b)->waiting_to_free);\
>> +	} while (0)
>
> Normal Linux style would be to make these inline functions.

Okay. I'll change those.

>
>> +static void scsiback_notify_work(struct vscsibk_info *info)
>> +{
>> +	info->waiting_reqs = 1;
>> +	wake_up(&info->wq);
>> +}
>> +
>> +static irqreturn_t scsiback_intr(int irq, void *dev_id)
>> +{
>> +	scsiback_notify_work((struct vscsibk_info *)dev_id);
>> +	return IRQ_HANDLED;
>> +}
>
> Seems like this driver should get the same threaded irq treatment as
> the initiator side?

Indeed.

>
>> +static void scsiback_disconnect(struct vscsibk_info *info)
>> +{
>> +	if (info->kthread) {
>> +		kthread_stop(info->kthread);
>> +		info->kthread = NULL;
>> +		wake_up(&info->shutdown_wq);
>> +	}
>> +
>> +	wait_event(info->waiting_to_free,
>> +		atomic_read(&info->nr_unreplied_reqs) == 0);
>> +
>> +	if (info->irq) {
>> +		unbind_from_irqhandler(info->irq, info);
>> +		info->irq = 0;
>> +	}
>> +
>> +	if (info->ring.sring) {
>> +		xenbus_unmap_ring_vfree(info->dev, info->ring.sring);
>> +		info->ring.sring = NULL;
>> +	}
>> +}
>
> Also the same treatment for goto based init failure unwinding.

Yep.


Juergen
