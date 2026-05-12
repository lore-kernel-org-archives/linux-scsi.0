Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0868397B08;
	Tue, 12 May 2026 13:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778591913; cv=none; b=nPULKLiwxHY8lHZTXaMnLatDlHupn3KrddEcZp9TnyhIkXwVfkdjG0wJ2W+j+yDoZk/6YBRPsh8jsrkXdh43PcRUVbI3WnijW2YkjnvYZhenOjbns7N5M+kaTgMWbeDOnnIlkZUMrDM3y8Cwa0WOmrQojf1XJgOOp0RmFqDvcuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778591913; c=relaxed/simple;
	bh=Uqvi7mTQOjfbF8LvcWgP0J/HCrtQ7KOAxVhybe6+720=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ivH/pFJ5hj6zZGcYtrZkESytpnRrDiF+QhP0eE1sVA9p337wVz2Xo8CDiVgHlKdQmueVxKnR8odsSAzdBGIxfD9Z5x+5mzSfA4Jofb3Oj3QRSA5aa/Wo9WCGuEdyxj8Wq1g/Bvo6kaW/JIZtZU4r7yIyE4bAHqCDAC8PoKN/Oi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=vJ16uOdH; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="vJ16uOdH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=31tYX4+VG7i4jQXxMONKUGCq02DhrTsTCvk8PT4+ePE=;
	b=vJ16uOdHVP3Gs/Vtho4V6WXhq8Gvd0sIOH+OaWgDPifgKM24su00jn/YvWz6OupHBDKDqs2Ji
	3NByShl1jBl1TdRsDENXytkvQBPUb17GgryIYm6d8h8CFJF8wCheydPERrJC8Ifh7SeTnYZRW30
	PqACzN6ldiyfpEsDZ1eA7O4=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gFH5h1Fkgz1T4Mb;
	Tue, 12 May 2026 21:10:48 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B17240538;
	Tue, 12 May 2026 21:18:28 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 May 2026 21:18:27 +0800
Message-ID: <9c4a1438-bd8f-4107-a519-a222e20f5da6@huawei.com>
Date: Tue, 12 May 2026 21:18:26 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: handle linkrate change in
 sas_rediscover_dev
To: Xingui Yang <yangxingui@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260512071226.2299741-1-yangxingui@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260512071226.2299741-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/5/12 15:12, Xingui Yang 写道:
> When a device attached to an expander phy experiences a linkrate change
> (e.g., due to cable reconnection or negotiation), the current code in
> sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
> if the SAS address and device type remain unchanged.
> 
> However, for drivers like hisi_sas, the ITCT entry needs to be updated to
> reflect the new linkrate. Without this update, the hardware continues
> using stale linkrate information, which can cause performance issues or
> protocol errors.
> 
> This patch introduces a new LLDD callback lldd_dev_info_update() to notify
> the low-level driver when a device's linkrate changes, allowing the driver
> to update its hardware structures accordingly.
> 
> Additionally, refactor sas_ex_to_ata() to use a new helper function
> sas_ex_to_dev() which returns any device type attached to an expander phy,
> improving code reuse.

Could you split this refactor to another patch? This makes it easier to 
review.

祝一切顺利
Jason
