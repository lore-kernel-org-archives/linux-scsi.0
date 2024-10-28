Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45B63A1DB;
	Mon, 28 Oct 2024 19:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730145060; cv=none; b=EOC3oKRNzN6tlapuY8qejONMxi9L9giVcvO2/F3pS3QoUdB+1eRRkT6ndhrZiHumsyVyFrWp3IF6ISN4qi9RdWteRRbgi9fPe7x2z6STnNhkH2eBsrrfL6645xmcppP/dO3mf7sBytKB1/oOuUV/h7sNuiClH65xGOYgkeXTbHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730145060; c=relaxed/simple;
	bh=/59UInKs1jPdhye+ywI9zjMLf0geE/n+JAGYfww/9ss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A3f1Xy8q0FtHZH4k3j0MD50ULgS27ffWboedOv6hmlu9lNxVrNVpalI7UsNtMsR6ddzn0kT30yCZak4a2OGUbvHr1w/lST5fkNqQrV9XGYQttIDddTfjf2KMYIdxyrs21n2DzSz6o2VpQl8iYN+RoPksFMN51mQ9XQP0LngLal4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1Y/Ijz61; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1Y/Ijz61"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XckXL0h1Vz6Cnk9N;
	Mon, 28 Oct 2024 19:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730145045; x=1732737046; bh=tI4AfILStzPbfhtZq0bCJPMf
	8+hLePNOOBQdMQ26eP0=; b=1Y/Ijz61vzLVRdeH2inV1Fb829PnUgbXolM5dJd/
	grOg/3w/e8frnP6asQKOV8AHyDAlf/IE47Dow5djxaz/wXTn2XuTlE9GEfPuTcnQ
	z6jEybHCqAxcss9lT4z+ZLKfy5SqF5BZjYpPmbomttv4Kcnk7RQzwdMoYW61a89H
	8DPP5v5J11dGTiMD6f3bSva3VkbNqHpo6tmmUiLSvY8VZdTRWSBzgAvOlNnCqPqH
	JiZzt7KNqwouBfSzuKA88m6uMdMLhOBEY3oFiL2TqIIfLdAc2v40SiyS+C6HE/+p
	zVQIMNI/3fh7XG3LICDkBo7uBhsKB3quffL28Ez4aOqQIQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9H1p7XdS2C7h; Mon, 28 Oct 2024 19:50:45 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XckX36P72z6Cnk9M;
	Mon, 28 Oct 2024 19:50:43 +0000 (UTC)
Message-ID: <13aff452-0ce8-4ebf-986c-dd3bb7c322de@acm.org>
Date: Mon, 28 Oct 2024 12:50:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ufs: core: Add WB buffer resize support
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, beanhuo@micron.com, luhongfei@vivo.com,
 quic_cang@quicinc.com, keosung.park@samsung.com, viro@zeniv.linux.org.uk,
 quic_mnaresh@quicinc.com, peter.wang@mediatek.com,
 manivannan.sadhasivam@linaro.org, ahalaney@redhat.com,
 quic_nguyenb@quicinc.com, linux@weissschuh.net, ebiggers@google.com,
 minwoo.im@samsung.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: opensource.kernel@vivo.com
References: <20241028135205.188-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241028135205.188-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/24 6:52 AM, Huan Tang wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/wb_toggle_buf_resize
> +What:		/sys/bus/platform/devices/*.ufs/wb_toggle_buf_resize
> +Date:		Qct 2024
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The host can decrease or increase the WriteBooster Buffer size by setting
> +		this file.
> +
> +		======  ======================================
> +		00h  Idle (There is no resize operation)
> +		01h  Decrease WriteBooster Buffer Size
> +		02h  Increase WriteBooster Buffer Size
> +		Others  Reserved
> +		======  ======================================
> +
> +		The file is write only.

The name "wb_toggle_buf_resize" is not clear and will make users guess
what the purpose of this sysfs attribute is. Please choose a name that
is more clear, e.g. "wb_resize_action".

Additionally, please change the word "file" into "attribute" to maintain
consistency with the rest of the sysfs documentation.

Please also make sure that the documentation is consistent with the
code. The above documentation mentions the value 0 while the code
doesn't allow writing the value zero.

> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_buf_resize_status
> +What:		/sys/bus/platform/devices/*.ufs/attributes/wb_buf_resize_status
> +Date:		Qct 2024
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The host can check the Resize operation status of the WriteBooster Buffer
> +		by reading this file.
> +
> +		======  ========================================
> +		00h  Idle (resize operation is not issued)
> +		01h  Resize operation in progress
> +		02h  Resize operation completed successfully
> +		03h  Resize operation general failure
> +		Others  Reserved
> +		======  ========================================

For the three new attributes: please use words in sysfs instead of 
numbers. Using numbers is not user-friendly.

> +static ssize_t wb_toggle_buf_resize_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	unsigned int wb_buf_resize_op;

Please introduce an enumeration type instead of using 'unsigned int'. 
Please also choose a more descriptive variable name than 'op'.

> +int ufshcd_wb_toggle_buf_resize(struct ufs_hba *hba, u32 op)
> +{
> +	int ret;
> +	u8 index;
> +
> +	index = ufshcd_wb_get_query_index(hba);
> +	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +				   QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &op);
> +	if (ret)
> +		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
> +			__func__, ret);
> +
> +	return ret;
> +}

This function doesn't toggle anything - it sets the value of the
bWriteBoosterBufferResizeEn attribute. Please reflect this in the
function name, e.g. by renaming this function into
ufshcd_wb_set_resize_en(). Additionally, the name of the 'op' argument
doesn't reflect the purpose of that argument. How about renaming it into
'enum wb_resize_en' where the wb_resize_en type support the three values
idle = 0, decrease = 1 and increase = 2?

Thanks,

Bart.
