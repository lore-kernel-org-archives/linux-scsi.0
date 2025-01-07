Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAA01FA17C
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 21:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736285465; cv=none; b=sl56Spw7IJ8+t4VpTfxvtDSmdRgSQ8ph/R3otSK/L8MoD6x/B17Nuj8nFwJeClmbmXs8YLnwg2HX5Qj8bWy//RlZAD1sGRS95OESl/JOqZ9UfOHuRM+mbYsPwq1MtLWlxVIkQgB6uk0JPbLX8WKiDLWJ0/M+Gxr7N0NKsf/E0BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736285465; c=relaxed/simple;
	bh=asV99X01VT+fqwybXvlYtG+KQv57jRV6gB1rjcprmV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a5hHk5VW60fZydIwLfLwtusJ5uWEN6JbdPbK3ggN5qF+dnSa+mbY2B1nC8U4d2DAtU8BJcnfiv++kEhEvAOpgJhyB+ItaDSERK7TskI1tZm836pHHhd9+foDx3tpJnm63WVb09qg8qe6ree3ZKMHFVlmh+0yMdYamAyGbhNbjXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V/AMbNnE; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V/AMbNnE"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YSPNt6RJJz6CmM6f;
	Tue,  7 Jan 2025 21:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1736285452; x=1738877453; bh=cgInRU3rgtdsPZDHhaW4PJ2A
	127chJObWrNgd+HIeyU=; b=V/AMbNnEFeweRXz/pvlXBoC50YJxigqXYjRCtvic
	T14jF6v6N5Ldpq9eTvbZx+Phl/EdBYcP+DnWxvWTwK+OTEGFZSFlQPmKfDeDCEoP
	TPKOs2WUo97p3Elvgp7s+QuhnnWhEf+KLyn6gAwcfzVrrOBbeE0z0tP5RKfardlo
	IcpLzQaOxsbGcA6hta+CTAQv/kONbpR6BXZDnB/arUSVLIjbGIs9ZIkSEzl+qwOJ
	1fMgI4V9eETyzWKjx6H71hYD3AVhdxPLWcHsnMmmzVR/fpJRs3ome7A4sv/nzEq8
	PcJDustd7gYJEIcxszJGVVRyT79GfAZzgJ6FRnvC+D2iGg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b23Euf-AKxCi; Tue,  7 Jan 2025 21:30:52 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YSPNp5hWpz6CmM6c;
	Tue,  7 Jan 2025 21:30:50 +0000 (UTC)
Message-ID: <2713950e-61ae-48bc-980c-23476cc2a613@acm.org>
Date: Tue, 7 Jan 2025 13:30:48 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: Fix command pass through retry regression
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc: Kris Karas <bugs-a21@moonlit-rail.com>
References: <20250107010220.7215-1-michael.christie@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250107010220.7215-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 5:02 PM, Mike Christie wrote:
> scsi_check_passthrough is always called, but it doesn't check for if a
> command completed successfully. As a result, if a command was successful
> and the caller used SCMD_FAILURE_RESULT_ANY to indicate what failures it
> wanted to retry, we will end up retrying the command. This will cause
> delays during device discovery because of the command being sent multiple
> times. For some USB devices it can also cause the wrong device size to be
> used.
> 
> This patch adds a check for if the command was successful. If it is we
> return immediately instead of trying to match a failure.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
