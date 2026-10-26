Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006634;
	b=bUrF/KqGyn3pIxPQdgwNYdnOcSE0TRXhj43NinnKJ1L1UuAmZfpA5tCZUqkNSKp/x0i3
	 NKbzSJNaJIfUYab3j/POMd+3OZCu+k3rTwLycsOBN31u/hw4proaolArGAa28UIhsvl6M
	 6y8DnIGmWx2MIB3wv2r/efsKAiOja3i3CFCops19eXT1yKiu5/bFKz+If61TYrrCk/b3a
	 6ztbBwV72SeQM5xw9isFhB4PemY2UO/QymTx+c776fsutpXTlT5Hr0D3yyvGfKKyAmgnD
	 KQos2OcKCXTT9AatCXkxp6pcpqIr2ox5ki8Lne9u3zf4sQoVI2PZh9T/FU1s0hQBSGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006634;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fbZMsWnaYIYM/ThLGYdbn20sA5Vi3c+iUF56iaPguYE=;
	b=aLxjP7AYtVC7NNB5ewQaRt+cinaxZ//tATLUxn4WLFBAVxFNBpbsi7cOwyYoUqQVEa1g
	 zeG32y2iVaWyvcylEL8OGgTbjyYOFsMzSpII4b6d01ihMUhNqDRt6IHOJ4kHXWTojAQPd
	 vE1zbrZQxWprEEtwYjJLRJJEcA6PVJxE7mCUmis9UBrPJiP/olvhcx4KrH7NFV9IeTa+4
	 7AvE+ZVRJRsef7T8La40hl/PyS+zHk+ojE7W26h5HFBb2OvhjPd92D6LS87omVg+DDMDV
	 wOtvldO5Jk8kjI+hVnMnOzCk6iALIs8PvNiu9gUtS78CSAhlWDv10J/vmcuxe64KGxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSXec617;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED274606A320
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 09:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSXec617
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE37C1F01829;
	Mon, 26 Oct 2026 09:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793006633;
	bh=fbZMsWnaYIYM/ThLGYdbn20sA5Vi3c+iUF56iaPguYE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=XSXec617JWKlqIHnA6n/GEYyOIDpdZVIJFJc15UgX7navg9S9D3NIuq2EJ1KWv0C8
	 bS8wsYS9rIYmLP5qJyYi2BYU4EQF1remdIgS8V9g60nGDJMcebB3IzZXRpMNJ4GJTN
	 p+iSyylRs0G57nnsX7ReHFkNlYTvNOHEBCJt9AXa+ztsNLr6GIlYABG6s0GTmwsClc
	 t0mwapUzdNRdEzS6XQR/6MT+DKbXsGC0YPbs6Ymm2Am/Hpg3dRzjItp96I92+zag8c
	 3gEcTphNeBj5OzRZ28ruYJv8VsRJAIBYAm7HfXK5T9445wU9X6zDXsLJlwNP0OWGDL
	 23zGHkMlhPKtw==
Message-ID: <sashiko-outbox-184774@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] scsi: ufs: Change the error check sequence for auto
 hibern8
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261026052632.1848929-1-hy50.seo@samsung.com>
References: <CGME20261026053046epcas2p31ae8a493f40c0f12523feec6e036072f@epcas2p3.samsung.com>
 <20261026052632.1848929-1-hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:23:53 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ufs: unmatched opening brace in ufshcd_uic_cmd_compl()
--

commit 0662e042cc8b3241cb51d99b2a23b42e34c3390e
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: Change the error check sequence for auto hibern8

This commit moves the auto-hibern8 error check in ufshcd_uic_cmd_compl()
ahead of the active UIC command NULL check so that auto-hibern8 errors are
recorded in hba->errors even when no UIC command is active. It also avoids
logging an error for a missing UIC command when an auto-hibern8 error is
detected.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index cc75384c65021..1dd9fbf2e696c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5928,16 +5928,22 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct uf=
s_hba *hba, u32 intr_status)
>  	struct uic_command *cmd;
> =20
>  	guard(spinlock_irqsave)(&hba->host->host_lock);
> +
> +	/*
> +	 * Auto-hibern8 is performed without a UIC command, so check for
> +	 * auto-hibern8 errors before checking for an active UIC command.
> +	 */
> +	if (ufshcd_is_auto_hibern8_error(hba, intr_status)) {
> +		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
> +
>  	cmd =3D hba->active_uic_cmd;

[Severity: High]
In ufshcd_uic_cmd_compl() in drivers/ufs/core/ufshcd.c, the
if (ufshcd_is_auto_hibern8_error(hba, intr_status)) statement opens a brace
without a matching closing brace before cmd =3D hba->active_uic_cmd.

Because the block is never closed, the remainder of ufshcd_uic_cmd_compl() =
is
enclosed inside the conditional and the final brace of ufshcd_uic_cmd_compl=
()
closes the if statement rather than the function body, breaking compilation
when building drivers/ufs/core/ufshcd.c.

Should the opening brace on the if statement be removed (or closed with a
matching brace)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026052632.1848=
929-1-hy50.seo@samsung.com?part=3D1
