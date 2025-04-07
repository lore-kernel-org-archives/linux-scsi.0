Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AB326AEC
	for <linux-scsi@vger.kernel.org>; Mon,  7 Apr 2025 16:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744045169; cv=none; b=Qd7MMwQbLM++8F1hi9Zj2Ytlzm2Az2g5vgHh7m1vJlZKfn+QwEeAoCh8y8GNR4BSjEOUmQAYtR6Ma2c2cNx0oEbUoZ/ak/vMlyIs2smQmzfb4pnxBgEZwT+2Yzkmjl9aX1LNJGdDgIbyp0ce8t5cl6G/hlo8VXjMX2has+3aSfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744045169; c=relaxed/simple;
	bh=rSalkazrhEvGJKsjdKX4wFA+OHmIHL/EzHzgzkHMrIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDwrYDYCSUDyl/NFR0ykYPHNrsJB6WnisJIgRlQe2Qwu7Mr2yf6idRPGpAGmHdzhGdKtIhzVg2lqw4Kc8G/hEdhrGA2F60N/u7adQW05ZeJvvZKmoki4dszxd5pzUltK80ZqMcVSavf3c7FXox3+7Zex7++ChglWIaF3N7FDYik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yToq1TGY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yToq1TGY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZWb612W31zlvyBJ;
	Mon,  7 Apr 2025 16:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744045160; x=1746637161; bh=rSalkazrhEvGJKsjdKX4wFA+
	OHmIHL/EzHzgzkHMrIo=; b=yToq1TGYgD9h1sozuOafTDte9S3XJjQiuKfJeRmT
	mXPgF5IwyriZo7cCcfVCMIGWDkc8kQglpq7thuXlM/x9RgPOL03ayynSiRlVmMG4
	XjbMR0+X6zWpYfsWapVdj5j06Psf2gv41iV5azELJNX6RKiqQu1VOjANr1zobAzz
	QJ9SOYhj/FFhZnBeihXT+GwOs3qe4HvSSvuCL/s5zPiHI/KyGql2bHwwN6T8z21j
	NVdXNXGKjSrweBWzB4IrfUUJl8BBkBilqPWhCESIzhfytuEPIre6TOjBYC9LBrDh
	FM5Dtg087qp1VQJd6kKM0gk6fM1Qtm/1v0bkLNXOy4Svgw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G7C8oP5qtzTC; Mon,  7 Apr 2025 16:59:20 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZWb5y5Nmzzlwf7m;
	Mon,  7 Apr 2025 16:59:17 +0000 (UTC)
Message-ID: <1c08cc57-60dc-4efc-870d-6b9688c85b2d@acm.org>
Date: Mon, 7 Apr 2025 09:59:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250314225206.1487838-1-bvanassche@acm.org>
 <yq1cyeb9pjp.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1cyeb9pjp.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 5:48 PM, Martin K. Petersen wrote:
> Applied to 6.15/scsi-staging, thanks!

Hi Martin,

Has a pull request already been sent to Linus for the changes on the
6.15/scsi-staging branch?

Thanks,

Bart.


