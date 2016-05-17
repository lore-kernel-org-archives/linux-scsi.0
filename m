From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi_lib: correctly retry failed zero length REQ_TYPE_FS
 commands
Date: Tue, 17 May 2016 11:28:35 +0200
Message-ID: <20160517092835.GI17154@c203.arch.suse.de>
References: <1463166246.2291.84.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331AbcEQJ2i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2016 05:28:38 -0400
Content-Disposition: inline
In-Reply-To: <1463166246.2291.84.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jinpu Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Parschauer <s.parschauer@gmx.de>, linux-scsi@vger.kernel.org

On Fri, May 13, 2016 at 12:04:06PM -0700, James Bottomley wrote:
> When SCSI was written, all commands coming from the filesystem
> (REQ_TYPE_FS commands) had data.  This meant that our signal for
> needing to complete the command was the number of bytes completed bei=
ng
> equal to the number of bytes in the request.  Unfortunately, with the
> advent of flush barriers, we can now get zero length REQ_TYPE_FS
> commands, which confuse this logic because they satisfy the condition
> every time.  This means they never get retried even for retryable
> conditions, like UNIT ATTENTION because we complete them early assumi=
ng
> they're done.  Fix this by special casing the early completion
> condition to recognise zero length commands with errors and let them
> drop through to the retry code.
>=20
> Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
> Signed-off-by: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
>=20
> ---
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8106515..f704d02 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -911,9 +911,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, u=
nsigned int good_bytes)
>  	}
> =20
>  	/*
> -	 * If we finished all bytes in the request we are done now.
> +	 * special case: failed zero length commands always need to
> +	 * drop down into the retry code. Otherwise, if we finished
> +	 * all bytes in the request we are done now.
>  	 */
> -	if (!scsi_end_request(req, error, good_bytes, 0))
> +	if (!(blk_rq_bytes(req) =3D=3D 0 && error) &&
> +	    !scsi_end_request(req, error, good_bytes, 0))
>  		return;


Naive question, why aren't we checking for blk_rq_bytes(req) =3D=3D 0 &=
& error in
scsi_end_request()?

> =20
>  	/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
