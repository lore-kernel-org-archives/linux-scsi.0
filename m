Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A703BB40;
	Tue, 16 Dec 2025 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765907889; cv=none; b=W2X4KkmaYPGP95/H/yQju3Bnfj6zrA8pSUtRbVi/lkqRw3OHZeWoBjZdb/Ue61YYLnVEQik1zQeXx7Ii9cJ0dkC5jO2pFPLMcPesBYmAsXD2/oM4l16LXEwNs/zT9kDZmtLEf9XEuibx023O2STU1hCxF32l50iddgGZ5QOAbuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765907889; c=relaxed/simple;
	bh=2Ec9MHZWMwRhIXQ+MAkAjt+xPMNAnA5QllzYC0wjnh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C9qTM0ikm4dxKYzEdNF0kkJOsDghunwqNzQtH3CtUEsMSscNPJXx7FQ/svT5BIkJ9ZPK1LYGrc2Y3imGEv+stUoFnBd3hAm98ns/qY8mGVZ90G2e1QPWpYHNYufZ0RU+iPHJY+nIMFqNeqWow+O18XhJ8JZ6u8H8blDPWfFit/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NVZ7CBcW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NVZ7CBcW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dW4Qw6jtmz1XT1Z1;
	Tue, 16 Dec 2025 17:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765907879; x=1768499880; bh=1a5iGjcMxiFYf/gtI27sMwwh
	pT5RC6fbzUxq/3T0CKw=; b=NVZ7CBcWk/8X9YWFiYHWRQsVgfWrGowURAPKEbyc
	xKCZPrEkUgS55RfeOkxo1c9LLqmxoBUj0q6DYG2Qbw0W4rKfnRAiN22le0/LUMJg
	3svWAn/HEAMb9kWGIdxplkYz2c/LwNjzwTLvctq4eB1kAU2OfHiROQSQlsiO2WDt
	0JW0X4nMskztl8dXzU1+fftb0TqNOQta4yCTzqwlT1tQHjFwFDmrkzL03WvEaYvQ
	vSA7D3QmaU2yQcJMuscJeV5vZDqt7QoM/8Djz5lsjLlIEg+ngT71nv+FKgcKa2sR
	Hndeq7NUO8gfbX52f3Mt0rDga/po1h8WBxwdj5Owv9EEUw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0anLFZjoD337; Tue, 16 Dec 2025 17:57:59 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dW4Qt086nz1XqyG4;
	Tue, 16 Dec 2025 17:57:57 +0000 (UTC)
Message-ID: <e0b4cfd3-2773-4a07-a3ba-3dc600ca69ac@acm.org>
Date: Tue, 16 Dec 2025 09:57:56 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: ufs: core: Fix error handler encryption support
To: Christoph Hellwig <hch@infradead.org>
Cc: Po-Wen Kao <powenkao@google.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20251208025232.4068621-1-powenkao@google.com>
 <aTkXqslvwMOz2TUG@infradead.org>
 <955ba65e-424b-4968-9541-ab235a7bafd3@acm.org>
 <aT-jjQpp1UfaiZIU@infradead.org>
 <54d824db-ec39-447c-8eab-6c2ce4ca87a6@acm.org>
 <aUE4Kf73OxxO7r-K@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aUE4Kf73OxxO7r-K@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/16/25 2:44 AM, Christoph Hellwig wrote:
> On Mon, Dec 15, 2025 at 08:47:03AM -0800, Bart Van Assche wrote:
>> (a) There is code in the SCSI error handler that submits SCSI commands
>>      with a data buffer. Hence, disabling encryption if and only if the
>>      data buffer length is zero can't fix the reported problem. From
>>      scsi_eh_prep_cmnd() in drivers/scsi/scsi_error.c:
> 
> This still does not actually transfer data to the media, and thus
> is not affected by inline encryption.

Hi Christoph,

Agreed that neither REQUEST SENSE nor any of the other SCSI commands
submitted by the SCSI error handler access the storage medium. However,
even if Po-Wen's patch would be modified such that it checks the SCSI
CDB to verify whether or not the SCSI command accesses the medium, the
other concerns that I mentioned still apply. So if nobody objects I
propose to repost patch "[PATCH v2 1/1] scsi: core: Fix error handler
encryption support" with v2 bumped to v3.

Thanks,

Bart.
