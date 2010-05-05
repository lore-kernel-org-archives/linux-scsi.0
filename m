From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Retry commands with UNIT_ATTENTION sense codes
Date: Wed, 05 May 2010 08:26:17 +0200
Message-ID: <4BE10F89.4020101@suse.de>
References: <20100504144853.D94C72A205@ochil.suse.de>	 <1272990403.5255.27.camel@mulgrave.site> <4BE0804D.1030406@cs.wisc.edu>	 <4BE08320.40206@cs.wisc.edu> <1273005003.16631.43.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755218Ab0EEG0T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 May 2010 02:26:19 -0400
In-Reply-To: <1273005003.16631.43.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2010-05-04 at 15:27 -0500, Mike Christie wrote:
>> On 05/04/2010 03:15 PM, Mike Christie wrote:
>>> On 05/04/2010 11:26 AM, James Bottomley wrote:
>>>> The other patch is fine, but I don't think this is necessary. The
>>>> reason is that even returning SUCCESS here, we go straight into
>>>> scsi_finish_command() (which passes it up to the driver handler) a=
nd
>>>> then scsi_io_completion(). There's a catch for UNIT_ATTENTION in
>>>> scsi_io_completion
>>> The request is sent as a REQ_TYPE_BLOCK_PC (this flag is set for th=
e
>>> request in sd_prepare_flush), and scsi_io_completion's blk_pc_reque=
st
>>> check() that returns the request upwards is before the UNIT_ATTENTI=
ON
>> I was looking at the wrong source.
>>
>> scsi_finish_command checks for REQ_TYPE_BLOCK_PC and sets good_bytes=
 to=20
>> scsi_bufflen, so when scsi_io_completion calls scsi_end_request, it=20
>> fails the request before we can get to the UNIT_ATTENTION.
>=20
> Ah, yes, missed that.
>=20
> However there are other problems then.  We can't just eat all unit
> attentions on the BLOCK_PC path because some of the user programs wan=
t
> to see them (CD burners for one).  I know the patch allows some to
> proceed upwards, but it's risky making all except device not started =
do
> a retry.
>=20
> I'm a bit stumped on this one ... the intention of BLOCK_PC is that t=
he
> caller simply retries if they get a unit attention (which is what all
> SCSI code does).  The block code doesn't want to look at the sense da=
ta
> but at the error return.  I suppose we could make UNIT_ATTENTION
> translate to -EAGAIN and have block do the right thing?
>=20
The intention of BLOCK_PC is ok, but the point here is the barrier
request isn't really a BLOCK_PC request. The caller precisely
does _not_ want to look the sense code but rather have the SCSI
layer do all the necessary things.

Why can't we just mark the barrier request as something else than
BLOCK_PC, eg REQ_TYPE_SPECIAL?
Then we'd avoid these pitfalls and everything should work as expected, =
right?

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index de6c603..b63f84e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1038,7 +1038,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
=20
 static void sd_prepare_flush(struct request_queue *q, struct request *=
rq)
 {
-       rq->cmd_type =3D REQ_TYPE_BLOCK_PC;
+       rq->cmd_type =3D REQ_TYPE_SPECIAL;
        rq->timeout =3D SD_TIMEOUT;
        rq->retries =3D SD_MAX_RETRIES;
        rq->cmd[0] =3D SYNCHRONIZE_CACHE;

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Markus Rex, HRB 16746 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
