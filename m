Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EAF3446C7;
	Fri, 14 Aug 2026 06:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689038; cv=none; b=sQFxbeFCWJmFNfh4mGvUeS2kHN7IdrrDoKQMQQPNJvrYoPcEvniLC6ZPre0jCX+nRVrq19lcHtzQ2J0yWAdSMEnWjr24ZuqXxgHgvkRMjIJpODGCRBbI0U5uRxijZKlmYH8SxLj3n3TU0YSieECvKYGvuWPC+uhwsKhpPb2CW0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689038; c=relaxed/simple;
	bh=7k81mPPKIJ1iS2RGHopyYxmLfV+X8jy39qtcdoN0hwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=vBM4N6FsQzrhFpppPRRtrM7BlV59foGDQqxvfEs3lojLnakldV7ADG95JoJk7ftAtzKngUCSm8AUxbSuB/7YJewiEVx0c+2GdXD7Od5jzUtr3S3cpw6ONhuAda+4+EO00+PLT8V4iEe1qKagLcTDnHOTzQ5ZI2oZ8SJ4BoiIcoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=zbtr+7/V; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="zbtr+7/V"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bSPopB0F2+cLBBCgTmOaAqUoDLk4Fkhd4gi/K500DIc=;
	b=zbtr+7/Vc3BFXJs8AZfS+86mXjm4dI+/0d1DjkmQd8Z8dUSpNIfClGkzOoIt99YhQLxTA1tiB
	2Waul3HOQ/WFxbowkLV2HIAiinTrt/oT7arZm5BTLGtkRB9+H8joM5rp/Lg3u0Z6TdHN2I8C2uG
	X7OTQRRzepXqX4nwV4ENPEQ=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hLsXg2wHTzcb3P;
	Fri, 14 Aug 2026 14:20:19 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 1116140538;
	Fri, 14 Aug 2026 14:30:30 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Aug 2026 14:30:29 +0800
Message-ID: <8512627f-b842-4eb7-b13b-cc28e60902be@huawei.com>
Date: Fri, 14 Aug 2026 14:30:28 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 1/2] scsi: libsas: Add sas_ex_phy_to_dev() helper
To: Xingui Yang <yangxingui@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260811040334.4184911-1-yangxingui@huawei.com>
 <20260811040334.4184911-2-yangxingui@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260811040334.4184911-2-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/8/11 12:03, Xingui Yang 写道:
> Add sas_ex_phy_to_dev() to return any device type attached to an
> expander phy, and refactor sas_ex_to_ata() to use it.
> 
> No functional changes intended.
> 
> Signed-off-by: Xingui Yang<yangxingui@huawei.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 13 +++++++++----
>   drivers/scsi/libsas/sas_internal.h |  1 +
>   2 files changed, 10 insertions(+), 4 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
