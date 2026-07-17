Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E3520010A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304082; cv=none; b=g7fViOGuKtF0p011jDQ5Y5V6Tzl7sovmBNcERnpLGDgDhIhfVCEEHHjbXldZXSWbYwDhAlE+VyuBsh9NDyaVcWAtpqs+w1WPxg6zsPwViRikFFkjidyJTiICVxWyvvv/PQYQ8mLPOAU8LeDqGVDdIGmVmYDTHQ1AgmyUDrdcA7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304082; c=relaxed/simple;
	bh=rsF+Mm3vRQe/UWS/ab78qb6y4S4CaquS+if+QG7LbRw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J9TF7hlPJ6nTU+XDbs/e/YM101ZHS02zVpQoWMpdVWI6p8DMlymcAha5iCyUDdx2ejTGs1iJ1D5FpRd73KnCrSbXnkOkUUqtWPUNZiezTiSIvs54F7ZTm8f9azeYsi6kXZSpDQ8ZFXJdzFuOFDaW9iEq1cL+hdD2ZKAYeK/yS2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmXKIUy4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmXKIUy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12D81F000E9;
	Fri, 17 Jul 2026 16:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304080;
	bh=B/5Um5i9RNJEnStIthuKiFDsiiKlXqUuztaGUsxf11Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZmXKIUy4w/RBayVwdFBm/YD40e2i9ZpesH0oO+YvK92AuqmbhhD3nhiSZxJP+RGFk
	 SLf6w/aeJ9w28tsPaEbD1PylZBT2qcE008GHVFmrzNFnnSGdk+rwYoSvaPThGFwhjC
	 sW11XJ9otp9O6jdPd7kLBUkUkgNoEWv9jm9AhNB6rD3PNMZ9+popSnilbTRFV7HD2L
	 unjroPpMu48dw9+sskkdfVlJg1AvvVkxH4CmwdmXbsCd0tLyCQQSBuX9gEDJ65vfG8
	 fvZ+TXZyHfkj9/px6Ivz0my091hn1Q+vLVtAt7BcnXMwrXC5jk/5Ml+a3QGW6G5D0V
	 NpU3VVc3ORlXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for
 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-23-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-23-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:01:20 +0000
Message-Id: <20260717160120.B12D81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Dropping a spinlock inside list_for_each_entry_safe exposes the ca=
ched next pointer to use-after-free.
- [High] Lockless iteration over fcport list exposes it to concurrent modif=
ications.
--

--- Patch [22]: [PATCH v5 22/56] scsi: qla2xxx: Enable qla2x00_shutdown for=
 29xx ---
commit 6046de798bc7fa0a80928785cf9ec35ed974164d
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable qla2x00_shutdown for 29xx

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
This isn't a bug introduced by this patch, but it exposes 29xx adapters to a
pre-existing use-after-free issue in qla2x00_abort_isp_cleanup().

Dropping the vport_slock inside list_for_each_entry_safe() exposes the cach=
ed
next pointer (tvp) to concurrent removal. If a concurrent vport removal (e.=
g.,
via sysfs /sys/class/fc_host/hostX/vport_delete) acquires vport_slock, remo=
ves
tvp from vp_list, and frees it, the loop will dereference a freed pointer w=
hen
resuming:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_abort_isp_cleanup() {
    ...
	spin_lock_irqsave(&ha->vport_slock, flags);
	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
		atomic_inc(&vp->vref_count);
		spin_unlock_irqrestore(&ha->vport_slock, flags);

		qla2x00_mark_all_devices_lost(vp);

		spin_lock_irqsave(&ha->vport_slock, flags);
		atomic_dec(&vp->vref_count);
	}
    ...
}

Can this lead to a use-after-free when the lock is reacquired and the loop
proceeds to tvp?

[Severity: High]
This is also a pre-existing issue, but this patch additionally exposes 29xx
adapters to a lockless list iteration bug in qla2x00_abort_isp_cleanup().

The vp_fcports list is iterated without holding any locks, which can race w=
ith
concurrent modifications like device discovery or target login/logout events
that modify vp_fcports under tgt.sess_lock.

For the primary host:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_abort_isp_cleanup() {
    ...
	/* Clear all async request states across all VPs. */
	list_for_each_entry(fcport, &vha->vp_fcports, list) {
		fcport->flags &=3D ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
		fcport->scan_state =3D 0;
	}
    ...
}

And for other vports where vport_slock is explicitly dropped before iterati=
ng:

drivers/scsi/qla2xxx/qla_init.c:qla2x00_abort_isp_cleanup() {
    ...
	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
		atomic_inc(&vp->vref_count);
		spin_unlock_irqrestore(&ha->vport_slock, flags);

		list_for_each_entry(fcport, &vp->vp_fcports, list)
			fcport->flags &=3D ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
    ...
}

Does this lockless iteration risk list corruption or use-after-free if the
list is concurrently modified?

>  	} else {
>  		/* Stop currently executing firmware. */
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D22
