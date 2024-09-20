Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EFA14F98;
	Fri, 20 Sep 2024 19:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726861117; cv=none; b=cAXNIHKrTNUq2idV/8FDJ3Rdgv2dWEgUxCM4G+E00+y9i+ZEK7SPJssjp4r9VFhjzSP2MddkbAxa5UoBFsg2Ea/xH1/50ukkg9hgXa93EFCFV8lc1MMq1a16KiPHfseNXEGd5xAkG+dfgkoVo0ltKD32RPM7q4Ge3usls/Fs2Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726861117; c=relaxed/simple;
	bh=k3aDTGVYK03uiMpHJNkfIDhuqzXCMlDtP8vJvbeZcSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qQLgyjS5wY2/NhzHr0DUCOr4cQCSSWDgilkf5P4uGrxjzuLAO+klysR/b4JeI+ykpQl56VxgxmwFzoUlcCPNhzPK3cKHqdf5nQ6MtB8dr/p6DnVn9WCSKp8+thqJHeYLvhH//uoGPO6ZdDJBGOpA1pFJfyvNT4T3UrIwMiFNAuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YS+2hZK+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YS+2hZK+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X9N3b0wmtzlgMVY;
	Fri, 20 Sep 2024 19:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726861113; x=1729453114; bh=k3aDTGVYK03uiMpHJNkfIDhu
	qzXCMlDtP8vJvbeZcSw=; b=YS+2hZK+SeOdwDRfHxsCOpUxFWQ9mHYvrKTR0lW2
	X0TgyEAJlsN/HJAr5g/0vuHR4ke1i/CgtLtWpsx90KN4fhUJ7dmEbUoHo6uBsXWW
	OnOjnivcQpgGNgwPqgnYBzF5lgBtoVd3W0cXM3yL/PYHZD9F+uZFYH6b08dYUBLv
	YPmHp8FOOrlOQzxwrF/GC96ENtBdm6WkvDq7FYjw6haGRdd4W4mhopmWMljPbCMV
	093F4Ljh3c+OUoSB+yAAH5kG3p5K3YZGmgew5XkQTU/qqGK9Izr/8erYDomtpjLp
	ZhTQ6vJZrfF+1KFQX1+AA9c3nYu1ON9FA6tm0tXZLIS8mQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ztG2lnDV2pDJ; Fri, 20 Sep 2024 19:38:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X9N3Y4F0qzlgMVV;
	Fri, 20 Sep 2024 19:38:33 +0000 (UTC)
Message-ID: <7dbb4ea6-0a66-47d5-a255-a35d6a0db4e1@acm.org>
Date: Fri, 20 Sep 2024 12:38:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Do not open code read_poll_timeout
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240919112442.48491-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240919112442.48491-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/19/24 4:24 AM, Avri Altman wrote:
> ufshcd_wait_for_register practically does just that - replace with
> read_poll_timeout.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
