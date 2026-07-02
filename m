Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599F539DBF7
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 18:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783015897; cv=none; b=eTu/pU81YS0HBO5XYklsu9o9PoxPQI+x2ynDWyHQCKUA5ahS+kXayZYvE0ynzL8QvprBCcSTlZDcXAjUdr0YqAiKrggY4AK6AIceoLV3NP9/nDAhKfnltMxz5yGQ1gEqx8YePqmOZkSguM5DcpUbBGfLPDESD7zFLJUcQa7RDhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783015897; c=relaxed/simple;
	bh=VKmDJYcixLqKm9xmJ7RpWcEZGft7Vw0NIa8x9ETs6yA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lnSPdUjPsAr2CeSJDocwGGbvbgJzivGxoJrhTvB5MSA2PiYwUgzaEGdFpgz/TOGksXwFXStw8prCa48ZYBg8u8v34s7eMtUxoabevj8VXMr2s23MPvB4lpKlwhRWT+r9lflcKQ5OSN497b1Gsw40TPV0iFEw+1cs5pk45qMN/tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJUAhIJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJUAhIJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E1D1F000E9;
	Thu,  2 Jul 2026 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783015896;
	bh=BrvLD9+rn1M5/Cbrj3q/7qlFjMmdGd7VWKGrxwHLfwE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dJUAhIJ/wX2L21RtjZ3+tOHVcGsm15eGoFyGQjPHTDfH7xNXS+ZmfVlo0dbIbxV2Q
	 i8yLl6swzBbwa/uYi+ms98eTH8lgXkIwIWzJY4LngiOqj/GyrPsRGf/RY03KpCkGKz
	 /vP5hdHMaZ0KKeenljDrzNSFvtOXIf3Vp5lbejAkxka8yrNEooHUc0Q+ZXMUh5dcDy
	 VPaFfeHXXUOZLxwwH+32hIH9GlVTmHgj/bk07ZRRwaayAc67rWlQjIctD8S1P/DNRZ
	 zFrUIPrORsCr5IXom0XUz+ULOIDY7Hvd7O7Gw60ROXnvdMNzOOmQ1Dx/RVGfgeNHkk
	 ddUxfvWaNDDgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/8] ibmvfc: Add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702-ibmvfc-fpin-support-v3-2-d95b9547cf88@linux.ibm.com>
References: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
 <20260702-ibmvfc-fpin-support-v3-2-d95b9547cf88@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 18:11:35 +0000
Message-Id: <20260702181135.D2E1D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Incomplete and insecure VFC_NOOP handling in `ibmvfc_handle_scrq` =
leads to protocol bypass and potential data corruption.

Pre-existing issues:
- [High] Untrusted Pointer Dereference in `ibmvfc_handle_scrq` leading to k=
ernel panic.
--

commit 026aa88f6415105823a4b94ede2214dbab9c0f42
Author: Dave Marquardt <davemarq@linux.ibm.com>

    ibmvfc: Add NOOP command support
   =20
    This patch adds support for receiving and recognizing VFC_NOOP
    messages from VIOS. This is done by defining the VFC_NOOP CRQ format,
    recognizing the VFC_NOOP CRQ format in the CRQ handler, and setting
    the "can use VFC_NOOP" bit in the capabilities sent during NPIV login.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index b63f41a6cfffd..110d77b9aac32 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -4099,6 +4109,10 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *=
crq, struct ibmvfc_host *vhost
>  		return;
>  	}
> =20
> +	/* Some CRQs, e.g. a VFC_NOOP command CRQ, do not have an ioba, so evt =
is NULL. */
> +	if (!evt)
> +		return;
> +

[Severity: High]
Does this blanket check safely handle VFC_NOOP messages?

If the VIOS sends a VFC_NOOP message with a valid, non-zero ioba that
corresponds to an active SCSI command, the sub-CRQ handler bypasses the
if (!evt) check. It will proceed to validate the event and erroneously
complete the active SCSI command using the NOOP's payload.

Additionally, this blanket check silently drops any other malformed zero-io=
ba
CRQs without logging them, and bypasses the IBMVFC_SUPPORT_NOOP_CMD capabil=
ity
validation that is explicitly implemented in the main ibmvfc_handle_crq()
handler.=20

Should the Sub-CRQ handler explicitly verify crq->format =3D=3D IBMVFC_VFC_=
NOOP
exactly like the main handler does?

[Severity: High]
This is a pre-existing issue, but can the event validation later in
ibmvfc_handle_scrq() cause a kernel panic due to a wild pointer dereference?

The ioba is cast directly to the evt pointer. If the hypervisor or VIOS sen=
ds
a Sub-CRQ message with a malicious or uninitialized non-zero ioba value, evt
is dereferenced before it is validated:

drivers/scsi/ibmvscsi/ibmvfc.c:ibmvfc_handle_scrq() {
    ...
	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
    ...
}

Could the struct ibmvfc_queue be passed directly to the handler so
scrq->evt_pool can be used for validation without dereferencing the
untrusted evt pointer?

>  	/* The only kind of payload CRQs we should get are responses to
>  	 * things we send. Make sure this response is to something we
>  	 * actually sent

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-ibmvfc-fpi=
n-support-v3-0-d95b9547cf88@linux.ibm.com?part=3D2
