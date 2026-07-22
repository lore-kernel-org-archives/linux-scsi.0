Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FEE361651
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 04:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784694468; cv=none; b=r0vJcaJ/mGbeHuWln1KQjfq4HpZWq3Q5AezWjagUiTRU6/F4/Xk6E4Tu4YD+CjIYZI98Hn5Kt72ld7wLH2waLTJj6oUKxN2zBExo2mov5Cxyxmhws1DbRNde3i0Dcm6s4/VpkNCFDNmCmV6oUabmeCJBLmQUst6JxrTUOX3Ko9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784694468; c=relaxed/simple;
	bh=sPeLc2IQVmHXjpGNFcjFB2bm9OVrLHSaOZlxlttklOY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kIyuln3r9o+avWjGOpzz94HF6EBDxZNWhxdE7osQFvZkDcQJE4Awhit/X8jletphgdsb7956sRaP/2Obp/pWfaNB4RZb++QZdpBRX1arSAs/JtWKOkIjaDTpXpUitLWIICnotEEuKqsPXPffYmkwnbi+HovkktcIMcUY7mVBBSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSnsNRe7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSnsNRe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1B01F000E9;
	Wed, 22 Jul 2026 04:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784694464;
	bh=4o86OBZzWDMKVOPPeEPn9aHnOju7sqHmK/4rzWCK/g4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bSnsNRe7dRaGBhBdq8ANRblxCJoTojajThytG4zIMpF4fOfHajO2zDDfFKZu42hS8
	 5TCJ+3Oz6kZbsTIHM/MF+f9Nh//FjOH0Rx4sVHaPlnp8drHIojoUXfLJeKzTVHI3hK
	 f52Koz0owjoyikVwqEdRMRlK6e9+1nkJj++LdL+lV3xveXmwZE7pXdJ/pUKWZir1QH
	 ovd7ij5NFgp36X83AnyZtvipU1o0pc1ChWQVQqjL4v5bSJhk/dm98ZWwY3hUgQv0Kp
	 zBOUHOAclHVu0nWy9eRgOyAoDkm4GM3Lauq2f04bdqMYkhOn+XEqXPRBeeFd7NLBN6
	 7WRcajFZwpl9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: validate variable event array spans
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 04:27:43 +0000
Message-Id: <20260722042744.5C1B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] TOCTOU vulnerability on shared DMA memory bypasses event validation

Pre-existing issues:
- [High] Missing bounds check for unhandled event types allows out-of-bound=
s read
- [High] Kernel panic in error path due to kfree() on a flexible array memb=
er
--

--- Patch [1]: [PATCH] scsi: mpt3sas: validate variable event array spans -=
--
commit 151ce14025a2487b9520990fe50767c45e6d12d5
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: mpt3sas: validate variable event array spans

This patch adds validation for SAS topology, PCIe topology, and IR configur=
ation
events to ensure variable arrays fit within EventData before dispatch.
Malformed events are dropped after being acknowledged, while other event ty=
pes
retain their existing behavior.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 79052f2accbd3..2a9ea81d1e2b0 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
[ ... ]
> @@ -1333,6 +1333,65 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *i=
oc,
>  	ioc_info(ioc, "%s\n", desc);
>  }
> =20
> +static bool
> +_base_variable_event_data_valid(struct MPT3SAS_ADAPTER *ioc,
> +				Mpi2EventNotificationReply_t *mpi_reply)
> +{
> +	const size_t event_offset =3D offsetof(Mpi2EventNotificationReply_t,
> +					     EventData);
> +	const void *event_data =3D mpi_reply->EventData;
> +	size_t event_data_len;
> +	size_t reply_len;
> +	u16 event;
> +
> +	event =3D le16_to_cpu(mpi_reply->Event);
> +	switch (event) {
> +	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
> +	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> +	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
> +		break;
> +	default:
> +		return true;
> +	}

[Severity: High]
This is a pre-existing issue, but since we are adding validation here, does
returning true early leave other event types vulnerable to out-of-bounds
reads?

When mpt3sas_scsih_event_callback() processes unhandled events, it uses the
unvalidated EventDataLength to calculate the payload size:

    sz =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;
    fw_event =3D alloc_fw_event_work(sz);
    ...
    memcpy(fw_event->event_data, mpi_reply->EventData, sz);

Could a compromised device supply a large EventDataLength (e.g. 0xFFFF) for
other events, causing memcpy() to read out-of-bounds from the ioc->reply
DMA pool?

> +
> +	reply_len =3D mpi_reply->MsgLength * 4;
> +	if (reply_len < event_offset || reply_len > ioc->reply_sz)
> +		return false;
> +
> +	event_data_len =3D le16_to_cpu(mpi_reply->EventDataLength) * 4;

[Severity: High]
Is there a Time-of-Check to Time-of-Use window here since mpi_reply is read
directly from shared DMA memory?

The validation function reads bounds from mpi_reply, but after validation
passes, mpt3sas_scsih_event_callback() re-reads fields like EventDataLength
and NumEntries directly from the same DMA-backed memory.

Could a malicious device mutate these fields in the window between validati=
on
and use to bypass the checks introduced by this patch?

> +	if (event_data_len > reply_len - event_offset)
> +		return false;
> +
> +	switch (event) {
> +	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST: {
[ ... ]
> @@ -1521,6 +1586,8 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 m=
six_index, u32 reply)
>  	ioc->put_smid_default(ioc, smid);
> =20
>   out:
> +	if (!event_data_valid)
> +		return 1;
> =20
>  	/* scsih callback handler */
>  	mpt3sas_scsih_event_callback(ioc, msix_index, reply);

[Severity: High]
This isn't a bug introduced by this patch, but looking at
mpt3sas_scsih_event_callback(), is it safe to call kfree() on a flexible
array member in the error path?

If kzalloc() fails for fw_event->retries, the error handler does:

    ioc_err(ioc, "failure!\n");
    kfree(fw_event->event_data);
    fw_event_work_put(fw_event);
    return 1;

Since event_data is declared as a flexible array member at the end of
struct fw_event_work, doesn't passing this interior pointer to kfree()
trigger a kernel panic?  The subsequent fw_event_work_put() already
frees the whole structure.

> =20
>  	/* ctl callback handler */
>  	mpt3sas_ctl_event_callback(ioc, msix_index, reply);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722041257.1557=
-1-pengpeng@iscas.ac.cn?part=3D1
