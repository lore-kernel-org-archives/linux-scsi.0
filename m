Received: from smtp.smtpout.orange.fr (smtp-72.smtpout.orange.fr [80.12.242.72])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E7F1FBCAF;
	Tue, 29 Jul 2025 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753819783; cv=none; b=f2lUCX30DnSh9x0FgjKRyTpfZn77doLFE3elFYjp5JVRKI4+AJOFuDbT3tuCI6CAPC0joKtQJ2km7GgpR5pMR3/yTS6n5AzJhP4FEhnH7Xyz0MgBrbxdwx4eQGKcmwAdxak0C7YasRJguL67dP8ffyjPCer/t5ByZ3J32O7dq5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753819783; c=relaxed/simple;
	bh=wazx78Hg42JipNRTn1OX+UN2uKuyl7Et/aM/CSlets0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T4n+RliDLrK9CEpoOcQ91esdHAt1mHhu64UndzgLi9aKrnTRE/drt+i+x0QOwNro5/W5UOJhC2BUKUWyK4srQMuj7qjTT5/C0W5LVx/+8nHfX3tzOkGUsnXxAMGKSws6UCW4txgEW6rG+F8CTvo8r+FyhMTTyCAHPHZL1JFOxzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=O7aQi08q; arc=none smtp.client-ip=80.12.242.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="O7aQi08q"
Received: from [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
 ([IPv6:2a01:cb10:785:b00:8347:f260:7456:7662])
	by smtp.orange.fr with ESMTPA
	id gqdcuMqPAZYUVgqdcuHq5u; Tue, 29 Jul 2025 22:09:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1753819772;
	bh=m38jeXU2uhy8iL3xi7vulN5ZnY6ZUr+4hixIRGdoSDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=O7aQi08q97cq0YiDaCsd/O70Q9nyQeXsMGzx2LsIIWv0q0OdvcsskMsHRxlE1Tlv0
	 tCJRppDYFqVuWsuWAVvVhHFiMdmIQEfAU5z/nzBC+b1RjKgEmEpj5WPXEQQbDCPO5Q
	 UnoylwDyqHtpiDCYt1chaWO5bJnwklFIaAOdSTsGJIwMfvdhGTNaQGSqzdLTWSuadR
	 vZrH2ROpZOVa8pun0wvP4VVSOs/V1ZIFalFNCBrwb+qikIkyPn+Ms5CpNrCGX8wFku
	 Z9ScIorgkLIdnVjQaWP/mCxtn6EEHTZ0KM8k4nUjxk5Ld+SVDv2Hk46SQqenJirEqR
	 BfRtxkPZ2JwcQ==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:8347:f260:7456:7662]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Tue, 29 Jul 2025 22:09:32 +0200
X-ME-IP: 2a01:cb10:785:b00:8347:f260:7456:7662
Message-ID: <d7c27813-52b9-4f06-b501-8443f7215be7@wanadoo.fr>
Date: Tue, 29 Jul 2025 22:09:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: scsi_debug: make read-only arrays static
 const
To: "Colin King (gmail)" <colin.i.king@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250729064930.1659007-1-colin.i.king@gmail.com>
 <86f359c3-8eb6-4fd7-8411-12d12e301d61@wanadoo.fr>
 <64ec6c5e-5eb3-4db8-9540-7679ac694c11@gmail.com>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
In-Reply-To: <64ec6c5e-5eb3-4db8-9540-7679ac694c11@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 29/07/2025 à 21:49, Colin King (gmail) a écrit :
> On 29/07/2025 18:45, Christophe JAILLET wrote:
>> Le 29/07/2025 à 08:49, Colin Ian King a écrit :
>>> Don't populate the read-only arrays on the stack at run time, instead
>>> make them static const. Also reduces overall size.
>>>
>>> before:
>>>     text       data        bss        dec        hex    filename
>>>   367439      89582       5952     462973      7107d    drivers/scsi/ 
>>> scsi_debug.o
>>>
>>> after:
>>>     text       data        bss        dec        hex    filename
>>>   365847      90702       5952     462501      70ea5    drivers/scsi/ 
>>> scsi_debug.o
>>
>> Hi,
>>
>> out of curiosity, any idea why 'data' increase?
> 
> Because the arrays are being stored in the data section rather than on 
> the stack.

Even when const is used?

See [1] for example, adding const moves the size from data to text.
I would expect the same with your patch.

CJ

[1]: 
https://web.git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=86b0fc4b2b45a78cbdc11873bc596d140eff390c

> 
>>
>> All my constification patches lead to data reduction.
>>
>>>
>>> (gcc 14.2.0, x86-64)
>>
>> (same kind of behavior with 15.1.1)
>>
>>
>> CJ
> 

