Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A69D481229
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 12:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782910136; cv=none; b=i1HSb5a4U+DUulMaCXZAcPDQjyg2ALxDBS1Fw+k2ZTAGV8GBE0dSu6CgRNl+xZp2NPlb7+G05sQVlEqNKzqCobzgLbyAehXhzH+gjzljJnejIat7KeNYANPbc4VNktV/qutTiD/lQxsZDsaFjGNYsV22nSbOeV3Lxy6mku/4P5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782910136; c=relaxed/simple;
	bh=KrbAL+jYS+hZiiGaRPke6Ow+yaawnGG5ncHBToAf/Q0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KKxo9AiT95mXozMhnA/FwNiIHK1XxIM/Pzytuvh6EfDPyvYE2wS4bl4Qz6JBZbQ8k+k45W85nOT4BwAsYClqWMU152QngE57TlKeQ4arTLkx8R20v2uy4Qnl7f6mgpUXWVHpZoLZkkzgOrVQ+QApLtDbS6bO2gOnjKzvdswSYbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id A3D4D47855;
	Wed, 01 Jul 2026 14:48:52 +0200 (CEST)
Message-ID: <a84b11e8-4205-481e-8da1-17103029940e@proxmox.com>
Date: Wed, 1 Jul 2026 14:48:51 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
To: Thorsten Leemhuis <regressions@leemhuis.info>, me@magik.net,
 Mats.topstad@intility.no, mail@danielfernau.com
Cc: chandrakanth.patil@broadcom.com, kashyap.desai@broadcom.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 megaraidlinux.pdl@broadcom.com, regressions@lists.linux.dev,
 shivasharan.srikanteshwara@broadcom.com, sumit.saxena@broadcom.com,
 Friedrich Weber <f.weber@proxmox.com>
References: <b8fcdb5e-f2be-4bd0-914d-d03e87af9630@leemhuis.info>
 <1cbf0f3e-4d6b-40ce-9d7b-3e9ea7e8f03e@proxmox.com>
 <49954999-5c2e-4fa7-9674-736e5f7b4216@leemhuis.info>
Content-Language: en-US
From: Mira Limbeck <m.limbeck@proxmox.com>
In-Reply-To: <49954999-5c2e-4fa7-9674-736e5f7b4216@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1782910126947

On 7/1/26 2:24 PM, Thorsten Leemhuis wrote:
> On 7/1/26 13:09, Mira Limbeck wrote:
>> We've seen some similar looking logs, but since they didn't mention
>> `prp` at all, we haven't responded here before.
> 
> Thx for chiming in here.
> 
>> Instead we sent a mail
>> to the linux-scsi list [0], but got no response so far.
>>
>> In our case the issue was first introduced by commit:
>> 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
> 
> Any reason why you didn't CC the author and the committer of that
> change? Even if the bug is in the driver that might have been a good
> idea, but before doing that, let's do something else first:
> 
>> This is similar to an issue we previously reported with the mpt3sas
>> driver [1].
>>
>> At least for our tests and one of our users we can say with certainty
>> that reducing the queue sectors back to the previous value fixed the
>> issue. In our tests this was done manually, and for one of our users
>> with their root on the disks, it was handled via udev rules.
>>
>> echo 1280 > /sys/block/<dev>/queue/max_sectors_kb
> You also in your [0] mentioned that 12da89e8844a ("block: open code
> bio_add_page and fix handling of mismatching P2P ranges") fixed things
> in v7.0. Make me wonder if that is the case for the others affected by
> this. Hence:
> 
> Lukasz, Mats, Daniel, have you checked if 7.1 or 7.2-rc2 are still affected?
> 
> Ciao, Thorsten
Actually, this only helped in our test cases. Some of our users that
were affected with kernel 6.17 had no issues with kernel 7.0, while
others still experience those issues.
So those 2 patches only fixed the issues for a subset of users.

Originally we thought that it fixes the issue for those using KIOXIA
NVMes, while those with Microns were still affected. But since then we
had additional reports where users with KIOXIA NVMes also still
experienced issues with kernel 7.0.
This we only found out last week though.

We're still in the process of finding a reproducer that isn't fixed by
that change.

> 
>> [0]
>> https://lore.kernel.org/all/d171cc76-bf25-48ce-b482-d344669dfc24@proxmox.com/
>> [1]
>> https://lore.kernel.org/all/7a0cfc66-3131-4b94-87f2-cbb96595ebb6@kernel.org/
> 


