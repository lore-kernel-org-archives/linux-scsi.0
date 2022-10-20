Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BAACC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 20:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJTUBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 16:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJTUBW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 16:01:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5775F1C122
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2022 13:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666296078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bXxtFjQOxRQsVUcLMa3z/e7n3G3jkw/mOsyeltrZg0Y=;
        b=Q50VlrUbq5g+yxo6wg17NSJGnVprIbnrutomFNXkNwJaNBwxfA0010je84/JLsNdq8M+nV
        9xcqnfTfZfl2Vt9C7O/Y75vEHbQPE7i/k7ThxO7+QZprOamVfXsT8osLwaTngSaaQ7sIh/
        QWM7VWvkc+zt/2YvU0Bl9zi4dQ1bYm8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-h6UaRQHiNYqT_GxLmuJMtQ-1; Thu, 20 Oct 2022 16:01:14 -0400
X-MC-Unique: h6UaRQHiNYqT_GxLmuJMtQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B16F3804526;
        Thu, 20 Oct 2022 20:01:14 +0000 (UTC)
Received: from localhost (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B2EC200A384;
        Thu, 20 Oct 2022 20:01:13 +0000 (UTC)
Date:   Thu, 20 Oct 2022 16:01:11 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>, djeffery@redhat.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Bug] double ->queue_rq() because of timeout in ->queue_rq()
Message-ID: <Y1GpB6Gpm7GglwO3@fedora>
References: <Y1EQdafQlKNAsutk@T590>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UxZs1nxHx0OJTHzs"
Content-Disposition: inline
In-Reply-To: <Y1EQdafQlKNAsutk@T590>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--UxZs1nxHx0OJTHzs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 20, 2022 at 05:10:13PM +0800, Ming Lei wrote:
> Hi,
>=20
> David Jeffery found one double ->queue_rq() issue, so far it can
> be triggered in the following two cases:
>=20
> 1) scsi driver in guest kernel
>=20
> - the story could be long vmexit latency or long preempt latency of
> vCPU pthread, then IO req is timed out before queuing the request
> to hardware but after calling blk_mq_start_request() during ->queue_rq(),
> then timeout handler handles it by requeue, then double ->queue_rq() is
> caused, and kernel panic
>=20
> 2) burst of kernel messages from irq handler=20
>=20
> For 1), I think it is one reasonable case, given latency from host side
> can come anytime in theory because vCPU is emulated by one normal host
> pthread which can be preempted anywhere. For 2), I guess kernel message is
> supposed to be rate limited.
>=20
> Firstly, is this kind of so long(30sec) random latency when running kernel
> code something normal? Or do we need to take care of it? IMO, it looks
> reasonable in case of VM, but our VM experts may have better idea about t=
his
> situation. Also the default 30sec timeout could be reduced via sysfs or
> drivers.

30 seconds is a long latency that does not occur during normal
operation, but unfortunately does happen on occasion.

I think there's an interest in understanding the root cause and solving
long latencies (if possible) in the QEMU/KVM communities. We can
investigate specific cases on kvm@vger.kernel.org and/or
qemu-devel@nongnu.org.

The kernel should be robust in the face of long latencies even if they
are due to issues with hardware or the hypervisor. I'm not familiar
enough with the Linux block layer to say whether the patch below is
correct, but having a solution in place would be good.

>=20
> Suppose it is one reasonable report to fix, what is the preferred solutio=
n?
>=20
> So far, it is driver's responsibility to cover the race between timeout
> and completion, so it is supposed to be solved in driver in theory, given
> driver has enough knowledge.
>=20
> But it is really one common problem, lots of driver could have similar
> issue, and could be hard to fix all affected drivers, so David suggests
> the following patch by draining in-progress ->queue_rq() for this issue.
> And the patch looks reasonable too.
>=20
> Any comments for this issue and the solution?
>=20
>=20
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 8070b6c10e8d..ca57c060bb65 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1523,7 +1523,12 @@ static void blk_mq_rq_timed_out(struct request *re=
q)
>  	blk_add_timer(req);
>  }
> =20
> -static bool blk_mq_req_expired(struct request *rq, unsigned long *next)
> +struct blk_expired_data {
> +	unsigned long next;
> +	unsigned long now;
> +};
> +
> +static bool blk_mq_req_expired(struct request *rq, struct blk_expired_da=
ta *expired)
>  {
>  	unsigned long deadline;
> =20
> @@ -1533,13 +1538,13 @@ static bool blk_mq_req_expired(struct request *rq=
, unsigned long *next)
>  		return false;
> =20
>  	deadline =3D READ_ONCE(rq->deadline);
> -	if (time_after_eq(jiffies, deadline))
> +	if (time_after_eq(expired->now, deadline))
>  		return true;
> =20
> -	if (*next =3D=3D 0)
> -		*next =3D deadline;
> -	else if (time_after(*next, deadline))
> -		*next =3D deadline;
> +	if (expired->next =3D=3D 0)
> +		expired->next =3D deadline;
> +	else if (time_after(expired->next, deadline))
> +		expired->next =3D deadline;
>  	return false;
>  }
> =20
> @@ -1555,7 +1560,7 @@ void blk_mq_put_rq_ref(struct request *rq)
> =20
>  static bool blk_mq_check_expired(struct request *rq, void *priv)
>  {
> -	unsigned long *next =3D priv;
> +	struct blk_expired_data *expired =3D priv;
> =20
>  	/*
>  	 * blk_mq_queue_tag_busy_iter() has locked the request, so it cannot
> @@ -1564,7 +1569,7 @@ static bool blk_mq_check_expired(struct request *rq=
, void *priv)
>  	 * it was completed and reallocated as a new request after returning
>  	 * from blk_mq_check_expired().
>  	 */
> -	if (blk_mq_req_expired(rq, next))
> +	if (blk_mq_req_expired(rq, expired))
>  		blk_mq_rq_timed_out(rq);
>  	return true;
>  }
> @@ -1573,7 +1578,7 @@ static void blk_mq_timeout_work(struct work_struct =
*work)
>  {
>  	struct request_queue *q =3D
>  		container_of(work, struct request_queue, timeout_work);
> -	unsigned long next =3D 0;
> +	struct blk_expired_data expired =3D {.next =3D 0, .now =3D jiffies};
>  	struct blk_mq_hw_ctx *hctx;
>  	unsigned long i;
> =20
> @@ -1593,10 +1598,17 @@ static void blk_mq_timeout_work(struct work_struc=
t *work)
>  	if (!percpu_ref_tryget(&q->q_usage_counter))
>  		return;
> =20
> -	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &next);
> +	/* Before walking tags, we must ensure any submit started before the
> +	 * current time has finished. Since the submit uses srcu or rcu, wait
> +	 * for a synchronization point to ensure all running submits have
> +	 * finished
> +	 */
> +	blk_mq_wait_quiesce_done(q);
> +
> +	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &expired);
> =20
> -	if (next !=3D 0) {
> -		mod_timer(&q->timeout, next);
> +	if (expired.next !=3D 0) {
> +		mod_timer(&q->timeout, expired.next);
>  	} else {
>  		/*
>  		 * Request timeouts are handled as a forward rolling timer. If
>=20
>=20
>=20
> Thanks,=20
> Ming
>=20

--UxZs1nxHx0OJTHzs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmNRqQcACgkQnKSrs4Gr
c8jxHgf9Hh/I5IRFGPPz1SDW5s0v9vLY5y8HrGl3nG6UrWPN2rT9YAL1+AcIksnh
udgdbBCdUOkvoPGPw1BnYfa19ZfMGGB4NYK8fNJDrEh4Hm+WGefYpbkqkVBEjZnF
N0TdLYZSe0PgScobsXvg5iDO3TE+m7wu8MHdYG9k3qLwb7M9NOpWNzxBMAPZxVe5
zSwbLSnexo6j5kP8QvgLC+QzDp6YYLSm+t2/0rd955EsbljSgw7pOmASl5pKak+7
K1bzHevtQh7ks7f5ayKRJnIKXl6IvS9NZUZ08OqHX7glAVfyFLz+De58lWI31mK9
z8Z+nnZ26ISbfmYQIDVKa1k0ec37MA==
=Wwmt
-----END PGP SIGNATURE-----

--UxZs1nxHx0OJTHzs--

