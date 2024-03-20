Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5941EB44;
	Wed, 20 Mar 2024 17:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710956791; cv=none; b=ZKSdhhuuf5JCNcln7JEI0Mys7X06CHy/Yu53IjtbrGEXo9YW18drMK40lmtErLO1GkZZ0D8KKd1N6LhHrp7/pFixEGTDJs8kZsQ0Nkat7bGhQtZpPEbL/ZYVLgJ0mzwGE5sfvdD8SEkwQRaSb2Ve/XCRMqCQBmQT3+7nX58m34s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710956791; c=relaxed/simple;
	bh=RAZA3Foj6DmLnOIOfvun84Nk17oaAK0hbw0pG3AqWf4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fr13+r8H/6rx3n9hD4bHO+SVqOONnPs+eNKdXVPGeeJolHg1rCZZS3SCkFiTjYXPh4fcYeCIitH2e3Qjq2zpFax4bEW34AjqSjc5ffzGf/O5FfzRzSozX1YzU1lpxA4N7h2h58ak/HlVWSDMmqVM1Kx8xhdkOAm4MoVQ4KqyRIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XEMRNx2Q; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XEMRNx2Q"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V0GH94x9Wz6Cnk90;
	Wed, 20 Mar 2024 17:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710956788; x=1713548789; bh=+JDungZ0fYbEqkstSUvpjUbP
	66QEue1tb543xoveSDw=; b=XEMRNx2QH8hRi3oTrwYqRdlN5USL1S3U28AN7guU
	Wvx5HovdF3vfZwO1owTtFEUavyDB0ZiqH7A8Bb5W2cb7YdJy56ET0dXvNKkLq0Rh
	xruew2OCre3yN1afaOMzcMgrmwi0GfoOstVM5nYXa3p78OqZ///3dAHU/7HB6dp1
	/cC6FBSpoa2kb7Q8KH3HDNadfWnrm+/bB/eQUgj7e9Ah8DfXzvgJWLSzf2WBiYA7
	Y2lcfDUVDfrU+1E1LMeMjtk5HRUEfATFjRfJpjkJXVPe+2CYCTlH/29s3AIFHKtO
	Iufqiy/nuRj5eX9R01ADUYO0fT0Zxct0e+xRQ9NBQc/YtQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zm6g_JFGHU2O; Wed, 20 Mar 2024 17:46:28 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V0GH71zwqz6Cnk8y;
	Wed, 20 Mar 2024 17:46:26 +0000 (UTC)
Message-ID: <27ffead7-1114-4fe4-8fb6-a0acecf96d53@acm.org>
Date: Wed, 20 Mar 2024 10:46:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sg: Avoid sg device teardown race
Content-Language: en-US
To: Alexander Wetzel <Alexander@wetzel-home.de>, dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
References: <20240318175021.22739-1-Alexander@wetzel-home.de>
 <20240320110809.12901-1-Alexander@wetzel-home.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240320110809.12901-1-Alexander@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 04:08, Alexander Wetzel wrote:
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 86210e4dd0d3..80e0d1981191 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2232,8 +2232,8 @@ sg_remove_sfp_usercontext(struct work_struct *work)
>   			"sg_remove_sfp: sfp=0x%p\n", sfp));
>   	kfree(sfp);
>   
> -	scsi_device_put(sdp->device);
>   	kref_put(&sdp->d_ref, sg_device_destroy);
> +	scsi_device_put(sdp->device);
>   	module_put(THIS_MODULE);
>   }

Since sg_device_destroy() frees struct sg_device and since the
scsi_device_put() call reads from struct sg_device, does this patch
introduce a use-after-free? Has it been tested with KASAN enabled?

Thanks,

Bart.


