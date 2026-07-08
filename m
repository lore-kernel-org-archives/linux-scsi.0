Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238DA3F39F3
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 21:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783544889; cv=pass; b=X/WR5IDNxhAM15/23ksu633be+1FeW5qxG+GUQhgMUPyE7J65AKazGAyVfmJwvY4VG6nkOjRrvho0eiyooWkyDSEPnv4XEJ9BONF6zm31jThSIEW7Xj06jQmJBqZbphtAtUC2CsdNl4I3NWJEJgdNzwJoKysAM/DFwkKJO2qgPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783544889; c=relaxed/simple;
	bh=mfRvpmoRjmOqO2XAQtiTJ9HsE3sKwWh+ng70GK0Vy1Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OlIPPS26HHTr6652abOYlwOQlG+XEfUWoKCxEGuZh/ul3Uf7ZwNCxffFf1av8B2ggckjH7zTBJyXFZBfAfUb0Yvy5B4GiCxggEFwqVxU5FZiM1KvahnKBCYIxOBcG0sbm0ecGhJ2tOWUXcR0FhFdZiqXV+oU+UbGgxMfMAYm+Zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=k5P+pXL9; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=svVUJpKd; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="k5P+pXL9";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="svVUJpKd"
ARC-Seal: i=1; a=rsa-sha256; t=1783544879; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=i85Y1VZg2L3WCc9Joex7EyN1LG2E0MSTACPhca3CslqI0zyjiOp3DhXSvhDa+bJjoV
    8mM2yT1fEc6SBT82eGM2iyUtwX75iDQRuxptkGFigRFbFepHDmMU422yGdxoQhlameqX
    UI15wvdPX1cvhHNvI5CNrVTwl/J9Q481lWMXDzYy1t58CjT7pOkMu5hQOS+dudlyHL2D
    AjE6rH99t2tHWn0/N1c1zts96Stxaq8glE4m9b6k/92hnLW/D8fxN8qWBEaqsgesw5wg
    d9q0DT9LdngpPQB1urtB+1juaaHDoQISsxDapjKPSoOLetbkq7qbovPwyv8WmlFKrpXF
    JI3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1783544879;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=SNjOYmb8RwdECZkm3ULnF51VU7P0EUEvdZQ2LqkBe2M=;
    b=Hkh0QXIKX4Df3nEAO6lFqbPXb5rb3eoj4t+8OpCPrgv9dnbcxGuStZ/bh2vtDuAhrC
    mWFC/4C+4aFENG1mc2KZKepAMSF0iKW+JCcinxDI7diby8crLjJAN+BOJJq0xOPg2Vom
    Q049PtCJZVwU7gKoEX/2hJvvfIRDDDWo02as7dPztE/COwN3FakdVMZTUTvvKNKx9dla
    HshX3q9ecJqIB07GyFGJJiFJyF6rwfQpRcBk9rTh5ORvIcFFnEvOa1fkRbH3zh5Av580
    eX8xjnqMaWRuFQoaJnIsAegq8C/mAJ2ys73lAZl9Kux8wI6fQuXoPLS2uYeA8J6mtVrS
    Z3Kw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1783544879;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=SNjOYmb8RwdECZkm3ULnF51VU7P0EUEvdZQ2LqkBe2M=;
    b=k5P+pXL93tTQxekExa/4jWx8343cPHEECJ5JHe9MVhbdduOW5Sn/lafi+lKdpEqfmr
    JZJfcEsh8PR2puMwTYmejuKaBT4lLaYqONgbBw+cF1+ixFOHi4uCNCE7/nJcKmFkT4uC
    EGiCRtpGcKqDOcqVAN6+dNPxUPRhzvxr3lUWeMJJ3wTQA7p5yRXHfQ+16PNgWw81up+b
    sYGOrE0JC0A0419gTbhsDMRe6XXkjzUFiq6FSSnjt+A7WvvXVbx6gM8bnot9eGQFopJ5
    QlJp13fkClQZEq4NSHavRA7DqLWRKiDx39MrIodrF1ebxk+RllkvCg5I7v/s5humdRD3
    vZiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1783544879;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=SNjOYmb8RwdECZkm3ULnF51VU7P0EUEvdZQ2LqkBe2M=;
    b=svVUJpKdOvt4yu9aVXBw81rnk1NGK/UQ51pOCc2AOzisZoXexcpwl81nFCRpH4fP2A
    tClcoLIOsPjKyXCU03Dg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGWUpI6wfUjZWOuvfZPDhjfo3o0tv9XjkArh/V4="
Received: from p200300c587147773f0f0e3c76ec87fb3.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id z4d388268L7xxOD
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 8 Jul 2026 23:07:59 +0200 (CEST)
Message-ID: <dbc236f9e107bc640d643602102313129be84edb.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: cancel RTC work in active-active
 suspend
From: Bean Huo <beanhuo@iokpp.de>
To: sashiko-reviews@lists.linux.dev, Guangshuo Li <lgs201920130244@gmail.com>
Cc: linux-scsi@vger.kernel.org
Date: Wed, 08 Jul 2026 23:07:58 +0200
In-Reply-To: <20260708130335.068681F000E9@smtp.kernel.org>
References: <20260708124934.764281-1-lgs201920130244@gmail.com>
	 <20260708130335.068681F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-07-08 at 13:03 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s)
> to consider:
> - [Medium] The patch cancels ufs_rtc_update_work during the active-active
> suspend path but fails to re-schedule it when the device resumes, causing
> periodic RTC updates to permanently stop.
> --
>=20
> --- Patch [1]: [PATCH] scsi: ufs: core: cancel RTC work in active-active
> suspend ---
> commit d6ec0bf16c0b8402d3955ca2fc9c1ec563b33c79
> Author: Guangshuo Li <lgs201920130244@gmail.com>
>=20
> scsi: ufs: core: cancel RTC work in active-active suspend
> =C2=A0=C2=A0=C2=A0=20
> This commit modifies the active-active suspend path in __ufshcd_wl_suspen=
d()
> to cancel the ufs_rtc_update_work before jumping to vops_suspend. This
> prevents the RTC work from accessing the controller while the hardware st=
ate
> is changing.
>=20
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index d3044a3089b53..9d5571a7aec23 100644
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
> If the work is cancelled here during active-active suspend, will it be sa=
fely
> rescheduled on resume?
>=20
> Looking at __ufshcd_wl_resume(), the rescheduling of ufs_rtc_update_work
> appears to be gated by a check for whether the device is not active:
>=20
> drivers/ufs/core/ufshcd.c:__ufshcd_wl_resume() {
> =C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0 if (!ufshcd_is_ufs_dev_active(hba)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D ufshcd_set_dev_pwr_mod=
e(hba, UFS_ACTIVE_PWR_MODE);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto s=
et_old_link_state;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_set_timestamp_attr(hba)=
;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 schedule_delayed_work(&hba->uf=
s_rtc_update_work,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
> =C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> Since the active-active suspend path leaves the device in UFS_ACTIVE_PWR_=
MODE,
> it looks like ufshcd_is_ufs_dev_active(hba) will evaluate to true. Does t=
his
> cause the periodic RTC work to be permanently stopped after the first=20
> active-active suspend cycle?


good catch, about this change:


diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 376a314189e4..06f253b08b65 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10339,6 +10339,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba,=
 enum
ufs_pm_op pm_op)
                        req_link_state =3D=3D UIC_LINK_ACTIVE_STATE) {
                ufshcd_disable_auto_bkops(hba);
                flush_work(&hba->eeh_work);
+               cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
                goto vops_suspend;
        }
=20
@@ -10548,10 +10549,11 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba=
,
enum ufs_pm_op pm_op)
                if (ret)
                        goto set_old_link_state;
                ufshcd_set_timestamp_attr(hba);
-               schedule_delayed_work(&hba->ufs_rtc_update_work,
-                                   =20
msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
        }
=20
+       schedule_delayed_work(&hba->ufs_rtc_update_work,
+                             msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS))=
;
+
        if (ufshcd_keep_autobkops_enabled_except_suspend(hba))
                ufshcd_enable_auto_bkops(hba);
        else




>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0goto vops_suspend;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> >=20
>=20

