Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF32280331;
	Wed, 29 Jul 2026 02:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785292465; cv=none; b=k8e19X1AB1bjgmI2T+tvttZFq3LIB/QaHn2Sh590XK++j9D5+8n6PcElXfA2RkKjdHM9EhANFrWY3MjZakff3fsLs5YRV1aC0D1idJDOX8IH95lq9YAW8YB+v/QeeDZVvpDrR3ZGwygB+aXsbE7TrWtK5iHw9/4GCOUItswG1H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785292465; c=relaxed/simple;
	bh=FrF/kciLC2mE0W/Krao8DWA/EljTwDd34hkw6Gyp478=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sWhi3aSedAl3mEwSQ11R9pLO75WHOSCFhLLLNAgYVMYavBRTOXXCrSoIeoGXKvhNOEoHpccrdA9eG9kShwVZI3TaEbjcV2a31Zgzc0y+Zp3Qrcp36h4eVVy/veXRcR1iSKmUYueGoTAYMJhCzU7TXNxwsBwuc7j3EE97oiXw6y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UMEAPa4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UMEAPa4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327061F000E9;
	Wed, 29 Jul 2026 02:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785292464;
	bh=PyuOUmnhfCf0pAOeeyv+1oQtQnBmrCyhFWhXVHrO/B4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UMEAPa4X+JwkdC2u2Bz73Yqf0C8/0JKASWflEEulvLSbgIaRwC90+9EuqzGEI3puz
	 H3IEq4dspitf4JZQGQ8ic9d3RNq4QZPjZg5YOXuez2mZRpeT86qu7QDli/qxX1nLXZ
	 B2afMGZ9uzub90OwWEcq1cH3LJ/MMkkhAPYscQVzWDUgsX6lLAARWI0d5jBzzUSBks
	 q+b1cJW1IN3eDZP8CgU46JxwoPMTP+TD23sEff4WhLtLHELDqVjjAEcr5Eza27oGPD
	 Lwzlp/iyxO2ijIp+7L1xyN7knkj5TPFizXaQtdrUnBkoU9G1VjCQZ0yhTJmoLmI0f6
	 eIBmjhFH/7nvg==
Message-ID: <10ff4e41-c7d8-4249-91e8-198fa45a8d0c@kernel.org>
Date: Wed, 29 Jul 2026 11:34:10 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
To: Mats Topstad / Intility AS <Mats.topstad@intility.no>,
 Daniel Fernau <mail@danielfernau.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Thorsten Leemhuis <regressions@leemhuis.info>, "me@magik.net"
 <me@magik.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
 <yq15x5lowt9.fsf@ca-mkp.ca.oracle.com>
 <b8fcdb5e-f2be-4bd0-914d-d03e87af9630@leemhuis.info>
 <yq17bmzd5jr.fsf@ca-mkp.ca.oracle.com>
 <YKopBh5zwX7tXjDOqU7R0K9CQfVpd3r9_baFGNLwcZGgb4m0cddKjzuQwp0lWZJqixIfpiHm9YwjQfRvNJjBZwl1PaqtuuuCd7dJ4lmirSY=@danielfernau.com>
 <9900ABF6-01C5-4B9B-BEF3-BAB5A18C3F54@intility.no>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <9900ABF6-01C5-4B9B-BEF3-BAB5A18C3F54@intility.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/28/26 22:43, Mats Topstad / Intility AS wrote:
> Hi all,
> 
> Adding a data point from an HPE ProLiant DL360 Gen11 with the MR408i-o Gen11
> controller (megaraid_sas), 960 GB SAS SSDs presented as sd*, running kernel
> 6.18.32 (Talos Linux v1.12.8). Without a cap the node panics within seconds of
> sustained block I/O to the controller, with the same megasas_make_prp_nvme
> signature discussed in this thread.
> 
> Capping max_sectors_kb=1280 on the sd* devices resolves it on this controller
> by itself. I pushed roughly 85 GB of dd bs=4M oflag=direct through it, so every
> request is split at the 1280 KB boundary, with zero panics, where the uncapped
> case dies almost immediately. On the MR416i-o you found the cap necessary but
> not sufficient because of a second problem in the SG advance path. I did not
> reach that second failure on the MR408i-o; the cap alone was enough here.
> 
> Both of our worker nodes have now run on kernel 6.18 throughout this testing
> with the cap applied by a udev rule at device add:
> 
>   ACTION=="add|change", SUBSYSTEM=="block", KERNEL=="sd[a-z]", DRIVERS=="megaraid_sas", ATTR{queue/max_sectors_kb}="1280"
> 
> This lines up with Martin's suggestion to cap max_hw_sectors on the driver side
> for NVMe behind MR. If a driver side patch would help, I am happy to build and
> test it on this exact hardware and report back, and I can provide a full dmesg
> or a serial panic capture from the uncapped case if that is useful.

This looks about the same problem as what commit 04631f55afc5 ("scsi: mpt3sas:
Limit NVMe request size to 2 MiB") fixes.

I strongly suspect that all Broadcom drivers (mpi3mr and megaraid) all need a
similar fix.

-- 
Damien Le Moal
Western Digital Research
