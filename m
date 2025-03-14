Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F52F510;
	Fri, 14 Mar 2025 03:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741921604; cv=none; b=hAxBzazZHzlFv7URAxEvBfsyzgeV63M2CuB25ZOP2AqHSDEGriZpyl+OEbauGGeJIlSGcaEgIvlD8vkVu2t1pVwTqQXjzfkoDxdV/4uhxS7zasRyYyUbXjI90kIIJRSRixClP3Qg+gIgIBKfxYsw+nS/7hnnhvPVza/cLdlF6bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741921604; c=relaxed/simple;
	bh=6XZicQHLQqb4T7I/ydtcb11NevXJ7bNf/I7ArCZbO1A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=qjFxD4vGZdbnG/JwxltVswbncB1lTxGc/ztFxqjZsxLqCfpbWCTq8duy9u+cNckym0PJY1WYc7WKb36pVaROsq3/rvH6memOjqvDoY4OMQOrP+zAiPV/VA+ZM3YvVVPkKs+4W5WwaZDCoIUCit2F9yHa9zrlouneFOkkgjhartQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=utY0Rf8U; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="utY0Rf8U"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1741921591; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=ZdF5ctGvLKDq5pX+AOnPf55RBc72mHWr0uw0L9GfUQ4=;
	b=utY0Rf8UewZAN6D0nbn84WXVO3dlb53tCjyyF27ZzDzW5DboFZYRoi/ibCAhmyOKSL0/fWRl107EmJ6Z3v0z0NN3HZ+TRqeloUpiIbBwT+hRf8jGcp7QoHGJdc88p7gUM8x55XiA98j1dma624kpiKiYgCEVUT4IamvwYyP2k1k=
Received: from 30.178.82.115(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WRIq-CV_1741921589 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Mar 2025 11:06:30 +0800
Message-ID: <74d40ff9-9bb4-40dc-be80-13faf3c896d7@linux.alibaba.com>
Date: Fri, 14 Mar 2025 11:06:29 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH] scsi: target: tcm_loop: fix wrong abort tag
From: Guixin Liu <kanie@linux.alibaba.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250313014728.105849-1-kanie@linux.alibaba.com>
In-Reply-To: <20250313014728.105849-1-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Gently ping...

Hi Martin, this is a serious issue I think, cloud you plz take a look?

Best Regards,

Guixin Liu

在 2025/3/13 09:47, Guixin Liu 写道:
> When the tcm_loop_nr_hw_queues is set to a value greater than 1, the
> tags of requests in the block layer are no longer unique. This may lead
> to erroneous aborting of commands with the same tag. The issue can be
> resolved by using blk_mq_unique_tag to generate globally unique
> identifiers by combining the hardware queue index and per-queue tags.
>
> Fixes: 6375f8908255 ("tcm_loop: Fixup tag handling")
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>   drivers/target/loopback/tcm_loop.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 761c511aea07..c7b7da629741 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -176,7 +176,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>   
>   	memset(tl_cmd, 0, sizeof(*tl_cmd));
>   	tl_cmd->sc = sc;
> -	tl_cmd->sc_cmd_tag = scsi_cmd_to_rq(sc)->tag;
> +	tl_cmd->sc_cmd_tag = blk_mq_unique_tag(scsi_cmd_to_rq(sc));
>   
>   	tcm_loop_target_queue_cmd(tl_cmd);
>   	return 0;
> @@ -242,7 +242,8 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
>   	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
>   	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
>   	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
> -				 scsi_cmd_to_rq(sc)->tag, TMR_ABORT_TASK);
> +				 blk_mq_unique_tag(scsi_cmd_to_rq(sc)),
> +				 TMR_ABORT_TASK);
>   	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
>   }
>   
