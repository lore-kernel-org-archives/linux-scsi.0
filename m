Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FB825EF89
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753198518; cv=none; b=cg/J8Hk8hy8nxmX8rb6QZiAVgNJYhL6+H+OBuEd6UV6i/vQQoFK/uy8wzr4qPmsHWTFEvhWwUHs9DWG3MMob3haNmGCdNPL95I519pHIftiQC/x+W+Us7otCMHlxrbEEhJON+dQaCwjidw2L8VFV4YEIfYSCFDElCHG/TQVOEyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753198518; c=relaxed/simple;
	bh=ltLTXkGj+M5DIFpL7xAcahBk61vI/1/lM2Y5PmcaN2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DtxZ6PLB5rbs0/6y8+hLX+bwqBXRChJRK3LKDN6KBqoi0u6hPw656G/mGaZsy70ldDayJJLKNjcsSt8kQDc9N8q8+xxgCAyZ+HJo+hC3Y13r5Q9IbzhUUIKu7DXqK4VNXTXN8MtRkdSqNw3Itg9QFMPlA2sfOdQ70U2bGNq2jn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=d7sSVsew; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="d7sSVsew"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bmhD30x7Czm0ySp;
	Tue, 22 Jul 2025 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753198512; x=1755790513; bh=ltLTXkGj+M5DIFpL7xAcahBk
	61vI/1/lM2Y5PmcaN2U=; b=d7sSVsewAT4YyY0fpIsd7qmelEZmO7ODy/7GInLG
	DjlVavmlWKaG51PjLIOn6+nTo7R1rEN/Thb5AZbM6Qnc7PSm4itDrVmBgdmFck6/
	YG3+DHqNOzgfMzJN8JwCC9xfb9nV2y1SnGiLWzsXmuhRZ8KA701jYkzeClvNN7hq
	vvr6lAdzuqEa7DyAR5uHQAZ9XxwiA6wc2IiFGCwz9UCu/8VXsQEtWKIoju7tQuBA
	kMymaWVL8IhEad8mgwb4wvP+3au44awNzDMFJCul9wTpq8gaJn4gMaJoeaOe2zaI
	8017Lo9ayVk8NFWVfrNb+nzmhzCwMUotU/nMxbwQpG9TKQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yvvHEJOvlmxd; Tue, 22 Jul 2025 15:35:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bmhCt39JPzm1HbT;
	Tue, 22 Jul 2025 15:35:05 +0000 (UTC)
Message-ID: <6d603276-1114-4dc8-b622-13716f3ea8c7@acm.org>
Date: Tue, 22 Jul 2025 08:35:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Fix IRQ lock inversion
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "huobean@gmail.com" <huobean@gmail.com>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "andre.draszik@linaro.org" <andre.draszik@linaro.org>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "mani@kernel.org" <mani@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20250721215055.2885241-1-bvanassche@acm.org>
 <0c1022496d2eb5cbe0d86ae3c249e28adf6a9c94.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0c1022496d2eb5cbe0d86ae3c249e28adf6a9c94.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 7/22/25 12:23 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2025-07-21 at 14:50 -0700, Bart Van Assche wrote:
>> other info that might help us debug this:
>> =C2=A0Possible interrupt unsafe locking scenario:
>>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 CPU1
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ----=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ----
>> =C2=A0 lock(shost->host_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local_irq_disable();
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock(&hba->clk_gating.lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock(shost->host_lock);
>> =C2=A0 <Interrupt>
>> =C2=A0=C2=A0=C2=A0 lock(&hba->clk_gating.lock);
>>=20
>> =C2=A0*** DEADLOCK ***
>>=20
>> 4 locks held by kworker/u28:0/12:
>> =C2=A0#0: ffffff8800ac6158 ((wq_completion)async){+.+.}-{0:0}, at:
>> process_one_work+0x1bc/0x65c
>> =C2=A0#1: ffffffc085c93d70 ((work_completion)(&entry->work)){+.+.}-{0:=
0},
>> at: process_one_work+0x1e4/0x65c
>> =C2=A0#2: ffffff881e29c0e0 (&shost->scan_mutex){+.+.}-{3:3}, at:
>> __scsi_add_device+0x74/0x120
>> =C2=A0#3: ffffff881960ea00 (&hwq->cq_lock){-...}-{2:2}, at:
>> ufshcd_mcq_poll_cqe_lock+0x28/0x104
>=20
> This kworker is acquiring cq_lock, not host_lock?

No. "lock(shost->host_lock)" means that it is acquiring the SCSI host
lock.

>> stack backtrace:
>> CPU: 6 UID: 0 PID: 12 Comm: kworker/u28:0 Tainted: G=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 W=20
>> OE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6.12.30-android16-5-maybe-dirty-4k #1
>> ccd4020fe444bdf629efc3b86df6be920b8df7d0
>> Tainted: [W]=3DWARN, [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
>> Hardware name: Spacecraft board based on MALIBU (DT)
>> Workqueue: async async_run_entry_fn
>> Call trace:
>> =C2=A0dump_backtrace+0xfc/0x17c
>> =C2=A0show_stack+0x18/0x28
>> =C2=A0dump_stack_lvl+0x40/0xa0
>> =C2=A0dump_stack+0x18/0x24
>> =C2=A0print_irq_inversion_bug+0x2fc/0x304
>> =C2=A0mark_lock_irq+0x388/0x4fc
>> =C2=A0mark_lock+0x1c4/0x224
>> =C2=A0__lock_acquire+0x438/0x2e1c
>> =C2=A0lock_acquire+0x134/0x2b4
>> =C2=A0_raw_spin_lock_irqsave+0x5c/0x80
>> =C2=A0ufshcd_release_scsi_cmd+0x60/0x110
>> =C2=A0ufshcd_compl_one_cqe+0x2c0/0x3f4
>> =C2=A0ufshcd_mcq_poll_cqe_lock+0xb0/0x104
>> =C2=A0ufs_google_mcq_intr+0x80/0xa0 [ufs
>> dd6f385554e109da094ab91d5f7be18625a2222a]
>> =C2=A0__handle_irq_event_percpu+0x104/0x32c
>> =C2=A0handle_irq_event+0x40/0x9c
>> =C2=A0handle_fasteoi_irq+0x170/0x2e8
>> =C2=A0generic_handle_domain_irq+0x58/0x80
>> =C2=A0gic_handle_irq+0x48/0x104
>> =C2=A0call_on_irq_stack+0x3c/0x50
>> =C2=A0do_interrupt_handler+0x7c/0xd8
>> =C2=A0el1_interrupt+0x34/0x58
>> =C2=A0el1h_64_irq_handler+0x18/0x24
>> =C2=A0el1h_64_irq+0x68/0x6c
>> =C2=A0_raw_spin_unlock_irqrestore+0x3c/0x6c
>> =C2=A0debug_object_assert_init+0x16c/0x21c
>> =C2=A0__mod_timer+0x4c/0x48c
>> =C2=A0schedule_timeout+0xd4/0x16c
>> =C2=A0io_schedule_timeout+0x48/0x70
>> =C2=A0do_wait_for_common+0x100/0x194
>> =C2=A0wait_for_completion_io_timeout+0x48/0x6c
>> =C2=A0blk_execute_rq+0x124/0x17c
>> =C2=A0scsi_execute_cmd+0x18c/0x3f8
>> =C2=A0scsi_probe_and_add_lun+0x204/0xd74
>> =C2=A0__scsi_add_device+0xbc/0x120
>> =C2=A0ufshcd_async_scan+0x80/0x3c0
>> =C2=A0async_run_entry_fn+0x4c/0x17c
>> =C2=A0process_one_work+0x26c/0x65c
>> =C2=A0worker_thread+0x33c/0x498
>> =C2=A0kthread+0x110/0x134
>> =C2=A0ret_from_fork+0x10/0x20
>>=20
>=20
> This backtrace also looks like it is acquiring cq_lock
> rather than host_lock. I'm not sure if I missed something?

No. ufshcd_release_scsi_cmd() doesn't call any function that acquires
cq_lock.

>> @@ -6455,10 +6453,9 @@ void ufshcd_schedule_eh_work(struct ufs_hba
>> *hba)
>>=20
>> =C2=A0static void ufshcd_force_error_recovery(struct ufs_hba *hba)
>> =C2=A0{
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock_irq(hba->host->host_lo=
ck);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 guard(spinlock_irqsave)(hba->hos=
t->host_lock);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->force_reset =3D true;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_schedule_eh_work(hba=
);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock_irq(hba->host->host_=
lock);
>> =C2=A0}
>>=20
>=20
> The other two functions do seem to have issues,
> but ufshcd_force_error_recovery shouldn't,
> because it is not used by ufshcd_threaded_intr, right?

Agreed. I will leave out this change.

Thanks,

Bart.
