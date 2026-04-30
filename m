Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB7C43D515
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 15:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777564102; cv=none; b=aVSUT+Mf2DPTOf9W7x7lGmzEuxJwtToD35ptRF3QQr2mKoRu87yr0zHkEF89GJlBzggFQiQtV/INOnRai9/hEhWGmdDTXHxN+8J+OwGdYdneEJaBJg1Fhvq6eKXymaLzG+W2xKH7dAN9Ev1aWeKu3ABrdHuluLAnJsiX+kyp5ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777564102; c=relaxed/simple;
	bh=+WXn/wqbvsJXOOpfOLDqgGQmeKzvlqRxpK7a7IT3pTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=De3Ny75i2opHnFxhAKp1/by3h4uFU8eZh2egCPxMf2cgnZi0vHmZhE4kFrBSj+fpnwpv2eff3gmTVdrQuhvGScq055d2neT30tY15McdRdpgTmokRrzhgK8ahvHlf9mmTlXv2vM+Mc91kmnKvr+n6CKhu3yjzk+kW0124mta8/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wwm00n5P; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wwm00n5P"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g5z902B7nz1XM6JH;
	Thu, 30 Apr 2026 15:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777564095; x=1780156096; bh=TMWxSn5OVQGTW9aA2+ngX/5r
	4+vJGr2Hy2F/7jgsoME=; b=wwm00n5PidIOKskZiPWrF6raZftlbeM11XlVNHPU
	4Xpnmyer+6ws98gpF5tHl0Ks+zcf5CzK25jMjBmL3BFx2pdDjlVW5JkAeUuKVqZX
	CdWwBIF8RmTzhbQ2dGViSm1+3Hr6aYD5RrkoFubV/fjN36FDXwBadzIFcg0dPgre
	zwbeRpO/m24fFuEFotXbM+uOJZ1GKcxXuwQXt5gCwCQtcuqn3ItCRPUDrIhr6Vmn
	PyRnMUE1xoeMae+tBSIOUaml2xIA0eJzrTN8iBw8+MIwGE91IFB0d0DmPAYr9IEN
	sKh4xjLopCocrIn7pvyPudEMp/sDPlRU2wwJb/ZcnMPtHg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m7KK5l37TRKA; Thu, 30 Apr 2026 15:48:15 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g5z8t2rzMz1XM31H;
	Thu, 30 Apr 2026 15:48:14 +0000 (UTC)
Message-ID: <cc6d3238-5574-4a0a-ba3a-2660687ec292@acm.org>
Date: Thu, 30 Apr 2026 08:48:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
To: Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc: hare@suse.de, dlemoal@kernel.org,
 Krishna Kant <krishna.kant@purestorage.com>
References: <20260429012733.40855-1-brian@purestorage.com>
 <20260429224939.77082-1-brian@purestorage.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260429224939.77082-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/26 3:49 PM, Brian Bunker wrote:
> All INQUIRY-derived sysfs attributes (type, scsi_level, vendor, model,
> rev, cdl_supported, and the binary inquiry attribute) read data that
> can be updated during device rescan. These reads must be protected
> against concurrent updates.
> 
> Use the existing inquiry_mutex to protect access to these sysfs
> attributes. This ensures that userspace always sees consistent INQUIRY
> data, even if a rescan is updating the buffer concurrently.
> 
> Replace the sdev_rd_attr macro with two new helpers,
> sdev_rd_inquiry_attr_int and sdev_rd_inquiry_attr_str, which generate
> the show functions for INQUIRY-derived integer and string fields and
> take the inquiry_mutex around the field access.
> 
> This is preparatory work for adding INQUIRY data update support during
> device rescan operations.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>

Shouldn't your signed-off-by come last since you are the person posting
this patch?

> -#define sdev_rd_attr(field, format_string)				\
> -	sdev_show_function(field, format_string)			\
> -static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL);
> +#define sdev_rd_inquiry_attr_str(field, accessor, len)			\
> +static ssize_t								\
> +sdev_show_##field(struct device *dev, struct device_attribute *attr,	\
> +		  char *buf)						\
> +{									\
> +	struct scsi_device *sdev = to_scsi_device(dev);			\
> +									\
> +	guard(mutex)(&sdev->inquiry_mutex);				\
> +	if (sdev->inquiry)						\
> +		return sysfs_emit(buf, "%.*s\n", len,			\
> +				  accessor(sdev->inquiry));		\
> +	return sysfs_emit(buf, "\n");					\
> +}									\
> +static DEVICE_ATTR(field, S_IRUGO, sdev_show_##field, NULL)
>   
>   /*
>    * Create the actual show/store functions and data structures.
>    */
> -sdev_rd_attr (type, "%d\n");
> -sdev_rd_attr (scsi_level, "%d\n");
> -sdev_rd_attr (vendor, "%.8s\n");
> -sdev_rd_attr (model, "%.16s\n");
> -sdev_rd_attr (rev, "%.4s\n");
> -sdev_rd_attr (cdl_supported, "%d\n");
> +sdev_rd_inquiry_attr_int(type);
> +sdev_rd_inquiry_attr_int(scsi_level);
> +sdev_rd_inquiry_attr_int(cdl_supported);
> +sdev_rd_inquiry_attr_str(vendor, scsi_inq_vendor, SCSI_INQ_VENDOR_LEN);
> +sdev_rd_inquiry_attr_str(model, scsi_inq_product, SCSI_INQ_PRODUCT_LEN);
> +sdev_rd_inquiry_attr_str(rev, scsi_inq_revision, SCSI_INQ_REVISION_LEN);

I'm not aware of any other example of "accessor" functions in the Linux
kernel for character data that is not '\0' terminated. Accessor
functions like scsi_inq_vendor() only hide the offset of the vendor data
but not the length. I prefer that all accessor functions would be 
removed for strings that are not '\0'-terminated. sdev_show_##field()
can be modified to accept an offset and a length instead of an accessor
function and a length.

Thanks,

Bart.
