Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F4B14D44D;
	Tue, 18 Jun 2024 23:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718752304; cv=none; b=VsfVWA7fFeILJUa23b4UJXM4k4amwYxc4R9gCCyFXwzj1QV5DVIQiLCfW2t/ByWf7tGr58JZ/GxSynWtgc+/QgMp05JgL5FDzHKgkfwlZF1wpW5VhTswJqHlTL4Ad7HUM2MBX0hNDdm4s8DWnfZ/1o/ken8sWBz9ZNkImyzeoD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718752304; c=relaxed/simple;
	bh=Q2Hbs/k0g975Ne1cPa3si3d9lZ42BlIgAMnhy8zapvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kt/SWIgey7uBBeyf8WuTb4tXKWGz8j7z1wNsPIkltWhBLga2RGlDl6n3hwQANQWbxoimLPu2bhZ+juonBGyf6muCbKs3kG6c0qLuSDv1jDNlpKI6Lp1TOZAN0a9jin0eihxBPrP6MaTbnbeUnAkZWA2wklSUAQcIWikn+KIgRF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tsk+HNck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tsk+HNck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1342C32786;
	Tue, 18 Jun 2024 23:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718752303;
	bh=Q2Hbs/k0g975Ne1cPa3si3d9lZ42BlIgAMnhy8zapvU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tsk+HNckcWa25izyTgU+XIedwyOiApTAO9DD1dEmFD0YNj9Kf45cXyfQgj2qutELw
	 gCb5bMfcFmDTIGnoc72UrMxXin0h0wNFKPPTk/NrC/vGQFJkPKn+bFK4400GeE3gO8
	 46Gw0gOMm/xe7CYudVDxF5N1De6zSfky4C1XJ0OpAnD8d7kiB8+NOKyKJllMDJEq/Y
	 Gmjt5sKLcArObYIW9LdDrXNPH1VQ42femmjblaLnQK6835vzu+BHocZbVT1rS66iow
	 fXmSXTtJ/fN5u3vHFSzciBhRQXz2Tcub+5Eko5j6yDY0fEFUQUe1LONGG/3iH+CnJo
	 0Ci1teYgFErgQ==
Message-ID: <0c5e14eb-5560-48cb-9086-6ad9c3970427@kernel.org>
Date: Wed, 19 Jun 2024 08:11:40 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] scsi: SATA devices missing after FLR is triggered
 during HBA suspended
To: Yihang Li <liyihang9@huawei.com>
Cc: cassel@kernel.org, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, john.g.garry@oracle.com, yanaijie@huawei.com,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 linuxarm@huawei.com, chenxiang66@hisilicon.com, prime.zeng@huawei.com
References: <20240618132900.2731301-1-liyihang9@huawei.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240618132900.2731301-1-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/18/24 22:29, Yihang Li wrote:
> Hi Damien,
> 
> I found out that two issues is caused by commit 0c76106cb975 ("scsi: sd:
> Fix TCG OPAL unlock on system resume") and 626b13f015e0 ("scsi: Do not
> rescan devices with a suspended queue").
> 
> The two issues as follows for the situation that there are ATA disks
> connected with SAS controller:

Which controller ? What is the driver ?

> (1) FLR is triggered after all disks and controller are suspended. As a
> result, the number of disks is abnormal.

I am assuming here that FLR means PCI "Function Level Reset" ?
FLR and disk/controller suspend execution timing are unrelated. FLR can be
triggered at any time through sysfs. So please give details here. Why is FLR
done when the system is being suspended ?

> (2) After all disks and controller are suspended, and resuming all disks
> again, the driver reference counting is not 0 (The value of "Used" in the
> lsmod command output is not 0).

Resuming all disks again ? So you mean system resume ?
Are we talking about system suspend to ram ? Hybernation ? or something else ?
(e.g. a controller reset through PCI FLR ?)

Please clarify exactly what your adapter is and the full procedure you do to
trigger the issue so that we can try to recreate it.

> For the issue 1, After all disks and controller are suspended, FLR command
> will resuming the controller and all sas ports. libsas layer will call
> ata_sas_port_resume() to resume ata port and schedule EH to recover it.
> In libata standard error handler ata_std_error_handler(), it will call ata
> reset function, revalidate ATA devices and issue ATA device command
> ATA_CMD_READ_NATIVE_MAX_EXT to read native max address. This command will
> failed due to the controller enter suspend state again and libata disable
> the device finally. The controller enter suspend state again because FLR
> command completes and the runtime PM usage counter is 0.
> 
> In commit 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
> and 626b13f015e0 ("scsi: Do not rescan devices with a suspended queue"),
> use blk_queue_pm_only() to check the device request queue state, if the
> device request queue is not running, the device will not be rescanned.
> Therefore, the runtime PM usage counter of the controller will not
> increase so that the controller enters the suspended state again.
> 
> For the issue 2, the cause is unknown.
> 
> How to solve these two issues?
> 
> regards,
> Yihang
> 

-- 
Damien Le Moal
Western Digital Research

