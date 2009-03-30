From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] libsrp: free kfifo struct in srp_iu_pool_free
Date: Mon, 30 Mar 2009 21:38:01 +0200
Message-ID: <200903302138.02155.jdelvare@suse.de>
References: <200903291119.42080.jdelvare@suse.de> <20090330184458.GB11116@hera.kernel.org> <20090330184901.GC11116@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58913 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759970AbZC3TiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2009 15:38:03 -0400
In-Reply-To: <20090330184901.GC11116@hera.kernel.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Wright <chrisw@sous-sol.org>
Cc: stable@kernel.org, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Hi Chris,

Le lundi 30 mars 2009, Chris Wright a =E9crit=A0:
> Appears to be a small leak here when freeing pool, the kfifo gets lef=
t
> behind.  Did I miss a caller that frees kfifo?
>=20
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> ---
> diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
> index 15e2d13..3a305f8 100644
> --- a/drivers/scsi/libsrp.c
> +++ b/drivers/scsi/libsrp.c
> @@ -81,6 +81,7 @@ static void srp_iu_pool_free(struct srp_queue *q)
>  {
>  	kfree(q->items);
>  	kfree(q->pool);
> +	kfree(q->queue);
>  }
> =20
>  static struct srp_buf **srp_ring_alloc(struct device *dev,
>=20

You appear to be correct, I can't see q->queue being freed anywhere
either.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

--=20
Jean Delvare
Suse L3
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
