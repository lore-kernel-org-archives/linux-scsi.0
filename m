From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH v4 3/3] block: improve detail in I/O error messages
Date: Thu, 27 Jan 2011 17:51:03 -0500
Message-ID: <AANLkTinhvmnDMS84jpGQCFrHnAj7wH+-2YCO2RqDYYKW@mail.gmail.com>
References: <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de>
 <cover.1295340405.git.hare@suse.de> <fecf8512b216779a43fd02d739e85be4023c2328.1295340405.git.hare@suse.de>
 <5acf8e401e40afb1bb7250bb37598c6e49dc830a.1295340405.git.hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45340 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1A0Wyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2011 17:54:47 -0500
Received: by fxm20 with SMTP id 20so2707713fxm.19
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2011 14:54:46 -0800 (PST)
In-Reply-To: <5acf8e401e40afb1bb7250bb37598c6e49dc830a.1295340405.git.hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, agk@redhat.com
Cc: James Bottomley <jbottomley@suse.de>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Hannes Reinecke <hare@suse.de>

On Tue, Jan 18, 2011 at 4:13 AM, Hannes Reinecke <hare@suse.de> wrote:
> Classify severity of I/O errors for target, nexus, and
> transport errors.
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =A0block/blk-core.c | =A0 23 ++++++++++++++++++++---
> =A01 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4ce953f..3380a49 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2028,9 +2028,26 @@ bool blk_update_request(struct request *req, i=
nt error, unsigned int nr_bytes)
>
> =A0 =A0 =A0 =A0if (error && req->cmd_type =3D=3D REQ_TYPE_FS &&
> =A0 =A0 =A0 =A0 =A0 =A0!(req->cmd_flags & REQ_QUIET)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "end_request: I/O error=
, dev %s, sector %llu\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 req->rq=
_disk ? req->rq_disk->disk_name : "?",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsign=
ed long long)blk_rq_pos(req));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *error_type;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (error) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case -ENOLINK:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_type =3D "recover=
able transport";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case -EREMOTEIO:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_type =3D "critica=
l target";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case -EBADE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_type =3D "critica=
l nexus";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case -EIO:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 error_type =3D "I/O";
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "end_request: %s error,=
 dev %s, sector %llu\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error_type, req->rq_disk=
 ? req->rq_disk->disk_name : "?",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long long)blk_=
rq_pos(req));
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0blk_account_io_completion(req, nr_bytes);
> --

Hi Jens,

Are you OK with this change provided James takes the SCSI patch?  If
so, should James pull this block patch in too to avoid dependency
concerns between trees?

Same question goes for the dm-mpath change (patch 2/3), Alasdair?

To ease merging with Linus, might be best if all patches were to go in
through a single tree.. if James were to carry these small block and
DM patches I'd wager chances of collision are slim.

Please advise, thanks.
Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
