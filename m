Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517B930749A
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 10:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115152; cv=none; b=Bv5R794+oPaWYxYqpvzlKXYI8iGdf95Q2I3lWcEm0CbCW98nT+5yrk2E9tkHjgbtGhjD1G5QMZAtDaj7nWQnNWk4QMInkcX8554PSvjTaPjZCkoWXx8SVxbDCI4VooPGO1AyQcIKTRl2kaHOiHREPOHxzjNLOBccyetXkG1ppQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115152; c=relaxed/simple;
	bh=TF226QbAAAA6EEvVrl9j0HYxcwnjA/WMciYUfa1PRGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=KdJve4LJ/+JIxQ08rojn20xFQXgb716fCPfV7tsmUmNz/mL/J9XjB/O5NhJbs2NMcNH6UMkBWSO3UQXW1bA9B0+M4RV+85dueqOaEW1Oi87tyS6M+xq3jyCXFyV+jLccXfTS60vgvpixe+2prvpFo3fAk+sSWoN8wRQgLFvMnqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=t5f2VfIF; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="t5f2VfIF"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20251114101227euoutp0297bc185a54bdf11b85e3a6c3013ed3bb~31_KWBfig3009530095euoutp02E
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 10:12:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20251114101227euoutp0297bc185a54bdf11b85e3a6c3013ed3bb~31_KWBfig3009530095euoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763115147;
	bh=i2rlFt5t7NXjJKVXv7BZBX38ksSyWHfe2bBKQqHxqrw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=t5f2VfIF8/3Nsssenh6mIatxuB3z9rl9Rd3KCVOos05SgiUfg3BG+LWaDybh6QKEf
	 vOxUw6QX2oYa7kvgGy6qKtDW1zAoekLM9Jj4jPdQge0cWksNXOWFxBS//5Gz4somZi
	 6F1DOesDWhKyA6397BilDEDS+RDyBwmZ3cofCkwg=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5~31_J850ak1626216262eucas1p1p;
	Fri, 14 Nov 2025 10:12:26 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251114101226eusmtip250576edea5f93292b467463b466e42ce~31_JRkxHU0287402874eusmtip21;
	Fri, 14 Nov 2025 10:12:26 +0000 (GMT)
Message-ID: <c988a6dd-588d-4dbc-ab83-bbee17f2a686@samsung.com>
Date: Fri, 14 Nov 2025 11:12:25 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Adrian
	Hunter <adrian.hunter@intel.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20251031204029.2883185-22-bvanassche@acm.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5
X-EPHeader: CA
X-CMS-RootMailID: 20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5
References: <20251031204029.2883185-1-bvanassche@acm.org>
	<20251031204029.2883185-22-bvanassche@acm.org>
	<CGME20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5@eucas1p1.samsung.com>

Hi,

On 31.10.2025 21:39, Bart Van Assche wrote:
> Instead of letting the SCSI core allocate hba->nutrs - 1 commands, let
> the SCSI core allocate hba->nutrs commands, set the number of reserved
> tags to 1 and use the reserved tag for device management commands. This
> patch changes the 'reserved slot' from hba->nutrs - 1 into 0 because
> the block layer reserves the smallest tags for reserved commands.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>


This patch landed in today's linux-next as commit 1d0af94ffb5d ("scsi: 
ufs: core: Make the reserved slot a reserved request"). In my tests I 
found that it causes boot failure on Qualcomm Robotics RB5 board. Here 
is the log from UFS probe failure:

ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find 
vdd-hba-supply regulator, assuming enabled
ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find 
vdd-hba-supply regulator, assuming enabled
scsi host0: ufshcd
scsi host0: nr_reserved_cmds set but no method to queue
ufshcd-qcom 1d84000.ufshc: scsi_add_host failed
ufshcd-qcom 1d84000.ufshc: error -EINVAL: Initialization failed with 
error -22
ufshcd-qcom 1d84000.ufshc: error -EINVAL: ufshcd_pltfrm_init() failed
ufshcd-qcom 1d84000.ufshc: probe with driver ufshcd-qcom failed with 
error -22


The 1d0af94ffb5d ("scsi: ufs: core: Make the reserved slot a reserved 
request") is the first commit which breaks UFS probe, but next-20251114 
fails in a bit different way:

ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find 
vdd-hba-supply regulator, assuming enabled
ufshcd-qcom 1d84000.ufshc: freq-table-hz property not specified
ufshcd-qcom 1d84000.ufshc: ufshcd_populate_vreg: Unable to find 
vdd-hba-supply regulator, assuming enabled
scsi host0: ufshcd
Unable to handle kernel NULL pointer dereference at virtual address 
0000000000000000
Mem abort info:
   ESR = 0x0000000096000004
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
   FSC = 0x04: level 0 translation fault
Data abort info:
   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[0000000000000000] user address but active_mm is swapper
Internal error: Oops: 0000000096000004 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 131 Comm: irq/148-ufshcd Not tainted 
6.18.0-rc5-next-20251114 #11692 PREEMPT
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : ufshcd_compl_one_cqe+0x24/0x4ac
lr : __ufshcd_transfer_req_compl+0x24/0x64
...
Call trace:
  ufshcd_compl_one_cqe+0x24/0x4ac (P)
  __ufshcd_transfer_req_compl+0x24/0x64
  ufshcd_poll+0xe4/0x204
  ufshcd_transfer_req_compl+0x44/0x54
  ufshcd_sl_intr+0x1f0/0x670
  ufshcd_threaded_intr+0xb8/0x198
  irq_thread_fn+0x2c/0xa8
  irq_thread+0x1d4/0x410
  kthread+0x150/0x228
  ret_from_fork+0x10/0x20
Code: a9025bf5 aa0203f5 f9401c00 f9413000 (b9400002)
---[ end trace 0000000000000000 ]---
genirq: exiting task "irq/148-ufshcd" (131) is an active IRQ thread (irq 
148)
ufshcd-qcom 1d84000.ufshc: ufshcd_abort: cmd at tag 0 already completed, 
outstanding=0x0, doorbell=0x0
------------[ cut here ]------------
WARNING: drivers/scsi/scsi_error.c:305 at scsi_eh_scmd_add+0x110/0x118, 
CPU#1: kworker/u32:1/61
Modules linked in:
CPU: 1 UID: 0 PID: 61 Comm: kworker/u32:1 Tainted: G D             
6.18.0-rc5-next-20251114 #11692 PREEMPT
Tainted: [D]=DIE
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Workqueue: scsi_tmf_0 scmd_eh_abort_handler
pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : scsi_eh_scmd_add+0x110/0x118
lr : scmd_eh_abort_handler+0x84/0x1c8
...
Call trace:
  scsi_eh_scmd_add+0x110/0x118 (P)
  scmd_eh_abort_handler+0x84/0x1c8
  process_one_work+0x208/0x604
  worker_thread+0x244/0x388
  kthread+0x150/0x228
  ret_from_fork+0x10/0x20
irq event stamp: 15902
hardirqs last  enabled at (15901): [<ffffd07807e1da44>] 
_raw_spin_unlock_irq+0x30/0x6c
hardirqs last disabled at (15902): [<ffffd07807e12970>] 
__schedule+0x410/0xf94
softirqs last  enabled at (13916): [<ffffd07806b46b64>] 
handle_softirqs+0x4c4/0x4dc
softirqs last disabled at (13905): [<ffffd07806a90688>] 
__do_softirq+0x14/0x20
---[ end trace 0000000000000000 ]---

Let me know how can I help debugging this issue.


> ---
>   drivers/ufs/core/ufshcd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index f6eecc03282a..20eae5d9487b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2476,7 +2476,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
>   	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) + 1;
>   	hba->nutmrs =
>   	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
> -	hba->reserved_slot = hba->nutrs - 1;
> +	hba->reserved_slot = 0;
>   
>   	hba->nortt = FIELD_GET(MASK_NUMBER_OUTSTANDING_RTT, hba->capabilities) + 1;
>   
> @@ -8945,7 +8945,6 @@ static int ufshcd_alloc_mcq(struct ufs_hba *hba)
>   		goto err;
>   
>   	hba->host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
> -	hba->reserved_slot = hba->nutrs - UFSHCD_NUM_RESERVED;
>   
>   	return 0;
>   err:
> @@ -9184,6 +9183,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
>   	.proc_name		= UFSHCD,
>   	.map_queues		= ufshcd_map_queues,
>   	.queuecommand		= ufshcd_queuecommand,
> +	.nr_reserved_cmds	= UFSHCD_NUM_RESERVED,
>   	.mq_poll		= ufshcd_poll,
>   	.sdev_init		= ufshcd_sdev_init,
>   	.sdev_configure		= ufshcd_sdev_configure,
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

