From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC PATCH] scsi_transport_fc: Make sure commands are
 completed when rport is offline
Date: Wed, 10 Mar 2010 14:46:57 +0900
Message-ID: <20100310144633R.fujita.tomonori@lab.ntt.co.jp>
References: <1FB7DC5E34DADB499463B6EA89DF40A4638369F937@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50638 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab0CJFrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2010 00:47:09 -0500
In-Reply-To: <1FB7DC5E34DADB499463B6EA89DF40A4638369F937@MNEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sarang.radke@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, lalit.chandivade@qlogic.com, giridhar.malavali@qlogic.com, ravi.anand@qlogic.com

On Tue, 9 Mar 2010 05:27:51 -0600
Sarang Radke <sarang.radke@qlogic.com> wrote:

> A panic is seen when an ELS BSG request is send for rport which is on=
line, but goes offline before the request is processed.
>=20
> Here are the details of the issue and the fix.
>=20
> . The request handler routine fc_bsg_handler checks if the rport is n=
ot online and tries to end the request by calling blk_end_request.
> . blk_end_request does not finish the request because it calls bidi_e=
nd_bidi_request with bidi_bytes =3D 0.
> . After 60 sec. the timeout handler, fc_bsg_job_timeout is invoked fo=
r this unfinished command.
> . A panic is seen in fc_bsg_job_timeout because req->special is NULL.
> . req->special =A0would have been set by function fc_req_to_bsgjob, i=
f the rport was online.
> . The patch uses blk_end_request_all instead of blk_end_request which=
 finishes the bidi request and timeout never happens.
>=20
>=20
> -Thanks,
> Sarang
>=20
> Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
> ---
>  drivers/scsi/scsi_transport_fc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tra=
nsport_fc.c
> index 79660ee..304e710 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -3852,7 +3852,7 @@ fc_bsg_request_handler(struct request_queue *q,=
 struct Scsi_Host *shost,
>                 if (rport && (rport->port_state !=3D FC_PORTSTATE_ONL=
INE)) {
>                         req->errors =3D -ENXIO;
>                         spin_unlock_irq(q->queue_lock);
> -                       blk_end_request(req, -ENXIO, blk_rq_bytes(req=
));
> +                       blk_end_request_all(req, -ENXIO);
>                         spin_lock_irq(q->queue_lock);

Yeah, looks fine to me. What we want to do here is just finishing the
request by force. But as James Smart pointed out, we need to replace
another blk_end_request too, I think.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
