Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83234296721;
	Wed, 14 May 2025 21:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747256720; cv=none; b=PXaLJylXN3NyQrc14nQPhD0pHR0mrQCiiOYVvm2QpXCB2UBeZgjCvACNub0XYQTX7rip3yoafJW7Bz7JomBVecnAGIInO050BHdNKKvn9h0WLNmJgiZAKoMETr8kYibA0KVd6w6fRzJVmrPEgR72L3b3IiBnLIwGK4RsOLowN3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747256720; c=relaxed/simple;
	bh=uoRh8aaEuZOB5yWJaOK5GfLIhzapSqZ04TVuCbrANNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WnnWazttlAVaMckWBf3fprLbRA/Ziy6ZjgbdU3J5c8Yznet9URhi67c4Y6q3R7g9fzgB41GtDQdhw1uo6LDbYH+psAYeUfet2b/R7HKyMs3OsBX+gCHdldXzS5akysRNHL0U0IaBvHEoX7snyJ4Rj1OT/OhmvmWUpUZj1/wMr3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x+6W/6QD; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x+6W/6QD"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZyQph1mslzlytFj;
	Wed, 14 May 2025 21:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747256712; x=1749848713; bh=4y6PpJpBvWFd4janBIfhVIiK
	UNQpKumZnChgRc1rMHc=; b=x+6W/6QDkL7EY+dpOuW6aAvIA2BJcx+poFLSCnez
	c9kP6soLoce7VKhm/J58RbrrT7MdFOBDPzBeUx79eWIh/kUcNUuEfyoL1L07fPfL
	q7LGxAC8ZkZpHWJ6Nel0i+AJL39sbFHhB2pjddhShrRU6G/F9nwcyyBp15s2s4er
	/7McPBtoFjzc9lawcVBvslN7QSlH8HvBHjE8HrhUNnki833OeyyhZtZJ/G3Act21
	8hbBdM0TLEgIn0x6qTRAHV+GGnoLpAq8xToSI1DB2Oz6f0zQwb3BTOLZ5Y7aj480
	2vaaRwFRkVlJIYQU9ABnkYlF/rvsS7QfoVjJ4GLfd9/p/w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q7JJV-5aA4eK; Wed, 14 May 2025 21:05:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZyQpL6nSDzlyj4g;
	Wed, 14 May 2025 21:04:57 +0000 (UTC)
Message-ID: <88718b2f-0583-4444-8bf0-7ecf9a45329c@acm.org>
Date: Wed, 14 May 2025 14:04:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Add HID support
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, quic_nguyenb@quicinc.com,
 luhongfei@vivo.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com, Wenxing Cheng <wenxing.cheng@vivo.com>
References: <20250512131519.138-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250512131519.138-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 6:15 AM, Huan Tang wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/ufs_hid/hid_analysis_trigger
> +What:		/sys/bus/platform/devices/*.ufs/ufs_hid/hid_analysis_trigger
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The host can enable or disable HID analysis operation.
> +
> +		=======  =========================================
> +		disable   disable HID analysis operation
> +		enable    enable HID analysis operation
> +		=======  =========================================
> +
> +		The file is write only.

All HID sysfs attributes occur in the "ufs_hid" directory and have a
"hid_" prefix. That's two times "hid". Please remove the "hid_" prefix
from the sysfs attribute names since it is redundant.

> +static struct attribute *ufs_sysfs_ufs_hid[] = {
> +	&dev_attr_hid_analysis_trigger.attr,
> +	&dev_attr_hid_defrag_trigger.attr,
> +	&dev_attr_hid_fragmented_size.attr,
> +	&dev_attr_hid_defrag_size.attr,
> +	&dev_attr_hid_progress_ratio.attr,
> +	&dev_attr_hid_state.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group ufs_sysfs_ufs_hid_group = {
> +	.name = "ufs_hid",
> +	.attrs = ufs_sysfs_ufs_hid,
> +};

Isn't the prefix "ufs_" in "ufs_hid" redundant since this sysfs group
occurs under a UFS host controller directory?

Regarding the name of this sysfs group, "ufs" occurs twice in that
name (ufs_sysfs_ufs_hid_group). Please make sure that "ufs" only occurs
once in that sysfs group name.

>   #define UFS_LUN_DESC_PARAM(_pname, _puname, _duname, _size)		\
>   static ssize_t _pname##_show(struct device *dev,			\
>   	struct device_attribute *attr, char *buf)			\
> @@ -1898,6 +2079,7 @@ const struct attribute_group ufs_sysfs_lun_attributes_group = {
>   
>   void ufs_sysfs_add_nodes(struct device *dev)
>   {
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
>   	int ret;
>   
>   	ret = sysfs_create_groups(&dev->kobj, ufs_sysfs_groups);
> @@ -1905,9 +2087,22 @@ void ufs_sysfs_add_nodes(struct device *dev)
>   		dev_err(dev,
>   			"%s: sysfs groups creation failed (err = %d)\n",
>   			__func__, ret);
> +
> +	if (hba->dev_info.hid_sup) {
> +		ret = sysfs_create_group(&dev->kobj, &ufs_sysfs_ufs_hid_group);
> +		if (ret)
> +			dev_err(dev,
> +				"%s: sysfs ufs_hid group creation failed (err = %d)\n",
> +				__func__, ret);
> +	}
>   }

Please merge ufs_sysfs_ufs_hid_group into ufs_sysfs_groups, remove the
new sysfs_create_group() call and add a visibility callback in
ufs_sysfs_ufs_hid_group that only makes the attributes in this group
visible if hba->dev_info.hid_sup == true.

Otherwise this patch looks good to me.

Thanks,

Bart.
