Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB91376A08
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 10:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209941; cv=none; b=RWYY3z3CFyKgmTMPGj6fFMiCuYtnRtWgpQP60TS1ddJ/B0YIrLSU2EHcSNm6WxO6w3cpEjES5Zr/BuxTeI5+qyBWhKI10g8pgbZrKUU2qOEks2lWIyv+Wj1H9bV/1hZwFFwOGe+hYdF+VHjOVHvRZiH8wgYGZORQJLIUa2a5boQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209941; c=relaxed/simple;
	bh=PfeOpXFjD/d7vkPDgAUWki8pDoPz5Hfq/+AzE9jbRBM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z3HgQubIJUz8fNt0Fj0Fug6ohPgv3xHZuD+XndMmTMoFwUlqGLHe2vFcxeWmxfmJYci5FsIwnYP+CAdtRGaDEsZ9c3waNHMrPrqEKY8ZENzULxMqjrpaZxNEro22yeOi5xrvBJqrwiL7xFkM8V6zQNYljZEmWxX8veZB0ypDk4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOxk6CBZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOxk6CBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E81F1F000E9;
	Tue, 23 Jun 2026 10:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782209940;
	bh=2YwVkTqsDN486sba4btZkJy0w3uUQZaaoPRy0yIsexM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SOxk6CBZYMy4yh2QCK+2+eTHevcF1lsEb0r7cDkR5sLhRWOocCiCdvDyBgsQK3sww
	 QHc7ozzlXQ65uWsv3iDKNJzul93bDoOKuCKUtpTPhinhw2zG/dPKsGO+xdFe8wqJ4F
	 V0FE3RzOUxvlRycM8KQ2U6ewlyJpkkSZSqnuX3UZ/shJAAbAEMcjk8VrESqoarTBmh
	 iqFz3ZoDTsjv5AFWY6H17BHw8/xMG51JQuSovTcrwSN+GsuHwiL2qPvzZ7e5wOFtvN
	 NOe8gvXKefQmJ4QHLCXOZUIC1huuifTq/5sCcvqTapLSBFrsEtdwBA2jcOCm6UUjcR
	 4q/JyC2eM7j6g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 4/4] scsi: sd: fix sd_done() sense handling condition
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623100159.4018066-5-yangxiuwei@kylinos.cn>
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
 <20260623100159.4018066-5-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 10:18:59 +0000
Message-Id: <20260623101900.5E81F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch introduces a logic regression by unconditionally bypassi=
ng valid sense data processing for any SCSI status other than SAM_STAT_CHEC=
K_CONDITION.
--

commit 6e9e6fa97257d1c3c528406c9719d2273c7f5a65
Author: Yang Xiuwei <yangxiuwei@kylinos.cn>

scsi: sd: fix sd_done() sense handling condition

This commit modifies the conditional in sd_done() to avoid entering the
sense_key switch with an uninitialized or stale sshdr when a CHECK CONDITION
occurs with invalid or deferred sense data. It replaces the previous logic
with an OR condition.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2419,8 +2419,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
>  	}
>  	sdkp->medium_access_timed_out =3D 0;
> =20
> -	if (!scsi_status_is_check_condition(result) &&
> -	    (!sense_valid || sense_deferred))
> +	if (!scsi_status_is_check_condition(result) ||
> +	    !sense_valid || sense_deferred)

[Severity: High]
Does this logic change inadvertently bypass valid sense data processing for
any SCSI status other than SAM_STAT_CHECK_CONDITION?

For example, if a low-level driver completes an I/O with
SAM_STAT_COMMAND_TERMINATED alongside valid sense data like RECOVERED_ERROR,
!scsi_status_is_check_condition(result) will evaluate to true.

This would cause the code to immediately jump to the 'out' label, skipping
the sense key switch block. Because good_bytes is initialized to 0 for any
non-zero result, the command will incorrectly fail instead of being handled
as fully or partially completed.

Would it be better to solely check if (!sense_valid || sense_deferred) to
ensure sshdr is initialized without discarding valid sense data on other
statuses?

>  		goto out;
> =20
>  	switch (sshdr.sense_key) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623100159.4018=
066-1-yangxiuwei@kylinos.cn?part=3D4
