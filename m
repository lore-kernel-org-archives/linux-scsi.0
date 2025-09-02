Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF4C22DF95;
	Tue,  2 Sep 2025 05:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756791152; cv=none; b=Qw+CVWR4r/iK3Gp2E4+9IRsiNRu1r7CpWl/SgpOXNhmCdTCmPvUGnKJ1twUT/0iM/Qr5DtBCwjmCU685WyMt/o1qekqbqfUEfCf4ndB+6WUdSsX/kUudrFP4eugVsbnFIrdUfF9G4wwu01tNxmRLqn02oDmRbLmCX0/1jc914t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756791152; c=relaxed/simple;
	bh=iO1lNAOJ9UudohzsLJsV+rFUHcI4isX+6IbpLMgedBE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e1haV0FnwQAzthXJTdx3uT1NHa+gv3Yfmq6xBAnWisyeFZfQCNTHTgTcwzlSilnaKhJp3cBUXPF2aPUXLEcPy81FIRZp/PCZGSxxhwXbxeFbUElq5pniMGggYeOdz9USzA7pJ6xtMjeZjWni76itL3iHwSeP4Zd9ff6xkbkcMe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cGDnY0Flbz24j3D;
	Tue,  2 Sep 2025 13:29:21 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id EF7EF1A016C;
	Tue,  2 Sep 2025 13:32:25 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 13:32:25 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 00/14] scsi: scsi_error: Introduce new error handle mechanism
Date: Tue, 2 Sep 2025 14:03:13 +0800
Message-ID: <20250902060313.2536037-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <04ca315e-e375-40ab-8596-613f8d453008@kernel.org>
References: <04ca315e-e375-40ab-8596-613f8d453008@kernel.org>
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

>Use write long command to "destroy" sectors. Then try to read them. That will
>generate uncorrectable read errors.

There is a misunderstanding here, the condition that triggers this error
handler is when the device is slow or unresponsive, or fails to start;
bad blocks refer to data errors rather than faults.

