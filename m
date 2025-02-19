Received: from 001.mia.mailroute.net (001.mia.mailroute.net [199.89.3.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EF1214221;
	Wed, 19 Feb 2025 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739988377; cv=none; b=S5htK2LQrPiYEW+vMI5S7IhHRk9S+xNSZUKwvwUbJeACuLAUVdTV8pX28HyV4xfX/MaGu9I6STUted3AcS9lb4PuNKpkO/0qLm3r7EqkiE1olASCL2DkwuOs2M1n2FIRacZZZkufYh3zzYfPcYR5ifoPobhKB/hsFjEozoSwl8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739988377; c=relaxed/simple;
	bh=31kRgLAZfDVOiQ8N1KRlmR/2G97vumycoIfpvwrBZh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZpkHucB5h4Bi773KorpzKt7Jhs3E0J2+mvpfGlWf9P7EYqcITLvBZz629DLatBrhV55U//lwvl8pPwxygAtWff8gAId1suz8i1K1fs77Rv06Qz2cLJmL0N4i6vjt6ArwbMe/k4DXuD9ekw+4DQpfdFMUaSzhLlRu5scEY/ie6Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FMpXm0ed; arc=none smtp.client-ip=199.89.3.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FMpXm0ed"
Received: from localhost (localhost [127.0.0.1])
	by 001.mia.mailroute.net (Postfix) with ESMTP id 4Yykpt53gTz1Xb87K;
	Wed, 19 Feb 2025 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739988373; x=1742580374; bh=yfMRDrYuIG3e1Afok2GQUBcC
	RLQjngN5DOpHmYmKhgk=; b=FMpXm0ed77Zyn9TWpNXyUuBuHcdpgRNyx8C3ScMf
	djZWfPA7VLL+szDPOruU+iTXa3CgCW/xIy74OjMXcjQnqAa1JDAD6IwX7/5v6O/f
	Fjc+AfrehN4b9/sMygrKvuLcP63VrtWyhbyhSItVhssRoT6bwMRVMMlD80prZ7mC
	C4hTnTvKp7YhjB5jE6ksZmmfH3/S1xo02XrLp3OTHMsx0iEhEDImsObf7LN8dBWL
	dM3bCOTp/ePXf7wSk/I6BryBPdgVwSvlzjxYsQ3OeOCEY0pfkJWWlqfGfNT3y2dy
	q3AUPmgAKx8znUn7FwMFRCYk2t6PWBN5g8fO20u4VbOONg==
X-Virus-Scanned: by MailRoute
Received: from 001.mia.mailroute.net ([127.0.0.1])
 by localhost (001.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hlYeEd01oGUK; Wed, 19 Feb 2025 18:06:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 001.mia.mailroute.net (Postfix) with ESMTPSA id 4Yykpp469yz1XY6MW;
	Wed, 19 Feb 2025 18:06:09 +0000 (UTC)
Message-ID: <03b1b927-fb33-46e8-b38d-08e986f45672@acm.org>
Date: Wed, 19 Feb 2025 10:06:07 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix missing lock protection
To: Chaohai Chen <wdhh66@163.com>, martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250219081119.203295-1-wdhh66@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250219081119.203295-1-wdhh66@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 12:11 AM, Chaohai Chen wrote:
> async_scan_lock is designed to protect the scanning_hosts list,
> but there is no protection here.
> 
> Signed-off-by: Chaohai Chen <wdhh66@163.com>
> ---
>   drivers/scsi/scsi_scan.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 087fcbfc9aaa..9a90e6ba5603 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -151,8 +151,12 @@ int scsi_complete_async_scans(void)
>   	struct async_scan_data *data;
>   
>   	do {
> -		if (list_empty(&scanning_hosts))
> +		spin_lock(&async_scan_lock);
> +		if (list_empty(&scanning_hosts)) {
> +			spin_unlock(&async_scan_lock);
>   			return 0;
> +		}
> +		spin_unlock(&async_scan_lock);
>   		/* If we can't get memory immediately, that's OK.  Just
>   		 * sleep a little.  Even if we never get memory, the async
>   		 * scans will finish eventually.

Has it been considered to use scoped_guard() as in the untested patch
below?

Thanks,

Bart.


diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 087fcbfc9aaa..efc90571ab47 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -151,8 +151,9 @@ int scsi_complete_async_scans(void)
  	struct async_scan_data *data;

  	do {
-		if (list_empty(&scanning_hosts))
-			return 0;
+		scoped_guard(spinlock, &async_scan_lock)
+			if (list_empty(&scanning_hosts))
+				return 0;
  		/* If we can't get memory immediately, that's OK.  Just
  		 * sleep a little.  Even if we never get memory, the async
  		 * scans will finish eventually.

