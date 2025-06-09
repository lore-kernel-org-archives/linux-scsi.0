Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2541DF25A;
	Mon,  9 Jun 2025 23:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749513393; cv=none; b=A23n2MkTDnVBxRFO0V8WTy1p+Ub8xysxqyynTBHp+Ne9jKDlz3bST9DDlTr4rVRiK6aAhg6YZpQccON0h9A0dKpc7bjXhAPX2xARHaW4c2GP+A60NEk1myXSEBHu+4UY04XldGdfCC7NJTf/s7+dYyKm/A4Am/MKewbCfXhIjrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749513393; c=relaxed/simple;
	bh=KSjEolPVe5dvnnsbVZqlsdVH46zQi+4/hbX6+f8Dy+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K52DaSEW0utQV2KOZ11kqOigrPcF5uimU5SxQD6C8rMEh+aBgEb0mSjdYonHSPQbzksyZDeF577xFeC28pMKH3Q0Ae3DufzWcZ/2pBlk3A5EKSWrQm4tdjPErWoPBQYElNYxnbfvq9KsrL4sS+odGwLy/ZYNFIVCYWcXlYIRims=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=K472MJD9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="K472MJD9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bGTN83r7FzlgqyR;
	Mon,  9 Jun 2025 23:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749513383; x=1752105384; bh=KYCXaUY9ndNL8OgV5qFsqIP2
	lhBk9b/78jW3INTU7XQ=; b=K472MJD9q6eQSV2yMg5Xkz/cxsGKzy9818VA8ASW
	OPqsYuNIJrMvNZsufihh6HXt1+27cX8Jn7yFTyx/VekkaK3kIhjSNzcdDXUgImyT
	y57foXKClO4b+6kbx/11N/63gf/ItxAIjlyjByzRoK+FhX4mAAw6+TzaB1nuTta3
	JM011xICvezk77plh64/SLIUjsnXfrRWqUyTLj6Oe8vXWhpFPoKy+lygxtCRJ9Lz
	YOB+JVNnq3dBJkTSduG1laiCT5Rn5+4dIxF5vnxtkxX5fFpMAlETtGx/UbBff6x9
	bnD+yjVtOByPO9iLfBZe0ZLm8XZJWQ3ioW61iJQoIs3mIQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lOStajVoL0oe; Mon,  9 Jun 2025 23:56:23 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bGTN32MHnzlgqyD;
	Mon,  9 Jun 2025 23:56:18 +0000 (UTC)
Message-ID: <7cfda015-75df-4ac9-897a-41cfc6338046@acm.org>
Date: Mon, 9 Jun 2025 16:56:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_devinfo: remove redundant 'found'
To: mrigendrachaubey <mrigendra.chaubey@gmail.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250531054638.46256-1-mrigendra.chaubey@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250531054638.46256-1-mrigendra.chaubey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 10:46 PM, mrigendrachaubey wrote:
> +	list_for_each_entry(devinfo_table, &scsi_dev_info_list, node) {
> +		if (devinfo_table->key == key)
> +			return devinfo_table;
> +	}

The braces around the loop body are not necessary. Please remove these.

Thanks,

Bart.
