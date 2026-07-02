Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C427343884
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016491; cv=none; b=DCYyWu3VrH+YGkPBi0bY3FluQX8raPBQUcUfmzYWSH4hdc4QuuneEsYCEzyiZi/HSc2roFu/x9xN7V5I1uCdROvMpAJD+Q66Lo8SmSlvJuX+RRx7M156rWzjb46lx5xhO8ImoX65wY7OWw7QYROyhDTNFFe+dGx801FKYuYKSOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016491; c=relaxed/simple;
	bh=0Pm5UtOdP5l+1B+4AwKQmcGGYqbQqWUYhaEea5EHcV4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Tfq19X+a3hGDRsshD+KJZbXjaNZj2W3qXouGCeNtuzKXC+TAZArgtzEkdtbWsiwUXimD87NeewlFBneem0rTGcsFDkvvF1Vl1TwmoOC8HXbN9fcjU0qA7W+QVFYMPWJ996cHkWgzeNNIzAjDBr/CUfLT5u438dbXtiWWn/JRhQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y/rgwHYb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y/rgwHYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A8D1F00A3D;
	Thu,  2 Jul 2026 18:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783016490;
	bh=CrXN+xml3ldmpAf94cy0LGqzfjPP/fWa0qkAANshYNE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y/rgwHYbvZY9dG4Ij/zKL7xHz9X2kgfuAIuAuU/6bBHpaVBAij91JPVymWXyWK1Qr
	 nKEo5PHIbYzxTtQkJw1D6a9a0Iv8GBf7DGt81+IeEs2Y8lrGKF0dEP1aq1IKT4zTEw
	 WfEbbQpDkbnbl9sZHIa9Orpne+Bf+PneYxMxnHUMAujlhmWQaWhmHrt/PuBFcw5+Oa
	 QH0he5/qK1urfQ996pTCQbrFgADkUP9Y8YE0fQ7gDWZn9mkzvOShWVPjVNFlsjfiWW
	 73h9l63ajf3syWsv3byWDJ2yFXmCGtiQPlMjmrngqo3lMzlvMLk1dhQrLmEFDE+Xm8
	 Qew0IYi0Gh5Jg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/8] ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702-ibmvfc-fpin-support-v3-8-d95b9547cf88@linux.ibm.com>
References: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
 <20260702-ibmvfc-fpin-support-v3-8-d95b9547cf88@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 18:21:29 +0000
Message-Id: <20260702182130.05A8D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Unconditional extraction of `node_name` from sub-CRQs causes an al=
iasing bug for extended FPIN events, leading to target lookup failures.
- [High] KUnit test structures for extended FPIN events are allocated on th=
e stack without zero initialization.
- [Medium] KUnit tests lack validation assertions for statistics and suffer=
 from race conditions due to an unsafe sleep-based wait.

Pre-existing issues:
- [Critical] Using the list iterator `tgt` after `list_for_each_entry_safe`=
 terminates without a match causes severe out-of-bounds memory accesses.
- [High] Missing reference counting on `tgt` when accessed outside of `host=
_lock` leads to a potential Use-After-Free.
--

commit 5f5e44381670a22f5b1837898b25fb9f7a477edd
Author: Dave Marquardt <davemarq@linux.ibm.com>
Subject: ibmvfc: handle extended FPIN events

This commit adds extended FPIN handling to the ibmvfc driver. It tells the
VIOS that ibmvfc can handle extended FPIN messages and converts any received
FPIN messages to struct fc_els descriptors. It also extends
ibmvfc_process_async_work to handle these extended FPIN messages.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 36abca0bbd34d..93622cb76adc0 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -3437,8 +3474,20 @@ static void ibmvfc_process_async_work(struct work_=
struct *work)
> =20
>  	if (crq)
>  		fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> -	else
> -		fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +	else {
> +		sqfpin =3D (struct ibmvfc_async_subq_fpin *)subq;

[Severity: High]
Does this function safely handle the node_name extraction for extended FPIN
events?

When an extended FPIN event is received, subq->id.node_name is read
unconditionally earlier in this function. For extended FPINs, this memory
region perfectly aliases with fpin_data.event_threshold and event_count.

This results in node_name being populated with this FPIN data. Will the
target lookup then compare the target's WWNN against this garbage node_name,
fail to find a match, and reject legitimate extended FPIN events?

[Severity: Critical]
This is a pre-existing issue, but does using tgt after the list lookup loop
terminates without a match cause out-of-bounds memory accesses?

If list_for_each_entry_safe() finishes without finding a match, tgt will
point to an invalid address computed from the list head. Since standard
Linux list iterators are not NULL when the loop terminates, a check like
(!tgt) will evaluate to false.

Could accessing tgt->wwpn or tgt->vhost here cause arbitrary memory reads
or a kernel panic?

[Severity: High]
This is a pre-existing issue, but is there a missing reference count on tgt
when it is accessed outside of the host_lock?

Earlier in the function, spin_unlock_irqrestore() drops the lock after
finding the target, but no kref is taken. If a concurrent teardown or link
down event frees the target, will accessing tgt->wwpn or tgt->vhost below
result in a use-after-free?

> +		if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) =3D=3D 0) {
> +			fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +		} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
> +			dev_err_ratelimited(vhost->dev,
> +					    "Invalid extended FPIN event received\n");

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index 6bde921975492..fab36891dbc25 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

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
Does this macro actually verify the post-condition statistics?

The post statistics are read, but there are no KUNIT_EXPECT_* assertions to
validate them against the pre statistics. Will this allow the test to silen=
tly
pass even if the driver logic fails?

Additionally, is using msleep(1U) to wait for the asynchronous work queue to
process the event race-prone?

> +
> +/**
> + * ibmvfc_extended_fpin_test - unit test for extended FPIN events
> + * @test: pointer to kunit structure
> + *
> + * Tests
> + *
> + * Return: void
> + */
> +static void ibmvfc_extended_fpin_test(struct kunit *test)
> +{
> +	enum ibmvfc_ae_fpin_status fs;
> +	struct ibmvfc_async_subq_fpin crq[IBMVFC_AE_FPIN_CONGESTION_CLEARED+1];

[Severity: High]
Are these arrays of struct ibmvfc_async_subq_fpin safely initialized?

These arrays are allocated on the stack. The IBMVFC_TEST_FPIN_EXT macro
partially initializes them but leaves fields like fpin_data.event_threshold
uninitialized.

Could this stack garbage be passed to the driver, causing erratic test
behavior depending on previous stack contents?

> +	struct ibmvfc_async_subq_fpin
> +		crqcn[IBMVFC_AE_FPIN_PORT_CONGESTED][FPIN_CONGN_DEVICE_SPEC+1];
> +	struct ibmvfc_async_subq_fpin crqportdg[FPIN_LI_DEVICE_SPEC+1];

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-ibmvfc-fpi=
n-support-v3-0-d95b9547cf88@linux.ibm.com?part=3D8
