Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AB113C3CD;
	Wed,  5 Mar 2025 01:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138600; cv=none; b=PyURKWeaLNRuXoIJNUgjkoNnwEWZKf78YIIXv2zIAPrAtOwdggVvKvp/Xo3PbeGbjGDyIQo72v5mNvvFg5PAQmO5eAeSzPqvy/bkNT1tUAcamKKwhfnr4DfaVvWKNJI10x+bhfNc47y2OEhvCvK9ug2x352yu57Zs9VwvcwTyiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138600; c=relaxed/simple;
	bh=tBvn2gr41JoUC1eHNgNoquOj4ynuJM6YbmSVAF9TBF8=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UHFa44gpxzwExisY1qYY1mgj14oVAV02PEdTPwNwitEHxzLkE4yyw7dGn1KVw9g9UPir2v0aTJKgbPeXMP21fXSctsxBMED7Z9Df93s4c7sIcG+qJfuyN9IWnuf6kCcHY8VjwvLJpdzF+CD8b93RVhyRMErVQOehnasBe1jEWt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Z6w4l3hv8z1cyTM;
	Wed,  5 Mar 2025 09:31:35 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 39A9614022D;
	Wed,  5 Mar 2025 09:36:29 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Mar 2025 09:36:28 +0800
Subject: Re: [PATCH] scsi: hisi: remove incorrect ACPI_PTR annotations
To: =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@baylibre.com>
References: <20250225163637.4169300-1-arnd@kernel.org>
 <49419ea6-5535-3612-c1c4-5ac58f2bc012@huawei.com>
 <h7oh3uhuvmulmqkxi5x73bnkmgkodjxemabiqwkrqu3jmbxu2e@p2pmhpxh6nxl>
CC: Arnd Bergmann <arnd@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Damien Le Moal
	<dlemoal@kernel.org>, John Garry <john.g.garry@oracle.com>, Bart Van Assche
	<bvanassche@acm.org>, Jason Yan <yanaijie@huawei.com>, Igor Pylypiv
	<ipylypiv@google.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <c75288a5-9e3c-e4c7-4717-9c04348dc7d4@huawei.com>
Date: Wed, 5 Mar 2025 09:36:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <h7oh3uhuvmulmqkxi5x73bnkmgkodjxemabiqwkrqu3jmbxu2e@p2pmhpxh6nxl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf100013.china.huawei.com (7.185.36.179)



On 2025/3/4 13:12, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Feb 26, 2025 at 11:23:18AM +0800, Yihang Li wrote:
>> On 2025/2/26 0:36, Arnd Bergmann wrote:
>>> From: Arnd Bergmann <arnd@arndb.de>
>>>
>>> Building with W=1 shows a warning about sas_v2_acpi_match being unused when
>>> CONFIG_OF is disabled:
>>>
>>>     drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:3635:36: error: unused variable 'sas_v2_acpi_match' [-Werror,-Wunused-const-variable]
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Looks good. So Reviewed-by: Yihang Li <liyihang9@huawei.com>
> 
> If you put your Reviewed-by tag in a separate line, the tooling that
> most maintainers use pick it up automatically. Martin applied your patch
> (currently as commit 7a9c0476d4073e742f474e71feeef4f54add4bc9 in
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git 6.15/scsi-staging
> ) indeed without your tag.
> 

Ok, thanks for the reminder. I'll pay attention next time.

Thanks
Yihang
