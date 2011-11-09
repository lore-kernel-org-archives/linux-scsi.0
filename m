From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Silencing 'killing requests for dead queue'
Date: Wed, 9 Nov 2011 12:53:23 +0100
Message-ID: <CAO+b5-r148yneG_h3PyfP9D8BGf5x7e7XKuY73BVtPTTRPkFuQ@mail.gmail.com>
References: <1320824364-8510-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53155 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1KILxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2011 06:53:24 -0500
Received: by wyh15 with SMTP id 15so1508159wyh.19
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2011 03:53:23 -0800 (PST)
In-Reply-To: <1320824364-8510-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Wed, Nov 9, 2011 at 8:39 AM, Hannes Reinecke <hare@suse.de> wrote:
> When we tear down a device we try to flush all outstanding
> commands in scsi_free_queue(). However the check in
> scsi_request_fn() is imperfect as it only signals that
> we _might start_ aborting commands, not that we've actually
> aborted some.
> So move the printk inside the scsi_kill_request function,
> this will also give us a hint about which commands are aborted.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 06bc265..f85cfa6 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1409,6 +1409,8 @@ static void scsi_kill_request(struct request *r=
eq, struct request_queue *q)
>
> =A0 =A0 =A0 =A0blk_start_request(req);
>
> + =A0 =A0 =A0 scmd_printk(KERN_INFO, cmd, "killing request\n");
> +
> =A0 =A0 =A0 =A0sdev =3D cmd->device;
> =A0 =A0 =A0 =A0starget =3D scsi_target(sdev);
> =A0 =A0 =A0 =A0shost =3D sdev->host;
> @@ -1490,7 +1492,6 @@ static void scsi_request_fn(struct request_queu=
e *q)
> =A0 =A0 =A0 =A0struct request *req;
>
> =A0 =A0 =A0 =A0if (!sdev) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("scsi: killing requests for dead=
 queue\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0while ((req =3D blk_peek_request(q)) !=
=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_kill_request(req,=
 q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;

Can this message appear during LUN scanning and hence confuse users ?

Also, patch 3308511 is already present in several stable trees so
shouldn't a patch like the above CC stable@vger.kernel.org too ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
