Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E7E169AE6;
	Mon, 17 Mar 2025 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742250784; cv=none; b=DKhGafQV1bq0PbiD5CdcVNUf8daN1ZfoWD2bwujlnfTuKJwGawPHJV7cRbvrFLuxg8hZtkhdhBa+pkNW2nvrkwcf7HmtD0UoAUI8BgFNAdRuV4j+Il86QcS9kwpIg4j9eWlxnEKVauXtsZsxi5JWyDNQ20BSzaNMXQlVY53g7vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742250784; c=relaxed/simple;
	bh=x2Jp6BA79XnSr568cFnJDlm0j4jkbXIbU7ZSskA8SgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImUlTUIpOs5wCRX2yJlTLIeclnOABCzSf9ItzuTuGCaCsSdVEq5ruDC7qNWCyGYRQpfd2myIO4RP/ORIuoiUP1jY5yYQ8tPFQ7ZKAjLaNbmK1vwaI9381gCdNcKktVmDehZHjckjQ+EoWnMahfb06fLLcxxiQUi6YfWWX8c15sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0hH1PUp6; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0hH1PUp6"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZGqVj0pK6zm0pKK;
	Mon, 17 Mar 2025 22:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742250779; x=1744842780; bh=x2Jp6BA79XnSr568cFnJDlm0
	j4jkbXIbU7ZSskA8SgI=; b=0hH1PUp6/iU9GbBX88mYABOt2ViHhVdL7SRPrz/C
	H69nEgpsvkA//eDLtUlQFlyjuGo0mW0tHIB71pYrrWunf8YCP91h078REiVGo18b
	nvCGKtmbZlizUlaPN4psyIUHGPxT8Qty9LjEgXihT/2DKC42gycmkchlmH0cF/f+
	b0EpBbM9btLq3u144UuFoW14P1TZ3xRjYva97mnd2Vtf0JoISStlLwLGdJpleyVD
	BVmywHhOb3j0Nm1KoFvYRjmCZ1qyj9nCoezhsarr8qNh3UzykUh34hUI3NnqPOOk
	4sIDhhK/SE3SCycqLIa8LDwQDFqlOvNdj/LA08EjBvNing==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3tZXuy2qahQw; Mon, 17 Mar 2025 22:32:59 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZGqVY5DlNzm0jvG;
	Mon, 17 Mar 2025 22:32:52 +0000 (UTC)
Message-ID: <048d2f33-2697-4ede-9814-d8e9f3aeb732@acm.org>
Date: Mon, 17 Mar 2025 15:32:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: crypto: add host_sem lock in ufshcd_program_key
To: ZhangHui <zhanghui31@xiaomi.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: ebiggers@google.co, peter.griffin@linaro.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250317110101.347636-1-zhanghui31@xiaomi.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250317110101.347636-1-zhanghui31@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 4:01 AM, ZhangHui wrote:
> On Android devices, we found that there is a probability that
> the ufs has been shut down but the thread is still deleting the
> key, which will cause the bus error.

How does this patch guarantee that crypto keys are evicted before the
UFS driver has been shut down? This should be explained in detail in the
patch description.

> Let's fixed this issue by adding a lock in program_key flow.

There are multiple synchronization objects owned by the UFS driver. Why
'host_sem' and not any other synchronization object?

Thanks,

Bart.
