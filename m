From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 3/6] [SCSI] Add support for scsi_target events
Date: Wed, 19 Jun 2013 19:54:57 +0200
Message-ID: <51C1F071.8070105@acm.org>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com> <1371663761-22481-4-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:50051 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3FSRzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jun 2013 13:55:01 -0400
In-Reply-To: <1371663761-22481-4-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, rwheeler@redhat.com

On 06/19/13 19:42, Ewan D. Milne wrote:
> +static void starget_evt_emit(struct scsi_target *starget,
> +			     struct starget_event *evt)
> +{
> +	int idx = 0;
> +	char *envp[3];
> +
> +	switch (evt->evt_type) {
> +	case STARGET_EVT_LUN_CHANGE_REPORTED:
> +		envp[idx++] = "STARGET_LUN_CHANGE_REPORTED=1";
> +		break;
> +	default:
> +		/* do nothing */
> +		break;
> +	}
> +
> +	envp[idx++] = NULL;
> +
> +	kobject_uevent_env(&starget->dev.kobj, KOBJ_CHANGE, envp);
> +}

Sorry but it's not clear to me why the envp[] array has size three while 
at most two entries are used ? And shouldn't that array be declared as 
const char*[] instead of char *[] since string constants have type const 
char[] ?

> +		list_for_each_safe(this, tmp, &event_list) {
> +			evt = list_entry(this, struct starget_event, node);

Any reason why list_for_each_entry_safe() has not been used here ?

> +void starget_evt_send(struct scsi_target *starget, struct starget_event *evt)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&starget->list_lock, flags);
> +	list_add_tail(&evt->node, &starget->event_list);
> +	schedule_work(&starget->event_work);
> +	spin_unlock_irqrestore(&starget->list_lock, flags);
> +}

Is it necessary here to invoke schedule_work() under protection of 
list_lock, or would it be safe to invoke schedule_work() after the 
spin_unlock_irqrestore() ?

> +#ifdef CONFIG_SCSI_ENHANCED_UA
> +	struct list_head *this, *tmp;
> +
> +	cancel_work_sync(&starget->event_work);
> +
> +	list_for_each_safe(this, tmp, &starget->event_list) {
> +		struct starget_event *evt;
>
> +		evt = list_entry(this, struct starget_event, node);
> +		list_del(&evt->node);
> +		kfree(evt);
> +	}
> +#endif

Same question here: any reason why list_for_each_entry_safe() has not 
been used ?

Thanks,

Bart.
