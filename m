Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E540480978
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 12:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782995110; cv=none; b=ha+izLncRoB4FnxQN0KzDdLnGDsmzxDzmsrXKaPcNMEaW+Ah5q0YoGFYg1WlKWiaW9DGmVUcTI9GhVLnaAHQHPEv0ND7uQIpRKw2RCg1EltlbFKr+Dt8ORHmg93j7xxfA2MFLgb3bltAoRjH295Py3/nbSG2iCbJ763ion0HlVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782995110; c=relaxed/simple;
	bh=xxJs8Zy3x7HaiihdDCQiQX/xiDvsSQldVEjorNkWsY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=g7+gTQl0vWhZPSpGALw+NXNZvl5D48vfuMYKfjJhmpdDl0CMiG1mzgFb5Zn6w4UbOXOzB7uCMsfR/UvpVo51SmRMifqGdn/a42vphJy6GVqtwfPY2kPqzqx8Zt/mbz7OpqSNulHazmpoAPfPHK2QcJipkgbGwLacl+YP6EWl2rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=GF0WIixI; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="GF0WIixI"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2wPyCJuguvWFu8csi2DRSMqiFZCLQ9A3pa/dFLczro8=;
	b=GF0WIixIdWYxbYaHc7gx387XfXN3WOOTgfmX1UrjKa00FmRUyPalRH8Ye41lno76jqaa+uRNi
	yAG7VyzDvdI+BYljpYFw2mYRF1jrCaHVnJq8W3dyRDfD4Zep25nbrjLmomoTE2d+5oFVJTtOvuG
	pq1IZHadTy4ORooRvhJzk6Y=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4grbSj4blkzRhT6;
	Thu,  2 Jul 2026 20:15:49 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id BA92F2012A;
	Thu,  2 Jul 2026 20:24:58 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 2 Jul 2026 20:24:58 +0800
Message-ID: <948fbaf9-8fc1-c1ce-3fd1-caaa6d9e5a0e@huawei.com>
Date: Thu, 2 Jul 2026 20:24:57 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH 2/2] scsi: hisi_sas: add spinup_notify callback to handle
 Active_Wait/Idle_Wait SSP devices
Content-Language: en-CA
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-scsi@vger.kernel.org>
References: <20260702035724.2059166-1-yangxingui@huawei.com>
 <20260702035724.2059166-3-yangxingui@huawei.com>
 <20260702042042.73C511F000E9@smtp.kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260702042042.73C511F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh200006.china.huawei.com (7.202.181.113) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/7/2 12:20, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Sleep in atomic context (softirq) leading to kernel panic.
> - [High] Unprotected lockless read-modify-write on the per-PHY SL_CONTROL register.

I'll update in next version, hisi_sas_spinup_notify() no longer calls 
sl_notify_ssp() directly. Instead, it queues a new 
HISI_PHYE_SPINUP_NOTIFY work item onto the driver's private workqueue 
(hisi_hba->wq) via hisi_sas_notify_phy_event().


Thanks,
Xingui
