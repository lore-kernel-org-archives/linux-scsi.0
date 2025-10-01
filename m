Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10976283C93;
	Wed,  1 Oct 2025 19:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759347813; cv=none; b=Ay1PGodTmD9YZkaCP2LpCBSwTzmkgiiN48xli+M/mUbhGjZ+3BQq6ZJB3LmaifqM7Yd6ATKW0YQCDa9gEkBRymZFy7e8ljwP/v8bNrmDddp8iawE7Tg/+HpgzjQf23DmGrD5oMZgKuhc+Y7pIci4gHsorJpyQDirR0mb5DPQ/sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759347813; c=relaxed/simple;
	bh=be3+GIr8n+qVKRBsFtvqGAvLzdWKRQw3g4nKiI4TU48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dD5oLBpk1A77BYln9jJ57oe9C7i+iV3spBWZ1ey5s+ZjR4auHhB30C/FlQclIFEcgis72YEPRyTwN+WLzdvx/c9RW5c8Vl99VbNK0sOcTckLKMGji/FmtP40MlxV+jABU5s2Hst66zQIJA6JdXIyO9B+/rr9ieLg2E+OM9g0jhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JpF34wNW; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JpF34wNW"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ccQMk66cQzm0yPs;
	Wed,  1 Oct 2025 19:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759347808; x=1761939809; bh=+MqMQ4UB5ZzsW/uQoNzbhXI2
	y/YqvAtZJHjg8vOG7qQ=; b=JpF34wNWKUzHKZ/Vp/Dg7UdsFIcDakbKwbURVNL/
	pJrxaQU6vFEdDjFi5jjEL8IGHNeC8hBAf4Rm/INZu2shV0+Crv4tq7zkFzv4dUZ7
	cxppx/pJp52nBpBmHRrRBopnUs19P7G1e5NyLR5cmvtMT/I5nuQ5f08dPQkkrbun
	Ae6Do0y6HZnVvXgazymfbzUwR7lgbhiwZljh3sZ5OAa7M6MtbnA2Vzi4y8GT/cuX
	4po4QZiIzlbotQkGcWVKyYbvbLB+gIQsxL7qn57bHUIICFCBKHZeoNRSW/bxgNCk
	rmRZnMWnbzNYuRWIg8zYhZhz7IRtF0L3yN+Q2o0VuHAg1g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dhISQHHwVx-0; Wed,  1 Oct 2025 19:43:28 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ccQMX0RcVzm0ysd;
	Wed,  1 Oct 2025 19:43:19 +0000 (UTC)
Message-ID: <b6a82f74-f64a-4706-8663-c6a72332fbb2@acm.org>
Date: Wed, 1 Oct 2025 12:43:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] scsi: ufs: core: fix incorrect buffer duplication
 in ufshcd_read_string_desc()
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com,
 jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251001060805.26462-1-beanhuo@iokpp.de>
 <20251001060805.26462-3-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251001060805.26462-3-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 11:08 PM, Bean Huo wrote:
> The function ufshcd_read_string_desc() was duplicating memory starting
> from the beginning of struct uc_string_id, which included the length
> and type fields. As a result, the allocated buffer contained unwanted
> metadata in addition to the string itself.
> 
> The correct behavior is to duplicate only the Unicode character array in
> the structure. Update the code so that only the actual string content is
> copied into the new buffer.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
