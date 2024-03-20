Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E48540866;
	Wed, 20 Mar 2024 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946964; cv=none; b=RlZyJ1+gLA7H1QBKn0Txc3mTOnoupjcg7qD3ay+RMvJXUlsHjcJIeLKefO1n0wwmQqGggYyZW7Zxoa7pZN1J1aGjYe07wgmbVy6n+MYw9L+qKxYNnvp9gfY+jaqy37rcDc9xw6Nh815Leg446Eh5b+g1I9rzKjg8ooWfKK43ago=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946964; c=relaxed/simple;
	bh=6FsNZvBqbDhmAEvPwqQlJAURMDxOT70+vrD2rWGm5PY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d5+Fo7oJ/gJHgZMWIZ3rHxOSzzIHEXE5X+PPLVdHNqPzbl9sy2c1ZeG0I3/fVDnP525eoDoXJM8qyKvJ0ML8cN9tmmRYLk7zw9sZeGeetmC+LzEEozCqTx+Yp2tzQUHl5XC5H9dG7R7zrPFzB8jsPZr0nUCSI1C0fJiQkhdc+Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=khXcSScN; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="khXcSScN"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V0Bf52YHRz6Cnk8y;
	Wed, 20 Mar 2024 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710946954; x=1713538955; bh=I/RsDzP1lcazugLbmfUU+XUL
	ysauzAEbPNvq73ZKKMg=; b=khXcSScN/+WF978id2jh5imim+jSLvz5thbG0upA
	D97ilSLTT+fmF/Ikmcj8pf9kwUZApgtQ9+bpvUn+e4LZ5GQFQaGWsH47YWWjws78
	FeWtLMuWB2NwwCwjAfB9dJyj7CJJZRFRwMKtMTCsxvJVhnjpOHJcsNvEPLp7Lwih
	uIlM19ZOq4MEuYbG4gVYik5CNapsb7WkiUFZNajH15+0LsQRX7ptUNyfLoJwZmDw
	HzdnFBxoN2EFrntcxa+I1I+EhRpUdn4VAGx2KKeanWAGT/u2phfxL7nIYml4s7jT
	7eHg2E6gsEU1KuD5+lfq8wtjnmT7w0XJlVuIe2HalGr3WA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b9t_VBaYbN15; Wed, 20 Mar 2024 15:02:34 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V0Bf21rv8z6Cnk8s;
	Wed, 20 Mar 2024 15:02:33 +0000 (UTC)
Message-ID: <8b8e5aca-4b97-4662-9ae0-fc36db2436b4@acm.org>
Date: Wed, 20 Mar 2024 08:02:32 -0700
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
> sg_remove_sfp_usercontext() must not use sg_device_destroy() after
> calling scsi_device_put().
> 
> sg_device_destroy() is accessing the parent scsi device request_queue.
> Which will already be set to NULL when the preceding call to
> scsi_device_put() removed the last reference to the parent scsi device.
> 
> The resulting NULL pointer exception will then crash the kernel.
> 
> Link: https://lore.kernel.org/r/20240305150509.23896-1-Alexander@wetzel-home.de
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
> ---
> Changes compared to V1:
> Reworked the commit message
> 
> Alexander
> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
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
>   

Is it guaranteed that the above kref_put() call is the last kref_put()
call on sdp->d_ref? If not, how about inserting code between the
kref_put() call and the scsi_device_put() call that waits until
sg_device_destroy() has finished?

Thanks,

Bart.
