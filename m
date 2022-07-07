Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED78C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 19:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbiGGTkZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiGGTkY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 15:40:24 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B734732EE9;
        Thu,  7 Jul 2022 12:40:22 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 59800412E1;
        Thu,  7 Jul 2022 19:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657222820; x=1659037221; bh=nA8TNY0ornF6bo1cxOMHrE2pNa/DDvkWSdk
        vKTs/bY8=; b=mFN4Ql5l3aqyzjdksEomZBycpVeI0OKIjgRzt+8WCgJLFyXUqHo
        9l5gMG+9XNGzYPxM7T9PE9xSGTcqrvUW2nQHYT4IZFnbV52FRR6nQ1GyzbC/2kXz
        /r3gN2Y9Prwk3M0tr2q4462gZgJTJjNFmx33ny41ICNM4aLzv/zWICrE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aKsmhgZCi4XV; Thu,  7 Jul 2022 22:40:20 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5A074412DE;
        Thu,  7 Jul 2022 22:40:19 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 22:40:19 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 22:40:18 +0300
Date:   Thu, 7 Jul 2022 22:40:18 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 10/36] target: Implement TMR_ABORT_TASK_SET
Message-ID: <20220707194018.GH23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <0004ae8cc8650a32f2aaab0ef9ee3b6e6eb6b69c.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0004ae8cc8650a32f2aaab0ef9ee3b6e6eb6b69c.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,

On Wed, Jul 06, 2022 at 04:35:26PM -0700, Thinh Nguyen wrote:
> Task ABORT TASK SET function is required by SCSI transport protocol
> standards (SAM-4 r14 section 7.3). It is similar to ABORT TASK
> function, but it applies to all commands received on a specified I_T
> nexus rather than a specific referenced command. Modify
> core_tmr_abort_task() to support TMR_ABORT_TASK_SET.
TCM Core does not support Task Sets, there is no list of commands per
I_T nexus. Your patch aborts all commands in all I_T nexuses for the
particular backstore device. That is defenitely not according to SAM.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_tmr.c       | 16 +++++++++++-----
>  drivers/target/target_core_transport.c |  2 +-
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 3e73f60319d5..e77721db1ea9 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -132,11 +132,13 @@ void core_tmr_abort_task(
>  				continue;
>  
>  			ref_tag = se_cmd->tag;
> -			if (tmr->ref_task_tag != ref_tag)
> -				continue;
> +			if (tmr->function == TMR_ABORT_TASK) {
> +				if (tmr->ref_task_tag != ref_tag)
> +					continue;
>  
> -			pr_err("ABORT_TASK: Found referenced %s task_tag: %llu\n",
> -			       se_cmd->se_tfo->fabric_name, ref_tag);
> +				pr_err("ABORT_TASK: Found referenced %s task_tag: %llu\n",
> +				       se_cmd->se_tfo->fabric_name, ref_tag);
> +			}
>  
>  			spin_lock(&se_sess->sess_cmd_lock);
>  			rc = __target_check_io_state(se_cmd, se_sess, 0);
> @@ -159,7 +161,11 @@ void core_tmr_abort_task(
>  			target_put_cmd_and_wait(se_cmd);
>  
>  			atomic_long_inc(&dev->aborts_complete);
> -			goto exit;
> +
> +			if (tmr->function == TMR_ABORT_TASK)
> +				goto exit;
> +
> +			spin_lock_irqsave(&dev->queues[i].lock, flags);
>  		}
>  		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
>  	}
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index cbd876e44cf0..bc1e4a7c4538 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -3519,9 +3519,9 @@ static void target_tmr_work(struct work_struct *work)
>  
>  	switch (tmr->function) {
>  	case TMR_ABORT_TASK:
> +	case TMR_ABORT_TASK_SET:
>  		core_tmr_abort_task(dev, tmr, cmd->se_sess);
>  		break;
> -	case TMR_ABORT_TASK_SET:
>  	case TMR_CLEAR_ACA:
>  	case TMR_CLEAR_TASK_SET:
>  		tmr->response = TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
