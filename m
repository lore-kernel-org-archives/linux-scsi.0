Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66673822AB
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 18:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790619426; cv=none; b=Eh9F/cUbyWLQtuIAwhnfo1V/AWeSUbCHjQ908Ib4CVGaR3a2AeNemWSmGKvdcqX07O5qPdvvf8k/2/aADL6gQiRDJ3oOzu6Mbb7jWBlcviy8q3cagr3/J+IVAwiyu3/UIDNzTFdJR5aSEmd8yO5ibfBiSDiy5SbSfcoiuEO9f+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790619426; c=relaxed/simple;
	bh=ywQln+8hB64SpzarDwFRFyX/XpaoO1LigU7VQBMBpBk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aFjOE1+96mLh4TRiJVf43Eqg1T4WgC1RtoiEdJtwT1l9PObLhXV5JlDRjbZR62oL24v7GL8Q45Mqi6yO3WfIFSK2UrZBg7Sln7oyq8EvbDo6wu6nBccOBm8OmJHfL4uYk9588oitSUO4W9yfh4aYdO4o/2RAt0+J854a8WEWVJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DC8x/w08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DC8x/w08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C721F000FF;
	Mon, 28 Sep 2026 18:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790619424;
	bh=aZetK73qPsihqq8smp3yfB+nEm2HfPOwo/bpyEjH4c0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DC8x/w08RtaWaZZfUmEXDmyFv+bPuz8xw02pSDGaknqmj/uCz+7WTXxUTDba8bb3k
	 Q5GQHyKAysQlWNOyMm9OX7o6Kod2oYMO81SQQIRIPklIjhZC+gzk2YbLvv5xDbuhR5
	 B6l7THDk3mrhvbIS1OzaWD/NhelkB5Nn5CH+2E5dB4aXMt4iAiYwBqmRoOOO/MFJgs
	 w9uEpAe3RNl9w0VZu/6A3AthWTXNVS4tbMjoVOK1BbXrXeSFxWBddCpUKO5TH0334l
	 coGficJYvSdQDH8LljnsYnQDhy7Jgy1xM9kiWrA0u7XOn6JB91cYMWUno3zkZmrJrY
	 Z3THg8mYoG9fw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/10] lpfc: Add handling for when PLOGI or PRLI is
 dropped during link failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nigel Kirkland" <nkirkland2304@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260928181757.21959-6-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
 <20260928181757.21959-6-nkirkland2304@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 18:17:03 +0000
Message-Id: <20260928181704.15C721F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] lpfc: clear_bit(NLP_PLOGI_SND) is a no-op since flag is never set
--

commit 0b98cf6de331fab63e77fe03e2cd19be5c4624b1
Author: Nigel Kirkland <nkirkland2304@gmail.com>

lpfc: Add handling for when PLOGI or PRLI is dropped during link failure

This commit adds handling for dropped PLOGI or PRLI during link failures by
clearing their respective send flags and decrementing counters in
lpfc_cmpl_els_link_down(). This is intended to prevent logistical mixups and
allow the login session to recover correctly.

> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 45aad4cd2dc80..cd431c7bd9f08 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
[ ... ]
> @@ -1237,17 +1239,40 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, st=
ruct lpfc_iocbq *cmdiocb,
[ ... ]
> +	if (cmd =3D=3D ELS_CMD_PLOGI) {
> +		/* A PLOGI ELS IO needs to clear the PLOGI_SND flag to
> +		 * acknowledge the ELS completion and allow recovery. Otherwise
> +		 * a subsequent PLOGI gets rejected as a duplicate.
> +		 */
> +		clear_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);

[Severity: Medium]
Is the NLP_PLOGI_SND flag still being actively used by this state machine?

It appears that this flag is never set anywhere in the lpfc driver codebase.
If NLP_PLOGI_SND is never set, this clear_bit() operation is a silent no-op.

Could this mean the intended PLOGI recovery mechanism is non-functional, and
subsequent PLOGIs might still get rejected?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928181757.2195=
9-1-nkirkland2304@gmail.com?part=3D5
