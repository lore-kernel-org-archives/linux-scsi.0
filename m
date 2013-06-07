From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 3/4] scsi: improved eh timeout handler
Date: Fri, 7 Jun 2013 12:21:08 -0400
Message-ID: <20130607162108.GB25323@logfs.org>
References: <1370511835-50072-1-git-send-email-hare@suse.de>
 <1370511835-50072-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59451 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392Ab3FGRuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 13:50:24 -0400
Content-Disposition: inline
In-Reply-To: <1370511835-50072-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Thu, 6 June 2013 11:43:54 +0200, Hannes Reinecke wrote:
>=20
> +	spin_lock_irqsave(&sdev->list_lock, flags);
> +	list_for_each_entry_safe(scmd, tmp, &sdev->eh_abort_list, eh_entry)=
 {
> +		list_del_init(&scmd->eh_entry);
> +		spin_unlock_irqrestore(&sdev->list_lock, flags);

I never liked the list_for_each_entry_safe() loop but until this
morning couldn't really say why.  The problem is that it can finish
with commands left on the list.  And since your kick_worker checks for
list_empty, there wouldn't be any more aborts.

Thread1		list state		Thread2
		head->1->2->head
spin_lock_irqsave();
scmd =3D 1; tmp =3D 2;
list_del_init(scmd);
spin_unlock_irqrestore();
		head->2->head
					spin_lock_irqsave();
					kick_worker =3D 0;
					list_add();
					spin_unlock_irqrestore();
		head->3->2->head=09
spin_lock_irqsave();
scmd =3D 2; tmp =3D head;
list_del_init(scmd);
spin_unlock_irqrestore();
		head->3->head

And now that I think about nasty races, you could also do
schedule_work() when the list is empty, but the worker thread is still
running.  I've had to debug similar cases and the approach is to waste
a day or five, despair and eventually get lucky half a year later when
you happen to notice the race.  Rare random crashes in the kworker
code a not my favorite sight.

> +void
> +scsi_abort_command(struct scsi_cmnd *scmd)
> +{
> +	unsigned long flags;
> +	int kick_worker =3D 0;
> +	struct scsi_device *sdev =3D scmd->device;
> +
> +	spin_lock_irqsave(&sdev->list_lock, flags);
> +	if (list_empty(&sdev->eh_abort_list))
> +		kick_worker =3D 1;
> +	list_add(&scmd->eh_entry, &sdev->eh_abort_list);
> +	SCSI_LOG_ERROR_RECOVERY(3,
> +		scmd_printk(KERN_INFO, scmd, "adding to eh_abort_list\n"));
> +	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +	if (kick_worker)
> +		schedule_work(&sdev->abort_work);
> +}
> +EXPORT_SYMBOL_GPL(scsi_abort_command);

J=C3=B6rn

--
Time? What's that? Time is only worth what you do with it.
-- Theo de Raadt
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
