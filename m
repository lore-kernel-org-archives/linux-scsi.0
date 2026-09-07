Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E173D51D50F
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 19:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809736; cv=none; b=phyqmvWQDhqAj2/uzgu3Oe6yLF/6nJ5+z21Huf6VRDEB212E3EQN8ZBAmqIwtD1RnuoDCZdtAAKeHp4hqa/jyYlf3QIRiof4zqn+dWCinhyAfo3lIwIpZTEKcyPiGxW0RX62pQcqVA/v5Z7nEz7xzBI+1yh4L/M8aOV+4pWAg8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809736; c=relaxed/simple;
	bh=sIwANLVvBaxAxxuF9cxlEldHh0n3pdsVz6bwiZ3LeS8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E/ePsdg8/MIoZLdPje47xKrqR4J8qGghA5nRZm2yszj71cE3FablZ3NiF+41HZcnS8nacBVH843IRupshGCEuqJVqpcJ4ci9sbbuGbKsvgBZ/A8NIwR5gYEWlCYS/tHOSKLmXXkpR8fphB5p9/BaX3HNl/1IcFEnNTNlO8mao10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIkudprS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIkudprS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6919B1F00A3A;
	Mon,  7 Sep 2026 19:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788809733;
	bh=ajp+7/lELcXD0f7E4GsFBQlq49tiwiSqJK5JbNZTxJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SIkudprSv2WYswrcYK7bQvg+7pqBzFlJ+OxJ3oZ5XSA5KhdmupykS9YyXt3BhSruI
	 mubYTv0I/BcHwFq///xz7tGIw91j3d6yxtoyem5xlG24rd7dHKkP2LS5JPaHPyZL56
	 pXW7ibAOZ5ZRS3YEWJi2p0GSpIPVB6VCCAU0LBFbD7JNvJ6pg/1b6ltKRnVzwOqh9s
	 D1+anDbPE005CSOXFSOdCrnVXzvzBL+MjT+YrMZYthvCViG13gcow1gRg9VF7qRuBp
	 oqSSMAryR09S0CrpJt0E5jlMkxWpdBksMqKZHqyHxI92qmd2LGHO1ELQ6wCPro4LPD
	 2B6bc40tDItAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: core: Report the current clock
 frequency to devfreq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bean Huo" <beanhuo@iokpp.de>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907192140.2701755-5-beanhuo@iokpp.de>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
 <20260907192140.2701755-5-beanhuo@iokpp.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 19:35:32 +0000
Message-Id: <20260907193533.6919B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Lockless read of shared frequency states (target_freq and curr_freq=
) introduces a data race.
--

commit 33056f7bc209eb72a0cfba73ae939b67d7a4ed81
Author: Bean Huo <beanhuo@micron.com>

scsi: ufs: core: Report the current clock frequency to devfreq

When a driver does not provide a ->get_cur_freq() callback, the cur_freq
sysfs attribute shows devfreq->previous_freq. This commit adds a
->get_cur_freq() callback to report the current clock frequency accurately.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 351c76094b9ff..bac95e891de5d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1711,6 +1711,26 @@ static int ufshcd_devfreq_get_dev_status(struct de=
vice *dev,
>  	return 0;
>  }
> =20
> +static int ufshcd_devfreq_get_cur_freq(struct device *dev, unsigned long=
 *freq)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +
> +	if (!ufshcd_is_clkscaling_supported(hba))
> +		return -EINVAL;
> +
> +	if (hba->use_pm_opp) {
> +		*freq =3D hba->clk_scaling.target_freq;

[Severity: Low]
Is it possible for this lockless read of target_freq to race with frequency
scaling updates?

If the devfreq sysfs cur_freq attribute is read concurrently with updates l=
ike
ufshcd_clkscale_enable_store() or ufshcd_devfreq_target(), could it trigger=
 a
KCSAN data race warning or result in a stale read? Should this be protected=
 or
use READ_ONCE()?

> +	} else {
> +		struct ufs_clk_info *clki;
> +
> +		clki =3D list_first_entry(&hba->clk_list_head,
> +					struct ufs_clk_info, list);
> +		*freq =3D clki->curr_freq;

[Severity: Low]
Similarly, could this lockless read of curr_freq race with updates in the s=
ame
way? Might READ_ONCE() be needed here to formally resolve the race?

> +	}
> +
> +	return 0;
> +}
> +
>  static int ufshcd_devfreq_init(struct ufs_hba *hba)
>  {
>  	struct list_head *clk_list =3D &hba->clk_list_head;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907192140.2701=
755-1-beanhuo@iokpp.de?part=3D4
