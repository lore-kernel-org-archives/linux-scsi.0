From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 3/4] scsi: improved eh timeout handler
Date: Thu, 6 Jun 2013 16:28:26 -0400
Message-ID: <20130606202826.GB17707@logfs.org>
References: <1370511835-50072-1-git-send-email-hare@suse.de>
 <1370511835-50072-4-git-send-email-hare@suse.de>
 <20130606162320.GC16616@logfs.org>
 <51B0F372.6040702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59433 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3FFV5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jun 2013 17:57:41 -0400
Content-Disposition: inline
In-Reply-To: <51B0F372.6040702@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Thu, 6 June 2013 22:39:14 +0200, Hannes Reinecke wrote:
>=20
> >>+		spin_unlock_irqrestore(&sdev->list_lock, flags);
> >>+		SCSI_LOG_ERROR_RECOVERY(3,
> >>+			scmd_printk(KERN_INFO, scmd,
> >>+				    "aborting command %p\n", scmd));
> >>+		rtn =3D scsi_try_to_abort_cmd(shost->hostt, scmd);
> >>+		if (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL) {
> >>+			if (((scmd->request->cmd_flags & REQ_FAILFAST_DEV) ||
> >
> >Am I being stupid again or should this be negated?
> >
> Knowing you I would think the former; where do you see the negation?

If REQ_FAILFAST_DEV is set, this runs scsi_queue_insert(), which I
would expect it should run scsi_finish_command().

> >>+			     (scmd->request->cmd_type =3D=3D REQ_TYPE_BLOCK_PC)) &&
> >>+			    (++scmd->retries <=3D scmd->allowed)) {
> >>+				SCSI_LOG_ERROR_RECOVERY(3,
> >>+					scmd_printk(KERN_WARNING, scmd,
> >>+						    "retry aborted command\n"));
> >>+
> >>+				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> >>+			} else {
> >>+				SCSI_LOG_ERROR_RECOVERY(3,
> >>+					scmd_printk(KERN_WARNING, scmd,
> >>+						    "fast fail aborted command\n"));
> >>+				scmd->result |=3D DID_TRANSPORT_FAILFAST << 16;
> >>+				scsi_finish_command(scmd);
> >>+			}
> >>+		} else {
> >>+			if (!scsi_eh_scmd_add(scmd, 0)) {
> >>+				SCSI_LOG_ERROR_RECOVERY(3,
> >>+					scmd_printk(KERN_WARNING, scmd,
> >>+						    "terminate aborted command\n"));
> >>+				scmd->result |=3D DID_TIME_OUT << 16;
> >>+				scsi_finish_command(scmd);
> >>+			}
> >>+		}
> >>+		spin_lock_irqsave(&sdev->list_lock, flags);
> >>+	}
> >>+	spin_unlock_irqrestore(&sdev->list_lock, flags);
=2E..
> >>@@ -231,6 +231,7 @@ static struct scsi_device *scsi_alloc_sdev(stru=
ct scsi_target *starget,
> >>  	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
> >>  	extern void scsi_evt_thread(struct work_struct *work);
> >>  	extern void scsi_requeue_run_queue(struct work_struct *work);
> >>+	extern void scsi_eh_abort_handler(struct work_struct *work);
> >
> >Function declarations in a .c file?  Ick!
> >
> Sing-along: We didn't start the fire, it always burning ...
>=20
> I'm just following precedents here.

=46air enough.

J=C3=B6rn

--
The cost of changing business rules is much more expensive for software
than for a secretary.
-- unknown
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
