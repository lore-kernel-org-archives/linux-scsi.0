Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE37277CB3;
	Sun, 13 Jul 2025 17:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752429557; cv=none; b=E47aSd+H7PHH9++Bfdga/KVrdJjFwkLGYjAy0BQDfDYou9a2dwVuHPZ24KCBSRyFi5WRbUsppp8tcnh6SUJ8HfTEsnZC7KHiuW7A9cHw0XGYkCfkaV6oL+0dpFOcUMWYazi4l3QpFTvzE3EBX0jTOVWf/CJoPoUF0KP/k2LRe8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752429557; c=relaxed/simple;
	bh=j/Xc3m8aGB/bnZvzCCQKEThLet9B2MWI5sHcRHNIHjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VnVAXL88VtpShSXiP98akAlKdHyC+wPDWsvmHvHzA9h/GEQeBN6lValhmUImApX/GcfG958LKYY1Gp7XMIhGbJJEro7hsLF/jR9j0WhL6yvjhU11oQfKVu+IF1ImVIWEUZLkcLXbfvgRJjJfJoJ3cOdQWxSzSU7PCrrEK1Ykgg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MctySvXb; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MctySvXb"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bgCrD73tLzlgqyj;
	Sun, 13 Jul 2025 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752429547; x=1755021548; bh=q5yVHxfCx9AnzU03pXoM2Ryy
	zVpHtDMUHzmqUhqzP1M=; b=MctySvXbDpWRa++rQyiL+7fv8bxUi5E9OW5gTcbN
	fQ/IhSzkcbQ3slWwoOhaeF/yMJQ/uyW5Zqgv0wo1KYKfenKbvjxIunZJ7ypd1lxY
	pHeeTqzIxvLRB26P9j1vOh+XpzVVEoPWvgKC8gUdmG3iJe1jVsSExuqIQn1lxVu6
	J0axayFiP6v+lNUp8m2oO1Bm8GeFrIQVFDaWLmPRCPG5X4mdEAm+8PrSlDZS/sbe
	GKNSvCRr8DPUaJHZ735Xpw98XHPOhDjI9yjOX/MxON3tu6sIdvqSMM8opYQ9JT9A
	jR7T1Av9bFboG2H9553DvsmK3PNa/FDLhWMZpXeFLKNPog==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vXGUHYKKw_b6; Sun, 13 Jul 2025 17:59:07 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bgCr34gprzlgqxr;
	Sun, 13 Jul 2025 17:58:57 +0000 (UTC)
Message-ID: <3a88109e-25e4-4873-8143-242d24f2dfe0@acm.org>
Date: Sun, 13 Jul 2025 10:58:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: hisi_sas: use sysfs_emit() in v3 hw show()
 functions
To: Greg KH <gregkh@linuxfoundation.org>,
 Khaled Elnaggar <khaledelnaggarlinux@gmail.com>
Cc: liyihang9@huawei.com, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com, linux-kernel-mentees@lists.linux.dev,
 shuah@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250712142804.339241-1-khaledelnaggarlinux@gmail.com>
 <2025071244-widely-strangely-b24c@gregkh>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2025071244-widely-strangely-b24c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/25 7:43 AM, Greg KH wrote:
> On Sat, Jul 12, 2025 at 05:28:03PM +0300, Khaled Elnaggar wrote:
>> Replace scnprintf() with sysfs_emit() in several sysfs show()
>> callbacks in hisi_sas_v3_hw.c. This is recommended in
>> Documentation/filesystems/sysfs.rst for formatting values returned to
>> userspace.
> 
> For new users, yes, but what's wrong with these existing calls?  They
> still work properly, so why change them?

How about making this explicit in Documentation/filesystems/sysfs.rst?
I think that would help to stop the steady stream of patches for
converting existing sysfs show callbacks to sysfs_emit()/sysfs_emit_at().

Thanks,

Bart.
