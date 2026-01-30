Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2BC23BCF7;
	Fri, 30 Jan 2026 08:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769761638; cv=none; b=oTdYV3DPLfvH6vWkrd3WkTO3PLWj8PcV7SgWUFNAr7HrTG1wP5Cqf0C8Qbl+oHQ+buuiZhMS+PYUPEclDrFKEVJpiARniP2SIu2LN40WMuje758MHMA378k0yptXqQOKV/1rVAxgzrfoqeWwNC4C9Q/Etj7ql9D4OdwQ4jNSmq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769761638; c=relaxed/simple;
	bh=pwB5nIOvc2torqBLmc4QlJ5S6T9A7KVllafGb+Ku16Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=e2SroNdHPPn4hvD/t5ENJNJLXW12zSaLs1NXVmCDzqXit6PP0QfRGl/iKec/CcKd8GZcViPmZkrRtjmfUWE1MuorAaKlvxKWfOidUemym87fU9wPvH/gX2jdx+ZglgMIQOxw1hX8Ei5gXLDVMHUXlDMlGULmdUrz8oMG7LKkONs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=f/dEHE5h; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="f/dEHE5h"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pwB5nIOvc2torqBLmc4QlJ5S6T9A7KVllafGb+Ku16Q=;
	b=f/dEHE5hPhP5hYl+KMWwXs2jF2yFSYOC3a0Lj8A1KRNBWrOKsu1I7IAWJph/Q/eeQUKW/nvOM
	uiKKG33qOzgUlRU3MIIIb5SN7KYS4g67enoBwvF79d8mDNL1qquLOLQLn5CKf+w4zwXERJUELpU
	Tg3hy8jq1zgbZTtSEY32WrI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4f2TYV28vLz1prKM;
	Fri, 30 Jan 2026 16:23:42 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 5950040538;
	Fri, 30 Jan 2026 16:27:13 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 30 Jan 2026 16:27:12 +0800
Message-ID: <e59ff23b-81d3-41b7-ac25-ab886a3379bf@huawei.com>
Date: Fri, 30 Jan 2026 16:27:11 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix dev_list race conditions with proper
 locking
To: Chaohai Chen <wdhh6@aliyun.com>, <john.g.garry@oracle.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<dlemoal@kernel.org>, <johannes.thumshirn@wdc.com>, <mingo@kernel.org>,
	<cassel@kernel.org>, <tglx@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260129093859.1418749-1-wdhh6@aliyun.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260129093859.1418749-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Hi,

在 2026/1/29 17:38, Chaohai Chen 写道:
> Multiple functions in libsas were accessing port->dev_list without
> proper locking, leading to potential race conditions that could cause:
> - Use-after-free when devices are removed during list traversal
> - List corruption from concurrent modifications
> - System crashes from accessing freed memory

libsas events are processed in orderd workqueue. Do you have a crash log?

Thanks,
祝一切顺利
