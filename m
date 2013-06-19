From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v3 3/6] [SCSI] Add support for scsi_target events
Date: Wed, 19 Jun 2013 14:49:52 -0400
Message-ID: <1371667792.17420.140.camel@localhost.localdomain>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
	 <1371663761-22481-4-git-send-email-emilne@redhat.com>
	 <51C1F071.8070105@acm.org>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964929Ab3FSStz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jun 2013 14:49:55 -0400
In-Reply-To: <51C1F071.8070105@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, rwheeler@redhat.com

On Wed, 2013-06-19 at 19:54 +0200, Bart Van Assche wrote:
> On 06/19/13 19:42, Ewan D. Milne wrote:
> > +static void starget_evt_emit(struct scsi_target *starget,
> > +			     struct starget_event *evt)
> > +{
> > +	int idx = 0;
> > +	char *envp[3];
> > +
> > +	switch (evt->evt_type) {
> > +	case STARGET_EVT_LUN_CHANGE_REPORTED:
> > +		envp[idx++] = "STARGET_LUN_CHANGE_REPORTED=1";
> > +		break;
> > +	default:
> > +		/* do nothing */
> > +		break;
> > +	}
> > +
> > +	envp[idx++] = NULL;
> > +
> > +	kobject_uevent_env(&starget->dev.kobj, KOBJ_CHANGE, envp);
> > +}
> 
> Sorry but it's not clear to me why the envp[] array has size three while 
> at most two entries are used ? And shouldn't that array be declared as 
> const char*[] instead of char *[] since string constants have type const 
> char[] ?

Hmm.  I copied the code from the (renamed) scsi_evt_emit() which had
char *envp[3], but you are right, only 2 entries are needed.  As far
as the const attribute goes, the signature of kobject_uevent_env() in
include/linux/kobject.h doesn't have the const attribute on the envp
parameter, and other callers don't use const.

> 
> > +		list_for_each_safe(this, tmp, &event_list) {
> > +			evt = list_entry(this, struct starget_event, node);
> 
> Any reason why list_for_each_entry_safe() has not been used here ?

No particular reason, again the code was copied from the (renamed)
sdev_evt_thread(). 

> 
> > +void starget_evt_send(struct scsi_target *starget, struct starget_event *evt)
> > +{
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&starget->list_lock, flags);
> > +	list_add_tail(&evt->node, &starget->event_list);
> > +	schedule_work(&starget->event_work);
> > +	spin_unlock_irqrestore(&starget->list_lock, flags);
> > +}
> 
> Is it necessary here to invoke schedule_work() under protection of 
> list_lock, or would it be safe to invoke schedule_work() after the 
> spin_unlock_irqrestore() ?

I think the call to schedule_work() can be moved outside, the lock, I'll
have to verify that.

> 
> > +#ifdef CONFIG_SCSI_ENHANCED_UA
> > +	struct list_head *this, *tmp;
> > +
> > +	cancel_work_sync(&starget->event_work);
> > +
> > +	list_for_each_safe(this, tmp, &starget->event_list) {
> > +		struct starget_event *evt;
> >
> > +		evt = list_entry(this, struct starget_event, node);
> > +		list_del(&evt->node);
> > +		kfree(evt);
> > +	}
> > +#endif
> 
> Same question here: any reason why list_for_each_entry_safe() has not 
> been used ?

Same answer:  the code came from scsi_device_dev_release_usercontext().

I see that James would prefer that the events be unified rather than
specific to scsi_device or scsi_target, so I'll remove the duplication.

Thanks for the comments.

-Ewan

> 
> Thanks,
> 
> Bart.


