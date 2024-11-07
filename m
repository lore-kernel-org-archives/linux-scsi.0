Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FE4621
	for <linux-scsi@vger.kernel.org>; Thu,  7 Nov 2024 00:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730938409; cv=none; b=T1qcajN3FZzNguMjRsHMS8JFjszeEl+gfNgga75OyZfXIXGpLWY4mrxorIlMN/2a+A+maRIGApGjk5KLIuB9yh3qEGh/d+FVBrJPfjabczrJsI/WVTgt5idXn+J0iLypNnOqs8RcozQzmtBM2A2if3ycVkNjgTQtQS7ycdOqnhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730938409; c=relaxed/simple;
	bh=cakW1pJIEf5HeB+5aFvclvz8RXf8NL9Fy8LTNObcAS0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=OuOMu30E8o5bzkmAn6A0/XRtafXBuRtqMbPKWYStC47t6TLJX3Cp6xxPZchna9288dnM1WluQtK5IjXe0KgNVyE1/Wnr/fmrjXnl/buHkh6rh6HNoMnxEgnldpZ7VwJeMhKPdJ++TW3A8+/XwWpbVbh/wA0KNkZUd64vn18GSkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2iyfAwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2iyfAwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1D8C4CEC6;
	Thu,  7 Nov 2024 00:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730938409;
	bh=cakW1pJIEf5HeB+5aFvclvz8RXf8NL9Fy8LTNObcAS0=;
	h=Date:From:Subject:To:From;
	b=F2iyfAwLTn6u/Q+m8yKsld7VSU9w637+qRxN69ohjEeNF3cSsuKtItqSiNyc3r8B9
	 ARQGDEm/sdWlduBK/jDqbCkWTSWD1Eba2sh9KUJGAEOp13KjcLGHinvk3UGERHh689
	 IheoXkHG1yN9unSlB+Dzis5vu94V+Q6tNgoh2yj4jErd/0T5qZ4wLfDdY50Tw0QOIB
	 jQ8Idxkenvj6Zfx8/XVBGyh/9Z4vrz0lVWT4Oib33B7TFHrkTrAReG1KG6bUMtXOEk
	 HdSPLuHgJtpVAwInZ6kPd5pUo84/Kxtklr2oPy320iRlesgiwQyTLls25L6RLyCTLg
	 kkwHwOg9swjyg==
Message-ID: <6d2cf555-26d8-4692-b6d6-5aeec61bbc07@kernel.org>
Date: Thu, 7 Nov 2024 09:13:26 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Subject: mpi3mr UBSAN splats
Organization: Western Digital Research
To: "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 mpi3mr-linuxdrv.pdl@broadcom.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

mpi3mr maintainers,

I am getting *a lot* of UBSAN splats with the mpi3mr driver whenever SAS
topology changes happen, including on boot. E.g.:

[17227.798414] UBSAN: array-index-out-of-bounds in
drivers/scsi/mpi3mr/mpi3mr_os.c:2697:12
[17227.808061] index 1 is out of range for type 'mpi3_event_sas_topo_phy_entry [1]'
[17227.817057] CPU: 8 UID: 0 PID: 0 Comm: swapper/8 Not tainted
6.11.4-201.fc40.x86_64 #1
[17227.826546] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.8 02/27/2024
[17227.835568] Call Trace:
[17227.839514]  <IRQ>
[17227.842986]  dump_stack_lvl+0x5d/0x80
[17227.848123]  ubsan_epilogue+0x5/0x30
[17227.853160]  __ubsan_handle_out_of_bounds.cold+0x46/0x4b
[17227.859958]  mpi3mr_os_handle_events+0x987/0x9d0 [mpi3mr]
[17227.866849]  mpi3mr_process_admin_reply_q+0x70e/0x7b0 [mpi3mr]
[17227.874146]  mpi3mr_isr+0x86/0xa0 [mpi3mr]
[17227.879649]  __handle_irq_event_percpu+0x4a/0x190
[17227.885728]  handle_irq_event+0x38/0x90
[17227.890921]  handle_edge_irq+0x8b/0x230
[17227.896114]  __common_interrupt+0x4c/0xd0
[17227.901476]  common_interrupt+0x80/0xa0
[17227.906660]  </IRQ>
[17227.910099]  <TASK>
[17227.913538]  asm_common_interrupt+0x26/0x40
[17227.919062] RIP: 0010:cpuidle_enter_state+0xd3/0x6a0
[17227.925349] Code: 00 00 e8 e0 a3 fb fe e8 1b f0 ff ff 49 89 c6 0f 1f 44 00 00
31 ff e8 dc 58 fa fe 45 84 ff 0f 85 48 02 00 00 fb 0f 1f 44 00 00 <45> 85 ed 0f
88 e7 01 00 00 4d 63 e5 49 83 fc 0a 0f 83 04 05 00 00
[17227.945488] RSP: 0018:ffffab620026fe68 EFLAGS: 00000246
[17227.952106] RAX: ffff9a69ce400000 RBX: ffff9a4b0cdf2800 RCX: 0000000000000000
[17227.960636] RDX: 00000fab2797d15e RSI: 000000002abf2f65 RDI: 0000000000000000
[17227.969163] RBP: ffffffffa96f7ba0 R08: ffffab620026fdb8 R09: 000000006a5538d0
[17227.977690] R10: 00000000000c3500 R11: 0000000000000003 R12: 0000000000000002
[17227.986221] R13: 0000000000000002 R14: 00000fab2797d15e R15: 0000000000000000
[17227.994768]  ? cpuidle_enter_state+0xc4/0x6a0
[17228.000529]  cpuidle_enter+0x2d/0x40
[17228.005503]  do_idle+0x1e5/0x240
[17228.010120]  cpu_startup_entry+0x29/0x30
[17228.015412]  start_secondary+0x12b/0x160
[17228.020707]  common_startup_64+0x13e/0x141
[17228.026178]  </TASK>

And in many more places, essentially, wherever topo_evt->phy_entry[i] is used.
I looked into it but cannot make sense of the code because topo_evt is a pointer
coming from a cast of struct mpi3_event_notification_reply
*event_reply->event_data, which is a __le32 value... But my machine is a 64-bits
AMD Epyc... So I have no idea how this can work, nor any clue what is going on
with the number of phy entries (num_entries field) and its flex-array.

Can you please have a look ? This has been happening since 6.12-rc1 and is not
fixed yet as of rc6.


-- 
Damien Le Moal
Western Digital Research

