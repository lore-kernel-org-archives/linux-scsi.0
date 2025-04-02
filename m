Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC4A23237C;
	Wed,  2 Apr 2025 04:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743567695; cv=none; b=n4kmqx8fvz7PNFk5R48cjvuKtk4f+tD+I1Tq7p7s6up72sKXLgzp2C0d0eruQLRIyWKvOHLq6bEF7oar/YltFu1J4aUsi1Cvyka+cJWsJOJNsH54Wmqn0EZX387KbkVIFhg41bFV/YtlFW+J7NbPI6qHDAPASFJvRtcTyQMvw/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743567695; c=relaxed/simple;
	bh=iVrNvGutPDYzqsgoah6jHfsjPdQqHhlL3O1BSV3F40w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rIWUovU17S7sTj1byOtwDZFi8z+JsFT4NqkBXWVJDptQ6ivvQ8JZ2cdZb638xkGKrf6Wo4Ds5Ky5ITiyZZYFszfCgn3NhWkrrcOUkJYQ6WN047R8qwsFwSGDwZaxmzrIgG0xHBhDzW5vZosKcgId/1S4CGaxWyUdg88vGr/ICg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c1/9Ws5d; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c1/9Ws5d"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZSBWq0ZZ7zlvfnd;
	Wed,  2 Apr 2025 04:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743567684; x=1746159685; bh=CPTmykr03XExO8Q7/kKxhPyv
	u3/fKiEb4C4kJE4nYkg=; b=c1/9Ws5dTpi5Ze+i9vyAhoFqR+tQByeoYFp7tT4H
	FOIP4fApEj6zVS/cB6iUih6BwA+v4FK/iZT0scZ07bFxOolLk1aDp37wVQwc+HXz
	/2tu/4gLr1B4c8ejs6TKxRqiLQtNf9KhDf/m16Dxgtt/3wvZHDizaAC8SKPl9c9F
	SD0WmABPS++sWwPFHaqQZcqUxzHBPb3MNPVQyQcRR/aGPlC1tMASbDo8D7XWcg4t
	u24LvmwCfE4rANED14Zt/Vt3u6pygAIsv73T+dAvSqvTTjIYJhLLNOJVqKWTyONh
	dE1XqvuMlJHaPkrhZ/2O4U8fLcaRFFzvmBFnPg0fJyK1yw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id B8t3pmhoC4BC; Wed,  2 Apr 2025 04:21:24 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZSBWL4vCGzlv629;
	Wed,  2 Apr 2025 04:21:00 +0000 (UTC)
Message-ID: <467b9ba0-5dea-49c5-ab43-435d3d3fd6bc@acm.org>
Date: Tue, 1 Apr 2025 21:20:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] ufs: core: Add WB buffer resize support
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
References: <20250402014536.162-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250402014536.162-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/25 9:45 PM, Huan Tang wrote:
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index ae0191295d29..efa1e2df292c 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1604,3 +1604,55 @@ Description:
>   		prevent the UFS from frequently performing clock gating/ungating.
>   
>   		The attribute is read/write.
> +
> +What:		/sys/bus/platform/drivers/ufshcd/*/wb_resize_enable
> +What:		/sys/bus/platform/devices/*.ufs/wb_resize_enable
> +Date:		April 2025
> +Contact:	Huan Tang <tanghuan@vivo.com>
> +Description:
> +		The host can decrease or increase the WriteBooster Buffer size by setting
> +		this attribute.
> +
> +		========  ======================================
> +		IDLE      There is no resize operation
> +		DECREASE  Decrease WriteBooster buffer size
> +		INCREASE  Increase WriteBooster buffer size
> +		Others    Reserved
> +		========  ======================================
> +
> +		The attribute is write only.

The description of the attribute contradicts the name of the attribute.
Wouldn't wb_resize_enable be a better name for this attribute?
Additionally, that name will be easier to recognize for anyone who is
familiar with the UFS 4.1 standard.

To be consistent with other sysfs attributes, the names of the verbs
should be changed from upper case to lower case and "Others - Reserved"
should be left out. This comment also applies to the other attributes.

> +static const char *ufs_wb_resize_hint_to_string(enum wb_resize_hint hint)
> +{
> +	switch (hint) {
> +	case WB_RESIZE_HINT_KEEP:	return "KEEP";
> +	case WB_RESIZE_HINT_DECREASE:	return "DECREASE";
> +	case WB_RESIZE_HINT_INCREASE:	return "INCREASE";
> +	default:	return "UNKNOWN";
> +	}
> +}

The formatting of the above switch/case statement is not compliant with
the Linux kernel coding style.

Thanks,

Bart.
