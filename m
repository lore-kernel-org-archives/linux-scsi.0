Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E10273D66
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 21:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207301; cv=none; b=J5MbKWP2QCGpg27pCtVmdwhEgTp3hsVIRhQIgaqDCTzdaS/9ew4Bb5lpssxIGzEO2mmGp/jcVU2XprEGX5RVi9nuh4vLNPJ+T9OuYu68M3AUPYCYlgC3KF49/t/EaVQ2R0uBJp62Q2ASgj9/Yj0xcn6ihqWHIthOZyz8E3ep1bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207301; c=relaxed/simple;
	bh=2dcVWaNT+dxNoD/daGn6dmXNNyU+KzplxRkXlkuy6XI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YdJaRf8m+EGFtv9+rUCGIcZhm7vFr/vy4MDvBeXzOE4i6af/alj5byXYpg2FJGnuQtrM8J5zFpVXaOJaLlYzxto5WO4YoYmRwYLfsHW7psbTpxBPh0kl9DoFDsF+RAHvl2R/on4iucYNhfZzD++zD47lyhUPqtZ0xmyKTb3sWYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DV9K8qh8; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DV9K8qh8"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c2z6W0RWCzlvWj8;
	Thu, 14 Aug 2025 21:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755207297; x=1757799298; bh=PldC1Jmj6JtkdCevoXA/tjqd
	P4GLadg7JnZzTX/8GCk=; b=DV9K8qh8OqLVfMDtaPShATvjUHpMzmqukRaHQkSt
	KEE84M6kTYnhAFK/rUQBY+qhK26FO6qdZUgO5nsp9axKWo3IK5HnJyQIMVEgCOy3
	MauzrHCSpfVzm6ipimw7vKItxTYln0y7Kc1J+tGD5xj+BsYpuHjEvbttG6dwnle9
	XDFWcHhd6tTwqR4NcQGi0XOmgok7txaHoKbp2QZouO1jLBVb03r8r5Un9GWaUq84
	Iv7rUkoE0TTzYMVslPYhZFDJRPQq1dkMiVCFJhvIEft3paahs8qQwtrEiZnk60w2
	c70oeXvi6jKVwlPmhiMKdzz7XYKerkTDDrMXbvTFemZmfw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id at7tELJSM3zT; Thu, 14 Aug 2025 21:34:57 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c2z6R0CkNzlgqyM;
	Thu, 14 Aug 2025 21:34:54 +0000 (UTC)
Message-ID: <37c61d03-408d-46aa-acfe-8523d488e755@acm.org>
Date: Thu, 14 Aug 2025 14:34:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] scsi: sd: Avoid passing potentially uninitialized
 "sense_valid" to read_capacity_error()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-6-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250814182907.1501213-6-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> read_capacity_10() sets "sense_valid" in a different conditional statement prior to
> calling read_capacity_error(), and does not use this value otherwise.  Move the call
> to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
> from read_capacity_16() and read_capacity_10().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
