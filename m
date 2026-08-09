Received: from mail-m12779.qiye.163.com (mail-m12779.qiye.163.com [115.236.127.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446D11D7E5C
	for <linux-scsi@vger.kernel.org>; Sun,  9 Aug 2026 10:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786269798; cv=none; b=AEloHg1o5LysitZ5uHEggjGrYN6tKNHN/kO5sdc0Y9epLy53DSYvsKkreVBND7ohN0AEJsgq3WPc1M4/1U72gZd/+Ea2RWD89StCiAP4A7Yf4/4S49v3LTaj2+tqYiEDpjIkugEG2FDJpAAlhYVoExLBFIj6g5ZaiiueBNe0Cy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786269798; c=relaxed/simple;
	bh=NBHTPYd5+zq08CoVAfWUd99s1PW4UFvHF/AXEmelv98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tRZx4AhCatuJIoz9oiBgbSjnsSEd2ldJ/q6RaehdsqkIFUZSNc8ITL+uG4oglvn3N2rXOiX72emxvemkOiCyaL6BzqC99TRlALDhp2zajX8AnRHymAQoxfVAQavQtUB8YWwHeV1j6T85AihDD0qcqPHTwjsCAhBwaSjG3a8TFq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=BbsFDmic; arc=none smtp.client-ip=115.236.127.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="BbsFDmic"
Received: from [IPV6:2001:da8:e800:71f4:e904:54cb:bab9:560b] (unknown [IPV6:2001:da8:e800:71f4:e904:54cb:bab9:560b])
	by smtp.qiye.163.com (Hmail) with ESMTP id 494c45914;
	Sun, 9 Aug 2026 16:47:24 +0800 (GMT+08:00)
Message-ID: <2361eb4a-f24d-4ffa-ac54-016c5313f131@leap-io-kernel.com>
Date: Sun, 9 Aug 2026 16:47:23 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/2] scsi: Add LeapRAID driver support
To: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 dlemoal@kernel.org, hare@kernel.org, hare@suse.de,
 yjzhang@leap-io-kernel.com, kezijie@leap-io-kernel.com,
 jzzhang@leap-io-kernel.com, baikefan@leap-io-kernel.com,
 linux-scsi@vger.kernel.org
References: <cover.1785823793.git.doubled@leap-io-kernel.com>
 <yq1tsp53oq3.fsf@mail.kernel.org>
From: Hao Dongdong <doubled@leap-io-kernel.com>
In-Reply-To: <yq1tsp53oq3.fsf@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fe5b4939703aekunm88cd49df21a9e9
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSh8aVkIeShkZSkNJGkwaHlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJS0tKQR8aQ0EeQ0tLQUxKHU9BHkJLT0FOTxgZQRkaGU
	JBTk1LGVlXWRYaDxIVHRRZQVlPS0hVQkJJTkpVSktLVUpCS0JZBg++
DKIM-Signature: a=rsa-sha256;
	b=BbsFDmic0yAK726Uan8/dmeqkPaSmrv9ENYHQfXhNlW161iMX6b8g06pytGc1qtT5O4G7J8YG5IkReWV+Kspp70l6KFUbvD1jl9DKTum7zIlctNAQ3Uz+CZ3RvIv21kKkT2tcQlZWEQ3Gdfg8xp2nKZDcFp5r0+67izIPTLSodcXS9h2NtPasdWCRyY7JPP/8Dl8xRrsbZZ3zY8P5lz1AeOFSbcez+/FB28/JxSS8ThPEif0si5ByMHkS8RlRAWVgqe4BZ6yEREc179jyr1eGyclhbkf8m2iubOvFw7LTDq6qPfWTuG8k7wzlRuUYTYcWyMB8tEseLfBATOfmcWKNw==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=BH9ZTTeNzkXnittr3VD+ABa12/TuEsgMQmtdCRrh9NU=;
	h=date:mime-version:subject:message-id:from;

在 2026/8/8 0:00, Martin K. Petersen (Oracle) 写道:
> 
> Dongdong,
> 
>> This series adds the LeapRAID driver and its documentation.
> 
> Applied to 7.3/scsi-staging, thanks!
> 

Hi Martin,

Thank you for applying the series!

I would also like to thank Damien and Hannes for their careful reviews
and valuable feedback.

Sashiko subsequently reported two minor issues in the documentation and
sysfs interface. We will address them in follow-up patches once the tree
has settled.

Best regards,
Dongdong
