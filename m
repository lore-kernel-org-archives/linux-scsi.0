From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/36] scsi_dh_alua: return standard SCSI return codes
 in submit_rtpg
Date: Fri, 02 Oct 2015 08:03:03 +0200
Message-ID: <560E1E17.5040505@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de> <1443523658-87622-9-git-send-email-hare@suse.de> <560DC8B7.8020800@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbbJBGDF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 02:03:05 -0400
In-Reply-To: <560DC8B7.8020800@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/02/2015 01:58 AM, Bart Van Assche wrote:
> On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
>> +	blk_execute_rq(rq->q, NULL, rq, 1);
>> +	if (rq->errors)
>> +		err =3D rq->errors;
>=20
> Not all code in the block layer uses the SCSI error codes. Do we need
> code to convert negative error codes into a SCSI error code here ? An
> example:
>=20
> void blk_mq_abort_requeue_list(struct request_queue *q)
> {
>         [ ... ]
> 		rq->errors =3D -EIO;
>         [ ... ]
> }
> EXPORT_SYMBOL(blk_mq_abort_requeue_list);
>=20
Sigh. In principle, yes. In practise, however, there are plenty
of other instances where the SCSI core assumes rq->errors to be
holding a valid SCSI error code.
And as the device handler is plain SCSI I guess we're fine here.

Separating SCSI error codes from block-layer error codes would
be a nice topic for LSF ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
