Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F763C8C43
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786030333; cv=none; b=gDjuFcVyHFFz6rSsOsspdqw0GGwB12ATP03kpDiDYgf7BfPDLS1CsbXa6gJqJKPbUXl74qpXQBPeQvz8kxJQFJDPXNX4kxZ+RA76/TSmTg0vnG2HDbssLbcsTmw1GuN98DfwkKEIblrR553N2IqFL+qfz9ME9EgeClWFtvW2A2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786030333; c=relaxed/simple;
	bh=aL8hU8qFHTc97niOlnJW4nKE//nn21jwP/CMixIRvyY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tDj4NS2bAqg4Q5HegBGrJLpvURbeSfVwFVYk1HlyRupMuKGZb81nnfAlY52qR1LWXvyFaZhECZCTp48wafGHeSd24YqLPyC7/z9PWsf+oCUFu29E2XC9yu8r4DZ9aEXt2Sign/wrVyeTM+5vLfF0TFKQi1stlGqJLeX2uFG7l9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UB27Z7Fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UB27Z7Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A701F000E9;
	Thu,  6 Aug 2026 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786030332;
	bh=f5+JwVPUm6r/V8HHTp3/m/3zPeuVIbw0sPaZ7UkTLHk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UB27Z7FnpbmGEwhq6K8UzTSPZ+9AGlWEl5qG8jt1WuZvvAmACDOUsxZmKjEdBEiu4
	 N8/i4TuCozJ5HiupmQrp3iua/leq41m1blNh1fR6oVgfJSQj1LSAVHCsimE4h4nzU5
	 sY3DpQBwpGx4RIXOiVlBNf8FaCsUq4VKz/hWFWcsZCZ3FqEHhjctZUiT00Z+Wq1qww
	 D0G+tJDVP94o988d5tAawsOqBiSgcBPgh+mCm4kh9huiInU5P4XKKK00ZuCHomq1mP
	 SKuSpKnjh5GkhleB1QKfDJxT28oxgt7rJ/aUmUB2jTr4+Keron+fvEzCENCVcsbk56
	 qDF/HmJa/0w3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/7] scsi: ibmvfc: define asynchronous sub-queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806-ibmvfc-fpin-support-v5-3-13fd6f8a8f8b@linux.ibm.com>
References: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
 <20260806-ibmvfc-fpin-support-v5-3-13fd6f8a8f8b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 15:32:11 +0000
Message-Id: <20260806153212.43A701F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch is heavily flawed due to a botched rebase or split: it=
 introduces dead, duplicate structures and an unused pointer, while the com=
mit message describes changes that are completely absent from the diff.
--

--- Patch [3]: [PATCH v5 3/7] scsi: ibmvfc: define asynchronous sub-queue -=
--
commit 3e3cb1faf7e598eb3299f36518825168d60237a2
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: define asynchronous sub-queue

This commit defines data structures for asynchronous sub-queue support requ=
ired
for full and extended FPIN functionality.

> Update ibmvfc_channel_setup structure to include async_subq_handle field
> and reduce IBMVFC_MAX_CHANNELS from 502 to 501 to accommodate the async
> sub-queue. Add async_scrq pointer to ibmvfc_channels structure.
>=20
> Add capability flags IBMVFC_USE_ASYNC_SUBQ and IBMVFC_SUPPORT_ASYNC_SUBQ
> for negotiating async sub-queue support with VIOS during login.

[Severity: Medium]
Are the changes described in these paragraphs of the commit message missing
from this patch? The updates to ibmvfc_channel_setup, the reduction of
IBMVFC_MAX_CHANNELS, and the new capability flags do not appear in the
diff below.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index e8ca0d30f483f..3711be4b6748c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -791,6 +791,25 @@ struct ibmvfc_async_work {
>  	struct work_struct async_work_s;
>  };
> =20
> +struct ibmvfc_async_subq {
> +	volatile u8 valid;
> +#define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
> +#define IBMVFC_FC_EEH			0x04
> +#define IBMVFC_FC_FW_UPDATE		0x08
> +#define IBMVFC_FC_FW_DUMP		0x10
> +	u8 flags;

[Severity: Medium]
Is this new ibmvfc_async_subq structure actually needed, or could this be an
accidental duplicate from a rebase?

It appears to be functionally identical to the pre-existing
ibmvfc_async_sub_crq defined earlier in the same file:

struct ibmvfc_async_sub_crq {
	volatile u8 valid;
	u8 flags;
#define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
	u8 link_state;
	u8 fpin_status;
	...

This newly added structure doesn't appear to be used anywhere.

[ ... ]

> @@ -935,6 +954,7 @@ struct ibmvfc_queue {
> =20
>  struct ibmvfc_channels {
>  	struct ibmvfc_queue *scrqs;
> +	struct ibmvfc_queue *async_scrq;

[Severity: Medium]
Is this async_scrq pointer intended to be used? It is added to
ibmvfc_channels here but appears completely unused.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-ibmvfc-fpi=
n-support-v5-0-13fd6f8a8f8b@linux.ibm.com?part=3D3
