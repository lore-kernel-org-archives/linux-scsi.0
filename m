Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747C52676C9;
	Tue,  2 Sep 2025 04:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756789194; cv=none; b=fr5XcMrkenOMZXiVE6YBdpJPwpAHkyP66RQwRk6oIHDzSpUI/P2oTEJWs6KlJPWy7kAubXsa+xP5mCQ8qE54vFhMbnRE2HKLVWUC8vHiES5t4Y48HrXvdo1w76no5uy258dSWY832QlBIAYZkXAkgR+etrXRsRJKmjlee2c4qX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756789194; c=relaxed/simple;
	bh=d1Opvqhnqh4lsETZw90Yw3zLXFNrlp2nj9ljTSrTBOk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TerwKGnscABvldCBC1bZJa7nBLnTRKs8HcH/h1Es3/YurWDbEH9YXrO8Zef2C8UtEICBrSAV0ymh+IKBxmmItPY+riOoqmyt3YmynKSeTiGwdRBdJwKB+0BDHhY0N87s3WT8Di+qBYjYtzscYZTYbkjJW9sWDy8c2P5LMg1kcko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cGD3v0WYVz2VRWY;
	Tue,  2 Sep 2025 12:56:43 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 7EA321A016C;
	Tue,  2 Sep 2025 12:59:48 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 12:59:47 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 00/14] scsi: scsi_error: Introduce new error handle mechanism
Date: Tue, 2 Sep 2025 13:30:35 +0800
Message-ID: <20250902053035.2486666-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <f02f049f-efa3-481b-b681-cf75308bfbc4@kernel.org>
References: <f02f049f-efa3-481b-b681-cf75308bfbc4@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk500001.china.huawei.com (7.202.194.86)

>Barely half of your emails have made it through for me and they landed in my
>spam folder. So please check your email setup.

I also find it strange, but my colleague can receive it. Maybe i reset email
and send again? 

>Also, was this all tested with libata and libsas attached devices as well ?
>They all depend on scsi EH.

There is currently no tool available for injecting faults into hard drives,
but we have implemented this solution in our company's products. So i just
test with scsi_debug.

