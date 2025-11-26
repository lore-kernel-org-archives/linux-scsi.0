Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750B730C345;
	Wed, 26 Nov 2025 03:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764126460; cv=none; b=kfSdIR/mlwStE5WVs63Nd0SHiaXyFNWv8i2unz9P4QZVKaBRwd3CcRwOOKKPhQ507IeFuUb0sy6pGkUzbYL/Z42RfBkQNl0tZv3DmKiRZF/U6H4UufV+k8GZdMHUgPT/F900n6z+5h/88GU6TIzS1ExSQAJEOeoXips4aEA+bvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764126460; c=relaxed/simple;
	bh=atienjZ8/nJxpNvYl4cKkbxi6Ko4q/QjODbpdYtnKt0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i/V9kvRtwfa7mzZH9yHkI3C52ENxQS9E1yMAwxXeQ1CSVNxjLWXeA/Y4Fiow9ZCkhv16TnU7g1V9F+7uNRj1SjS2jOv+8lqvCOYi4mmNDnpFMS1RL6tjfMwzWIK4QH7Kwqk/r+umb+FM3MDTnDSDN91zPsoBxTGhahiGvZ0tKUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=OAlZczY8; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="OAlZczY8"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=atienjZ8/nJxpNvYl4cKkbxi6Ko4q/QjODbpdYtnKt0=;
	b=OAlZczY8zuhTSRkcVm/F8TMDKgRoNoSBkQN6r8OP6y9jhpwOXhHTR4DpJXemNTmCvwMbQkWXF
	kizw+zivquSInUDw41EKuuGxyP5XSaEdmwGr9yx2UynQdJ6hinED1cF8tkAk2hD6cfhBpnHsLzu
	NZzcEV71H8dByhTmdWjXTME=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dGPZm1vFRz1T4FX;
	Wed, 26 Nov 2025 11:05:52 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id A68511402C3;
	Wed, 26 Nov 2025 11:07:34 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 26 Nov 2025 11:07:33 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <hare@suse.de>, <dlemoal@kernel.org>, <yangxingui@huawei.com>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<wubo40@huawei.com>, <jiangjianjun3@huawei.com>
Subject: Re: [PATCH] scsi: scsi_error: the Error Handler base on SCSI Device
Date: Wed, 26 Nov 2025 11:07:28 +0800
Message-ID: <20251126030728.2275040-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <b62930b3-9b80-4b06-b922-c38c7e309048@acm.org>
References: <b62930b3-9b80-4b06-b922-c38c7e309048@acm.org>
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

> The current behavior should be retained as the default and the new
> behavior should only be enabled if a SCSI LLD requests the new behavior
> because many SCSI LLD .eh_host_reset_handler implementations are based
> on the assumption that no I/O is in progress if they are called.

However, the Device-Error-Handler does not call `eh_host_reset_handler`,
but instead calls `eh_device_reset_handler`. Only the Host-Error-Handler
will call `eh_host_reset_handler`. Therefore, any assumptions or designs
made by the SCSI LLD in `eh_host_reset_handler` will not effected.

Even so, is it still necessary to add a switch that allows the SCSI LLD
to decide whether to enable the Device-Error-Handler on its own?

Jun.

