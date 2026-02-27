Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6D43D34AF;
	Fri, 27 Feb 2026 21:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772229001; cv=none; b=KUD/VFcZCC1QEj4mA9U0ACMS6xHRR6CHcHOL88GZieIKsyhpoXDCXXQqQQARWaDSWduYsX0objpAmPu+Kdb7drF69fWmDlf09NOO2E/EOBDxACdZwK7EIE7fWJcT8fr4B4xT5e53WBQQIiLLGba7KI8ZuZMnN1hkYArGzUVFjM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772229001; c=relaxed/simple;
	bh=MZBWVEAAH0e19mX8ecCD+vQcMpNSFroEruUcw0AwCEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=btiSBIn73zYCHebCZ38AaQHfZUiJWGLm/aob9mO6jfeUHrhp+DDW4hj6ZeCzki8ou2M3fRZTfcTx9GOy2NreTLElsptDdnHCTggciX+sdzpqP9eODDmyxbyYv8OHpy+q5piU2aZNGrHZ1MThSPQ9cYkpUWDiL8Tp7bYlIf5wccE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3zknfz5N; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3zknfz5N"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fN26v35F5z1XM5kD;
	Fri, 27 Feb 2026 21:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772228996; x=1774820997; bh=Jt/nVw2FAiyqMKdxaixuhKXq
	ohkxeefzKIT3VaXBkkI=; b=3zknfz5NLokxsGj4NNgEyR6rmtBnsv1IcqJZSzss
	uIcCSl0OXkawxrBiaYI+SWtfp8LzeLgRt4g0TCZDv6khJEbDW7szIlof1wP0AErQ
	ppy+j18o/1BoWWw+Lf6ofC8TfDzNFnR+Lf3WpoIASPjh0D8VLO3VCDESEpZ6Jt3p
	T2hUWkRZpM5Xyx9VyXIsyk3SQTwq95xmpjqIUpQB7P1mq+9YMMRr76YwWW4S/fkv
	g7ErzdXqAL50eb+j5h4j80ZLAZy+zTn1iV4mtVGsChQM50MwDJWxRXb1ytZVM0Ht
	GYzBTWWtgTBWhPwKuptHbrSPdjv0RTo3ESpuKZ7nsNrF+g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oesnZBtptJgo; Fri, 27 Feb 2026 21:49:56 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fN26p218vz1XM5jn;
	Fri, 27 Feb 2026 21:49:53 +0000 (UTC)
Message-ID: <3d5a65c9-c5ae-4547-a55c-f7554df62553@acm.org>
Date: Fri, 27 Feb 2026 13:49:53 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] scsi: ufs: core: Add debugfs entries for TX
 Equalization params
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-6-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260227160809.2620598-6-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/26 8:08 AM, Can Guo wrote:
> @@ -230,6 +427,15 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
>   			    hba, &ee_usr_mask_fops);
>   	debugfs_create_u32("exception_event_rate_limit_ms", 0600, hba->debugfs_root,
>   			   &hba->debugfs_ee_rate_limit_ms);
> +
> +	if (!(hba->caps & UFSHCD_CAP_TX_EQUALIZATION))
> +		return;
> +	hba->debugfs_tx_eq_gear = UFS_HS_GEAR_MAX - 1;
> +	debugfs_create_file("tx_eq_gear_sel", 0600, hba->debugfs_root, hba,
> +			    &tx_eq_gear_fops);
> +	for (attr = ufs_tx_eq_attrs; attr->name; attr++)
> +		debugfs_create_file(attr->name, attr->mode, root, (void *)attr,
> +				    attr->fops);
>   }

So the 'tx_eq_gear_sel` is an attribute that controls what output is 
shown in the other debugfs attributes? I don't think that is acceptable.
Please make sure that there is one set of debugfs attributes for every
valid 'gear' value, e.g. by creating one directory per gear.

Thanks,

Bart.
