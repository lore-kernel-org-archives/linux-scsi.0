Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793354302;
	b=cWm5ztEWWgdg9iyzGhfC0UaWGtKKsWukx1JJDd2NspgsBzcOIeWXBGVfIEYodbKtxN6B
	 D4qBWyV/8eFojT+kDhla4FgvPaV1qMjkCHZlRwbbP9bkbhwf0XX6FR8FXOgQTbiYeB208
	 ME6tAenEHMQcWxAO1g+JTrEqX3zGe4f6bAMdcA4hOjFkvObY80HCFSaBettXCpjRjj1ek
	 u4IewA9CCody/ie1k627gVcLj7wpB36bAdNH8oooyjE7gsoMGXgXN8I5gMRy7tRqxk7P7
	 9W5mgK2O/SccIZ0EoN/BwfJFrYfKLQ5W5ElAs+Rd9/uLan6dyntpwU0WfC81wJIEkXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793354302;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=SuIC54P4TRtU4P0ZZNQgb58E7FQF+CaCMzpYRV82n7g=;
	b=nFhivO0FY9PU2FysSGQ/Q+TG1DTPJA2xKzDlasbsNWoo1Azvv0cU0d7wBC7CPoP3YTqy
	 bKJHpSG/MzVftVcsN9Ac4X9RBQMabUpK/wLkl89BJHr4bbD8hzUergHj09l7Y6lLphHkw
	 59wysrVxuAF0hNKFH2IGSqyjpNlxzYl5bX96vDeeFNd8bjx0C40Mrgt1R2e2gxpxrwy3r
	 PgonvGSLDz/Dan5rw6f4HYtmZId5Y9DsKte7A7j2mCy8/1qZLL70gd3oIX1y1YfG8/nUH
	 XzLCX1CjrxwOjiNrH71/Nb6hH1TWAz/n4+Af9LFb48tj9u59wR0mU+UCr65i+mWptJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cc684Clb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02D8606A31D
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 09:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cc684Clb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE0C1F000C1;
	Fri, 30 Oct 2026 09:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793354301;
	bh=SuIC54P4TRtU4P0ZZNQgb58E7FQF+CaCMzpYRV82n7g=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=cc684Clb7d+Gf/4yFIocb0U/mcVQ34DayC1joI3zkMFkhTvW1MUoxmNF6Mu1YXTZs
	 PfAHTrxfd4fv6qljBOs2xqezUvr+N+nHJC8SQjsTyH5+WPMOzfTPfHHsHry7xpoGH6
	 bTn9bEzjxW7bCmwhg0rzkJkqo58VwaSZHrsc7TY8RhMezX0ldF7lNVKKCjwLl7C8R7
	 RbzZwZ6LPyo3s/K+uNT5UZ6GjUVZvRDOYvGeqSfhQtbEM1K0lGw0365kBZ48TQiV/r
	 59OuGFWxPFVh2yiJwe2yhdzCIbiNFemKtsqpF5PkGWkzLLHVacCLTDUT24bjhlRUC5
	 sJXRT+eW/CVhQ==
Message-ID: <sashiko-outbox-190791@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ufs: mcq: fix dev cmd abort path and add OCS poll
 after sq cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kiwoong Kim" <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261030093645.790159-1-kwmad.kim@samsung.com>
References: <CGME20261030093653epcas2p329f2bb351b051a118edad4211b4b3470@epcas2p3.samsung.com>
 <20261030093645.790159-1-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 09:58:20 +0000
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
- [Medium] ufs: mcq: re-read header.ocs after timeout in ufshcd_mcq_sq_clea=
nup()
--

commit 840d70c7b6d87e03c26e1ea5e9102ecbc05ff2f0
Author: Kiwoong Kim <kwmad.kim@samsung.com>

ufs: mcq: fix dev cmd abort path and add OCS poll after sq cleanup

This commit skips the task management path in ufshcd_try_to_abort_task()
for reserved device management commands and calls ufshcd_clear_cmd()
directly. It also extends ufshcd_mcq_sq_cleanup() to poll header.ocs for
device management commands after SQ_CUS is set.

Link: https://lore.kernel.org/linux-scsi/20261030083311.602909-1-kwmad.kim@=
samsung.com/

> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 25e392f8ede2b..8c8b8e018fbdc 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -613,6 +613,31 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int t=
ask_tag)
>  			 __func__, id,
>  			 FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
> =20
> +	/*
> +	 * For device management commands, there is no order guaranteed between
> +	 * OCS update and CUS update, which is why we need to wait here. SCSI
> +	 * commands are excluded because the OCS in their UTRD is not updated
> +	 * from the CQE.
> +	 */
> +	if (!err && blk_mq_is_reserved_rq(rq)) {
> +		enum utp_ocs ocs;
> +		ktime_t start =3D ktime_get();
> +
> +		do {
> +			unsigned long flags;
> +
> +			spin_lock_irqsave(&hwq->cq_lock, flags);
> +			ocs =3D READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
> +			spin_unlock_irqrestore(&hwq->cq_lock, flags);
> +			if (ocs !=3D OCS_INVALID_COMMAND_STATUS)
> +				break;
> +			usleep_range(20, 50);
> +		} while (ktime_us_delta(ktime_get(), start) < MCQ_POLL_US);
> +
> +		if (ocs =3D=3D OCS_INVALID_COMMAND_STATUS)
> +			err =3D -ETIMEDOUT;
> +	}

[Severity: Medium]
Can this loop in ufshcd_mcq_sq_cleanup() return a false -ETIMEDOUT if the
CQ interrupt updates lrbp->utr_descriptor_ptr->header.ocs while the task
is sleeping in usleep_range(20, 50)?

If the task wakes up after MCQ_POLL_US has elapsed, either on the final
polling iteration or due to scheduling delay on a busy CPU, the while
condition evaluates to false and exits the loop without re-reading
header.ocs.

The subsequent check then evaluates the stale pre-sleep ocs value and sets
err =3D -ETIMEDOUT, which causes ufshcd_mcq_abort() to fail and trigger an
unnecessary full SCSI host reset even though the command cleanup completed.

Should this re-read lrbp->utr_descriptor_ptr->header.ocs under hwq->cq_lock
after the loop exits (or use poll_timeout_us() from include/linux/iopoll.h)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030093645.7901=
59-1-kwmad.kim@samsung.com?part=3D1
