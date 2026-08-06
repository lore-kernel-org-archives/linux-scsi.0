Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3816847D451
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030496; cv=none; b=BwhXDlgusq8IP5Loud84NSwa7YagAumcSZQ6ZGl/NGvi4WV+INfn3flEgyDbS+8hkBSCW2AEpoVxZxyDhfevGxy2HLkLPFzR6LNew/D2Mzhc3zbBmzejNkQUwVEO4yRlI+9R2OkShZQ8pg88tElwqQAM4ZrEz73uPoKbKYlXxx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030496; c=relaxed/simple;
	bh=ZQAFRtWYmR3JTuX3Gj4sNOg4gKHcC86hpxLX+YndgF0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LrA977h+L7Z1p3P5FCzosPv/XayQdw+BxlQwGx8deHi1NB0gX76DHaQoQbxF4lhEM+87i4JGrHvegJL8l/Tbw8TvDaXeHY2hZKyNFmsLba6nBDqyYx7IoKnMz5JDgt94LZUgOTj1adW79NVusKye16/7+S5CWe15tVImGpAvYY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5PnbdVr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5PnbdVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FC31F000E9;
	Thu,  6 Aug 2026 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786030495;
	bh=iUsNa0fHZqZ3O51B456cy2ZWWn1CXUUkis5sT8o2Ig0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J5PnbdVrvd8HZKVPcnHTQpuA0ln4V6XiVKCwm5FRT4u0AL7DJvjwZOKStqbljL72+
	 PXjLBaX0IpaZMHUyFlVcAetCozWIxorNPG7qeKpVZJ8VYwBrMb+lfDZG3ORHQ8eV6I
	 Hjr1mohpslOF1elbZvS8khiq0ZpXo/GivMAavASH4+etavQFShxw7Tyu2uvBfNvgtw
	 5cKxKzgjdto8wpmlI/++/ic9Nht3tzo/Jr6jIFlLKJDF6Uub9Id1mHzHHKdQyauL1+
	 7DwO7e1KZLV0mq6Q4UE2AgYKjWtwNGQQj/uelaLwxm/+4OqQor6QzVmtFEr7mJxmP4
	 u+bulyPhNKW9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/7] scsi: ibmvfc: extend async event handlers to
 handle async sub queue events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806-ibmvfc-fpin-support-v5-5-13fd6f8a8f8b@linux.ibm.com>
References: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
 <20260806-ibmvfc-fpin-support-v5-5-13fd6f8a8f8b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 15:34:54 +0000
Message-Id: <20260806153454.98FC31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] Dereferencing a `void *` pointer causes a fatal compilation er=
ror.
- [High] Double-clearing of the hardware ring buffer's `valid` flag introdu=
ces a race condition that drops events.
- [High] Target matching for sub-queue events is broken due to unconditiona=
lly treating the identifier union as `node_name`.
- [Medium] Sub-queue FPIN descriptors are generated with an invalid event t=
ype (0), causing telemetry loss.
- [Medium] KUnit tests compare mismatched FPIN port congestion statistic fi=
elds.
- [Low] Use of `rmb()` to order memory reads before a subsequent memory wri=
te violates generic memory barrier semantics.
--

--- Patch [5]: [PATCH v5 5/7] scsi: ibmvfc: extend async event handlers to =
handle async sub queue events ---
commit 91821c3532cfc1d2567a96c877a77e93654a286a
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend async event handlers to handle async sub queue events

This commit refactors async event handling to support traditional async
CRQs and new asynchronous sub-queue CRQs. It introduces a new is_subq flag,
extracts target information according to the event source, and updates KUnit
tests for the new interface.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index c8efe17223c9e..97856a609bde4 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> +static struct fc_els_fpin *
> +ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq *ibmvfc_fpin)
> +{
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin=
->wwpn,
> +					  cpu_to_be16(0), cpu_to_be16(0),

[Severity: Medium]
Is hardcoding the event type to 0 intended here?

Unlike ibmvfc_basic_fpin_to_desc() which maps the status to a valid Fibre
Channel event type (like FPIN_CONGN_DEVICE_SPEC), passing 0 results in an
invalid event type.

Could this cause downstream generic handlers to drop the telemetry metrics?

[ ... ]
>  static void ibmvfc_process_async_work(struct work_struct *work)
>  {
[ ... ]
> +	is_subq =3D aw->is_subq;
> +	if (is_subq) {
> +		subq =3D &aw->crq.subq;
> +		scsi_id =3D 0;
> +		wwpn =3D subq->wwpn;
> +		node_name =3D subq->id.node_name;

[Severity: High]
Does this misinterpret the identifier for NVMe devices?

The ibmvfc_async_subq structure uses a union for the ID. If the
IBMVFC_ASYNC_ID_IS_ASSOC_ID flag is set, this unconditionally extracts it as
node_name.

This means an assoc_id would be incorrectly compared against
tgt->ids.node_name during the ibmvfc_find_target() lookup, causing valid
sub-queue events to be ignored.

[ ... ]
> -VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
> -					  struct ibmvfc_host *vhost)
> +VISIBLE_IF_KUNIT void ibmvfc_handle_async(void *crq,
> +					  struct ibmvfc_host *vhost,
> +					  bool is_subq)
>  {

[Severity: Critical]
Does this cause a compilation error?

The signature of ibmvfc_handle_async() was changed so that crq is now a
void pointer. While the list_for_each_entry() loop for scsi_scrqs was
updated to use the new scsi_id, wwpn, and node_name local variables, the
identical loop for nvme_scrqs was not updated:

ibmvfc_handle_async() {
    ...
    list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
        if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
            break;
    ...
}

Because crq is now void *, direct member access is invalid in C and will
break the build.

[ ... ]
>  	default:
> -		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event=
);
> +		dev_err(vhost->dev, "Unknown async event received: %llu\n", event);
>  		break;
>  	}
> +
> +	rmb();

[Severity: Low]
Does this barrier provide the correct guarantees?

The rmb() only ensures prior loads complete before subsequent loads.
To ensure that prior loads complete before the subsequent valid =3D 0 store,
shouldn't this be a full mb()?

> +	if (is_subq)
> +		subq->valid =3D 0;
> +	else
> +		async_crq->valid =3D 0;
> +	wmb();
>  }

[Severity: High]
Will clearing the valid flag here and again in the caller permanently drop
new events?

Once the valid flag is cleared here, the hardware is free to reuse this slot
and write a new event (setting valid to 0x80). However, ibmvfc_tasklet()
(the caller) redundantly executes async->valid =3D 0 upon return from this
function:

ibmvfc_tasklet() {
    ...
    while ((async =3D ibmvfc_next_async_crq(vhost)) !=3D NULL) {
        ibmvfc_handle_async(async, vhost, false);
        async->valid =3D 0;
        wmb();
    }
    ...
}

If a new event was written by the hardware in this tiny race window, the
second clear in ibmvfc_tasklet() will overwrite the 0x80 with 0, permanently
dropping the new event.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index 64a517a74af8e..a3e3e3471c5ef 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -45,7 +45,7 @@ static void ibmvfc_async_fpin_test(struct kunit *test)
>  	fc_host =3D shost_to_fc_host(vhost->host);
> =20
>  	pre[IBMVFC_AE_FPIN_LINK_CONGESTED] =3D READ_ONCE(fc_host->fpin_stats.cn=
_device_specific);
> -	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] =3D READ_ONCE(tgt->rport->fpin_stats=
.cn);
> +	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] =3D READ_ONCE(tgt->rport->fpin_stats=
.cn_device_specific);
>  	pre[IBMVFC_AE_FPIN_PORT_CLEARED] =3D READ_ONCE(tgt->rport->fpin_stats.c=
n_clear);

[Severity: Medium]
Are we comparing mismatched fields in this test?

The initialization of pre[IBMVFC_AE_FPIN_PORT_CONGESTED] was correctly
updated to capture cn_device_specific, but the corresponding post-event read
(and the second bad-path test initialization) still captures cn.

This mismatch leads to assertions comparing cn_device_specific against cn.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-ibmvfc-fpi=
n-support-v5-0-13fd6f8a8f8b@linux.ibm.com?part=3D5
