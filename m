Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954CC7489;
	Thu, 27 Jun 2024 01:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719450257; cv=none; b=WQX3I6hyf3CGypPG3WBTconyzdtio4gJIJd5zucAvaE5ezMkpI8DZSzdyHD3X97JKimVvUPNjEHgHLUtNRGfv4Q/4mqitkvTrOybFwWQto7zJcy0nnRx1sNqvRIIwl8iuSspoqgSipvaalJ95sxeGbtkOQQEdI1ZZFzyn7W1r/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719450257; c=relaxed/simple;
	bh=EstRjC1ODHp/QjdZJ4mvFXdVs4ABul+e1rTEjZczg4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VVmAHYoiRwqUNeCgq5DjjfNpumlcMqTfLsUeFwmqo3vabL4UOSMitvwUjUNmjZbembEajsjRBNAWb431QbmIQclnxQ9ljuCDclTWlmCPplpZClRVQYgXIdLkl1MDBUDhMc9llh+IDt4IwvLHmPRjfz53iPB/7nTtYmiDwc0Jfi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/xhleUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/xhleUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE152C116B1;
	Thu, 27 Jun 2024 01:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719450257;
	bh=EstRjC1ODHp/QjdZJ4mvFXdVs4ABul+e1rTEjZczg4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n/xhleUUufJJql0yurQzV6g/xFfpbCMEEEIiyP0QMY5gOrln7LmtPJaxWV+GXvjlZ
	 8tVYczai8ACRZTrmLYH/sCGVJCgGhsnME/fc+AWlkdtQxd7RVZQ0V0tAhpGu4at8DM
	 iUpRinsL2oEJIjM1C6jrMY/3qJrAxZ78VNf4d3iexc63Q+Z2kr7zlFTccVbRPlihvp
	 ZfTKa32o0ljv+9eRaleGgUHbHcwVokLSZ2JO7G8Ave2eCV7l7sMbQ6af3/dbX3ZWnc
	 KXSYoLZfKXNhlRndmWk9XLNxPjyjYkftVcXs3tGF8FfM/Et7u0Rnamz6w82fvkl/8/
	 XJrq2NNyXTP4A==
Message-ID: <7384c068-e4e1-40c8-9f79-b1a05ec39c1e@kernel.org>
Date: Thu, 27 Jun 2024 10:04:14 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/13] ata: ahci: Clean up sysfs file on error
To: Niklas Cassel <cassel@kernel.org>,
 Kai-Heng Feng <kai.heng.feng@canonical.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 stable@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-18-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-18-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> .probe() (ahci_init_one()) calls sysfs_add_file_to_group(), however,
> if probe() fails after this call, we currently never call
> sysfs_remove_file_from_group().
> 
> (The sysfs_remove_file_from_group() call in .remove() (ahci_remove_one())
> does not help, as .remove() is not called on .probe() error.)
> 
> Thus, if probe() fails after the sysfs_add_file_to_group() call, we get:
> 
> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:04.0/remapped_nvme'
> CPU: 11 PID: 954 Comm: modprobe Not tainted 6.10.0-rc5 #43
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x5d/0x80
>  sysfs_warn_dup.cold+0x17/0x23
>  sysfs_add_file_mode_ns+0x11a/0x130
>  sysfs_add_file_to_group+0x7e/0xc0
>  ahci_init_one+0x31f/0xd40 [ahci]
> 
> Fixes: 894fba7f434a ("ata: ahci: Add sysfs attribute to show remapped NVMe device count")
> Cc: stable@vger.kernel.org
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good. And I think same as patch 1 and 2: let's send this out as a 6.10 fix.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

