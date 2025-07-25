Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47501283FE9
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 06:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753424462; cv=none; b=fkpRhHxKHPvMNKO+v5ENzJD381o7paesDJ0kw5IezPvbSjbL0us2Y32PhlaDL5bCOuthgu87BVSohWoM0T5IQxE1Zm/JRpZoAznXEx8S4xds6oY06r9IsPYBsUHrCxnAAUatMzNJ6v9X7meH4QNg00yUoiRhDJkbtQmnsJzkzVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753424462; c=relaxed/simple;
	bh=IVdxuP3EcNUiK3Uo0CABOPfc26RZHAWvDNN9+JkhrXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CCKtK/EgdfY7i/MEhxv/yFfHLQApbxEPxsiH2iaQndXvZsyzJVwUSkjp2G8nYjBfO1BPw7yN79BPQta/Ig5LJWHvmMf3WAmHdfPpfd4bvJLY1FhHfmW8S4R0huBnBu0ArMoKrwFrwVrdQQzOUuIyfkW6I1Vd1J0dl75EKJP9Igk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bpHls3HMqztStV;
	Fri, 25 Jul 2025 14:19:53 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 2427518006C;
	Fri, 25 Jul 2025 14:20:57 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 25 Jul 2025 14:20:56 +0800
Message-ID: <754bfd00-f06d-4377-8999-3e11ea9e3fcc@huawei.com>
Date: Fri, 25 Jul 2025 14:20:55 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] scsi: libsas: Simplify sas_ata_wait_eh()
To: Damien Le Moal <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>, "Martin
 K . Petersen" <martin.petersen@oracle.com>, John Garry
	<john.g.garry@oracle.com>
References: <20250725015818.171252-1-dlemoal@kernel.org>
 <20250725015818.171252-3-dlemoal@kernel.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20250725015818.171252-3-dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2025/7/25 9:58, Damien Le Moal 写道:
> Simplify the code of sas_ata_wait_eh(), removing the local variable ap
> for the pointer to the device ata_port structure. The test using
> dev_is_sata() is also removed as all call sites of this function check
> if the device is a SATA one before calling this function.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>
> Reviewed-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_ata.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
