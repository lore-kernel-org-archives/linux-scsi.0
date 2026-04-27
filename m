Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA2B146A66;
	Mon, 27 Apr 2026 04:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777265163; cv=none; b=BS1jWbgTBwDdPqYpW3erR453jAqaO+Rg60XKW283WAOd3Dw5LAAcMsrAWdLz9LrXygKu3wvuN7NDc3BnVdL36DVFEBkE/K/SMCvDx+fZpof8R1Dvw2HLSWq1qS2n03l9tm7M/Oa6FRMQAOfjfFh9DkhkC8SZIrAH7puM0l/x/XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777265163; c=relaxed/simple;
	bh=z95bnebCYSGOB/ExuIaArFAKmpoIpR6vBAvj96UQp9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JuHJHUgWkBJgeM7OTGieJN+gNXaGD5F51pxLSRyk9gGeIXo+meIjkNFx4El1wvcG3YFaN0hr8P7wCj0QV4pW7FtLb0irk0Jz0kGvSjznrm/vHtwFedG7eG1fbWl1uycE5RP/mp3njS3mtdRpysW0piDp3mFZITeMKOFX/ACq3sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NC25d9TI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NC25d9TI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4EAC19425;
	Mon, 27 Apr 2026 04:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777265162;
	bh=z95bnebCYSGOB/ExuIaArFAKmpoIpR6vBAvj96UQp9o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NC25d9TIotfJuT2HCn8abAjphYl4TEKWW18gimWI6Xr3CWYm38ID3AKEjWXxi8z5A
	 RI5nBGj6Ai4Ec54ZBArwTILhrVUVpAufZfXgON/wpu/h4m8I/dU4O4sdpxNHPLlSsZ
	 dkIn8B/IKKzFvWDm5V7u4LAtOX9q9Qx9RjudSjJ4REsH/P291TdY51TR6xXIFfL3lu
	 r0zAbHJAczd5Uss8hYqZPQtoSbN9uEf20ZvZmbrTAe3a46O8Y4IQukD5uR8azeQUC2
	 J/tlQT1zxh7WIWHcSVqXY90pHTi+SPRfZ+Ay2NKphp0ScCX8SyW9o+Q7nz96zNfpQU
	 Omv1FIBEDbmEA==
Message-ID: <33299d0d-d863-4e00-951e-4728ddc823e2@kernel.org>
Date: Mon, 27 Apr 2026 13:45:54 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ata: libata-sata: retry hardreset when device detected
 but PHY not established
To: yangxingui <yangxingui@huawei.com>, cassel@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuyonglong@huawei.com, kangfenglong@huawei.com, linux-ide@vger.kernel.org
References: <20260425060447.1312763-1-yangxingui@huawei.com>
 <e8d237bc-7191-4881-924b-86a34ff0f3b9@kernel.org>
 <a118114e-9828-06d6-d38b-2b426c92bb14@huawei.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a118114e-9828-06d6-d38b-2b426c92bb14@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/27/26 10:51 AM, yangxingui wrote:
> 
> 
> On 2026/4/26 6:53, Damien Le Moal wrote:
>> On 4/25/26 15:04, Xingui Yang wrote:
>>> When sata_link_hardreset() detects that the link is offline, it currently
>>> returns immediately without distinguishing the reason. According to SATA
>>> specification, the SStatus register's det filed (bits 0-3) indicates:
>>>    - 0x0: No device detected, PHY not communicating
>>>    - 0x1: Device detected but PHY communication not established
>>>    - 0x3: Device detected and PHY communication established
>>>
>>> This patch helps improve device detection reliability and adds a check
>>> when the link is offline but det filed shows 0x1, return -EAGAIN to
>>> trigger retry, rather than giving up immediately.
>>>
>>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>>
>> This is a pure ATA patch so please CC the linux-ide list, not the linux-scsi
>> list.
> 
> Ok.
>>
>> Also, please check your mail setup: your email was in my Junk folder.
> 
> Well, patche was sent using the git send command.

Not git send-email, your smtp server. It probably has something wrong with
DMARC. All your emails endup in my junk folder.

>> This is preceeded by a call to sata_link_resume(), which calls
>> sata_link_debounce() and that function makes sure that DET is stable. So if
>> after that DET still shows that their is no PHY, there is likely a big problem
>> with it and it is super slow to be established.
>>
>> In this case, I do not think that doing another hardreset is the right thing to
>> do. Have you tried increasing the deadline for hardreset ? That deadline is used
>> as the limit for the link debounce too.
>>
>> Do you have a specific controller/device where you see this issue ? What exactly
>> is the hardware setup where you see this issue ?
> 
> Our customer imports and verifies a new disk, there is an occasional failure in
> performing a hard reset on the disk and no exception log is generated for
> resume and debounce.

Does this hold for all disks or for only one or some models ?

> 
> [   22.864418][ T1285] ahci 0000:76:03.0: Adding to iommu group 23
> [   22.870403][ T1285] ahci 0000:76:03.0: controller does not support SXS,
> disabling CAP_SXS
> [   22.878655][ T1285] ahci 0000:76:03.0: SSS flag set, parallel bus scan disabled
> [   22.885966][ T1285] ahci 0000:76:03.0: AHCI 0001.0300 32 slots 2 ports 6
> Gbps 0x3 impl SATA mode
> [   22.894743][ T1285] ahci 0000:76:03.0: flags: 64bit ncq sntf stag pm led clo
> only pmp fbs slum part ccc ems boh
> [   22.905277][ T1285] scsi host0: ahci
> [   22.909061][ T1285] scsi host1: ahci
> [   22.966463][ T1285] ata1: SATA max UDMA/133 abar m4096@0xa3010000 port
> 0xa3010100 irq 108
> [   22.974629][ T1285] ata2: SATA max UDMA/133 abar m4096@0xa3010000 port
> 0xa3010180 irq 109
> [   25.242373][ T1286] ata1: SATA link down (SStatus 1 SControl 300)
> <==============
> [   25.659901][ T1288] ata2: SATA link down (SStatus 0 SControl 300)
>>
>>
>>
>>> +        u32 sstatus;
>>> +
>>> +        if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
>>> +            (sstatus & 0xf) == 0x1) {
>>> +            ata_link_warn(link, "device detected but PHY not ready (SStatus
>>> %X), retrying\n",
>>> +                      sstatus);
>>> +            rc = -EAGAIN;
>>> +        }
>>> +
>>>           goto out;
>>> +    }
>>>         /* Link is online.  From this point, -ENODEV too is an error. */
>>>       if (online)
>>
>>
> 
> Thanks,
> Xingui
> 


-- 
Damien Le Moal
Western Digital Research
