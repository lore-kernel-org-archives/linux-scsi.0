Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956AB155C97;
	Wed,  9 Apr 2025 21:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744233469; cv=none; b=qATsHHmVPqwbzQ1zyZkpVJMdrFIoo1bGve7GxzG2Nsg1eKCJuAQ+kj+A2WVpN8KiaV4m84aRxnjStE7rky2P1GsqPvrvrwC4IDsuI7NA8TIsUPjO2uCFodhzyLmUDTLq+6qJLHdZTdbB3BhoVWIenotadHryZmLbeHM6Jvx+fhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744233469; c=relaxed/simple;
	bh=RbubNOUbcBh5lPCO69UGE4GSAbA1rjLNoE859qAac2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e57nKxwJMDB+E4BvN66FUt3TY5bLC7Mh2BBiDFcVfSccIcmuet7IKRlYjinnWamHucYSDBEU+brh97xEj7uFghcHBdwFlA2KH6/31nX+kLDpAhYSzAO+50x/8t7obwnjXJTF9P//TJzdpcFhsJm6C7+IcEa7bdG1hHWWPrjpeW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XuSM6pe0; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XuSM6pe0"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZXwlC20kBzm0jvb;
	Wed,  9 Apr 2025 21:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744233459; x=1746825460; bh=/YkQk5LbbSx546vI1MZJxap/
	PF085F71V15VA/wS7lk=; b=XuSM6pe0fJOUSAPkVNwWyLz4p53LWske0nSFySgJ
	XuqTjOIzKgS+tPKoYxJMeA5Wj7yPCHu72waDn3boiLPPViCiiR/uh9SSrE7ie/JP
	Beu062gk+qJmdNsdce69zaNfYffaUdQ/amU0D37KKmsHhwSneGG6+896taG3V0Sl
	kZxI/YoMT3AovR4AbUkzXdMvlHXd6rrS4F1XteiE2Nk3ObEA6swkOOiAhCpyP3li
	V43B76Th9d+3CiEw3FcfThH8r+mvPmE9bgMYP72L3sChTg6FXYC51SqONsUtLWRM
	RSWVORUcZxy3tKupauI5/BR0GVq/waJCJBcs1/72bOnedg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HAdLs5GBptoH; Wed,  9 Apr 2025 21:17:39 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZXwkv3tCPzm0ysg;
	Wed,  9 Apr 2025 21:17:26 +0000 (UTC)
Message-ID: <4ef0fe17-c30a-4d15-87e0-35f0c0163e1b@acm.org>
Date: Wed, 9 Apr 2025 14:17:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10] ufs: core: Add WB buffer resize support
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, beanhuo@micron.com, luhongfei@vivo.com,
 quic_cang@quicinc.com, keosung.park@samsung.com, viro@zeniv.linux.org.uk,
 quic_mnaresh@quicinc.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, quic_nguyenb@quicinc.com,
 linux@weissschuh.net, ebiggers@google.com, minwoo.im@samsung.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com
References: <20250407090920.431-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250407090920.431-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/25 2:09 AM, Huan Tang wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ext_wb_sup
> +What:		/sys/bus/platform/devices/*.ufs/device_descriptor/ext_wb_sup
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		This file shows extended WriteBooster features supported by
> +		the device.
> +
> +		The file is read only.

Please remove this attribute again. I don't think that it is useful to
make the value of wExtendedWriteBoosterSupport available in sysfs.
Additionally, wExtendedWriteBoosterSupport is a bitfield and hence
exporting it directly violates the sysfs one-value-per-attribute rule.

> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_status
> +What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_status
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The host can check the resize operation status of the WriteBooster
> +		buffer by reading this attribute.
> +
> +		================  ========================================
> +		idle              Resize operation is not issued
> +		in_progress       Resize operation in progress
> +		complete_success  Resize operation completed successfully
> +		general_fail      Resize operation general failure
> +		================  ========================================

Why "general_fail" instead of "general_failure"?

> +static const char * const wb_resize_en_mode[] = {
> +	[WB_RESIZE_EN_IDLE]		= "idle",
> +	[WB_RESIZE_EN_DECREASE]		= "decrease",
> +	[WB_RESIZE_EN_INCREASE]		= "increase",
> +};

A minor comment: please remove one tab in front of "=" for the value
assignments in the above array definition.

> +static ssize_t wb_resize_hint_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	int ret;
> +	u32 value;
> +
> +	ret = wb_read_resize_attrs(hba,
> +			QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT, &value);
> +	if (ret)
> +		goto out;
> +
> +	ret = sysfs_emit(buf, "%s\n", ufs_wb_resize_hint_to_string(value));
> +
> +out:
> +	return ret;
> +}

The formatting of the above code is not compliant with the Linux kernel 
coding style guide. Please reformat this patch, e.g. with "git 
clang-format HEAD^".

Otherwise this patch looks good to me.

Thanks,

Bart.
