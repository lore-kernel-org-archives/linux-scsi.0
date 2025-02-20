Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3143B10FD;
	Thu, 20 Feb 2025 03:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740020543; cv=none; b=KL7tgJf9uJoVBTFU5XzbGSIkw6d3unIqoXwJCmnXhWLruBT0fpvYUdZo6bH9Tya3QpUzFNnXbqkMKP+uAQx7/OdRPN8opVmp2u3gkkPmpsLY0NRoCBXgru/mCX8z5aV1qchIropX/zO1kdDeuIMbXkbaYV5SLNZgJka1umgTol8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740020543; c=relaxed/simple;
	bh=hILjsdMWrbZFA3fURJN1324PIk8voKtSyZOWwXTLFhg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RchDrRyf+bXWlexcfYTJWzDNO/2iQtkbnVyv/UuWhOw8sFcml7yvgDlR5MqPMuaSaQmjIAeuPQXdN0lrFHrQiXrRiz6R1Kd4eQNLU2Os8xoix+NdhamNWVDx08f3u72epg9Yt2qLi6OwTJNh9NlVfjf1/Kqjh2+1BJ4umhJLy2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=gThlVVka; dkim=fail (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FMpXm0ed reason="signature verification failed"; arc=none smtp.client-ip=199.89.3.4; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="gThlVVka";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FMpXm0ed"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=Fog4g/9GIIquTxNnIUI0Sd+LPaX7qKVrXRiHGmc5y/0=;
	b=gThlVVkaxMYNogpkYvajefU65J6r6hsh6DmVSBsODG4rUiw5JJQ+nUoZY9vHur
	LjypdDZ9DQAZTjs0ltDpVwOyWsGZDccDbk4XPuGcAwPhE0b4MEnPbKoaQS1WS7B2
	hMNAN9i7h8STT5Pjk80o/trIJP57KOqjB9LS/+y8c6pXg=
Received: from wdhh6.sugon.cn (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDX_6Icm7ZnAYqBNQ--.9966S2;
	Thu, 20 Feb 2025 11:01:49 +0800 (CST)
From: Chaohai Chen <wdhh66@163.com>
To: wdhh66@163.com,
	martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: fix missing lock protection
Date: Thu, 20 Feb 2025 11:01:46 +0800
Message-ID: <03b1b927-fb33-46e8-b38d-08e986f45672@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250219081119.203295-1-wdhh66@163.com>
References: <20250219081119.203295-1-wdhh66@163.com>
Received: from 001.mia.mailroute.net (001.mia.mailroute.net [199.89.3.4]) (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits)) (No client certificate requested) by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EF1214221; Wed, 19 Feb 2025 18:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1]) by 001.mia.mailroute.net (Postfix) with ESMTP id 4Yykpt53gTz1Xb87K; Wed, 19 Feb 2025 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h= content-transfer-encoding:content-type:content-type:in-reply-to :from:from:content-language:references:subject:subject :user-agent:mime-version:date:date:message-id:received:received; s=mr01; t=1739988373; x=1742580374; bh=yfMRDrYuIG3e1Afok2GQUBcC RLQjngN5DOpHmYmKhgk=; b=FMpXm0ed77Zyn9TWpNXyUuBuHcdpgRNyx8C3ScMf djZWfPA7VLL+szDPOruU+iTXa3CgCW/xIy74OjMXcjQnqAa1JDAD6IwX7/5v6O/f Fjc+AfrehN4b9/sMygrKvuLcP63VrtWyhbyhSItVhssRoT6bwMRVMMlD80prZ7mC C4hTnTvKp7YhjB5jE6ksZmmfH3/S1xo02XrLp3OTHMsx0iEhEDImsObf7LN8dBWL dM3bCOTp/ePXf7wSk/I6BryBPdgVwSvlzjxYsQ3OeOCEY0pfkJWWlqfGfNT3y2dy q3AUPmgAKx8znUn7FwMFRCYk2t6PWBN5g8fO20u4VbOONg==
X-Virus-Scanned: by MailRoute
Received: from 001.mia.mailroute.net ([127.0.0.1]) by localhost (001.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP id hlYeEd01oGUK; Wed, 19 Feb 2025 18:06:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82]) (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits) key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256) (No client certificate requested) (Authenticated sender: bvanassche@acm.org) by 001.mia.mailroute.net (Postfix) with ESMTPSA id 4Yykpp469yz1XY6MW; Wed, 19 Feb 2025 18:06:09 +0000 (UTC)
Precedence: bulk
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX_6Icm7ZnAYqBNQ--.9966S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar13Jw4fJF4fZw4kAF4Utwb_yoW8AF43pF
	WFg34jkr48Jw4kuwnagw1fZr4rZ3yxWryUKa17u3sxZF93Wr9rKwnIgw18ZFn5Cr4rKF4j
	qF1UtFy5G3WUt37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRSksPUUUUU=
X-CM-SenderInfo: hzgkxlqw6rljoofrz/1tbiEAv51me2hPaO8QACsq
Message-ID: <20250220030146.3WSLgMIcQ_pEIxLeCC_gAZMKgkd5OfEumCLm1zCzPqg@z>

From: Bart Van Assche <bvanassche@acm.org>

On 2/19/25 12:11 AM, Chaohai Chen wrote:
>> async_scan_lock is designed to protect the scanning_hosts list,
>> but there is no protection here.
>> 
>> Signed-off-by: Chaohai Chen <wdhh66@163.com>
>> ---
>>   drivers/scsi/scsi_scan.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 087fcbfc9aaa..9a90e6ba5603 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -151,8 +151,12 @@ int scsi_complete_async_scans(void)
>>   	struct async_scan_data *data;
>>   
>>   	do {
>> -		if (list_empty(&scanning_hosts))
>> +		spin_lock(&async_scan_lock);
>> +		if (list_empty(&scanning_hosts)) {
>> +			spin_unlock(&async_scan_lock);
>>   			return 0;
>> +		}
>> +		spin_unlock(&async_scan_lock);
>>   		/* If we can't get memory immediately, that's OK.  Just
>>   		 * sleep a little.  Even if we never get memory, the async
>>   		 * scans will finish eventually.
>
>Has it been considered to use scoped_guard() as in the untested patch
>below?
>
>Thanks,
>
>Bart.
>
>
>diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>index 087fcbfc9aaa..efc90571ab47 100644
>--- a/drivers/scsi/scsi_scan.c
>+++ b/drivers/scsi/scsi_scan.c
>@@ -151,8 +151,9 @@ int scsi_complete_async_scans(void)
>  	struct async_scan_data *data;
>
>  	do {
>-		if (list_empty(&scanning_hosts))
>-			return 0;
>+		scoped_guard(spinlock, &async_scan_lock)
>+			if (list_empty(&scanning_hosts))
>+				return 0;
>  		/* If we can't get memory immediately, that's OK.  Just
>  		 * sleep a little.  Even if we never get memory, the async
>  		 * scans will finish eventually.
>
>

Of course, it looks nice, thanks.

Chaohai

