From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [Patch] zfcp: fix compiler warning caused by poking inside new semaphore (linux-next)
Date: Thu, 17 Apr 2008 12:22:59 +0200
Message-ID: <20080417102258.GA11231@schmichrtp.de.ibm.com>
References: <1208383683.4163.14.camel@kitka.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:5829 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYDQKXE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 06:23:04 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate6.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m3HAN1ZW148964
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 10:23:01 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3HAN1pG2269420
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 11:23:01 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3HAN0BE011746
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2008 10:23:01 GMT
Content-Disposition: inline
In-Reply-To: <1208383683.4163.14.camel@kitka.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux-Scsi <linux-scsi@vger.kernel.org>, heiko.carstens@de.ibm.com

ACK

On Thu, Apr 17, 2008 at 12:08:03AM +0200, Martin Peschke wrote:
> From: Martin Peschke <mp3@de.ibm.com>
>=20
> as seen in linux-next tree:
>=20
> drivers/s390/scsi/zfcp_dbf.c: In function =E2=80=98zfcp_rec_dbf_event=
_thread=E2=80=99:
> drivers/s390/scsi/zfcp_dbf.c:697: warning: passing argument 1 of =E2=80=
=98atomic_read=E2=80=99
>  from incompatible pointer type
>=20
> Caused by recent git commit 348447e85749120ad600a5c8e23b6bb7058b931d
>=20
> We are not supposed to poke inside semaphore.
>=20
> Signed-off-by: Martin Peschke <mp3@de.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_dbf.c |    2 --
>  drivers/s390/scsi/zfcp_dbf.h |    1 -
>  2 files changed, 3 deletions(-)
>=20
> --- a/drivers/s390/scsi/zfcp_dbf.c
> +++ b/drivers/s390/scsi/zfcp_dbf.c
> @@ -623,7 +623,6 @@ static int zfcp_rec_dbf_view_format(debu
>  	zfcp_dbf_out(&p, "id", "%d", r->id2);
>  	switch (r->id) {
>  	case ZFCP_REC_DBF_ID_THREAD:
> -		zfcp_dbf_out(&p, "sema", "%d", r->u.thread.sema);
>  		zfcp_dbf_out(&p, "total", "%d", r->u.thread.total);
>  		zfcp_dbf_out(&p, "ready", "%d", r->u.thread.ready);
>  		zfcp_dbf_out(&p, "running", "%d", r->u.thread.running);
> @@ -694,7 +693,6 @@ void zfcp_rec_dbf_event_thread(u8 id2, s
>  	memset(r, 0, sizeof(*r));
>  	r->id =3D ZFCP_REC_DBF_ID_THREAD;
>  	r->id2 =3D id2;
> -	r->u.thread.sema =3D atomic_read(&adapter->erp_ready_sem.count);
>  	r->u.thread.total =3D total;
>  	r->u.thread.ready =3D ready;
>  	r->u.thread.running =3D running;
> --- a/drivers/s390/scsi/zfcp_dbf.h
> +++ b/drivers/s390/scsi/zfcp_dbf.h
> @@ -35,7 +35,6 @@ struct zfcp_dbf_dump {
>  } __attribute__ ((packed));
>=20
>  struct zfcp_rec_dbf_record_thread {
> -	u32 sema;
>  	u32 total;
>  	u32 ready;
>  	u32 running;
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
