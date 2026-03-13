Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0642F5328
	for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2026 01:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773365740; cv=none; b=f/MLq7d4Up2HxXucc2VpABkeqWhp6FkS1cM+dyMrxQXV1NZ2p5UzMpb7VH9MyPH6++CiTgnFCfaJCNde4KRKtF9r6r+jTsUXzYM8jj08kU8dCGMWEcPsOmkC2sn8oHPhSrwF3Or4q3x9qdQcqIicg/vGziNhGHTWnJYo/T2gPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773365740; c=relaxed/simple;
	bh=ydxrLyCF5Aq69CWOb0JG+87G8HeOZtzzK0LFGFlFzPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=clOIyoyJsdYqKxMJDQAYXwKMnsShc38qGDkkMKubV2t9fN2CsrhLyfhfSEAP24jkZELEKdehZHaEqba5/6NbGT/7aO7TH9/1f0bSjmngaI2zLpXhTe3QkunXKnrp4RoI4rOuMO/mg3vydWay5WnrXb1KISYV25iQ6tQfe68HuMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=RVndYDAo; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="RVndYDAo"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oTjj8GDAS+SbEMAfQFA9hlIDPeizDEAK41Ydbne7Kh0=;
	b=RVndYDAoou2CDBnd/Qvjmdaiub2OlOlC+TRSCyQiL0ctuJ+Koy3oYe+qUEiOfAdM8SOBmbNfj
	GWMZ5LPIAOKtmfw9YI0p5B7WciDf7OYMOxrmWKOt6DSmDrd8yZKIOitKE27f5gsd+e3HF0kHgG5
	YI6KTGxnAoQPDw4rop86YFk=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fX6P772qwzpT0t;
	Fri, 13 Mar 2026 09:30:19 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 73CD340363;
	Fri, 13 Mar 2026 09:35:34 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Mar 2026 09:35:33 +0800
Message-ID: <bf6eaa23-bf8a-4919-8165-114923a8f808@huawei.com>
Date: Fri, 13 Mar 2026 09:35:32 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/36] scsi: libsas: Prepare for enabling lock context
 analysis
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Nathan Chancellor
	<nathan@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel
	<cassel@kernel.org>, John Garry <john.g.garry@oracle.com>, Kees Cook
	<kees@kernel.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
 <20260312211636.3245119-24-bvanassche@acm.org>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260312211636.3245119-24-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/3/13 5:15, Bart Van Assche 写道:
> Since Clang requires that lock context annotations only refer to
> variables that are visible, modify a __must_hold() annotation.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/libsas/sas_ata.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 61368e55bf86..2340790c9f6b 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -153,7 +153,7 @@ static void sas_ata_task_done(struct sas_task *task)
>   }
>   
>   static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
> -	__must_hold(ap->lock)
> +	__must_hold(qc->ap->lock)
>   {
>   	struct sas_task *task;
>   	struct scatterlist *sg;

Reviewed-by: Jason Yan <yanaijie@huawei.com>
