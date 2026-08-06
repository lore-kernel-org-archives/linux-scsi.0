Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E40D48095F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786031594; cv=none; b=MnqoPMEw3qlkPGis0i9BalTZI5NyXjaKEpJxAMf2A/ySy51TDQeM49Govy81pvPg9GmiO71zy4Xw0ynT03T7wVliK1rMsjS7hgKOWkngqk84pf0O33K/76lC7SNJjVUzpc79GUgMB9pPsRsLWILg35gMKgtDPOmDn5fk72O1He4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786031594; c=relaxed/simple;
	bh=nqViJoPypbwY5DC89bqzwXDJPO/p51LuBd3KFyHl9DU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r6M0JBnO6fZc9z+uViOgQiXmcIoDVbQ0ssDiegeYlVJw5rSbDmD7NDEJFpuSnW+vVVRvRY6JDoDapQ4oObIfnPI5a5dUeAhO923sixz2msS0uis2ZBC5aSKPwqenCG+tvAo6QSYE/DQmucvDIZEhAPeOGOvI6Dut4Xjc3ViESNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfI/iwYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfI/iwYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C1C1F00A3D;
	Thu,  6 Aug 2026 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786031581;
	bh=D8czuyBePJwYeEe8Yuxzzbds27Qt5+comu5plTvQNoo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZfI/iwYOtxDxIpcYfmITFZtIxK8bDZ8/NgJSHzsxVAqzRb3DbXa0nOSJk/DARZQKW
	 Tp0vTOSetI6z/rxRkueVCkVyRhOgqhvVe6yRt1urjv3tPSAU1eS0BvbxYNWpt1abmJ
	 ZnQoD1SKSP3J9ot+zI6pngHkTML22tn1CZbefe1quBxd487zg4F/3xjdwPnzOlLJRC
	 crrf540btr4affO36SJ15uzbzl+398CQKt6WQs2sVPqOzdsmG0JZLn7QlhXNV8ismf
	 Vj/lI+71jkQjayigfbjLuMRLYsgPevEJiRwHAskBEWdGv43zw/eUPV5Iwwz64//V8Z
	 QaOhpz3L2Yw+w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 7/7] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806-ibmvfc-fpin-support-v5-7-13fd6f8a8f8b@linux.ibm.com>
References: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
 <20260806-ibmvfc-fpin-support-v5-7-13fd6f8a8f8b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 15:53:00 +0000
Message-Id: <20260806155301.39C1C1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Struct union aliasing bug causes valid extended FPIN events to be =
dropped due to garbage node_name.
- [High] Missing flush_workqueue in ibmvfc_remove causes a Use-After-Free o=
f vhost on module unload or hot-unplug.
- [High] Manual call to destroy_workqueue on a devm-managed workqueue durin=
g probe failure causes a double-free crash.
- [Medium] The KUnit tests for extended FPIN events lack assertions and con=
tain race conditions.
--

--- Patch [7]: [PATCH v5 7/7] scsi: ibmvfc: handle extended FPIN events ---
commit a5bae65b668808baf4437c91c70e1618c59070b3
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: handle extended FPIN events
   =20
Implement support for extended FPIN messages received via the
asynchronous sub-queue, completing full FPIN functionality.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b6ac87c2042b5..9cf82c87907a8 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3485,6 +3521,7 @@ static struct ibmvfc_target *ibmvfc_find_target(str=
uct list_head *target_list,
>   */
>  static void ibmvfc_process_async_work(struct work_struct *work)
>  {
> +	struct ibmvfc_async_subq_fpin *sqfpin;
>  	struct ibmvfc_async_subq *subq =3D NULL;
>  	struct ibmvfc_async_work *aw;
>  	struct ibmvfc_async_crq *crq =3D NULL;
> @@ -3533,8 +3570,20 @@ static void ibmvfc_process_async_work(struct work_=
struct *work)
> =20
>  	if (crq)
>  		fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> -	else
> -		fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +	else {
> +		sqfpin =3D (struct ibmvfc_async_subq_fpin *)subq;

[Severity: High]
Does this code have a struct union aliasing issue that causes valid extended
FPIN events to be dropped?

Looking at ibmvfc_process_async_work() just above this change, it
unconditionally reads node_name:

        node_name =3D subq->id.node_name;

For extended FPINs, the subq structure is actually ibmvfc_async_subq_fpin.
In ibmvfc_async_subq, id.node_name occupies bytes 24-31. In
ibmvfc_async_subq_fpin, the fpin_data structure begins at byte 16, and its
event_threshold and event_data fields perfectly overlay bytes 24-31.

Since hardware populates these with non-zero values (like
IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD), node_name is parsed as non-zero garba=
ge.
Then ibmvfc_find_target() attempts a strict match against this garbage
node_name, fails to find the correct target, and drops the valid event.

Can we adjust the extraction logic so we don't read garbage data for the
node_name field when processing extended FPINs?

[Severity: High]
Will the deferred async work item processed here cause a use-after-free of
vhost on module unload or hot-unplug?

In ibmvfc_probe(), vhost->fpin_workq is allocated via devm_alloc_workqueue(=
).
Consequently, its destruction is tied to the driver core's devres mechanism,
which invokes destroy_workqueue() only after ibmvfc_remove() returns.

Inside ibmvfc_remove(), scsi_host_put(vhost->host) is called, dropping the
reference count and freeing the vhost structure. Since there is no explicit
flush_workqueue(vhost->fpin_workq) prior to this, pending asynchronous FPIN
events remain in the queue.

When devres later cleans up the workqueue, destroy_workqueue() flushes it,
executing the pending ibmvfc_process_async_work items. These works
dereference aw->vhost:

        spin_lock_irqsave(vhost->host->host_lock, flags);

which now points to the freed memory. Should we add an explicit
flush_workqueue() in ibmvfc_remove()?

[Severity: High]
Can a manual call to destroy_workqueue() on the devm-managed workqueue duri=
ng
probe failure cause a double-free crash?

In ibmvfc_probe(), vhost->fpin_workq is allocated using
devm_alloc_workqueue(). This registers a devres release action to destroy t=
he
workqueue when the device unbinds or probe fails.

If a subsequent step in probe fails (e.g., ibmvfc_alloc_mem()), the error
path jumps to free_workq, which manually calls
destroy_workqueue(vhost->fpin_workq) and sets the pointer to NULL. When the
probe function returns the error, the devres cleanup framework invokes
devm_workqueue_release(), calling destroy_workqueue() on the original point=
er
that was captured at allocation time, causing a double-free crash.

Should we remove the manual destroy_workqueue() in the error path?

> +		if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) =3D=3D 0) {
> +			fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +		} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
> +			dev_err_ratelimited(vhost->dev,
> +					    "Invalid extended FPIN event received\n");
> +		} else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
> +			dev_err_ratelimited(vhost->dev,
> +					    "Unexpected extended FPIN event received\n");
> +		} else {
> +			fpin =3D ibmvfc_ext_fpin_to_desc(sqfpin);
> +		}
> +	}
> =20
>  	if (fpin) {
>  		fc_host_fpin_rcv(tgt->vhost->host,
[ ... ]
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index a3e3e3471c5ef..8c9ba748597ba 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
[ ... ]
> @@ -114,8 +115,117 @@ static void ibmvfc_async_fpin_test(struct kunit *te=
st)
>  			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
>  }
> =20
> +#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat, crq) {		\
> +	crq.valid =3D 0x80;					\
> +	crq.flags =3D IBMVFC_ASYNC_IS_FPIN_EXT;			\
> +	crq.link_state =3D IBMVFC_AE_LS_LINK_UP;			\
> +	crq.fpin_status =3D (fs);					\
> +	crq.event =3D cpu_to_be16(IBMVFC_AE_FPIN);		\
> +	crq.wwpn =3D cpu_to_be64(tgt->wwpn);			\
> +	crq.fpin_data.flags =3D IBMVFC_FPIN_EVENT_TYPE_VALID;	\
> +	crq.fpin_data.event_type =3D cpu_to_be16((ev));		\
> +	pre =3D READ_ONCE(tgt->rport->fpin_stats.stat);		\
> +	ibmvfc_handle_async((struct ibmvfc_crq *)&crq, vhost, true);	\
> +	msleep(1U);							\
> +	post =3D READ_ONCE(tgt->rport->fpin_stats.stat);		\
> +}

[Severity: Medium]
Are these KUnit tests missing assertions to actually validate the statistics
changes?

The IBMVFC_TEST_FPIN_EXT macro and ibmvfc_extended_fpin_test() function
invoke ibmvfc_handle_async() and read the post statistics, but completely
omit KUnit assertions (like KUNIT_EXPECT_GE) to verify that the statistics
were incremented. This causes the test to silently pass even if the code
under test is completely broken.

Additionally, the test uses a non-deterministic msleep(1U) rather than
flush_workqueue(vhost->fpin_workq) to wait for the mocked async work to
complete, potentially causing a race condition.

Could we add proper assertions and replace msleep() with flush_workqueue()
to ensure the test is robust and actually validates the changes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-ibmvfc-fpi=
n-support-v5-0-13fd6f8a8f8b@linux.ibm.com?part=3D7
