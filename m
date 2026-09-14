Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7078048A8A3
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 17:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789408430; cv=none; b=EdzwYFWWgveoQTXavKVhCXUInFaiLtlLrROvSfOEPKRnlpZGBXzuww9PGd4WpuYf80mbxwWVlR4JKJiNmK4VJ4E1vgLCHv2ggP/t3NEJshM9OpYCDLPpPRM/ZMNdh6mGf89TgZ7j3i4VXDg3HQ2j5e0ebKY14TZ+k76avIsPA1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789408430; c=relaxed/simple;
	bh=ieG+RhTR9N474Y5FBTFLy8BhPnT3c/uFdem+xevOlCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fq6alRiuJVN9G4VGvAc93dkr6zx946ycA/mbkk36GtCgJgeh3HbyaM0/Bxro3dDieRgWEwecELml8RxwEJAvRqshssrUsVBYLGMmFg1iHBe3DgJiskVyJZDByiwlmE8/FkHXj05IxuGy3s++NI1XMTGIdC6ZEVbScq8u7b8Ciyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UPtfU+HT; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UPtfU+HT"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8701fcf40d4so612326b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 10:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789408429; x=1790013229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q5jXCqyzigjCqMuJ/T2jsSR0EfY0qyNEor9riHDlbmU=;
        b=UPtfU+HTNO5NdfgrEQ8KdYnRqrds2gCDoc71R3kx3ZLD79hKwYZ5J1qyiOY5m7LxC2
         wIiZn/Ho7SQvy4GJJNJEHDyCj/k1q1/OuHhmUO8og1pNF8kw2pzhFYznEbe8MPbBjvGh
         fLumEhSxLgYCK9BQB4BVl/WyA+AHupNJ7LbqYmSjoq8xfdMihfh0vhBMGo6Q2ccY87Oc
         uvxQcmXsT9sjFgJK4v2I0ApOShd1Ncm6fX8J2Id+2HvbVn/kVgfDwE0CnbfV9yJYzc8+
         Qmy24fqwDoZZNGa2odmVUvq6yVaZZWIm7uMjOD7Y5z4aR6R3BKpxEz3VoJFjEJix7/zo
         g1rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789408429; x=1790013229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q5jXCqyzigjCqMuJ/T2jsSR0EfY0qyNEor9riHDlbmU=;
        b=c6Pva6/wiROAPxmMFBJC+tqDtIUj0ia6/i22CCpOqv3U8RWdtWkM9CWiwesnNDl1YU
         /rhx0aHKhpzpOgCGqN1hyWv9jItlTkpoQMrSWpeemJAKlKapgxAA5UVYX1bi66dv5oGW
         sNtNmxj4r6Y15U2X/QCz07V16PO30rkMNhnf6QBa+DMobbhqqdRYZvqAt29TDJoDzoql
         qLD33Se5CuPkAMmFniryZHOrBC4egkSXiAdOq3UtHzXTkrmR7W3BRMJzegOICmqrwvss
         yKylN+5+iAgddBiUTtrHcfHvBvHP6M7M4lboui6hKBRjoLzjniwkscgVBnhG+6hAyZs3
         m6eQ==
X-Forwarded-Encrypted: i=1; AKwUvBxG86agbVTzboiMzepbI3eLRu3MN2mk5dnW5hj9DWD9ueyyVEd2dan6hYIZ+h9px+BnfMbF5hOrAeM1@vger.kernel.org
X-Gm-Message-State: AFuF++krJLiCD/8YCVzwEwovtmXFYsEPX/WqMh2Dh+dbonai5jvzvZQ8
	hL8kKYHZsf/Cpbp4tCNtW44bmb+t26chutCwKkuNJ7+efndcr+4NPf1e5QlgUYSaRBA=
X-Gm-Gg: AYBFou1iq/bybV+QZPju7axUyDy9RdLbIWeO4CrjUbXu8GsE4L/s52TlkBFrqUGFgQe
	XyeS/pNObCLF0PQePF/XkKh3OPnBvox32T918IAVgW4IkTmFJrKPkgrv7nCZZSxo0O5sqa3rddO
	TGRtoELAcShORdQcgSB1rWur0HE6r31mA8AMqrnaf1YLX5BfBRHWwb8i9caxNExw2cUPoYGcl8r
	R+CKmTUNHg+ijRxlUKKmc1WXhwZTX6/2u+iE0e5w3fkfdoer0OMV4EB0khAp5GVvW9W6lYpbBvW
	/Y0HZCUyo2RJX4BwBbjD78O802irHmju/rFcaQ+Sa4MnZMDz/pKmnnDGeLd1lZqcuVPjq4oq9Do
	w1YNjhpIOHl+9DkFBwIzL8YvA85IxbizUD8Jd0IuTyGtw1o760d0b6g9RBQvTZPqZFPuj1iKVJs
	y14p7i2g3KjywXV+xNGlppNmjyblQ6wEH+ksuWxlhhmjnJXBSYgiPCdhObwu24M9RDG2HMtQpa5
	q5tDGuQQ5sLsRQhN/5lLU11eaR9twAdAmvx2mUTBWnYeQ1HKM0pSpmwsl141Ju9Dc7qx8KC7cde
	JlbBxiTWxEhIYo0/SMOD
X-Received: by 2002:a05:6a21:138f:b0:3d3:adbf:7779 with SMTP id adf61e73a8af0-3db4059a9b9mr8533732637.21.1789408428674;
        Mon, 14 Sep 2026 10:53:48 -0700 (PDT)
Received: from NV-9MNJ414.tailae2068.ts.net (2001-b011-2005-787e-1dca-bd0c-04f0-d1fc.dynamic-ip6.hinet.net. [2001:b011:2005:787e:1dca:bd0c:4f0:d1fc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6596d88sm5579062a12.26.2026.09.14.10.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 10:53:48 -0700 (PDT)
From: Yiwei Lin <s921975628@gmail.com>
To: Yiwei Lin <s921975628@gmail.com>
Cc: alim.akhtar@samsung.com,
	avri.altman@sandisk.com,
	bvanassche@acm.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: sysfs: fix current_power_mode read without SSU
Date: Tue, 15 Sep 2026 01:53:32 +0800
Message-Id: <20260914175332.9546-1-s921975628@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260914170032.5551-1-s921975628@gmail.com>
References: 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2026/09/15 01:00, Yiwei Lin wrote:

> current_power_mode was generated by UFS_ATTRIBUTE(), which calls
> ufshcd_rpm_get_sync() before issuing the query.
>
> That resumes the UFS device WLUN, and ufshcd_wl_runtime_resume() sends
> START STOP UNIT to bring the device back to Active. As a result
> bCurrentPowerMode always read back as 0x11 (Active) no matter what
> state the device was actually in. Sleep could never be observed through
> sysfs.
>
> Per the UFS spec, bCurrentPowerMode is the one attribute the device
> must answer in any power mode, so there is no need to wake it.
>
> Tested on hardware: with the device runtime-suspended, reading
> current_power_mode used to return 0x11; after this change it returns
> 0x22 (Sleep), matching the device's real state.
>
> Assisted-by: LLM
> Signed-off-by: Yiwei Lin <s921975628@gmail.com>
> ---
>  drivers/ufs/core/ufs-sysfs.c | 59 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 58 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 63e670d1a9d9e..36cffd535ab7d 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -1786,7 +1786,64 @@ out:									\
>  static DEVICE_ATTR_RO(_name)
>  
>  UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
> -UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
> +
> +/*
> + * Per UFS spec, bCurrentPowerMode is the only attribute the device must
> + * respond to in any power mode.  Read it without waking the device to
> + * Active: restore HBA clocks via pm_runtime_get_sync(hba->dev) only
> + * (avoids triggering ufshcd_wl_runtime_resume and its START STOP UNIT),
> + * exit Hibern8 if needed so the link can carry the UPIU, then query.
> + */
> +static ssize_t current_power_mode_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	u32 value;
> +	int ret;
> +
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +
> +	ret = pm_runtime_get_sync(hba->dev);
> +	if (ret < 0) {
> +		pr_warn("%s: pm_runtime_get_sync failed %d\n", __func__, ret);
> +		pm_runtime_put_noidle(hba->dev);
> +		up(&hba->host_sem);
> +		return ret;
> +	}
> +	ret = 0;
> +
> +	ufshcd_hold(hba);
> +
> +	if (ufshcd_is_link_hibern8(hba)) {
> +		ret = ufshcd_uic_hibern8_exit(hba);
> +		if (!ret)
> +			ufshcd_set_link_active(hba);
> +		else
> +			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
> +				__func__, ret);
> +	}
> +
> +	if (!ret)
> +		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +			QUERY_ATTR_IDN_POWER_MODE, 0, 0, &value);
> +
> +	ufshcd_release(hba);
> +	pm_runtime_put(hba->dev);
> +
> +	if (ret) {
> +		up(&hba->host_sem);
> +		return -EINVAL;
> +	}
> +	ret = sysfs_emit(buf, "0x%08X\n", value);
> +	up(&hba->host_sem);
> +	return ret;
> +}
> +static DEVICE_ATTR_RO(current_power_mode);
> +
>  UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
>  UFS_ATTRIBUTE(ooo_data_enabled, _OOO_DATA_EN);
>  UFS_ATTRIBUTE(bkops_status, _BKOPS_STATUS);

According to [Sashiki's review](https://sashiko.dev/#/patchset/20260914170032.5551-1-s9      21975628@gmail.com?part=1), I think I overlooked the condition that the link is not forcefully active, which may lead to a race condition or unexpected behavior. 

I'll provide v2 with careful review and validation.

> -- 
> 2.34.1
>
