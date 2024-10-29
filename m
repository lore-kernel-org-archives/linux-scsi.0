Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64551FBF50;
	Tue, 29 Oct 2024 19:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730229127; cv=none; b=boX8GrM54FUZ5P1mEGAnpirQ1ImKQliI65/tobhdCCZAWEtQsnlO9wvpmTj8P7pQ7B4bde3m/x+r1g7Lv1UWBXnYHbP2SyvZXQ5JGbhy6cmYAUadHw5+OOZUjdt/RYRMarmYU1OE8fJtwTy1PuuOwsXryUl9ol3G/wzSTYrX9qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730229127; c=relaxed/simple;
	bh=KfJeyNXckP8ryDW4PLbD5ryy4KlUL7OyJI3I1nGZk6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P/RR1O7JjhDe0DnhJmAKhOcEUJmZfIA4elAZrn5PZC3/QWarc7nHu3YvaQSzG0dv1iGWLEodVJexhuCdtMuYwngEIPem+49bpfvaywK+jUEY0Bx3yUqueiajPVSbleWGsdPSla29//uLBpEpLgUoKfqze/LCBRjFecAszUMBS8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FZ1tjSD+; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FZ1tjSD+"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XdKd11s2Wz6CmM6M;
	Tue, 29 Oct 2024 19:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730229123; x=1732821124; bh=CWBykyCGoTby+KMCV20ywtLX
	mEyYVyRBMmjHZbe+h+o=; b=FZ1tjSD+EmpJg5hcmZDLKtvcYBI1KG6CnZuPou/C
	gX7Gc090Cka2I/5/N0NiybpEU5hM1fUikgOZ+p2hMLpMSpFGWdN/CNSYmTJSYeEx
	EjRVjo2uUm+mcHaVSoeceDMpu1gJFK9Fpw1kohKU6hWmHpir45shvTdzGYWT+3Lz
	ZJKqeSGFV5mXXnYC8Baxkm8it/gljkNaKHFxcsWHwB4pKQbbxO36FwyGazbqxg9p
	rUVDiGTKfb85izDAE3sSSiMNqNqUKIJgWuNK33kOpnGbe5Vd3aG3kZogQoX8uAG4
	X/HlxPuRjvDmvDGeJ11AGJY+bMqgWCXR/CgL3iPCC1q74w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 05IhVrWL7etX; Tue, 29 Oct 2024 19:12:03 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XdKcy4CNhz6CmM5x;
	Tue, 29 Oct 2024 19:12:01 +0000 (UTC)
Message-ID: <c48cfcbd-0f8b-42fe-b804-1a3da473a7fe@acm.org>
Date: Tue, 29 Oct 2024 12:12:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating lock
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20241029102938.685835-1-avri.altman@wdc.com>
 <20241029102938.685835-2-avri.altman@wdc.com>
 <611fc99e-c947-463a-82e1-9d2a68d67aa4@acm.org>
 <BL0PR04MB6564D3BBB11D00067485F5CBFC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <BL0PR04MB6564D3BBB11D00067485F5CBFC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 11:39 AM, Avri Altman wrote:
>> On 10/29/24 3:29 AM, Avri Altman wrote:
>> and do not exceed the 80 column limit. git clang-format HEAD^ can help
>> with restricting code to the 80 column limit.
> Isn't the 80 characters restriction was changed long ago to 100 characters?
> I always use strict checkpatch and doesn't get any warning about this.

80 columns is the limit currently used in the UFS driver so I think we
should stick to this limit to keep formatting of the UFS driver
consistent. Here are two additional arguments:
* From Documentation/process/coding-style.rst:

   The preferred limit on the length of a single line is 80 columns.

* From .clang-format:

   ColumnLimit: 80


Thanks,

Bart.
