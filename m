Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EDEE56A;
	Thu, 27 Jun 2024 01:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719450123; cv=none; b=TWV21pGEAz6RpQvJGXj3AdKpST3iqBwN5rITDO4f1zXwl2yXOBEhq9VnyoHzzFiAnB716xwrMNQ5gAMOju5bUVBqV+ps5cvmYchCqOwggmZnuNt0qCNmXEwZI4jPHFDbKrMsh/dqfUYOjBu1EBJelahwE9jOL9JxQGwO+rrjl/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719450123; c=relaxed/simple;
	bh=4tdWvjgedRLHX/fb8sJ5Z7YMFAzxGpM99yCC+6AVqi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lZqm8pKH4Lp+1eEhu/aVpwoTnfhPLvUR9MoY+TuUhQfkjTSJGXrdeHktBFUoAs2exMVFaJbSKXIV9LhzShywkEnF7X3dDrcPPEI+7ApLe+grNR5kTASPl8dYAXNIYFqCTmnlcHinTQo9dIyv7GAj5aZLrjEKP1608qhPyeFoPB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5Wj8UID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5Wj8UID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F67C116B1;
	Thu, 27 Jun 2024 01:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719450122;
	bh=4tdWvjgedRLHX/fb8sJ5Z7YMFAzxGpM99yCC+6AVqi0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n5Wj8UIDTZWtU19PlGHY3FiOv+iNG7CVw63tEc6E3PnPWUFis0QAiUSs6BotlMI2n
	 JJaAtPB79K4A7WrY4Y3464AWPOPP9mhLoC9KMcIc28SF2eysp5C6NDIHzF09yAL2SZ
	 nIX3TGaT0YZdYPq8dHflOHwWwuxACBQTzecpsGJUK3Z5i3NAJBTqB6yC+H5tp6+WKq
	 rxeDsXgnHvdfM6eIrGnw9yyHAbreUCznymG4n6RxmFv8mxFNr8jOgALMiwt9Zj+c5R
	 ESsmk284iaoqYUTnOSWbBXUFN8UHVvrlxiCrxJUOquVHz6BFQXNq9cmULazOtLFzkX
	 gXlBAJhJaTK9w==
Message-ID: <91033c98-37a8-4ada-96f2-4661b170bbfa@kernel.org>
Date: Thu, 27 Jun 2024 10:02:00 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/13] ata: libata-core: Fix double free on error
To: Niklas Cassel <cassel@kernel.org>, Colin Ian King
 <colin.i.king@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 stable@vger.kernel.org, linux-ide@vger.kernel.org
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-17-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240626180031.4050226-17-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/27/24 03:00, Niklas Cassel wrote:
> If e.g. the ata_port_alloc() call in ata_host_alloc() fails, we will jump
> to the err_out label, which will call devres_release_group().
> devres_release_group() will trigger a call to ata_host_release().
> ata_host_release() calls kfree(host), so executing the kfree(host) in
> ata_host_alloc() will lead to a double free:
> 
> kernel BUG at mm/slub.c:553!
> Oops: invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> CPU: 11 PID: 599 Comm: (udev-worker) Not tainted 6.10.0-rc5 #47
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
> RIP: 0010:kfree+0x2cf/0x2f0
> Code: 5d 41 5e 41 5f 5d e9 80 d6 ff ff 4d 89 f1 41 b8 01 00 00 00 48 89 d9 48 89 da
> RSP: 0018:ffffc90000f377f0 EFLAGS: 00010246
> RAX: ffff888112b1f2c0 RBX: ffff888112b1f2c0 RCX: ffff888112b1f320
> RDX: 000000000000400b RSI: ffffffffc02c9de5 RDI: ffff888112b1f2c0
> RBP: ffffc90000f37830 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffc90000f37610 R11: 617461203a736b6e R12: ffffea00044ac780
> R13: ffff888100046400 R14: ffffffffc02c9de5 R15: 0000000000000006
> FS:  00007f2f1cabe980(0000) GS:ffff88813b380000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2f1c3acf75 CR3: 0000000111724000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ? __die_body.cold+0x19/0x27
>  ? die+0x2e/0x50
>  ? do_trap+0xca/0x110
>  ? do_error_trap+0x6a/0x90
>  ? kfree+0x2cf/0x2f0
>  ? exc_invalid_op+0x50/0x70
>  ? kfree+0x2cf/0x2f0
>  ? asm_exc_invalid_op+0x1a/0x20
>  ? ata_host_alloc+0xf5/0x120 [libata]
>  ? ata_host_alloc+0xf5/0x120 [libata]
>  ? kfree+0x2cf/0x2f0
>  ata_host_alloc+0xf5/0x120 [libata]
>  ata_host_alloc_pinfo+0x14/0xa0 [libata]
>  ahci_init_one+0x6c9/0xd20 [ahci]
> 
> Ensure that we will not call kfree(host) twice, by performing the kfree()
> only if the devres_open_group() call failed.
> 
> Fixes: dafd6c496381 ("libata: ensure host is free'd on error exit paths")
> Cc: stable@vger.kernel.org
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

