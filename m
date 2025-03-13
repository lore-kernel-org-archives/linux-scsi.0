Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F106E1E8353;
	Thu, 13 Mar 2025 18:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741889699; cv=none; b=CUzxs7c0GjNHxB8uYybLTZyslhxCk9xgPoeTBi1rTuODkfRR23djhFJXdpToSU4WWOUGzip6IKJfNxSxmfjrp3+fJuxw7xEOmPKQas9dBkrSRvlddJnPS3ogKuXtkQFawKG4BZtv/u6Q66i5YDo0rIm0766d6nYpxq0WExJBkvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741889699; c=relaxed/simple;
	bh=hIBH78mE6GO1MejE6dr+XaQJGM2c3fwjbfirYnMXDGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FjEtX98sz39ff3KDmsDQft/xMgvS2adS0S40QsYMW0ox5IUCqZvCr3D3aY6UW42g5VQP79UEmuffs46Mhh8NW7J+R7aB+pIWgXVMWAk6330+597OKjMpiNtbtmTjcfBAqsOOxGS83ts1Wi93FRIGB0xc4H6yKCHLkNfWqIAgSKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KKtQvRO8; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KKtQvRO8"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZDFym5cLGzlxY1w;
	Thu, 13 Mar 2025 18:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741889693; x=1744481694; bh=LV8qgu4HNhR4DJaiWiuYUDp2
	+uUqQ+GBcNS/EVeGX+8=; b=KKtQvRO8z/4Nb47g/yEcTK7W6yIYi2zh4o+BlHcF
	Xxq0QgPiRUKWg0VtVwmsTbUdAmOlrOgDTjUvZWheXNlLoNKRoYR/qBPztpOFBrVf
	b4v/eswekj3vLOPQjxMjyiS1HZY5QpwAFPl+b87nN/UgT4lv+bSo8kqh79wgaEdi
	EVX+mn6EfShJ9N7kr2NPdsxDQcJgohBBQUj1A3S516xz9ZzIh/CoDW4E5kntjQkR
	c28jtFiAJPz7KemUtZQB7Prqpm60Z285fwVkzsqqLU+rq7waKVuQOmxpyPf8nmYS
	n4fy/o+Hb5HSpP7L6VkB5xcaknZhBSnV84HJzaJPU8HwdQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RfCfv0FjJaMb; Thu, 13 Mar 2025 18:14:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZDFyR13KlzlxY1r;
	Thu, 13 Mar 2025 18:14:37 +0000 (UTC)
Message-ID: <41678800-470f-4ea2-802c-f9f4d21817f6@acm.org>
Date: Thu, 13 Mar 2025 11:14:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] scsi: ufs: core: add device level exception
 support
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, minwoo.im@samsung.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Bean Huo <beanhuo@micron.com>, Ziqi Chen <quic_ziqichen@quicinc.com>,
 Keoseong Park <keosung.park@samsung.com>,
 Gwendal Grignou <gwendal@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Eric Biggers <ebiggers@google.com>, open list <linux-kernel@vger.kernel.org>
References: <772730b9a036a33bebc27cb854576a012e76ca91.1741282081.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <772730b9a036a33bebc27cb854576a012e76ca91.1741282081.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/25 9:31 AM, Bao D. Nguyen wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception
> +What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception
> +Date:		March 2025
> +Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
> +Description:
> +		The device_lvl_exception is a counter indicating the number
> +		of times the device level exceptions have occurred since the
> +		last time this variable is reset. Read the device_lvl_exception_id
> +		sysfs node to know more information about the exception.
> +		The file is read only.

Shouldn't this sysfs attribute have a "_count" suffix to make it clear
that it represents a count?

Additionally, here and below, please change "file" into "attribute".

> +What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
> +What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_id
> +Date:		March 2025
> +Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
> +Description:
> +		Reading the device_lvl_exception_id returns the device JEDEC
> +		standard's qDeviceLevelExceptionID attribute. The definition of the
> +		qDeviceLevelExceptionID is the ufs device vendor specific design.
> +		Refer to the device manufacturer datasheet for more information
> +		on the meaning of the qDeviceLevelExceptionID attribute value.
> +		The file is read only.

I'm not sure it is useful to export vendor-specific information to
sysfs.

> diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
> index 90b5ab6..0248288a 100644
> --- a/drivers/ufs/core/ufs-sysfs.c
> +++ b/drivers/ufs/core/ufs-sysfs.c
> @@ -466,6 +466,56 @@ static ssize_t critical_health_show(struct device *dev,
>   	return sysfs_emit(buf, "%d\n", hba->critical_health_count);
>   }
>   
> +static ssize_t device_lvl_exception_show(struct device *dev,
> +					 struct device_attribute *attr,
> +					 char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	if (hba->dev_info.wspecversion < 0x410)
> +		return -EOPNOTSUPP;
> +
> +	return sysfs_emit(buf, "%u\n", hba->dev_lvl_exception_count);
> +}

The preferred approach for sysfs attributes that are not supported is to 
make these invisible rather than returning an error code.

> +static ssize_t device_lvl_exception_id_show(struct device *dev,
> +					    struct device_attribute *attr,
> +					    char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	u64 exception_id;
> +	int err;
> +
> +	ufshcd_rpm_get_sync(hba);
> +	err = ufshcd_read_device_lvl_exception_id(hba, &exception_id);
> +	ufshcd_rpm_put_sync(hba);
> +
> +	if (err)
> +		return err;
> +
> +	hba->dev_lvl_exception_id = exception_id;
> +	return sysfs_emit(buf, "%llu\n", exception_id);
> +}

Just like device_lvl_exception, this attribute shouldn't be visible if
device level exceptions are not supported.

> +	if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION) {
> +		hba->dev_lvl_exception_count++;
> +		sysfs_notify(&hba->dev->kobj, NULL, "device_lvl_exception");
> +	}

sysfs_notify() may sleep and hence must not be called from an interrupt
handler.

Thanks,

Bart.
