Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAA7449EB8
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 12:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784117722; cv=pass; b=lx8yKQKmkvKzDhHqXNlarjs1phqdONJ7PCXdFdvVQTaEzAew2pESwxwUevOnQJ/AvpgYsKhT9RzX3/JtVcPNWchHKps9UOqGXUBOc78mLP76avXronDdoQhLMsiGpQmeAvR35im8E+dQbNzvvYuYLFVze7hZ9aEHGD0pCW04U7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784117722; c=relaxed/simple;
	bh=aOrVeHtXzsM1pRkqxNNddE3wD/FxMb2Yh1OYwAbAeQs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XvCF8EM60+JhvhydlZszl/Wpm752ArAb+wiCbniHogUdEIymXMEuTb2EXF6UL94sLhEMptckSH6HFJXlICVt3whe47dj5th/8H7iZqGMeqrdaIFyX6li9Zccy6nTLt292+9xJntCvRgP/t02nIx7t75/sBF0HP2X3Z6KItHaO8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=sdGMsn5x; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=JDQOyGmN; arc=pass smtp.client-ip=85.215.255.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="sdGMsn5x";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="JDQOyGmN"
ARC-Seal: i=1; a=rsa-sha256; t=1784117530; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=a/C6r5DF3R+Y1Ks3iNwIJUapFpxCwF4w4LEQy7Id4OV73TFXevynSp+tpko9vnipk+
    Wuz684JOYaB2PIzILyCEnWXXOU5K2AdsgiTYcXXdCy1ynDqaGR/fCoxHFSwPsgOhXydl
    IzwQvmMB69B5Xn3ZcP0Eyz0zLuMT0Zsmro+mePA6K5fvLsG1AQ24acsbWQft+c0WpIYK
    j5BLh993byIw0H6/8zufmJQOEsMAlS9fk0YjpSWIz64tHKIBLWmSZ3vXnMyrEYi2WeS1
    44a6h/N2Odb8i84pSzMV/2T9XCY63Zp3e7R/p9vhtp9jzDnDmIEc3r7kqusgAXe90GBs
    0S7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1784117530;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aOrVeHtXzsM1pRkqxNNddE3wD/FxMb2Yh1OYwAbAeQs=;
    b=EDHUgpEisSGRdDMQi2oDId6oAmXsHlRVkPLExcEuB4MuYuAXmi+6+Jep/zsws2VHqj
    kdQpwGv1xi1k75lELtCCZhlTTzJchBYWNuxiEXKNceUMzAh5QJCHG8++xs6KWm5pPRKs
    r4xT7mPTnXuTpJ+F9AKdPUWxL4sU5VJZdpvc/zYeTPz7ASmb6f76s3eHj/y9jxZjHCjf
    Pk3wyldM9tQqHa7Y7y6Y5cWOYHuVH+0D9Q+msFstoFF1SwvZUN6aUZaMhZkDhKTGPa9t
    xCAQbuDwzOXs4HS/LI/CEJPBMcWGs8H0jh2bHduYjS6NvHA23g9R+VzPAmrA+YSDUlse
    BMQA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1784117530;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aOrVeHtXzsM1pRkqxNNddE3wD/FxMb2Yh1OYwAbAeQs=;
    b=sdGMsn5xkczACH78Z7fAcNGkGwI/KgPW1YgVGUJyA0OAZuG48mx3ds+5z5AkUGV95w
    /wjnFrLpl5Nfh+2isLfNZHaBzHPwzr6UBtj8CFnWOoGUeZQOKbdMyGF5PNmAuQjJpqkA
    5b+Dhi55WGeeWA//tYW6aGyLagIid5KxeGhanu3TdPhJVgOXGCQVt19YbUuCRVBHR+zX
    iReyS7aLk9fYk7VrFClmu3tNGcE1qALJU3PMCP6LAuS18+ev3PcoPdfpZrWKn/BY9Ftf
    E237ZX49KCvAC9QrcdmTXK+FvL1QhOy0DgNe9FM7MDS3WfsQOiAaqs0tAp7EEpjhPPTu
    5i6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1784117530;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=aOrVeHtXzsM1pRkqxNNddE3wD/FxMb2Yh1OYwAbAeQs=;
    b=JDQOyGmNwcfLVpvak6VZpFpjVubp/cOk7Ux5rnaBJTSodl/A/bKx/zdA4kmsnjyymS
    FmT18xHC7dRuhqx3juCw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZik"
Received: from [10.176.237.62]
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id z4d38826FCCAOLg
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 15 Jul 2026 14:12:10 +0200 (CEST)
Message-ID: <c3b5899213c76c62fa0c7f9dffdf56607c3ae1f0.camel@iokpp.de>
Subject: Re: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active
 suspend
From: Bean Huo <beanhuo@iokpp.de>
To: sashiko-reviews@lists.linux.dev, Guangshuo Li <lgs201920130244@gmail.com>
Cc: linux-scsi@vger.kernel.org
Date: Wed, 15 Jul 2026 14:12:09 +0200
In-Reply-To: <20260714174406.6FD471F00A3A@smtp.kernel.org>
References: <20260714172726.1736967-1-lgs201920130244@gmail.com>
	 <20260714174406.6FD471F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-07-14 at 17:44 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s)
> to consider:
> - [Medium] The `ufs_rtc_update_work` is permanently lost if
> `__ufshcd_wl_suspend()` fails after cancelling it in the active-active su=
spend
> path, stopping periodic UFS RTC updates until the next successful
> suspend/resume cycle.
> --
>=20
> --- Patch [1]: [PATCH v2] scsi: ufs: core: cancel RTC work in active-acti=
ve
> suspend ---
> commit 9a4850975ce80edc6032f13153aa50eb19b4cc19
> Author: Guangshuo Li <lgs201920130244@gmail.com>
>=20
> scsi: ufs: core: cancel RTC work in active-active suspend
> =C2=A0=C2=A0=C2=A0=20
> This commit cancels the UFS RTC update work in the active-active suspend
> path before calling the vendor suspend callback to prevent an SError.
>=20
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index d3044a3089b53..c3b105b2678e4 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -10269,6 +10269,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *=
hba,
> > enum ufs_pm_op pm_op)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
req_link_state =3D=3D UIC_LINK_ACTIVE_STATE) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_disable_auto_bkops(hba);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0flush_work(&hba->eeh_work);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
>=20
> [Severity: Medium]
> If the active-active suspend path fails after this point, is the
> ufs_rtc_update_work permanently lost?
>=20
> When this jumps to the vops_suspend label, if ufshcd_vops_suspend() retur=
ns
> an error, the function branches to the error handling path:
>=20
> __ufshcd_wl_suspend() {
> =C2=A0=C2=A0=C2=A0 ...
> vops_suspend:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ret =3D ufshcd_vops_suspe=
nd(hba, pm_op, POST_CHANGE);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto set_link_active;
> =C2=A0=C2=A0=C2=A0 ...
> out:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (ret) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_update_evt_hist(hba, UFS_EVT_WL_SUSP_ERR, (u=
32)ret);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0hba->clk_gating.is_suspended =3D false;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ufshcd_release(hba);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0hba->pm_op_in_progress =
=3D false;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return ret;
> }
>=20
> The error path doesn't appear to re-arm the canceled RTC update work befo=
re
> returning the error code. Does this mean periodic UFS RTC updates will st=
ay
> stopped until the next successful suspend and resume cycle?

This is not a real issue, for the following reasons:

1\ The RTC work is not permanently lost. If suspend fails, the device stays=
 in
the active state and the PM core will retry the suspend later (runtime PM
retries once the device idles again; a failed system suspend is simply retr=
ied
on the next suspend attempt). The next successful suspend/resume cycle re-a=
rms
the work via the now unconditional schedule_delayed_work() in
__ufshcd_wl_resume().

2\ RTC updates being paused between a failed suspend and the next successfu=
l
cycle is harmless. The device only uses the RTC for internal housekeeping/a=
ge
estimation, and periodic updates are opt-in anyway: rtc_update_period defau=
lts
to 0 and must be enabled via sysfs.

3\ This behavior is not introduced by this patch. The common suspend path h=
as
worked exactly the same way since commit b0bd84c39289 ("scsi: ufs: core: Fi=
x
SError in ufshcd_rtc_work() during UFS suspend"): it cancels the work befor=
e the
PRE_CHANGE vendor callback and does not re-arm it on the error paths either=
. If
anything, this could be a separate follow-up cleanup, but it should not hol=
d
this bug fix.

