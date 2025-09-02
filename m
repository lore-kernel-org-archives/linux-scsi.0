Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1E354652;
	Tue,  2 Sep 2025 05:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756790752; cv=none; b=ShgEL2UUnBfD1iiIkU5Tjfxz+W67B/qyIcxYYKWsOyKY75Ch35oLBVwKmc6xRNDBFk02lVymhUvV+81RUL9OLbk0DHGF5IfPcuuBjN+Kb+jxnaAOFfgx9hPkvUG+Z80VaIACyrAdPtW1EWF1GuKJYB/QMpUptIknvVhpMlWlV/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756790752; c=relaxed/simple;
	bh=Edb5dwU4QvcqbknGt64YIP/IHrA1tAFqQjzkUztbUx4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzwMJGCB7rMY1vd1CyYJXSb3Ku4NvwY3bDN6Ee/tRgd8SOcG2Nb7L73RP1Zqx8t9m9a14PQGj14GymIssl7GsPV48T/G3dSenthXDjIS+l5A3c4+6heiUCq35hE4DsWUbRbcsGxoin5bZdiw29VtcXL/bLdg1DmjgbKaSvrmXCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cGDc75zW0zdclP;
	Tue,  2 Sep 2025 13:21:11 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 92153180490;
	Tue,  2 Sep 2025 13:25:40 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 13:25:39 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <hare@suse.de>, <linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 00/14] scsi: scsi_error: Introduce new error handle mechanism
Date: Tue, 2 Sep 2025 13:56:28 +0800
Message-ID: <20250902055628.2524926-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <17230842-0a7a-403e-abc7-a15e3aa5d424@suse.de>
References: <17230842-0a7a-403e-abc7-a15e3aa5d424@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk500001.china.huawei.com (7.202.194.86)

>I fully agree that SCSI EH is in need of reworking. But adding 
>another layer of complexity on top of the existing one ... not sure.

Perhaps it would have been better to use only the error handler on the
device from the start. Users might wonder why a single disk failure
could cause other disks to become blocking.

>Additionally: TARGET RESET TMF is dead, and has been removed from SAM
>since several years. It really is not worthwhile implementing.

Hmm.

>Can't we take a simple step, and just try to have a non-blocking version
>of device reset?
>I think that should cover quite some issues already.

Do you think it's necessary to escalate the issue after the device reset
fails? Should we reset the bus or the host? 
Moreover, a failed device reset does not necessarily indicate a fault
with the target or host. 
And what means of "non-blocking"?

