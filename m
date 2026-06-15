Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3800837EFE7;
	Mon, 15 Jun 2026 06:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781505596; cv=none; b=DYB1cjW/faVEhLWBW9e2ljWAF0v8E66Isf9Z/FwUF/XrDLHZwBNSetYcisVmb4sdgyKw8BUj2mnozXx4gR85S34hxdc2VSNMs65qW6A08yH6rF0HAYbuF3P1nMOW6nqfvDjLjdvhSYT6mVD4V14/S/BUCQrCi/+adFBiWrQ29Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781505596; c=relaxed/simple;
	bh=LHjT5Vx45M/3GZPUIa2Rs7oC/bDLodd7rgnVJBygwc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DiIpSZYxc7sWzyUsKMfRNtjqBPkf6q0qn/Pf8WOWMrOUo15LAyWg8vmpbzBfXWy6+EROwXApULB74D9SZXr62tbdtDChA+OZoL44vtiWnFDZkyRRawqq6n5a/S6VDYkXxbGoBv5kyQoxsnJ72bDFSdJW7TfeVn0ljPkySrRLIlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Kp28UWhD; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Kp28UWhD"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=K52ZEk0yalvKezo+LKQizzr77iPgMILxLtqWdjpyYig=;
	b=Kp28UWhDXGCYGkXCsKi+WG63wlygEx9QTUflDUpZh1IcbAhyg3eqfdVBdn+1/iFyW4BnIcSal
	ZtTPWnVKVZQnRdluXFz7F3Jq/BRPp2DTSBxdnKlJemJyxTY+Xgs2p+Kxe//KkOMkSNfcgc6PkX1
	P1lria1oM2gbokHdMCXJUOo=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gf0dg3LBCzmVD6;
	Mon, 15 Jun 2026 14:31:51 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id EB2C440565;
	Mon, 15 Jun 2026 14:39:49 +0800 (CST)
Received: from [10.174.179.11] (10.174.179.11) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 15 Jun 2026 14:39:48 +0800
Message-ID: <8c37dc76-bcf6-4146-b3bd-977bb34ad4c4@huawei.com>
Date: Mon, 15 Jun 2026 14:39:48 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
To: Xingui Yang <yangxingui@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260611061551.1171058-1-yangxingui@huawei.com>
 <20260611061551.1171058-3-yangxingui@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <20260611061551.1171058-3-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/6/11 14:15, Xingui Yang 写道:
> In sas_rediscover_dev(), when detecting a "flutter" condition (same SAS
> address and compatible device type), the code assumes the device remains
> unchanged and only handles SATA pending state recovery. However, this
> approach misses two important scenarios:
> 
> First, the flutter detection only compares SAS address and device type,
> ignoring potential linkrate changes that may have already occurred.
> 
> Second, after sas_ex_phy_discover() re-queries the expander phy, both
> linkrate and attached SAS address may be updated. The current code does
> not validate these changes against the existing child device.
> 
> Additionally, the replace code path (different SAS address detected)
> has a sysfs duplication issue: sas_unregister_devs_sas_addr() only marks
> the device as gone, but the actual sysfs cleanup happens later in
> sas_destruct_devices(). Calling sas_discover_new() immediately after
> unregister causes sysfs_warn_dup() errors.
> 
> Introduce sas_dev_is_flutter() to check whether it is a true flutter with
> validation for linkrate and sas_addr changes. It returns true for normal
> flutter and false when changes are detected requiring rediscovery.
> 
> When sas_addr change is detected, restore phy->attached_sas_addr to
> child_dev->sas_addr so that sas_unregister_devs_sas_addr() can properly
> match and unregister the device via sas_phy_match_dev_addr().
> 
> Introduce sas_rediscover_ex_phy() to handle async rediscovery for both
> flutter and replace cases. When invoked:
> - Set phy_change_count and ex_change_count to -1 to force revalidation
> - Unregister the device via sas_unregister_devs_sas_addr()
> - Queue DISCE_REVALIDATE_DOMAIN event
> 
> The old device sysfs is cleaned up by sas_destruct_devices() at the end
> of current revalidation work. The new event triggers discovery via
> sas_discover_new() since attached_sas_addr is cleared, avoiding the
> sysfs duplication issue.
> 
> Signed-off-by: Xingui Yang<yangxingui@huawei.com>
> Suggested-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 82 +++++++++++++++++++++++++-----
>   1 file changed, 68 insertions(+), 14 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>

Thanks,
祝一切顺利
