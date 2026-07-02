Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A450282F15
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 03:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782964234; cv=none; b=lfIuFlUey7D5LK9SMV+jSoucN8tpW8y9yzdF/uHps5ftZF2j7uJq5CoJrEuhwKknD0fv0StYVZc+FN8YR974/29F5o1fnSHzUqwNNBvpQ1jhgUrRzjJtv45xnC9TNAevZbambsel+BK2PzlKWAe613Q8kfNP0k1qTq+o1c2wyIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782964234; c=relaxed/simple;
	bh=mTBo2ihvkwORhk6/Us9pZDnsn5lOW4/uTQjaes/XaA8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G8lNZE/GfkhFTwQMCmEIUYw9m+t0+t9s5w01xFZZY9zGssnvheu4zXhjbGp05SlO/wZCzNCPQ17F9+AeNqGgQq4vmoKNBph6JtZCuO9Tb0g4igcj8xdz/xNHY/ZSBLv/6RTXm8rVkjOoIX6X1uBTc6eaIcA4OzcPYAooeX1OS/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPV4aJli; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPV4aJli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D181F000E9;
	Thu,  2 Jul 2026 03:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782964233;
	bh=Y0sFSZQ3txRIqm2zt6bdfiamkGiWya221NRZj5+w3xo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OPV4aJlip+ds53aoZFatXUkjkjJmauesXgxOizMNFFZEJ+tYHLCVJ1PwCSrXg/TaK
	 DkAWUyLHq9JNzhbIxFPHEWcBC5WXEDO21wDgbv27po/Mnxv3Tn+TOiPFxfJyMkeRsa
	 a7JvRi0vQlURTbsrMETGCS/wJfHYqM1HeNoZb38bBojKuSl+ALqUWhFadHBlugU6Zt
	 v8XQ337+pOgfJZ4qy7mLMD3rtEvj95Iws7ZcruMcMArPocFA8JJaNsJ2KWo/d9uktz
	 MKfk5f9LUhJRQOEq2qKGC7qd3cRWq1o4hguXVLyWIDctYoP70joCRoMrcdHw0VAIFO
	 qmdjq3Jf6HpyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: libsas: fix HA resume deadlock and hisi_sas
 disk-wake race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702033211.1743313-1-yangxingui@huawei.com>
References: <20260702033211.1743313-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 03:50:32 +0000
Message-Id: <20260702035032.F2D181F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Hardware initialization race: scsi_unblock_requests() allows I/O d=
ispatch to uninitialized hardware in _resume_v3_hw().
--

commit 9e820865310a614d1e3c143d85daf43eae7329e2
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: fix HA resume deadlock and hisi_sas disk-wake race

This commit fixes a resume deadlock by moving the PHYE_RESUME_TIMEOUT
notification to occur after sas_drain_work(). It restores the standard
sas_resume_ha() behavior in hisi_sas and removes the no-sync variant.

> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_s=
as/hisi_sas_v3_hw.c
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -5262,14 +5262,7 @@ static int _resume_v3_hw(struct device *device)
> =20
> [ ... ]
> =20
>  	scsi_unblock_requests(shost);
>  	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
> =20
>  	sas_prep_resume_ha(sha);
>  	rc =3D hw_init_v3_hw(hisi_hba);

[Severity: High]
This is a pre-existing issue, but I noticed a potential hardware
initialization race here.

Does unblocking requests before hw_init_v3_hw() completes allow pending I/O
to be dispatched to uninitialized hardware?

During PM resume, _resume_v3_hw() calls scsi_unblock_requests() and clears
HISI_SAS_REJECT_CMD_BIT. Any blocked block-layer requests could immediately
be dispatched to hisi_sas_queue_command().

These requests would be written to the controller hardware before it has
been reset or initialized by hw_init_v3_hw().

Could this lead to hardware corruption, SErrors, or system lockups on
standard suspend/resume cycles if there is pending I/O?

>  	if (rc) {
>  		scsi_remove_host(shost);
>  		return rc;
>  	}
>  	phys_init_v3_hw(hisi_hba);
> =20
> -	/*
> -	 * If a directly-attached disk is removed during suspend, a deadlock
> -	 * may occur, as the PHYE_RESUME_TIMEOUT processing will require the
> -	 * hisi_hba->device to be active, which can only happen when resume
> -	 * completes. So don't wait for the HA event workqueue to drain upon
> -	 * resume.
> -	 */
> -	sas_resume_ha_no_sync(sha);
> +	sas_resume_ha(sha);
>  	clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702033211.1743=
313-1-yangxingui@huawei.com?part=3D1
