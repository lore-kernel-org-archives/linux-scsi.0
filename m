From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Correct tag initialisation for commands
Date: Fri, 19 Oct 2007 15:23:35 +0200
Message-ID: <4718AFD7.5000203@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60186 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087AbXJSNXh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 09:23:37 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 318E014FF1
	for <linux-scsi@vger.kernel.org>; Fri, 19 Oct 2007 15:23:36 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi all,

currently the initialisation of scmd->tag seems to be wrong.
We have this lines from scsi_lib.c:scsi_get_cmd_from_req():

	/* pull a tag out of the request if we have one */
	cmd->tag =3D req->tag;

which are supposed to fill the tag value for a given command.
However, the function is called from the ->prep_fn callback,
invoked from elv_next_request() in scsi_request_fn().

In scsi_request_fn() we have:

	req =3D elv_next_request(q);
	if (!req || !scsi_dev_queue_ready(q, sdev))
		break;

	if (unlikely(!scsi_device_online(sdev))) {
		sdev_printk(KERN_ERR, sdev,
			    "rejecting I/O to offline device\n");
		scsi_kill_request(req, q);
		continue;
	}

	/*
	 * Remove the request from the request list.
	 */
	if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
		blkdev_dequeue_request(req);

ie the value of rq->tag is filled _after it has been copied
to scmd->tag.

A proposed patch would be:

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1055,8 +1055,6 @@ static struct scsi_cmnd *scsi_get_cmd_from_req(st=
ruct scsi_device *sdev,
 		cmd =3D req->special;
 	}
=20
-	/* pull a tag out of the request if we have one */
-	cmd->tag =3D req->tag;
 	cmd->request =3D req;
=20
 	return cmd;
@@ -1445,6 +1443,9 @@ static void scsi_request_fn(struct request_queue =
*q)
 			blk_dump_rq_flags(req, "foo");
 			BUG();
 		}
+		/* pull a tag out of the request if we have one */
+		cmd->tag =3D req->tag;
+
 		spin_lock(shost->host_lock);
=20
 		if (!scsi_host_queue_ready(q, shost, sdev))

Comments?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
