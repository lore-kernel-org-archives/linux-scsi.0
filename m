Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215EC49B5DB
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 17:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789406160; cv=none; b=lrDrWsHWZe4xLweJ9YpR8T7HclOapxnCq2CIymtNBpqFaZsUemd3+karElvjj4wAjonHcX7gLiZqYM6DvNZAD69ulP3GZQ8wp6pMJsz7vafu2efJMQ3vjVWkCggKl2SyoyOXVmk+pFbK6oMFnn2adnQNFxbZ1toj4H5eHASgCBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789406160; c=relaxed/simple;
	bh=aQzfRjYY9HvPf2bQT3W9HvFZihtRR8e/HN1/bNLor20=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ut1Q5KMSfHS/dL9y+9uctqzX8hgsu/amuFEg/PwBUz9FTpDrdaJ9/iiJiZlbL2gpD746aXoTy6skvQdHz53lsezLbmZpP6iKxm4ZZclr54shr1bXCfIRdax2oxpHZLfHEcRPA4OiL00pSngmks01OkjZBpdTvYKz6Ymmqyrepxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Va8nqVjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Va8nqVjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDBE1F000FF;
	Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789406158;
	bh=4w/ClkyKr6t1tMgMqXYYBlwAoHqiIB4YdCyFFDmapDU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Va8nqVjEAW5Vrf5Qfk7A6XM15G8XYbAf6rp14CMCbUDMp8xeOLPh6L55MgyaJbfHS
	 yy1EpmIKJZOyMc2NX9SB8NVmu73Ig8FzbOmYLAR6Yi40MKZtrrOnSPv4oXML3K5DcN
	 5n2dWcFRNGjtvAdAvfiQCyNssJVB1c685PvtCvyoC4auxxofo2ik7jTXAbVFr+/w+7
	 1LKpkAcYjE8wvaLh3NsIAzAd5eKiJ9ru93aACVf++haFaA6nuRUHlbdAb0A9CtsDDN
	 Sse6PfzI7K/7YFZEZEliJQZQl5o4JSTztdxtN3Fzsbji/kP61sL+QzYg0pwErR76bv
	 I82cgQa4+Noww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ufs: sysfs: fix current_power_mode read without SSU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yiwei Lin" <s921975628@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260914170032.5551-1-s921975628@gmail.com>
References: <20260914170032.5551-1-s921975628@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 17:15:57 +0000
Message-Id: <20260914171557.BFDBE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Exiting Hibern8 manually without restoring it leaves the UFS link =
in the ACTIVE state, leading to hardware state corruption and power leaks w=
hen the host controller auto-suspends.
- [High] A Time-Of-Check to Time-Of-Use (TOCTOU) race exists between the sy=
sfs read and WLUN runtime resume, potentially causing duplicate Hibern8 exi=
ts and forcing severe link recovery.
- [High] The sysfs read blindly sends a UPIU query over an OFF link if the =
UFS device was suspended to a DeepSleep/PowerDown state.
--

commit f4fe909880e2766ce73fa9889b03cdb85f6b474d
Author: Yiwei Lin <s921975628@gmail.com>

ufs: sysfs: fix current_power_mode read without SSU

This patch changes how current_power_mode is read from sysfs to avoid waking
the device to Active state. It directly fetches the PM sync reference, exits
Hibern8 if necessary, queries the attribute, and drops the PM reference.

> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index cf49ad0258e14..86705432aa42d 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
[ ... ]
> +	ufshcd_hold(hba);
> +
> +	if (ufshcd_is_link_hibern8(hba)) {

[Severity: High]
Could this introduce a Time-Of-Check to Time-Of-Use (TOCTOU) race with a
concurrent WLUN runtime resume?

If a sysfs read of current_power_mode executes concurrently with an I/O
request that triggers ufshcd_wl_runtime_resume(), both threads might check
ufshcd_is_link_hibern8() at the same time without holding uic_cmd_mutex.

If both see the link in Hibern8, they will serialize on uic_cmd_mutex inside
ufshcd_uic_pwr_ctrl(). The first thread will set the link to ACTIVE, and the
second thread will send a duplicate UIC_CMD_DME_HIBER_EXIT command to the
already ACTIVE link, which can cause a hardware command failure and trigger
a severe link recovery.

> +		ret =3D ufshcd_uic_hibern8_exit(hba);
> +		if (!ret)
> +			ufshcd_set_link_active(hba);
> +		else
> +			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
> +				__func__, ret);
> +	}
> +
> +	if (!ret)
> +		ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_POWER_MODE, 0, 0, &value);

[Severity: High]
Does this blindly send a UPIU query over an OFF link if the UFS device was
suspended to a DeepSleep/PowerDown state?

When the UFS WLUN is suspended to a level that puts the link into
UIC_LINK_OFF_STATE, ufshcd_is_link_hibern8() evaluates to false. This
function will skip link initialization entirely and leave it in the OFF
state, proceeding to call ufshcd_query_attr().

Sending a query to unpowered/unlinked hardware typically fails with a
hardware timeout or fatal controller error.

> +
> +	ufshcd_release(hba);
> +	pm_runtime_put(hba->dev);

[Severity: High]
Does dropping the host controller's runtime PM reference here leave the
hardware in an invalid state if we explicitly exited Hibern8?

Because the link was manually transitioned to ACTIVE in this function
without an explicit mechanism to restore it to Hibern8, the UFS link
remains in the ACTIVE state.

When pm_runtime_put() drops the usage count, ufshcd_runtime_suspend()
can execute and unconditionally turn off the UFS clocks. Turning off
clocks while the link is physically ACTIVE violates the UFS specification
and can lead to hardware lockup or fatal controller errors upon the
next access.

> +
> +	if (ret) {
> +		up(&hba->host_sem);
> +		return -EINVAL;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914170032.5551=
-1-s921975628@gmail.com?part=3D1
