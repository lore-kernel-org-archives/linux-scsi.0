Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77955375ADF;
	Tue,  7 Jul 2026 17:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443793; cv=none; b=XAgf4TOXhJW8um5rgFlysl75eWPn0XQIjTD48F77AFsEp+hKSGlrPEz+iPiO41uTA1QgpxuTl982P8m5ku/NUQGrDXeJjgj2dCbEAWlk/wmawVvmUwwPce6ohLiadnTNBEkxu/07q+pPAJcMdgIw67sg+SF3sZkLxjYgxUT2nnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443793; c=relaxed/simple;
	bh=Pbs2C6A7I1NCHdDRv8bI/OT0Oe24i5iyzFuCCSb6d8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iq5rM+udNRY0A+cRlJOG0NA1w2VX/KKUJFGNsPsC0MZh2mUKFHzX/dsrmCnhfvkj88djgRgvQh7vHGH+17a8SF7keJXaDLw2S6qewBdSzh1KUV2lAAXGWWCmMm5PtnMMmRzPx8tnZwRmxqpjcM+2iUO7mF8unK1bV7qowoARqh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NQEq/IvL; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NQEq/IvL"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gvnc00h0Xzlfl5d;
	Tue,  7 Jul 2026 17:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783443788; x=1786035789; bh=fVKyVlK3NGblRWmZxYmQOop4
	Kttaef5EopO+szduHLU=; b=NQEq/IvL51F6COxXMNUIiEopWCoK02GQOGRAf1I1
	zXrJOh7MgVMPvL9vgO5nl+Wz2RfyHsx846ymGAa5sHBpvJ/1GvfkpauRe7eSm0OQ
	kcv+8TdOf/LGIF3Q8vZUt+NgYB4YDFUH1iY5m6TUr4sXaGmElz90+6gfkE75P7Lq
	x/MPp4u2eXHonmInq1ozNn0P6SUizRnU25/547Rn/jBMMQ+Vk0iF7sTfThJqnW+q
	HmRyP0IynE7IPPYMfmCZfMQTBReTsvFX8xrwJ+9zPkhqy8tz8dznVLxK0a7pQLWe
	+VhVKXNHtAUpzyFiJ6420IVKfwKUDOgFqbOR2M24sn8wLA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QdDwKIRwCTBH; Tue,  7 Jul 2026 17:03:08 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gvnbt53w0zlh2ry;
	Tue,  7 Jul 2026 17:03:06 +0000 (UTC)
Message-ID: <0b8c93ca-1160-4052-a297-f6772969c111@acm.org>
Date: Tue, 7 Jul 2026 10:03:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sg: report request-table problems when any
 status is set
To: raoxu <raoxu@uniontech.com>, dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <54B60C19F7DB8889+20260707030845.970018-1-raoxu@uniontech.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <54B60C19F7DB8889+20260707030845.970018-1-raoxu@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/6/26 8:08 PM, raoxu wrote:
> SG_GET_REQUEST_TABLE reports per-request diagnostic state through
> sg_req_info::problem. The field is meant to indicate whether there is
> an error to report for a completed request.
> 
> sg_fill_request_table() currently combines masked_status, host_status
> and driver_status with bitwise AND. This only reports a problem when all
> three status fields are non-zero at the same time. A normal target check
> condition, for example, has masked_status set while host_status and
> driver_status may both be zero, so the request is incorrectly reported
> as clean.
> 
> Use the same condition as sg_new_read(), which sets SG_INFO_CHECK when
> any of the three status fields is non-zero.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
