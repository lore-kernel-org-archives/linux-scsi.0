Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7FB349CC2
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694246; cv=none; b=VBaM1UQuya6qXOqBqnU5KT+32dWjAHqXzuExIO+VUuCRQ3nxlPU/faLjWWrEDOTj1gvoVbauoFFdl2BWuTUuaZY6ojN11VTzHG1NlVCa3UXiQNJ8/SCGqMMPo6639WTLAh2dmLFIKGMm/zqFkwXSgdQ5cuvhhgdHZ8C177Mp30o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694246; c=relaxed/simple;
	bh=YdiRV9OZD2/cW1IigQUj9kZwi9NL4a+BOChZpzYEajA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AqyNniyutQzGfkQfUf3jBn/+BECdfUpNsWG4VXrx53kONaN8eOFz/Q9srLH9b8j1aeACWErpN3IYJqvLUWoB85DzC9RMbqATiEV+dsb4B3TksWILlWBR4KCn2WwNMNxAbtQizgAUGbrMM1gvnk0iUf+1Ff2+VxXHlR6HEofRLuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ctyfqVxb; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ctyfqVxb"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gxZDN5cPTz1XM2FS;
	Fri, 10 Jul 2026 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783694243; x=1786286244; bh=YdiRV9OZD2/cW1IigQUj9kZw
	i9NL4a+BOChZpzYEajA=; b=ctyfqVxbzkLc1/vHypgsaGYtQIssqRw2M6ZRtkzC
	0mYDFPJOsCQIOn1Ubu5CV5YdlPFwUwA8ofUhldjr+k0OV3eCtzbfpZL5f+jCxonf
	yrJiow9kX/xGe9jmmELqBGkcOYG7D+Cpn/9cevstzdXawFS32jQFpX+8UKK//r0f
	PDbiBCPdaD5QgNWZjE02L9Pk5nXlBueklIJrAt3Fjw1CNkzjFSn4RjlR4ja+tGcH
	eNIHtIhJPDkRgwAHRi9MJ/Ub17XNt4CBGNCGZad7aVZ5oDT+5NxVb2CL9q+jISb7
	QFTnUVgZ2GoydGHfFpRdXAxlgECuA3j9HONsH/X6dlJe5w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vY_jXKAvSEhZ; Fri, 10 Jul 2026 14:37:23 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gxZDK4pBsz1XM5kW;
	Fri, 10 Jul 2026 14:37:21 +0000 (UTC)
Message-ID: <512639c6-3f18-4577-bc4f-7aa8b7e1caf4@acm.org>
Date: Fri, 10 Jul 2026 07:37:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: scsi_debug: fix REPORT ZONES alloc_len underflow
 OOB write
To: sashiko-reviews@lists.linux.dev, Ibrahim Hashimov <security@auditcode.ai>
Cc: linux-scsi@vger.kernel.org
References: <1357dbf9-e135-4ba3-896d-1472a208f82f@kernel.org>
 <20260710055755.53830-1-security@auditcode.ai>
 <20260710060543.621591F000E9@smtp.kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260710060543.621591F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/26 11:05 PM, sashiko-bot@kernel.org wrote:
> On 32-bit platforms, kzalloc() takes a 32-bit size_t, which silently
> truncates 0x100000000 to 0. Calling kzalloc(0) returns ZERO_SIZE_PTR, which
> bypasses the (!arr) NULL check.

Ibrahim, do you plan to address this finding?

Thanks,

Bart.
