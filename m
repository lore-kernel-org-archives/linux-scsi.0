From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 10 Jun 2013 11:47:08 -0400
Message-ID: <20130610154708.GC18076@logfs.org>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
 <1370850058-27613-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59511 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3FJRQe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jun 2013 13:16:34 -0400
Content-Disposition: inline
In-Reply-To: <1370850058-27613-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Mon, 10 June 2013 09:40:52 +0200, Hannes Reinecke wrote:
> +
> +	spin_lock_irqsave(&sdev->list_lock, flags);
> +	if (list_empty(&sdev->eh_abort_list))
> +		kick_worker =3D 1;
> +	list_add(&scmd->eh_entry, &sdev->eh_abort_list);
> +	spin_unlock_irqrestore(&sdev->list_lock, flags);
> +	SCSI_LOG_ERROR_RECOVERY(3,
> +		scmd_printk(KERN_INFO, scmd, "adding to eh_abort_list\n"));
> +	if (kick_worker)
> +		schedule_work(&sdev->abort_work);

You fixed the case with the non-empty list.  But afaics the same
workitem can still be called multiple times simultaneously, which will
crash the system.

J=C3=B6rn

--
The only real mistake is the one from which we learn nothing.
-- John Powell
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
