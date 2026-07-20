Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307D623ABBE;
	Mon, 20 Jul 2026 02:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784515046; cv=none; b=o8VE0VZW1+aJcUSUDbwCw/UMGlGLeKiIpllJdSyfZSDopvGVA20LYQJ95woy/lDvMMa3HT6VEgKU06Pc/H2SmSxAuq/t7M7CATdLi2jXdrdR1ix0xzRzqHNcM5VSwE6ikzG1w6ca9+oVWMdQEARx/VQuu8fnSuyRkuQBSOUMMy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784515046; c=relaxed/simple;
	bh=I5+vPH4xw26UEaVBnniVHnNX3kFxqmEpB8FG1aAIqGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TfsHVmKtSCFcWwE6BOkoYx0vEWs5xjnri3L23Vj/S9GxnQ6JpGVAUx/94jD7qlo/63u7iRAZHgbrn6d8iWNJTxbLwRXr1cO5FKM/UCXl0pOvNg9Tl89roPPbVh7kLKizzHSsnoZ0hZ/b5tVjAxq0kggJNgq6284LKjeDNbkefLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=PA7d0Shj; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="PA7d0Shj"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=seTomVHGZbY0laxVvLQOlpfxX85OegHjloFlN6hEPeE=;
	b=PA7d0ShjLxE9qy5pehkh+w33F9f1bnGmq/ru5dq/Z+ym7YztFHoIh/ANslLn5IJDtXHu2RMip
	wTQWBIYln07JUsCi6xh5cEufXqN+eF7RNoTp+nfmCB0qTTD1cDVxcmgfjzOo2dTwdMp6g3sDPZ9
	LnUSQECqlKbSjRW576/yEV8=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4h3PZ05vbYzmV8f;
	Mon, 20 Jul 2026 10:27:52 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 41EA440563;
	Mon, 20 Jul 2026 10:37:14 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 20 Jul 2026 10:37:13 +0800
Message-ID: <8426bc71-99c7-a2a2-7ac8-9a32f610a50e@huawei.com>
Date: Mon, 20 Jul 2026 10:37:13 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 0/2] scsi: support spinup notification for SAS SSP
 devices in Active_Wait/Idle_Wait state
Content-Language: en-CA
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<john.g.garry@oracle.com>, <dlemoal@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260703022833.36847-1-yangxingui@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <20260703022833.36847-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh500008.china.huawei.com (7.202.181.139) To
 kwepemj100018.china.huawei.com (7.202.194.12)

Kindly ping for review...

On 2026/7/3 10:28, Xingui Yang wrote:
> When a SAS HDD connected via SSP (Serial Attached SCSI Protocol) is powered
> up with the RNOT (Ready Not Optimized) bit set, the device enters the
> Active_Wait or Idle_Wait power state per the SAS protocol specification. In
> this state, the device does not respond to standard SCSI START_STOP spinup
> commands and instead returns NOT_READY with ASC/ASCQ = 0x04/0x11 ("Logical
> unit not ready, notify (enable spinup) required").
> 
> Without handling this condition, the SCSI mid-layer will indefinitely retry
> the command with ACTION_DELAYED_RETRY, resulting in the disk never spinning
> up and becoming unusable. A typical manifestation is:
> 
>    sd 4:0:9:0: [sde] Spinning up disk...
>    ...not responding...
>    sd 4:0:9:0: [sde] Sense Key : Not Ready
>    sd 4:0:9:0: [sde] Add. Sense: Logical unit not ready, notify (enable spinup) required
> 
> To resolve this, the SAS controller needs to send a NOTIFY(ENABLE SPINUP)
> primitive to the target phy, which transitions the device out of the waiting
> state and allows normal spinup to proceed.
> 
> This patch series addresses the issue:
> 
> Adds a new optional spinup_notify callback to struct scsi_host_template
> in the SCSI mid-layer. When ASC/ASCQ = 0x04/0x11 is detected in
> scsi_io_completion_action(), the callback is invoked before the mid-layer
> falls through to ACTION_DELAYED_RETRY, giving the LLDD an opportunity to
> perform controller-specific spinup notification.
> 
> Changes in v2 (addressing Sashiko AI review on v1):
> - Add softirq context documentation to spinup_notify in scsi_host.h
> - Defer sl_notify_ssp() to ordered workqueue, fixing msleep-in-
>    atomic bug, preventing RMW races on SL_CONTROL, and deduplicating
>    concurrent callbacks via queue_work()
> 
> Xingui Yang (2):
>    scsi: scsi_lib: add spinup_notify callback for ASC/ASCQ=0x04/0x11
>    scsi: hisi_sas: add spinup_notify callback to handle
>      Active_Wait/Idle_Wait SSP devices
> 
>   drivers/scsi/hisi_sas/hisi_sas.h       |  2 ++
>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 34 ++++++++++++++++++++++++++
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  1 +
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  1 +
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  1 +
>   drivers/scsi/scsi_lib.c                |  4 +++
>   include/scsi/scsi_host.h               | 12 +++++++++
>   7 files changed, 55 insertions(+)
> 


Thanks,
Xingui
