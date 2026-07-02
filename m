Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251401C695
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 18:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016196; cv=none; b=Rs1RGZ99nkUlNFrrfWPYlQ5zxlJ2NLZinE+gZpkc4Sgb86aYFp3wZfzmmIF0wVRdjRD1pT5/l9i4NWW5EqRaflQeiBqLLp56xmLq1Lce1rx8c2oIH+Je0ul+RoCnUZ6Pbx1ghmYxBnVuvHItewfPRMAtri1/CsMs8aU9f8WPzsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016196; c=relaxed/simple;
	bh=S3OEemLAj24uCxbKOVOriUGCDtwHvdhp7IsQXw6TbtA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OgxOP8n1X/Su7bw2Z6u/OrhRIlNfoLxc7sI6dzsl8yffz0A2wYgimz2UfNGYbVRRsDLWpjUWtZC1WZEjsRvvM0s8iYFL/RIu527lwM4JdWdx70cRgK4XBWHfloVpPI0L29yVF5SYs8LuNkN01XXLQiRgmExjcjOB+ghxJqjdFRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ln8Hoh/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ln8Hoh/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11571F000E9;
	Thu,  2 Jul 2026 18:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783016195;
	bh=aqE1Zn8M8PYoR7f680eYsdo9d0k3o8o0IfDC+W0zBhA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ln8Hoh/prvNN+8b+RN9tHsu0e9xMfWT09eqjoGCT3BqKIkAjOqx5wF2JkAwtbrPZP
	 ASYaJYCPQg1GhL1gRJZKpSrZrG0CgcTxm1Okj+T6ItJirQvDqCtdtKqg9VXoqK/nIp
	 eF1qGUZws47doCNqEJpTbhy46eJFEBkqUNPKvzWhQNFXGRT2MyLNcz/N+F+AxFgmGG
	 9MI5mAdvpZZa3XoQFwDXdu4k42W+DgUGXLezcyall4ED1TULBO1jJm7AFxnthk6ELG
	 LxrVx9BP0uDvLu17G/lXZKlpmXvkF+fvAhT30gzcLZccYy8nPvFZjE0naAeFw1ySSD
	 ApAqpOBKtT1bQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/8] ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702-ibmvfc-fpin-support-v3-1-d95b9547cf88@linux.ibm.com>
References: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
 <20260702-ibmvfc-fpin-support-v3-1-d95b9547cf88@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 18:16:34 +0000
Message-Id: <20260702181634.D11571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Use-After-Free (UAF) on target structure during asynchronous F=
PIN processing.
- [High] Out-of-bounds Memory Access / Type Confusion due to misused list i=
terator.
- [Medium] Incorrect lifecycle cleanup ordering allows FPIN work item to ru=
n on a removed transport device.
- [Medium] The KUnit test unconditionally fails on systems without the IBM =
Virtual FC hardware instead of gracefully skipping.
--

commit ef1762da1f48d8a096031c317c4a9bf573f1b39e
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: add basic FPIN support

This commit adds basic FPIN message support to the ibmvfc driver. It adds
FPIN handling to the async event handler, offloads processing to a work
queue, and converts the VIOS FPIN messages to struct fc_els_fpin.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
[ ... ]
> @@ -3185,16 +3189,228 @@ static const char *ibmvfc_get_link_state(enum ib=
mvfc_ae_link_state state)
[ ... ]
> +static void ibmvfc_process_async_work(struct work_struct *work)
> +{
[ ... ]
> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> +	list_for_each_entry_safe(tgt, next, &vhost->targets, queue) {
> +		if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) !=3D crq->scsi_id)
> +			continue;
> +		if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) !=3D crq->wwpn)
> +			continue;
> +		if (crq->node_name && cpu_to_be64(tgt->ids.node_name) !=3D crq->node_n=
ame)
> +			continue;
> +		if (!tgt->rport)
> +			continue;
> +		break;
> +	}
> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> +
> +	if (!tgt || !tgt->rport) {

[Severity: High]
Does this list iterator evaluation correctly determine if the target was fo=
und?

If an asynchronous FPIN event is received with a wwpn or scsi_id that does =
not
match any active target (for example, immediately after a target disconnect=
s),
the list_for_each_entry_safe() loop finishes without executing a break.
At this point, the list iterator tgt points to the list head, not NULL.

The validation check if (!tgt || !tgt->rport) is bypassed because tgt is a
valid pointer, and its rport member maps to vhost->crq.msgs which contains a
valid initialized pointer. This causes the function to mistakenly treat the
vhost struct fields as a target struct, which can result in an out-of-bounds
read and a crash.

[Severity: Critical]
Is it possible for a concurrent system event to free the target structure h=
ere?

When the target is successfully matched in the loop, the spinlock
vhost->host->host_lock is immediately dropped. The function proceeds to acc=
ess
tgt->wwpn and tgt->vhost->host to populate the FPIN descriptor without acqu=
iring
a reference count via kref_get(&tgt->kref).

Because ibmvfc_process_async_work() runs asynchronously in fpin_workq, a
concurrent event (such as a link down or fabric logout) could acquire the
host lock, delete the target, and invoke kref_put(), freeing the memory for
tgt. The subsequent reads by this worker thread would then result in a
use-after-free.

> +		dev_err_ratelimited(vhost->dev, "Invalid target for FPIN\n");
> +		goto end;
> +	}
[ ... ]
> @@ -6453,6 +6686,8 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_release_crq_queue(vhost);
> =20
>  	ibmvfc_free_mem(vhost);
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq =3D NULL;
>  	spin_lock(&ibmvfc_driver_lock);

[Severity: Medium]
What prevents pending FPIN tasks from executing on removed infrastructure?

The destroy_workqueue(vhost->fpin_workq) call occurs at the very end of
ibmvfc_remove(), long after fc_remove_host(vhost->host) and
scsi_remove_host(vhost->host) have been called earlier in the lifecycle.

Because destroy_workqueue() flushes and executes all pending work items, any
queued asynchronous FPIN messages will be processed against a host whose rp=
orts
are deleted and whose sysfs transport representation has been torn down.

[ ... ]
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..e41e2a49e5497
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
[ ... ]
> @@ -0,0 +1,131 @@
[ ... ]
> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{
[ ... ]
> +	headp =3D ibmvfc_get_headp();
> +	KUNIT_ASSERT_FALSE_MSG(test, list_empty(headp), "No ibmvfc devices avai=
lable\n");

[Severity: Medium]
Could this KUnit test gracefully skip instead of forcing a hard failure on
systems without the IBM Virtual FC hardware?

The test unconditionally asserts that ibmvfc_head is not empty. Executing t=
his
module on architectures or systems lacking the specific IBM POWER Virtual FC
hardware directly invokes a failure instead of yielding via kunit_skip().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-ibmvfc-fpi=
n-support-v3-0-d95b9547cf88@linux.ibm.com?part=3D1
