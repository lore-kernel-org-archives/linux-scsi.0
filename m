Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02C34399F3
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802858; cv=none; b=OPyADkKXmnV+AuPy+ZfCANgVHZGqEQPEIsLYBkq5l3UiN0kM3ftbSaBM6eJwcdIsPuwoT61sWQzP9+XLAEw4LfLUAHUvQ5y8CmYMxTVKdosLpG7tc8bgSjYqK8ycR1L3NiJLyK412Nxxcz0Oh76qkVwCzNLE4QtA3nvnSqUxtHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802858; c=relaxed/simple;
	bh=M96fgdp2+doTI4WMvwSfEjQXm4YqMyaYJ7C+MaJAuI4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HofeEdTpznt5H15Uhzfn+g5bL2o0aOUzsAwCLmiteE1aCSKgZrtLxV+74F6kDxxWqYNMn6OvYMrDe79MiJVtUSK7Da8OGNVSWL/9HoKuOI1gHBMCBoegxqgv53oojoNmyqVcPMnoHbJ7mOhSdRrGMOEcav2QViPU7EuHDDvtoNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EOgzPPfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EOgzPPfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0741F00A3A;
	Thu, 23 Jul 2026 10:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784802856;
	bh=u3IhkX0H1+nCFzbpylgAlEnBOgQBCUwx2xhNXrep/bs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EOgzPPfHfjIUCvqJMvKGQ6/4dQmleUCB8YLjx2gmfXDQaUF3sfX0ZdgJ1HS6y4tmZ
	 91T5ALausdR12qW6fURh2YxJ2Ca928UOUbwb1x77JTnSy7RQqowmwM+AVXgR/nI7qi
	 VM2CLacrkHdpCwIlT9FDEDNgGmmIn28syxHVEKIkI7hT9xSp/SCqMb+6cngdVeMpD3
	 XTCDfLpb1qogGFMDCRHJXZEB8V+RjrXi9DFwkcEJZRBxChqdTk9GtwEElHhFLV495e
	 3s3kNkaVIDyvNZ2zennAEOlB7SaZWjUu6Fhy1NEGdXN+TqfNMWZQIiy1XrDD23NiWO
	 VfG9X1hd2QyXA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for
 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-23-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-23-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:34:13 +0000
Message-Id: <20260723103416.3F0741F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unsafe lock drop inside `list_for_each_entry_safe` over `ha->vp_li=
st` causes Use-After-Free during list traversal.
- [High] Unprotected list traversal over `vp_fcports` without holding `sess=
_lock` allows concurrent modifications to corrupt the traversal.
--

--- Patch [22]: [PATCH v6 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for=
 29xx ---
commit 432bc00837ab9eb63a8687ca9bc265acf0d5bb67
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
   =20
Enable qla2x00_shutdown for 29xx adapter by adding IS_QLA29XX check
to the shutdown path that performs firmware abort cleanup.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 146701445485f..5450c40259bf9 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3840,7 +3840,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
>  		qla2x00_disable_eft_trace(vha);
> =20
>  	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
> -	    IS_QLA28XX(ha)) {
> +	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>  		if (ha->flags.fw_started)
>  			qla2x00_abort_isp_cleanup(vha);

[Severity: High]
This isn't a bug introduced by this patch, but since you are enabling
qla2x00_abort_isp_cleanup() for 29xx adapters, could this lead to a
use-after-free during list traversal?

Looking at qla2x00_abort_isp_cleanup() in drivers/scsi/qla2xxx/qla_init.c:

	spin_lock_irqsave(&ha->vport_slock, flags);
	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
		atomic_inc(&vp->vref_count);
		spin_unlock_irqrestore(&ha->vport_slock, flags);

Is it safe to drop vport_slock inside the loop?

Since list_for_each_entry_safe() caches the next entry (tvp) prior to
dropping the lock, a concurrent thread (like qla24xx_vport_delete() via
sysfs) could remove and free tvp while the lock is dropped. When the lock
is reacquired, the loop would attempt to advance using the freed tvp.

[Severity: High]
This is a pre-existing issue, but does this function also lack necessary
locking when traversing vp_fcports?

Further down in qla2x00_abort_isp_cleanup():

	list_for_each_entry(fcport, &vha->vp_fcports, list) {
		fcport->flags &=3D ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
		fcport->scan_state =3D 0;
	}

And similarly for vp->vp_fcports:

	list_for_each_entry(fcport, &vp->vp_fcports, list)
		fcport->flags &=3D ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);

Can these iterations be corrupted by concurrent modifications?

This traversal doesn't appear to hold vha->hw->tgt.sess_lock. If concurrent
tasks (such as workqueues or softirqs executing qlt_create_sess() or
qla24xx_create_new_sess()) add to vp_fcports via list_add_tail(), or sysfs
tasks executing qla2x00_free_fcport() remove from it via list_del(), could
it corrupt the traversal state and cause a use-after-free?

>  	} else {
>  		/* Stop currently executing firmware. */
>  		qla2x00_try_to_stop_firmware(vha);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D22
