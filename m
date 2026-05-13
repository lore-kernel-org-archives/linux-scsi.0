Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF8C3D3492;
	Wed, 13 May 2026 06:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778653129; cv=none; b=sY1j4rw/eKcHPE5zA9qNOSDnd9fO3PhZPpD2VEIXH6FiAsTYJZ4f3/TZ6piYJip9J12F1QsDpD4fQ0+DXIfAs9XeQ+pNZtSDd+BR8HqiUkPKm+7Cul68SXGgzQLPnPkku33WnhfKr4CPNzB+z29dAignZwsGzvg6MHofjdErBCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778653129; c=relaxed/simple;
	bh=GF7YjI7Yxo3kODHA8MtxSiMb9MW1A70ZL7Nu/CqDeEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SVXxBvqD7LH9awlkKrxfUVxBt3wcFSrRpn/4cJ5Rm1bcg8Dn8NhOQfU5Olr6Sm6CGkHadyVMmT/7UGUsohPUUGtqpGwmZWDm7FDx+gVxbP57dTkNVeCOrfUsuQbGa319sPtACFASFldgOUqAeIKK50JXzQWVqWasEbSUGm64y3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Bp4NGkpi; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Bp4NGkpi"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=w9c9dp0u2GLULfCKgK6ya4GXpmEDIXQXmxfyUvQDzbg=;
	b=Bp4NGkpiZ7bI9RyI1N0Bn/7wmVIyYCl0nWHQtnLei5hz7Z809ts9JO6nIB6c3W9w4Ung4xLra
	sZqkAltEXl/cRBPR1ImqZnv4TCypJ6lkWYl9CJecnNxbdVvRXgUlP2huuGLlfr1CnXtZdyE1LVx
	rSv8XCaQ9HgCvPPnrOdXRpk=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gFjkp1c80zKm4B;
	Wed, 13 May 2026 14:10:58 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id A352C402AB;
	Wed, 13 May 2026 14:18:37 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 13 May 2026 14:18:36 +0800
Message-ID: <55435a58-2d76-44ff-8ad7-99f2901e946d@huawei.com>
Date: Wed, 13 May 2026 14:18:35 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: libsas: refactor sas_ex_to_ata() using new
 helper sas_ex_to_dev()
To: Xingui Yang <yangxingui@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260513021603.3023329-1-yangxingui@huawei.com>
 <20260513021603.3023329-2-yangxingui@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260513021603.3023329-2-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/5/13 10:16, Xingui Yang 写道:
> The sas_ex_to_ata() function checks for an attached ATA device on an
> expander phy. Refactor it to use a new helper function sas_ex_to_dev()
> which returns any device type attached to an expander phy, improving code
> reuse and allowing other code paths to find attached devices regardless
> of type.
> 
> No functional changes intended.
> 
> Signed-off-by: Xingui Yang<yangxingui@huawei.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 12 ++++++++----
>   drivers/scsi/libsas/sas_internal.h |  1 +
>   2 files changed, 9 insertions(+), 4 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
