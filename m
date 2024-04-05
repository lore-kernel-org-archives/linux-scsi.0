Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E58516E897
	for <linux-scsi@vger.kernel.org>; Fri,  5 Apr 2024 14:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712328619; cv=none; b=N+R7ZnNdgmQJLp8H80FHUgmXCTF5Cw73UG8+2o60dEEtbaFgVK9or3DHEFGE4xIrpjIDT29ejDgdaST1PCfNT5D1mD2DC2c0ODjSzii2Im0qZhGzYqSCoMMNC7YPGllO8JM02c1iolkPilBQDZ7iNsa2N3erYFdznwGiSOW5Qa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712328619; c=relaxed/simple;
	bh=f1RkwhPeAUS3cZ6kCj+dmzs89sUycWjsVlzvjgHIiLE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=UpnbewZ6zT67ExSnXgCSdzLiMwuawXCbGCGx3iHGZMgHDVac+jCO2C4brXxgzIaWDGhiDUpJ4wuT8hGsWuJ73s1eiAv7KOdDu9VOkkuQ8wZzn2rX+HM9rHqBdty9uzjMEs1chGaaufe48sQBvYBSsA/eN3+K85AJGCYc7A12Rk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MIaGaTEH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MIaGaTEH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712328616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XBj727h/u4J/KZBO20py+azndrqh7+ZG5fTGby2SUWM=;
	b=MIaGaTEH6/W96CZj337hIiuc1gy40ni7opuXL1A4cFtlq2G5bd5zV+57ik60C2C5xwtIhY
	qcJEAg1uwzWULq76r31w4nbZ34S6Hsx3O0oxM5Et05bGbywuGAaHX6006w/3haEgcPz4Dz
	dpLkF5BqDfDSZ778ntsOp5e/FKFOyQ0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-OwbujdfnMWGVZubNDx9tUQ-1; Fri,
 05 Apr 2024 10:50:12 -0400
X-MC-Unique: OwbujdfnMWGVZubNDx9tUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E34DA3813F3B;
	Fri,  5 Apr 2024 14:50:11 +0000 (UTC)
Received: from [10.22.16.70] (unknown [10.22.16.70])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 863FE20239F3;
	Fri,  5 Apr 2024 14:50:11 +0000 (UTC)
Message-ID: <310a1082-94e3-4f7e-9089-53882bbf979b@redhat.com>
Date: Fri, 5 Apr 2024 10:50:11 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH] qedi: Fix crash while reading debugfs attribute.
To: martin.petersen@oracle.com, Manish Rangankar <mrangankar@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
 Martin Hoyer <mhoyer@redhat.com>, Nilesh Javali <njavali@marvell.com>
References: <20240327091100.14405-1-mrangankar@marvell.com>
Content-Language: en-US
Organization: RHEL Core Storge Team
In-Reply-To: <20240327091100.14405-1-mrangankar@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Martin, we've tested this patch here at Red Hat and found that it fixes the problem.

Manish, Please clean up the commit message and submit a v2 patch with a little better description.

Tested-by: Martin Hoyer <mhoyer@redhat.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>

Thanks,

/John

On 3/27/24 05:11, Manish Rangankar wrote:
> BUG: unable to handle page fault for address: 00007f4801111000
> PGD 8000000864df6067 P4D 8000000864df6067 PUD 864df7067 PMD 846028067 PTE 0
> Oops: 0002 [#1] PREEMPT SMP PTI
> CPU: 38 PID: 6417 Comm: cat Kdump: loaded Not tainted 6.4.0-150600.9-default #1 SLE15-SP6 6b4f1850a99c4e4121f832c3fb6a8cf64ec22338
> Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 06/15/2023
> RIP: 0010:memcpy_orig+0xcd/0x130
> Code: 08 4c 89 54 17 f0 4c 89 5c 17 f8 c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 83 fa 08 72 1b 4c 8b 06 4c 8b 4c 16 f8 <4c> 89 07 4c 89 4c 17 f8 c3 cc cc cc cc 66 0f 1f 44 00 00 83 fa 04
> RSP: 0018:ffffb7a18c3ffc40 EFLAGS: 00010202
> RAX: 00007f4801111000 RBX: 00007f4801111000 RCX: 000000000000000f
> RDX: 000000000000000f RSI: ffffffffc0bfd7a0 RDI: 00007f4801111000
> RBP: ffffffffc0bfd7a0 R08: 725f746f6e5f6f64 R09: 3d7265766f636572
> R10: ffffb7a18c3ffd08 R11: 0000000000000000 R12: 00007f4881110fff
> R13: 000000007fffffff R14: ffffb7a18c3ffca0 R15: ffffffffc0bfd7af
> FS:  00007f480118a740(0000) GS:ffff98e38af00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4801111000 CR3: 0000000864b8e001 CR4: 00000000007706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>   <TASK>
>   ? __die_body+0x1a/0x60
>   ? page_fault_oops+0x183/0x510
>   ? exc_page_fault+0x69/0x150
>   ? asm_exc_page_fault+0x22/0x30
>   ? memcpy_orig+0xcd/0x130
>   vsnprintf+0x102/0x4c0
>   sprintf+0x51/0x80
>   qedi_dbg_do_not_recover_cmd_read+0x2f/0x50 [qedi 6bcfdeeecdea037da47069eca2ba717c84a77324]
>   full_proxy_read+0x50/0x80
>   vfs_read+0xa5/0x2e0
>   ? folio_add_new_anon_rmap+0x44/0xa0
>   ? set_pte_at+0x15/0x30
>   ? do_pte_missing+0x426/0x7f0
>   ksys_read+0xa5/0xe0
>   do_syscall_64+0x58/0x80
>   ? __count_memcg_events+0x46/0x90
>   ? count_memcg_event_mm+0x3d/0x60
>   ? handle_mm_fault+0x196/0x2f0
>   ? do_user_addr_fault+0x267/0x890
>   ? exc_page_fault+0x69/0x150
>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
> RIP: 0033:0x7f4800f20b4d
> 
> Reported-by: Martin Hoyer <mhoyer@redhat.com>
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> ---
>   drivers/scsi/qedi/qedi_debugfs.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_debugfs.c b/drivers/scsi/qedi/qedi_debugfs.c
> index 8deb2001dc2f..37eed6a27816 100644
> --- a/drivers/scsi/qedi/qedi_debugfs.c
> +++ b/drivers/scsi/qedi/qedi_debugfs.c
> @@ -120,15 +120,11 @@ static ssize_t
>   qedi_dbg_do_not_recover_cmd_read(struct file *filp, char __user *buffer,
>   				 size_t count, loff_t *ppos)
>   {
> -	size_t cnt = 0;
> -
> -	if (*ppos)
> -		return 0;
> +	char buf[64];
> +	int len;
>   
> -	cnt = sprintf(buffer, "do_not_recover=%d\n", qedi_do_not_recover);
> -	cnt = min_t(int, count, cnt - *ppos);
> -	*ppos += cnt;
> -	return cnt;
> +	len = sprintf(buf, "do_not_recover=%d\n", qedi_do_not_recover);
> +	return simple_read_from_buffer(buffer, count, ppos, buf, len);
>   }
>   
>   static int

