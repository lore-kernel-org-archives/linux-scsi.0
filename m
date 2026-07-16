Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F1B441635;
	Thu, 16 Jul 2026 17:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784224036; cv=none; b=dqiCMRZ+/qrvw00003tQ+rNBx6zfZ2RDgl7JuW1ZEFzAirMwlIIytTCBwyKsUrCb+yp+E8yO8dEJ8xwYNdHpcl0tTUkpnFJtNXB4ta5Y3abeklXGe7dA3f87MCPO1kYaFS+PKglt5sHvM+ij/yGUhuLUMqwHDzwAoET2C2jcrNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784224036; c=relaxed/simple;
	bh=DF0g2HEo1MqvpBtF4+epT+72u3A+eZGJhDQgzTur4kM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0n3Rxxyr/BKyBkDJ92ezNYgyY7iQv9ftIWkx80e5X6EtuHeXP/2LFC+GGVflxTU5qx0laB6Rqo62BnVJDyT7tbly5Ym48kwNHyr0vEMJ6acYa/JrJoqpOD93CVsWu2rcRlMjSC3RG/CkfdxcU6uqi+YNTyL6IGnpkngdCjg5hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DF9Tj430; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DF9Tj430"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h1L8f2FnMz1XM6Jm;
	Thu, 16 Jul 2026 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784224027; x=1786816028; bh=xdWKFjyOYmBTRePMAe/MxuyN
	Zcks0Z5o3/Ym7/KErSQ=; b=DF9Tj430E4gCQ99m26XTsKB1uGGWvi8l8BhMubuB
	m3rWYg2/2o7K27eNoAv3OoePgoGyAaDEPWKQPYou60Bj497KlmOrTRkXcwVRXhnR
	iMKpb4oKvtUi5b9F2y5hEV/vZ1YBWH+OYvQbyICB3O/RGJoVy4CJp5Qhxg897so/
	zoI84aEY5k+3DNrTr78ZhhD/K8HZoGQOvLSIkjmnhN8s0zzcMuPRlGnYdWk+CsoH
	qOtRls3kM6LfLwVDZNk+TN4Hmc9wKXW8mtwg7HwnGz9o0HZzQ0fXLCAN+FCM8yON
	NddV1a8dYmbTKFGtTB/gOtX4lc5G2WVbQdrs9fF2RJ6EYg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bVx_uBGR5R5d; Thu, 16 Jul 2026 17:47:07 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h1L8R6B5zz1XM5jn;
	Thu, 16 Jul 2026 17:47:03 +0000 (UTC)
Message-ID: <3e7ab1d2-4a38-4bb9-860d-17eb0ac65cc7@acm.org>
Date: Thu, 16 Jul 2026 10:47:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] scsi: ufs: core: Validate string descriptors
To: liqiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <c68b23bd15e3ff570e95afb5422bc242efd038df.1784182493.git.liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c68b23bd15e3ff570e95afb5422bc242efd038df.1784182493.git.liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/26 11:19 PM, liqiang wrote:
> @@ -3916,11 +3924,17 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index, u8 **buf, enum u
>   		str[ret++] = '\0';
>   
>   	} else {
> -		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);
> +		/*
> +		 * Keep the bLength-sized raw output for the RPMB device ID ABI.
> +		 * The two bytes beyond the UTF-16 payload are explicitly zeroed
> +		 * instead of being read past the descriptor buffer.
> +		 */
> +		str = kzalloc(uc_str->len, GFP_KERNEL);
>   		if (!str) {
>   			ret = -ENOMEM;
>   			goto out;
>   		}
> +		memcpy(str, uc_str->uc, uc_len);
>   		ret = uc_str->len;
>   	}

The above code can be simplified by using kasprintf(GFP_KERNEL, "%.*s",
...), isn't it?

Thanks,

Bart.
