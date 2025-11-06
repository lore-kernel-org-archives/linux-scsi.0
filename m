Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9BF302745
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 11:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428533; cv=none; b=IvZokrHcdrqFSvpzENpudF4oap3U3mo2+9B6Y9xtYW90EWGpBLJBpip+bCd8x6Z2nHxHhUJ/UX+9ZwXS13AdpF7CalBU7fgJ/oFmB6XqXiKONHVYDymv2vmv+wVHAE3tyQECRMMZe18MoTiiMBaq4A/bEjAH0PZXTwtoLrUE4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428533; c=relaxed/simple;
	bh=GltlKS7dWuRIsX2z1RVzRWNjZvSyGjKRSyGO1fN+JYU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ef5hAl5ajoBkfhk+Vsgx57GIWyOs5+kwUcfz2ggFlrPmXgAFOLuqT9K2+4NTGZ35RmABXph9fbs4fo+HgIER6jRvM1DEv6mIpG4eoPGJdzK5dQl2jugUgXdjqa9NbwKdHvSraKObwiFk+prj5BNfScNBOLbiPc8sJZwOMo1ZZpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Vvms37fZ; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Vvms37fZ"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GltlKS7dWuRIsX2z1RVzRWNjZvSyGjKRSyGO1fN+JYU=;
	b=Vvms37fZJGWJCvYExHTTe0tPWW6XRbmiSOaqV7d+oIsLtXqBNm6ezDlIejIBqOb0bT6qWfj3G
	2sF82uK/Gy6SWYF+iYIlH7O+puqxhXDiGvCRsf54OHfnm5QdxzLMdwxYDIdKk0U67ogj6MnKz3I
	eJgaI4Z01f6JhKHsgEd+n2c=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4d2KfN4MWbzcZxy;
	Thu,  6 Nov 2025 19:27:08 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 3CCDF18006C;
	Thu,  6 Nov 2025 19:28:47 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 6 Nov 2025 19:28:46 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <bvanassche@acm.org>, <john.g.garry@oracle.com>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>
Subject: scsi: scsi_debug: make timeout faults by set delay to maximum value
Date: Thu, 6 Nov 2025 20:03:14 +0800
Message-ID: <20251106120314.3272270-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <93816c36-26ae-42e9-bd2e-bf7324279c1a@oracle.com>
References: <93816c36-26ae-42e9-bd2e-bf7324279c1a@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk500001.china.huawei.com (7.202.194.86)

> I got this patch 3x times...
Sorry, command has an error, i thought it had failed, so I sent it again.

> What do you mean by "checked during cancellation"?
&
> I don't know what is meant by "cancel the command properly".
Maybe I shouldn't use "cancel" to describe it; in the code, it's called "abort".
The function `sdebug_timeout_cmd` is designed to simulate a command timeout, by
discarding it. I noticed that you added a check to see if the command was
executed before "abort"; otherwise, it returns a failure.
Therefore, I change discarding to long-long-delay, so that "abort" will succeed.
If we needed abort-failure, we can inject ERR_ABORT_CMD_FAILED.

The fault-injection can be seen this link:
https://lore.kernel.org/r/20231010092051.608007-5-haowenchao2@huawei.com

