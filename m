Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89CCF9E8
	for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2024 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725067641; cv=none; b=ny6MZXSFuMnrmhMuCg/VHfaLeIAEPtJYHMun5ifsCuyv3/1czU/XP24prsbKYYHvde9PnG1KDkGtFpEdbksubs3r2LyfcL/39UqUmhXL4lCvHpLPFvh6xmQpgUbB7gpaEYrclLgUDsUIbWqQwNCRhaf1whJWwH8o7Hn1npD0esU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725067641; c=relaxed/simple;
	bh=g/OnUBPLxlpbF7OlSOUKWKXZ5idKQLDc8XY0snedp6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Y5Xx9atrQeoxmeZriMxHvn8ugUx4or/v9PbNC0GAB1HbXpOZBjK6RiXFyyWwcdK1uOy7brcpL5f402mNSi9gFF8pCeXQO2EXE99gGOtRckSC78yLGfnM8WuPK3zmXe+EFCmwf2UtBE2U1/22RdRjMH2wLxGJgpRQZsFdmLm6JD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WwcnJ47Y1z1j7sr;
	Sat, 31 Aug 2024 09:27:00 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 1924E140109;
	Sat, 31 Aug 2024 09:27:15 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 31 Aug 2024 09:27:14 +0800
Message-ID: <d71bcac0-1adf-4375-9998-4bd1ad6f14f2@huawei.com>
Date: Sat, 31 Aug 2024 09:27:14 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] scsi: qla2xxx: replace simple_strtoul to kstrtoul
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>
References: <20240830080505.3545641-1-lihongbo22@huawei.com>
 <bafcca6f-a23c-4c31-a982-b553a96c3dad@acm.org>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <bafcca6f-a23c-4c31-a982-b553a96c3dad@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/8/30 20:13, Bart Van Assche wrote:
> On 8/30/24 4:05 AM, Hongbo Li wrote:
>> -    num_act_qp = simple_strtoul(buf, NULL, 0);
>> +    if (kstrtoul(buf, 0, &num_act_qp)) {
>> +        pr_err("host:%ld: fail to parse user buffer into number.",
>> +            vha->host_no);
>> +        rc = -EINVAL;
>> +        goto out_free;
>> +    }
> 
> The message "fail to parse user buffer into number" is a bit long.
> "failed to parse" is probably sufficient.
> 
> Additionally, has it been considered to assign the kstrtoul() return
> value to rc instead of discarding the returned value?
kstrtoul can tell two error which are ERANGE and EINVAL. rc can keep 
return value from kstrtoul, and it won't affect the original code. Can I 
use rc to hold the return value from kstrtoul?

Thanks,
Hongbo

> 
> Thanks,
> 
> Bart.
