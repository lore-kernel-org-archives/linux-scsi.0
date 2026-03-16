Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8DE339878;
	Mon, 16 Mar 2026 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773681774; cv=none; b=KGuE+rSww/J8pXi3+KguTZFh9xf9MrIqKhjXQReEiPuKfV9pmDn6fwze+eMJKexpyXRSRwDr9vjaTn9BdYQt5IUOzauyZWXMub5TaDAbikyVsg78YDAfw69nMJ+LtsFGBMRBjf9Yn0STQcymJ7oZ/kuCv586PoEbLoWvPlQERSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773681774; c=relaxed/simple;
	bh=VRKoM2hVCNLFlFWJJGNxYsPPFqjItCeCk2ANqtacNiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C+77+Iw2+9vJDuQSDEuQyaDOLy5txK5GeXz9+qal4DDo+x9AP3x2ANnZgAQTU0PokCwxNjVm8QYOIRVz3GUd75EpphG4TC7Pe1MuSimdqcwZMZ8NwawBmdFwR/exdfsFcyANcB432hvnJpx3kJoRgday/DQ3mI/sKbHFcZ6USMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y4GuM/g9; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y4GuM/g9"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fZMNr2ZPzzlh1Sw;
	Mon, 16 Mar 2026 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773681769; x=1776273770; bh=VRKoM2hVCNLFlFWJJGNxYsPP
	FqjItCeCk2ANqtacNiQ=; b=y4GuM/g9ZnlZuAseCxlcOciwNz+QW6BC4ntlphsj
	OzjApnud4On/cufcsECPL7M1IA3CHokSLf08HzpTpw5v7idNKIdcbOBDKpUoC56Q
	/50QvRCRr1MOxfSyaNJjoQ9nJ9QxqgLlBeVNWqUNrJCV77xZa/IfKiWraO/WlTQv
	Qq+UZtV4Bv9smN3k0WhkAFXjWT/mn7Z/ZUdq7ztsW4aGi0r7punv0V7XYzEGLU7v
	BzezSh9Oe9m1gCE1VkwZM1/2AaL/naO29NnTzztv+1giiUZp9ada5VQ5AqX20hn+
	XKMJbZX8DRtNb1QgiAK8AwP2BCtw+LTvEJwqkz9eUqTllg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FjXqnV1tnm6o; Mon, 16 Mar 2026 17:22:49 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fZMNl3KS5zlh1Rs;
	Mon, 16 Mar 2026 17:22:47 +0000 (UTC)
Message-ID: <6103e5cd-12e2-4527-8aee-985c2a75f255@acm.org>
Date: Mon, 16 Mar 2026 10:22:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Fix the maximum channel scanning issue
To: Yihang Li <liyihang9@huawei.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, ranjan.kumar@broadcom.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuyonglong@huawei.com, linuxarm@huawei.com
References: <20260313023057.4151105-1-liyihang9@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260313023057.4151105-1-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 7:30 PM, Yihang Li wrote:
> Fix and support specifying the scan shost->max_channel for scanning.

A more specific prefix than "scsi:" should be used for SAS patches. In
the kernel log I found the following examples:
* scsi: transport: sas:
* scsi: scsi_transport_sas:

I'm not sure what prefix is preferred.

Thanks,

Bart.
