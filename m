Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D453A7;
	Sun, 17 Aug 2025 08:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755418528; cv=none; b=Bg2D4OyGRCHjVxup8mdk4H5GRD8HUk/iuaixg2+n5XtJ0KUxF+6l/2SzLyqsDU3ogdMdBXbxeCdwpXVVmHx8bjRVVHlqjmYH0X6c4dN6BYVqEy05sNmrowhOQrDRydrVbv2MXL6Jk4DingkJ9StwwsUT+db7wVWLRu8i7ykGzMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755418528; c=relaxed/simple;
	bh=8eGpRLEnXOEIrwJWExVSb4pmH7LNtWDNvC/pY+U/3ks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NL/YVAX8qF9whqM/j16ttUDJH5ZikXn0KaN131A0RFIfMjC0R7sTxFJUwQP5C/yVviZAiWWMGd6hmah/hoHHYvblovbluxA8Iz2oxWB8zYd6EmA+eB4kvFz7hv/Gp7dNEJVLAlXmR4TUI2oleSKpoUIBlyjj5vIb8H1hKRqHZmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c4T7T2fp6zdc9c;
	Sun, 17 Aug 2025 16:11:01 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 00B9F1402DA;
	Sun, 17 Aug 2025 16:15:23 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 17 Aug 2025 16:15:21 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 00/14] scsi: scsi_error: Introduce new error handle mechanism
Date: Sun, 17 Aug 2025 16:46:33 +0800
Message-ID: <20250817084633.1409286-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
References: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk500001.china.huawei.com (7.202.194.86)

I apologize for taking too long to test and modify these patches.Here
are the revision points, with the first two being the main ones:
  1. The scsi_target.can_queue value can control the increment and
    decrement operations of scsi_target.target_busy. The new error
    handler also needs to adjust target_busy. Both Bart and Mike opposed
    removing this control condition. In this version, I have only added
    the error handler check when scsi_target.can_queue <= 0.
    link: https://lore.kernel.org/linux-scsi/daba5c92-2395-4eee-b212-978fbe83b56f@oracle.com/
  2. I have added callbacks for setting and clearing the error handler
    in scsi_host_template. Drivers can support device or target error
    handlers by setting these callbacks. I believe the advantage of this
    approach is that driver developers will be aware of this feature
    when they see the callback prototypes and comments, and it can be
    used even without device or target initialization callbacks.
    However, this means that the modparam controlling the enablement can
    only be removed. I have considered adding configurations only for
    the virtio_scsi and iscsi_tcp drivers. 
    link: https://lore.kernel.org/linux-scsi/b8350de1-6ac8-4d5f-aaa7-7b03e2f7aa93@oracle.com/
  3. In scsi_eh_scmd_add, a return statement was added under the
    condition of xxx_in_recovery because each branch ultimately calls
    scsi_eh_scmd_add_shost, which does not fail. Therefore, continuing
    further would result in duplicate additions.
  4. The return type of ->is_busy was changed to bool. 

I have retained the original content of Wenchao's email in cover letter.

