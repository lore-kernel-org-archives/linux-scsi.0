Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E463AB466;
	Thu, 30 Jul 2026 07:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785396521; cv=none; b=hgshHSBZcj0JzptyaykQtrDsvy6lPraPDIhUA9Jt2T4ae6NoTGQ17sCNSiua66lP1NdEmU/e7IoKLVOxX+rv08C7ZEtRWUSc+onyZ9u6lCUpGG67Q3zsA17wsIz2EoiveP4hELjImESCFDKBOulrcJD224MYuetrdaceKKW1aUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785396521; c=relaxed/simple;
	bh=8JLvKp02JIDLvz0o3DUHGjug4ffl0qxbgVn2nHsp+6g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uILGHlhMt7IVJYdQZ9y5U3YR/HGmsOgsWxh2Jp3zWZcDsiXTKFC5eO/T614yGecLjV4Axw09TXfBPUyAmcm8Rj4+cHuD/zyDgSKZbbtj2OC73X9myCQ2AVBOO4Zwvt860ypaU07cNQ6TeAmCOAgmhViuT0+FjKayez2v3NEIerw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h9glV6PtczYQtrR;
	Thu, 30 Jul 2026 15:27:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 4656C4058F;
	Thu, 30 Jul 2026 15:28:33 +0800 (CST)
Received: from [10.174.176.179] (unknown [10.174.176.179])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgBHg0If_WpqobTeAQ--.50972S3;
	Thu, 30 Jul 2026 15:28:33 +0800 (CST)
Message-ID: <fc2543b6-9f73-4128-8e6b-32da1221b772@huaweicloud.com>
Date: Thu, 30 Jul 2026 15:28:30 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: do not block on tag allocation in
 scsi_eh_lock_door()
To: Zizhi Wo <wozizhi@huaweicloud.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 yangerkun@huawei.com, chengzhihao1@huawei.com, yukuai@fygo.io,
 zhousiqi5@huawei.com
References: <20260723041238.1584632-1-wozizhi@huaweicloud.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <20260723041238.1584632-1-wozizhi@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBHg0If_WpqobTeAQ--.50972S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWrWrtF18uFy8JFWUCF1rWFg_yoW5Gr15pF
	WDWa1qkrZ8WF1093Wqq34fWFyYvw47C343ta1xG34fAFZ8JFyv9Fnrta4jqFWxur97tF1U
	Jr1qqFyDW3WUX37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

friendly ping

在 2026/7/23 12:12, Zizhi Wo 写道:
> From: Zizhi Wo <wozizhi@huawei.com>
> 
> scsi_eh_lock_door() is called from scsi_restart_operations() while the host
> is still in the SHOST_RECOVERY state, i.e. before the host is switched back
> to SHOST_RUNNING and scsi_run_host_queues() restarts the queues. It
> allocates a request via scsi_alloc_request() with no flags, so
> blk_mq_get_tag() may block waiting for a free sched tag when all tags are
> already in use.
> 
> Those tags can be held by commands that were just requeued by
> scsi_eh_flush_done_q() during error handling. Such commands cannot be
> dispatched until the host leaves SHOST_RECOVERY and scsi_run_host_queues()
> is called - which only happens *after* scsi_eh_lock_door() returns.
> 
> This forms a circular dependency:
> 
>    - scsi_eh_lock_door(), running in the SCSI error handler thread, waits
>      for a sched tag held by a requeued command;
>    - the requeued command cannot complete and release its sched tag until
>      the error handler thread leaves scsi_restart_operations() and restart
>      the queues.
> 
> For devices with a single driver tag (e.g. USB storage) it is a guaranteed
> deadlock and I/O that can never be submitted. This problem has also been
> reproduced in our environment.
> 
> Locking the door is a best-effort operation, and scsi_eh_lock_door()
> already returns silently when the request allocation fails. Pass
> BLK_MQ_REQ_NOWAIT to scsi_alloc_request() so the allocation fails instead
> of blocking when no tag is available. This breaks the circular dependency
> and allows the error handler to finish restarting the queues, after which
> the pending commands are dispatched normally.
> 
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>   drivers/scsi/scsi_error.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 147127fb4db9..3d42fe7701b7 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2139,11 +2139,11 @@ static enum rq_end_io_ret eh_lock_door_done(struct request *req,
>   static void scsi_eh_lock_door(struct scsi_device *sdev)
>   {
>   	struct scsi_cmnd *scmd;
>   	struct request *req;
>   
> -	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
> +	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT);
>   	if (IS_ERR(req))
>   		return;
>   	scmd = blk_mq_rq_to_pdu(req);
>   
>   	scmd->cmnd[0] = ALLOW_MEDIUM_REMOVAL;

