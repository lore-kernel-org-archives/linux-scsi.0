Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B36237713
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 13:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783515816; cv=none; b=UjueDSzLFW87F6T7IrZqaFNwVA/ze3ut5s4phCZQ8eE3ZbrbL0+WE+ooypz4z/J6U+qc9/MnTtVLu8U3xz0/5modPM//vnVRVbBRmEDTq8tcFqzFp8wwT9K64RqgLEOIhkR8jcVsx8+6OkKH7H2KEjBg0ThLl4A38yK6CQ7O9Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783515816; c=relaxed/simple;
	bh=RzRzGi/EvH2XBYOciERbNfhko7sFLF5DptWemUXecFQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=re8DFTx4EgqT6oH9FHyx5vs/46sJcFBGo5/C7D2RqsGM72iqT/KqXON/qDLvMhwGJ/yi/NF9/a6S6iWIHt95lZA/n0BP5v31W1ybDpA37HbO3nWUFrHTKbBz0/olb6s1mvrNvhWA9Z0mgQiFMy40G0n1rx9xoMpXl/3yY5x+ZC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iFpeY9JJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iFpeY9JJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068681F000E9;
	Wed,  8 Jul 2026 13:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783515815;
	bh=PGwt6UTutovGPM0iBDtfb1LQ2hdvny9gYegrATIBPoA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iFpeY9JJCfGGdek+ccmHZxi9Kynp3uQDZxuuO3YYVtKfLcIEfzx0eTIl8OWiPBFfX
	 3ceZqyOVRtfJGK0DfgTx6qEmsuSURUxekYmyP836ujH6S0EAKYSLL/kVPbBS2eTWg7
	 Iubsia+mXLNHCNRIoQ+cTa3dM3yNbCrLVhTNsI0WL7ykK6JbnlFA24mVmiwHXvdVaZ
	 VIJYvJzcpkBWt8Wy74DO6mlQl+8WCO3s5hGbxSECIMID8Q7g82o7vR3TCDjtgnAfSH
	 Te+CtQkdzO7T/kedOSWkGSLQYKyjW189+pj8OII+qb3VzldL4IqWx6g+t9hyLFx4xV
	 RORFswUU2lSyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: core: cancel RTC work in active-active
 suspend
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <lgs201920130244@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260708124934.764281-1-lgs201920130244@gmail.com>
References: <20260708124934.764281-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 13:03:34 +0000
Message-Id: <20260708130335.068681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The patch cancels ufs_rtc_update_work during the active-active s=
uspend path but fails to re-schedule it when the device resumes, causing pe=
riodic RTC updates to permanently stop.
--

--- Patch [1]: [PATCH] scsi: ufs: core: cancel RTC work in active-active su=
spend ---
commit d6ec0bf16c0b8402d3955ca2fc9c1ec563b33c79
Author: Guangshuo Li <lgs201920130244@gmail.com>

scsi: ufs: core: cancel RTC work in active-active suspend
   =20
This commit modifies the active-active suspend path in __ufshcd_wl_suspend()
to cancel the ufs_rtc_update_work before jumping to vops_suspend. This
prevents the RTC work from accessing the controller while the hardware state
is changing.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index d3044a3089b53..9d5571a7aec23 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10269,6 +10269,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hb=
a, enum ufs_pm_op pm_op)
>  			req_link_state =3D=3D UIC_LINK_ACTIVE_STATE) {
>  		ufshcd_disable_auto_bkops(hba);
>  		flush_work(&hba->eeh_work);
> +		cancel_delayed_work_sync(&hba->ufs_rtc_update_work);

[Severity: Medium]
If the work is cancelled here during active-active suspend, will it be safe=
ly
rescheduled on resume?

Looking at __ufshcd_wl_resume(), the rescheduling of ufs_rtc_update_work
appears to be gated by a check for whether the device is not active:

drivers/ufs/core/ufshcd.c:__ufshcd_wl_resume() {
    ...
    if (!ufshcd_is_ufs_dev_active(hba)) {
        ret =3D ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
        if (ret)
            goto set_old_link_state;
        ufshcd_set_timestamp_attr(hba);
        schedule_delayed_work(&hba->ufs_rtc_update_work,
                              msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
    }
    ...
}

Since the active-active suspend path leaves the device in UFS_ACTIVE_PWR_MO=
DE,
it looks like ufshcd_is_ufs_dev_active(hba) will evaluate to true. Does this
cause the periodic RTC work to be permanently stopped after the first=20
active-active suspend cycle?

>  		goto vops_suspend;
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708124934.7642=
81-1-lgs201920130244@gmail.com?part=3D1
