Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480A014B977
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782180265; cv=none; b=NF9IstSZhthhalR8Uw3xWZmR7M+HNm+6uM1IHIJ5Kc1p9WW+W7JgdxRGjeWda1Bu7g97tQkcY48Ax5+5Qk/BYWbXCYAzbSqSNHAM/2XVCiUcsmRwmul42+aNPFyvZ5HgZYghSyENFyLwBmv1zyHBTuwxyKTGoJhhVB2oAZY/Zqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782180265; c=relaxed/simple;
	bh=tY2e+U/EMJHX8go0Sf7LmtkGvjY65dV07TFRit3yl18=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B+9rAxBgdpX/7UpRXFKMEsDz4rdQ7q9BPMSD3XPIsDE1U6nYVe+D82Neb0eeyWWLSRJ+sdODQ1RLKUxfTA4j7+uLlVTqZ//xMjRvNMWrqk3ESPulrOBMvrphNKe8dVTTrFHh1VzCbjc/lT8oW6W2oZLepKro/Di6GK0eBZMBtP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CR8Aps/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CR8Aps/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A601F000E9;
	Tue, 23 Jun 2026 02:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782180263;
	bh=v8tSQCnJHxb+ztHrlPDwQZE/70r7TGQwalZoipUDqvE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CR8Aps/8Q6AUtVyBr9fxogVtZPShzic5iX0un5vB1fZfkni6KerykxQQ/0umky5jV
	 /lSWVd+ewZwtl8PXgSZnwNeP6Yhsziz4RiNNqukFxLACUZH/9bGkhtQI+KZU+souUz
	 qpnJCVpU9LiAyrNeK4mKhoc02lnv5vPEje7DwEmQzKCbApWz0JX0frt8Nc/QVZ5/W1
	 HOcJlJLOTvZ7d8BdGAymJciu/FukQX/JT1fv1BurkU1lmoUwbl/b71SyP5KhC3rYDE
	 dYGWOjX2gpkmHYPKZafOWkcEqYRcKG/wxldPBBSYoopK3K3NsNuDw6tI6ubPpRkBQA
	 daWXt0NRTGpeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 23/29] ibmvfc: declare global function definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-24-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-24-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:04:23 +0000
Message-Id: <20260623020423.B8A601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Objects allocated via mempool_alloc are incorrectly freed using kf=
ree, breaking mempool semantics and causing deadlock under memory pressure.
- [High] Non-synchronous timer cancellation during host removal leads to Us=
e-After-Free on `vhost` in the timer callback.
- [High] Recursive deadlock in ibmvfc_send_event() error path when sending =
management (MAD format) events.
--

commit 433fbb97fc83e37f1339b6c6598956ee0f1ae0a5
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: declare global function definitions

Some common functions will require visibility by both SCSI and NVMe
protocols. Make common ibmvfc helper routines available to the NVMe
support code.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 7e6912fba899d..177d341ce7bc6 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -1410,7 +1403,7 @@ static void ibmvfc_set_rport_dev_loss_tmo(struct fc=
_rport *rport, u32 timeout)
>   * @kref:		kref struct
>   *
>   **/
> -static void ibmvfc_release_tgt(struct kref *kref)
> +void ibmvfc_release_tgt(struct kref *kref)
>  {
>  	struct ibmvfc_target *tgt =3D container_of(kref, struct ibmvfc_target, =
kref);
>  	kfree(tgt);
>  }

[Severity: High]
This isn't a bug introduced by this patch, but does this leak reserved obje=
cts
to the slab allocator and risk deadlock?

Since the target is allocated from tgt_pool (a mempool), shouldn't it be fr=
eed
with mempool_free() rather than kfree()?

Under memory pressure, if mempool allocations fail, mempool_alloc() sleeps
waiting for objects to return. Freeing directly to the slab bypasses the
mempool and its waitqueue is never woken.

[ ... ]

> @@ -1639,7 +1629,7 @@ static void ibmvfc_locked_done(struct ibmvfc_event =
*evt)

[Severity: High]
This isn't a bug introduced by this patch, but does this code path contain a
recursive deadlock when sending management (MAD format) events?

Management commands are often issued from a context that already holds
vhost->host->host_lock. If ibmvfc_send_event() encounters a local error, it
synchronously calls evt->done(evt):

ibmvfc_send_event() {
    ...
    if (rc) {
        ...
        evt->done(evt);
    }
}

For MAD format events, evt->done is often assigned to ibmvfc_locked_done(),
which unconditionally attempts to lock the same spinlock again:

ibmvfc_locked_done() {
    ...
    spin_lock_irqsave(evt->vhost->host->host_lock, flags);
    ...
}

Will this cause a fatal recursive deadlock?

>   * @done:	Routine to call when the event is responded to
>   * @format:	SRP or MAD format
>   **/
> -static void ibmvfc_init_event(struct ibmvfc_event *evt,
> +void ibmvfc_init_event(struct ibmvfc_event *evt,

[ ... ]

> @@ -1764,7 +1754,7 @@ static void ibmvfc_timeout(struct timer_list *t)

[Severity: High]
This isn't a bug introduced by this patch, but can ibmvfc_timeout() execute
concurrently and cause a use-after-free on vhost?

During teardown, ibmvfc_purge_requests() cancels each event's timer using t=
he
non-synchronous timer_delete() while holding host_lock.

If the timer callback ibmvfc_timeout() is concurrently firing on another CP=
U,
it blocks waiting for that lock:

ibmvfc_timeout() {
    ...
    ibmvfc_reset_host(vhost);
}

ibmvfc_reset_host() then calls spin_lock_irqsave(vhost->host->host_lock, fl=
ags).

Once the teardown drops the lock and frees vhost, the timer callback acquir=
es
the lock and operates on the freed vhost object. Could this lead to a
use-after-free?

>   *
>   * Returns the value returned from ibmvfc_send_crq(). (Zero for success)
>   **/
> -static int ibmvfc_send_event(struct ibmvfc_event *evt,
> +int ibmvfc_send_event(struct ibmvfc_event *evt,
>  			     struct ibmvfc_host *vhost, unsigned long timeout)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D23
