Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58858282F06
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781277049; cv=none; b=gtjgKAR3IwzrLeOOzfvIcnzkir4+hkFq5Zrs5uo4Brj36wAtwT7zQPnE6O5d09ugevNzPzRVWFjmx3/crOD0lNStwRnp5Nl/ngONlwemYqy0ebpil1nuf22vr1NyFEVGXXNw+KSWae40eh5KMDH0w4LqdCyqYMjTGJolQCB7dBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781277049; c=relaxed/simple;
	bh=Sq9Ero/LS3ur/yy/ddGuBp5N+tV7cLwHkF0mBkzPrgI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=biqNJBM0TQRVmIiJJauJUJFqZji9Q4taxFH1G8YVx34CV09lItUGloJIJrSJ+YDpP6tgNV/S9Qh1MK420TmQjDgD9prrHOKod3Gc0Hu0mNJLnSeO2AUeGoxWrLSr3xZLN3CMkj+nPNPwIty8rOjccASsdOU9oLh663kwlnQch1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bsnpoHqE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bsnpoHqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF8E1F000E9;
	Fri, 12 Jun 2026 15:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781277048;
	bh=pK2hdSWHNKRW1IYuKJCPg+FDoxVytPtUbD47XdAOeyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bsnpoHqEQbf1Ae1WMQ0N8G+nT5o4hRJItApyvNl18gDQBH7hTjc/+TlFdRco+e6yd
	 PJ0DCKKiEK1JPzNrEMb5eRbItiEd9vdpkhsIjmswCfSB/gkgxNUA+Ps+dvSRcvllBO
	 ohcUrk1MmYlioGHtBI2Etswsbtr6/ADGbch3NGfLxHMd25dxFzmoPyvx7tHhY25IES
	 CuzIA5y0DQIYsW576gQ02zUOjxPSrbNMX8ki+gfPrDf/bxMCFC9OCP5iGoIPoVq5mN
	 2WjCsvFIAiLXiULLyzNfcmxMt+0nfVC2YoqU+lAGzKdDYxchjMf9bYulovAibtTAdt
	 /jil3wZakq5mg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ufs: sysfs: Add WB partial flush mode support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daniel Lee" <chullee@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612150136.2263477-1-chullee@google.com>
References: <20260612150136.2263477-1-chullee@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 15:10:47 +0000
Message-Id: <20260612151047.CAF8E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unhandled pm_runtime_get_sync error leads to potential hardware ac=
cess on suspended device
--

commit 75ac0206b35904f19c6179a4c935e644238e4421
Author: Daniel Lee <chullee@google.com>
Subject: ufs: sysfs: Add WB partial flush mode support

This commit adds sysfs entries for JEDEC UFS 4.1 Extended WriteBooster
attributes and flags to support FIFO and Pinned partial flush modes.
It introduces UFS_ATTRIBUTE_RW and UFS_FLAG_RW macros to support
writable attributes and flags.

> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index d9dc4cc3452ee..fbf7404d6d78a 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
[ ... ]
> @@ -1527,41 +1533,94 @@ static const struct attribute_group ufs_sysfs_str=
ing_descriptors_group =3D {
> =20
>  static inline bool ufshcd_is_wb_flags(enum flag_idn idn)
>  {
> -	return idn >=3D QUERY_FLAG_IDN_WB_EN &&
> -		idn <=3D QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8;
> +	return (idn >=3D QUERY_FLAG_IDN_WB_EN &&
> +		idn <=3D QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8) ||
> +	       idn =3D=3D QUERY_FLAG_IDN_WB_UNPIN_EN;
> +}
> +
> +static ssize_t ufs_sysfs_flag_show(struct device *dev,
> +	struct device_attribute *attr, char *buf, enum flag_idn idn)
> +{
> +	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> +	u8 index =3D 0;
> +	bool flag;
> +	int ret;
> +
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +	if (ufshcd_is_wb_flags(idn))
> +		index =3D ufshcd_wb_get_query_index(hba);
> +	ufshcd_rpm_get_sync(hba);
> +	ret =3D ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +		idn, index, &flag);
> +	ufshcd_rpm_put_sync(hba);

[Severity: High]
This isn't a bug introduced by this patch, but this newly refactored functi=
on
ignores the return value of ufshcd_rpm_get_sync(). If the device W-LUN and
underlying HBA fail to resume from runtime suspend (returning a negative er=
ror
code), does it make sense to blindly proceed to call ufshcd_query_flag()?

Writing to or accessing MMIO registers of an unclocked or unpowered UFS
controller can trigger a synchronous external abort or PCI master abort.

[ ... ]
> @@ -1804,6 +1916,71 @@ UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
>  UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
>  UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
> =20
> +static ssize_t wb_partial_flush_mode_show(struct device *dev,
> +				 struct device_attribute *attr, char *buf)
> +{
[ ... ]
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +	ufshcd_rpm_get_sync(hba);
> +	ret =3D ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +		QUERY_ATTR_IDN_WB_PFM, ufshcd_wb_get_query_index(hba), 0, &value);
> +	ufshcd_rpm_put_sync(hba);
> +	up(&hba->host_sem);

[Severity: High]
This is a pre-existing issue in the older sysfs macros that has been propag=
ated
here to the newly created functions. Should we check the return value of
ufshcd_rpm_get_sync() here as well? The same pattern is present in
wb_partial_flush_mode_store(), ufs_sysfs_attr_show(), ufs_sysfs_attr_store(=
),
and ufs_sysfs_flag_store().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612150136.2263=
477-1-chullee@google.com?part=3D1
