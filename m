Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B98132483
	for <linux-scsi@vger.kernel.org>; Wed,  6 Mar 2024 13:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709732449; cv=none; b=HwqeO5+7hq1UmXvSj8c19NqWnjpeXUdcMmOPCCAkDEhbI1UPboVGCqmx1Jf1DITiTADmO7iqvr/7m+/U+KtSyUQ++Vadpr4XzRwIDAiguSXDchbEIXkw1O64wbbo3Dq7RmgwIjfGh804lETPqMX6QBJHZr2pSrrHbha22ZhFxJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709732449; c=relaxed/simple;
	bh=UQtvWBiF4mHqs9nsWZDwcDVTQAkPDosmzIHY2G8Vl74=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SGfcvaReNoC9lpHFMyKNmEsX1PvWLx5YgGwIIQ3ThqCfYWGOOTxgVmfyoYGBnCWGPmJRvR/Q6VszUEsdWnXPca1reOQ2APB6bRWHytJbiiPZxR5tJGk5gI5/kv7JlF1N1RP+8uSxitd5XsQRZH9yytxaam8IgWL2D/49aN0ZKX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4TqYT83wDQz27g16;
	Wed,  6 Mar 2024 21:39:56 +0800 (CST)
Received: from kwepemm600012.china.huawei.com (unknown [7.193.23.74])
	by mail.maildlp.com (Postfix) with ESMTPS id C817F14011A;
	Wed,  6 Mar 2024 21:40:36 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 21:40:36 +0800
Message-ID: <f5d0c425-22ce-4035-8284-3dbffa82751e@huawei.com>
Date: Wed, 6 Mar 2024 21:40:34 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv8 00/10] scsi: EH rework, main part
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen"
	<martin.petersen@oracle.com>
CC: Christoph Hellwig <hch@lst.de>, James Bottomley
	<james.bottomley@hansenpartnership.com>, <linux-scsi@vger.kernel.org>
References: <20231023092837.33786-1-hare@suse.de>
Content-Language: en-US
From: Wenchao Hao <haowenchao2@huawei.com>
In-Reply-To: <20231023092837.33786-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600012.china.huawei.com (7.193.23.74)

On 2023/10/23 17:28, Hannes Reinecke wrote:
> Hi all,
> 
> (taking up an old thread:)
> here's now the main part of my EH rework.
> It modifies the reset callbacks for SCSI EH such that
> each callback (eh_host_reset_handler, eh_bus_reset_handler,
> eh_target_reset_handler, eh_device_reset_handler) only
> references the actual entity it needs to work on
> (ie 'Scsi_Host', (scsi bus), 'scsi_target', 'scsi_device'),
> and the 'struct scsi_cmnd' is dropped from the argument list.
> This simplifies the handler themselves as they don't need to
> exclude some 'magic' command, and we don't need to allocate
> a mock 'struct scsi_cmnd' when issuing a reset via SCSI ioctl.
> 
> The entire patchset can be found at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> branch eh-rework.v8
> 
> As usual, comments and reviews are welcome.
> 

Hi Hannes,

It seems a long time, is this work still going on?

> Changes to v6:
> - Include reviews from Bart
> - Add patch to return -EAGAIN from scsi_ioctl_reset()
> 
> Changes to v5:
> - Improve description for patch to modify scsi_eh_bus_device_reset()
> - Add patch to modify the iteratrion in scsi_eh_bus_reset()
> 
> Hannes Reinecke (10):
>    scsi: Use Scsi_Host as argument for eh_host_reset_handler
>    scsi: Use Scsi_Host and channel number as argument for
>      eh_bus_reset_handler()
>    scsi: Use scsi_target as argument for eh_target_reset_handler()
>    scsi: Use scsi_device as argument to eh_device_reset_handler()
>    scsi: set host byte after EH completed
>    scsi_error: iterate over list of failed commands in
>      scsi_eh_bus_reset()
>    scsi: Do not allocate scsi command in scsi_ioctl_reset()
>    scsi_error: iterate over list of failed commands in
>      scsi_eh_bus_device_reset()
>    scsi_error: map FAST_IO_FAIL to -EAGAIN in SCSI EH
>    scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL
> 

