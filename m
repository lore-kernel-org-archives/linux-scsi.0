Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99703AC0DE
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 22:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789770009; cv=none; b=VDsaSbv7amRHSDsyZYlahqKj27xxwvq7QKJIlqbAZsYT3wEuS6lziuia8ufQPZ5G2cHHc8Epj+Sc9gypvAPjPaLo7aE3lWWbKoqjrLngXhKmVUxVRs/nGebVN5rPXs3wS0NSDsFZ6tcBT4pbIPXJg7oEUYnfU/EPUnRUz46izgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789770009; c=relaxed/simple;
	bh=y9YClzRam+EZ0ikVvID/IImjSk2g7AD0/1ncVqaBtFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VUZPSSNcsVfwIKNjhlGMW934wBp+GfGv3gUc9EBQFpsIcfhVp0X56K05nMQKS7PRpx1i5vLMbem7bIW1jhO6fIu/1PfvnAg6kfZ2XUjFEgl7GCgmq8D3SW3X4/KEU5mpHWQnPdB83EQrRNlJDNVEVFUnu9TxBD9WMNf32VuICJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gwrZ8eKf; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gwrZ8eKf"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hmn9t3NX2zlfvqS;
	Fri, 18 Sep 2026 22:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789769999; x=1792362000; bh=y9YClzRam+EZ0ikVvID/IImj
	Sk2g7AD0/1ncVqaBtFY=; b=gwrZ8eKfjp/v/FpFFNe3CFtJji1Ti9ELy1T7Y1Kv
	51nMEfwXpDeg6qFcQOAiAPG3FryPE6pLf1hpg92diw3DN5inow3k6/Xl5BzXH/xO
	ytOBLysIwq/CU5amtt/YRwoQvW52X01tnTiELr547luOp0cCWzcZOBl+uoJYNwup
	q3yjIKznsG1PWMMlGIoXhgTgnNAqhfOx3VmV9IZlvSnAcSy2esR/zf1nMcGZhVCC
	PZ4OV1Ygp5zNYu6IaoYvT/4tzRkrCsgkS4L10LAWJzRGLVN1LBGcj9eCnx4YVkNp
	BbeLSI3YYyOuPmvT4C7r1WauFFyS6TBi4hatEMcC5WZWxQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EaPiWCLL1imn; Fri, 18 Sep 2026 22:19:59 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:9130:c9d9:dd94:6232] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hmn9n1WJBzlfvpc;
	Fri, 18 Sep 2026 22:19:56 +0000 (UTC)
Message-ID: <e3351cd2-b788-417f-8942-ad85e6998be4@acm.org>
Date: Fri, 18 Sep 2026 15:19:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Make SCSI host scan interruptible
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com
References: <74786683eadc0a32ab335373ead8dd76a9d5a342.1789157339.git.bvanassche@acm.org>
 <18d5f6f60e9c36fd.3137322e31362e3131332e313435.397753.0000sendgmr@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <18d5f6f60e9c36fd.3137322e31362e3131332e313435.397753.0000sendgmr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/26 6:19 PM, Stanley Jhu wrote:
> Both issues arise because signal_pending(current) cannot distinguish a
> user-initiated rescan from driver probe enumeration. Would passing an
> explicit flag or scan mode from user-initiated entry points
> (store_scan() and procfs) be cleaner than inspecting current?

I'm waiting for others (long-time SCSI contributors) to comment on
whether or not they agree with making SCSI scanning interruptible.

Thanks,

Bart.
