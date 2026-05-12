Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1170438758A
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 19:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778615895; cv=none; b=P7AUGeliNDpWQfCFzRSEMvY8ZQSDbX4GUgDL+fL7erE2bLgW/nW7pywEMQMDvVGrnS1UnVjsUNEoGNTAXLHo43UAdzT7S0FdplrPsXCLVVLjGG7qgWOzD8gkAIChrYvpx0HRpFxDAEkTZuzBazrOVJQRyKro8EVv2RCyWJrPdMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778615895; c=relaxed/simple;
	bh=N3N5ilA67KFrNT1T7qr62a5WqRYoGbe0pCV7+4fJiS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=N/Hx0bhLKP/dkS+nAWnVb3CiR4Ktfh63d3R9Im7mVQVES/MmUFJwUPhCMPHrOlgn7v8W+8MmzH/9ozLqEij8a/eNMczxwBHHdhsXjuD7TCncCSr2lMQZvS0hIVKLKlGQeLZFTd31VeE9foImOSvdOBe0rFvIoLxyA2U+KGXZlHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zKdDE0io; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zKdDE0io"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gFS7n06yNz1XM5kD;
	Tue, 12 May 2026 19:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778615890; x=1781207891; bh=N3N5ilA67KFrNT1T7qr62a5W
	qRYoGbe0pCV7+4fJiS8=; b=zKdDE0io63EFvL06AiEvNOsVnBrXdfrFDaKwfZbK
	vVUEwjpSZo9L+IYlrAIIUszVQH4g69OTAd0XaWJezoBKj6rnthlKnFPwkpjhSU9B
	cSqRuxHQVT4JaTLZ6aGXCpTjnpekg3yHAkfVLjh1zrhi/lh1k98vuDSaaP0Vldyl
	coqPacPKZ4UL5QRGQQKo6/d97AZijVgibEWr9+CzR6f8oCQ3ttc2w83Pg9AtNCDk
	K6o3318N6P+HVfMvHFAyKIxkURDD4XIx3M/uK2hV+rQrhmym3iqmQu2F8PvAhbBD
	DSH1hvaiUBWrQkeZ40Sxx12qOFXagddOR+EK0QGk6r1kSA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LuCDPvYJaR3S; Tue, 12 May 2026 19:58:10 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gFS7j5jFpz1XM5jn;
	Tue, 12 May 2026 19:58:09 +0000 (UTC)
Message-ID: <8eb6dbf6-4da7-4a5e-aed2-f9319721b6ee@acm.org>
Date: Tue, 12 May 2026 12:58:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: Fix return code handling in sd_spinup_disk
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
 error27@gmail.com
References: <20260511175317.114007-1-michael.christie@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260511175317.114007-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/26 10:53 AM, Mike Christie wrote:
> As found by smatch-ci scsi_execute_cmd can return negative or positve
> values so we should use a int instead of unsigned int.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
