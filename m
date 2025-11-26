Received: from mail-m3290.qiye.163.com (mail-m3290.qiye.163.com [220.197.32.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD9422AE7A
	for <linux-scsi@vger.kernel.org>; Wed, 26 Nov 2025 07:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764143481; cv=none; b=T/4c3evG1ZXpzWZPZiwbXjyXtGRoOO1lS/7VNLK49NNvesXBedhw9V+65b0lwIXbBgOlFBxIYZQmzv7uw9+B2zLCnLVtUGIumaxiSEDntp1TWcZIgGKtwxB5xVSSOwJaHoi14giE+k+atxYqbQ+4a+AdXJYpv1BhqhTqlLPzVSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764143481; c=relaxed/simple;
	bh=DO9CsLcBcBJJDARcoy0ltEpdRiCTuCyWMT9zOicHsn8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oJHDlFjDagAnlkkR1A0yW8o16SmsRJHOEPV1eBQdp7XWZKgvjFj1GJLZ+OCorf/GN5NN/aUFcNxuQG7U5gZNH/s7Pqs3tQfA2pBzrTwmtBsNR7GXlWgg77nB5Mr8RwEVBz8qRVhtDNbEoKM+RMwdmNvEO13FICIu6uNswdpLA6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=gbPhSGQw; arc=none smtp.client-ip=220.197.32.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="gbPhSGQw"
Received: from [172.16.12.14] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2af3fa8cc;
	Wed, 26 Nov 2025 15:51:07 +0800 (GMT+08:00)
Message-ID: <91ef4f89-8f8e-4d55-a2bf-bf3e381f63c2@rock-chips.com>
Date: Wed, 26 Nov 2025 15:51:06 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: core: Remove the alignment check in
 ufshcd_memory_alloc()
To: Avri Altman <Avri.Altman@sandisk.com>
References: <1764122900-30868-1-git-send-email-shawn.lin@rock-chips.com>
 <DS1PR16MB675374C98979E25FF23177E9E5DEA@DS1PR16MB6753.namprd16.prod.outlook.com>
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <DS1PR16MB675374C98979E25FF23177E9E5DEA@DS1PR16MB6753.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9abf250c0d09cckunm5ece35ee53bfb7
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGkJCS1ZNTh9OSklLTE1NQhlWFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0
	hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=gbPhSGQwtabeOby4Ipv3XQewbVorM/erleeOyCQpKwhr5x67CgaxhOKV8E/33rSGTXGMvos1QMVcaDeNdI5ABGhDr57n6kLmVgoWQ7IFgOKwLJ1U4wdvflVWWPJ34DwSFX1q6P/AvrXTDsgVRsnxZn/7TLNDfLmQPjcE7uxSbA4=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=jj67GQOlSG0fjdH75vbLrfAG7XgjsVyp1zSK/MPihfM=;
	h=date:mime-version:subject:message-id:from;

在 2025/11/26 星期三 14:05, Avri Altman 写道:
>> The dmam_alloc_coherent() function guarantees page-aligned memory on
>> successful allocation. The current alignment checks using WARN_ON() for buffers
>> smaller than PAGE_SIZE are therefore redundant and can be safely removed to
>> simplify the code.
> The commit that introduced those checks (339aa1221872) for sizes != PAGE_SIZE explained:
> "...
>      In the case where these allocations are serviced by e.g. the Arm SMMU, the
>      size and alignment will be determined by its supported page sizes. In most
>      cases SZ_4K and a few larger sizes are available.
> 
>      In the typical configuration this does not cause problems, but in the event
>      that the system PAGE_SIZE is increased beyond 4k, it's no longer reasonable
>      to expect that the allocation will be PAGE_SIZE aligned.
> ..."
> 

Thanks for pointing this out. But I'm thinking the commit message might 
not be correct.

Without IOMMU/SMMU support, the allocation must be PAGE_SIZE aligned.
With IOMMU/SMMU support, the returned address is IOVA, it should be
the MMU page size aligned. Isn't it always be at least 1K aligned?

So, what does "the system PAGE_SIZE is increased beyond 4k...." mean
regarding to this? The only possble way I see here is the MMU used
with a e.g, 512B page size, so the returned adress could be 512B
aligned, which couldn't fit for UTRDL. But is that possible? I doubt, or
maybe I am missing something, please correct me.


> Thanks,
> Avri
>>
>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
>> ---
>>   drivers/ufs/core/ufshcd.c | 18 +++++++-----------
>>   1 file changed, 7 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
>> 8f68e305e83c..89737f0c299c 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -3916,18 +3916,16 @@ static int ufshcd_memory_alloc(struct ufs_hba
>> *hba)  {
>>          size_t utmrdl_size, utrdl_size, ucdl_size;
>>
>> -       /* Allocate memory for UTP command descriptors */
>> +       /*
>> +        * Allocate memory for UTP command descriptors
>> +        * UFSHCI requires 128 byte alignment of UCDL
>> +        */
>>          ucdl_size = ufshcd_get_ucd_size(hba) * hba->nutrs;
>>          hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
>>                                                    ucdl_size,
>>                                                    &hba->ucdl_dma_addr,
>>                                                    GFP_KERNEL);
>> -
>> -       /*
>> -        * UFSHCI requires UTP command descriptor to be 128 byte aligned.
>> -        */
>> -       if (!hba->ucdl_base_addr ||
>> -           WARN_ON(hba->ucdl_dma_addr & (128 - 1))) {
>> +       if (!hba->ucdl_base_addr) {
>>                  dev_err(hba->dev,
>>                          "Command Descriptor Memory allocation failed\n");
>>                  goto out;
>> @@ -3942,8 +3940,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>>                                                     utrdl_size,
>>                                                     &hba->utrdl_dma_addr,
>>                                                     GFP_KERNEL);
>> -       if (!hba->utrdl_base_addr ||
>> -           WARN_ON(hba->utrdl_dma_addr & (SZ_1K - 1))) {
>> +       if (!hba->utrdl_base_addr) {
>>                  dev_err(hba->dev,
>>                          "Transfer Descriptor Memory allocation failed\n");
>>                  goto out;
>> @@ -3966,8 +3963,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>>                                                      utmrdl_size,
>>                                                      &hba->utmrdl_dma_addr,
>>                                                      GFP_KERNEL);
>> -       if (!hba->utmrdl_base_addr ||
>> -           WARN_ON(hba->utmrdl_dma_addr & (SZ_1K - 1))) {
>> +       if (!hba->utmrdl_base_addr) {
>>                  dev_err(hba->dev,
>>                  "Task Management Descriptor Memory allocation failed\n");
>>                  goto out;
>> --
>> 2.43.0
>>
> 
> 

