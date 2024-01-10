Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0388933EC
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 02:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ahwlawgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696E8C433C7;
	Wed, 10 Jan 2024 02:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704853082;
	bh=jyImiAEPQ+c6zcOuWxgXzf14+6PA86zdtnSh7sbJ3u4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ahwlawgiy6uy2N2qfZAHwftzgHE6B4dikUyKOmnkp1GnFxM/xUR8deEVreMrQt6wK
	 YlGiEEbIiJxQAVRbXKcVg4GvdAIULUkx5iBqpwpABGO3PbJAd3rdg4LGJhPn/Cn/AZ
	 mQTMpG+V7jxJ9eQYc5MeMxBL1t0GFDtXvywfD40+T46MfC2peqJ9F8rooG4YgDiW95
	 gsWJ6SjGAjh+ybcUkOwkVKtOr7b98lDJnSO3Aao/LQF7W4se/H4g+qGP4RSmotTv2m
	 dnNwHC4l4p9yRPAUg+kMjKAkfUmbAr8vRD8CR/svCPr+Sul8fQOoFkmb/spRzfnvSv
	 NCSJPWWxWoITA==
Message-ID: <a6d89569-8369-4550-83da-d63afdab579d@kernel.org>
Date: Wed, 10 Jan 2024 11:18:00 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Content-Language: en-US
To: Kevin Locke <kevin@kevinlocke.name>, Bart Van Assche
 <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZZw3Th70wUUvCiCY@kevinlocke.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/24 02:56, Kevin Locke wrote:
> Hi all,
> 
> On a ThinkPad T430 running Linux 6.7, when I attempt to delete the ATA
> device for a hard drive in the Ultrabay slot (to hotswap/undock it[1])
> the process freezes in an unterruptible sleep.  Specifically, if I run
> 
>     echo 1 >/sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/delete
> 
> The shell process hangs in the write(2) syscall.  The last dmesg
> entries post hang are:
> 
>     sd 1:0:0:0: [sda] Synchronizing SCSI cache
>     ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
>     ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>     ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>     ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>     ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>     ata2.00: configured for UDMA/133

It looks like the device was sleeping or was in standby state.
If that is the case, then we may be deadlocking with the scsi revalidate done
when waking up a drive. Can you confirm what the power state of the drive was
when you ran this ? Do you see an issue if you first make sure that the drive is
spun-up ?

>     ata2.00: retrying FLUSH 0xea Emask 0x0
> 
> On kernel versions prior to 6.5-rc1, dmesg would subsequently contain:
> 
>     sd 1:0:0:0: [sda] Stopping disk
>     ata2.00: disable device
> 
> Note that the hang only occurs when deleting a hard disk drive.  It
> does not occur when deleting an optical disk drive.
> 
> I bisected the regression to 8b566edbdbfb5cde31a322c57932694ff48125ed.
> 
> I know very little about the SCSI/ATA subsystems or the internals of
> ATA hotswapping/undocking.  I'd appreciate any help investigating the
> issue, or properly undocking.
> 
> Thanks,
> Kevin
> 
> [1]: https://www.thinkwiki.org/wiki/How_to_hotswap_Ultrabay_devices
> 

-- 
Damien Le Moal
Western Digital Research

