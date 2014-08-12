From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V4 3/4] Introduce XEN scsiback module
Date: Tue, 12 Aug 2014 14:52:17 +0200
Message-ID: <53EA0E01.2060409@suse.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>	<1407484194-31876-4-git-send-email-jgross@suse.com>	<20140811181436.GA14313@infradead.org> <53EA08BC.90809@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaHLMwT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2014 08:52:19 -0400
In-Reply-To: <53EA08BC.90809@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com

On 08/12/2014 02:29 PM, Juergen Gross wrote:
> On 08/11/2014 08:14 PM, Christoph Hellwig wrote:
>>> +static void scsiback_notify_work(struct vscsibk_info *info)
>>> +{
>>> +    info->waiting_reqs = 1;
>>> +    wake_up(&info->wq);
>>> +}
>>> +
>>> +static irqreturn_t scsiback_intr(int irq, void *dev_id)
>>> +{
>>> +    scsiback_notify_work((struct vscsibk_info *)dev_id);
>>> +    return IRQ_HANDLED;
>>> +}
>>
>> Seems like this driver should get the same threaded irq treatment as
>> the initiator side?
>
> Indeed.

Turns out to be hard. The interrupt is allocated via
bind_interdomain_evtchn_to_irqhandler() which is not capable of threaded
irq handling. The underlying bind_interdomain_evtchn_to_irq() is not
exported, so I can't use it.

I'll try to change this, but until then I have to leave the irq handling
more or less the same.


Juergen
