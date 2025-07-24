Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769B32C178D
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2025 12:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753358480; cv=none; b=J7wLXiRpaBStnKfi/fzYvtiL966VpJoXOu/kfgDkqsl2UjDpA3XRkylN7J5VZWUuDqFgfafHOHkopDNkXXrjEu+jZFBwaOwd4v6mPTPCAx+0mlV35AdFZK7JY3X22yjA5+rEPiNYjvXz6bl4y0GpHWFfypBYbF+jdgH87k4UiNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753358480; c=relaxed/simple;
	bh=duZt6qT+5ErbM1clOkjUYDW0MF+LLEdgb7U13h4NEAg=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=HagpeU3sVKhA1v7yneVW2wDuHpTZOYdCvAPvh9OYiBkQhl9TcL2z0eIFTDafo8T3ayp5xukjkLBAaqF3Y5UA3lVCaoh7aOax4kk/kYsbKKfusrV9PKLysKkWVxIUalphVLkyl5g16rTk0QHs7xZ/rK02bZ6WHtpi9jdyam4La1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 9FABE46F3E;
	Thu, 24 Jul 2025 14:01:09 +0200 (CEST)
Message-ID: <da2e3a15-e185-45e9-b557-a8c3e051058a@proxmox.com>
Date: Thu, 24 Jul 2025 14:01:08 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Friedrich Weber <f.weber@proxmox.com>
Subject: Re: [PATCH 0/2] Disable CDL probing on ATA with mpt2sas and mpt3sas
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 MPT-FusionLinux.pdl@broadcom.com
References: <20250723052334.32298-1-dlemoal@kernel.org>
Content-Language: en-US
In-Reply-To: <20250723052334.32298-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1753358466967

Hi Damien,

On 23/07/2025 07:26, Damien Le Moal wrote:
> Martin,
> 
> Friedrich reported issues with HBAs using the mpt3sas driver and CDL
> probe, particularly on device hot-plug. These 2 patches address this
> issue by force-disabling CDL probing with mpt2sas and mpt3sas. This has
> no effect on feature limitation since the firmware of all HBAs driven by
> mpt2sas and mpt3sas do not have a SAT implementation capable of handling
> CDL on ATA devices.

Thanks for the patches, but they do not seem to fix hotplug in the setup
we've been testing [0]. We applied the patches to our downstream kernel
based on 6.14.8 (plus the dependency [1]). Looks like `is_ata` is 0,
so the CDL check still occurs. We checked with a bpftrace script [2]
which prints the following on hotplug:

[kfunc:vmlinux:scsi_cdl_check] comm=kworker/u224:1 sdev=0xffff89b483eef000 sdev.scsi_level=8 sdev.is_ata=0 hostt.no_ata_cdl=1 host=5 id=1 channel=0 lun=0 stack=
        bpf_prog_996f05907e728033_scsi_cdl_check+554
        bpf_prog_996f05907e728033_scsi_cdl_check+554
        bpf_trampoline_6442497360+67
        scsi_cdl_check+5
        scsi_probe_and_add_lun+350
        __scsi_scan_target+255
        scsi_scan_target+224
        sas_rphy_add+311
        mpt3sas_transport_port_add+1046
        _scsih_add_device.constprop.0+1247
        _firmware_event_work+7872
        process_one_work+379
        worker_thread+696
        kthread+254
        ret_from_fork+71
        ret_from_fork_asm+26

> 
> Damien Le Moal (2):
>   scsi: Allow SCSI hosts to force-disable CDL support probing
>   scsi: mpt3sas: Disable Command Duration Limit Probing
> 
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 ++
>  drivers/scsi/scsi.c                  | 6 +++++-
>  include/scsi/scsi_host.h             | 6 ++++++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 

[0] https://lore.kernel.org/all/3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com/
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=6.17/scsi-staging&id=b1ba03c49a711c30e24735733dfd68f2422fa150
[2]

kfunc:vmlinux:scsi_cdl_check {
	printf("[%s] comm=%s sdev=%p sdev.scsi_level=%d sdev.is_ata=%d hostt.no_ata_cdl=%d host=%d id=%d channel=%d lun=%d stack=%s",
		probe, comm,
		args->sdev, args->sdev->scsi_level, args->sdev->is_ata, args->sdev->host->hostt->no_ata_cdl, args->sdev->host->host_no, args->sdev->id, args->sdev->channel, args->sdev->lun,
		kstack());
}

