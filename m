Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000B6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 13:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbiGGNkc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 09:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiGGNk3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 09:40:29 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6432870C;
        Thu,  7 Jul 2022 06:40:28 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 53B784127A;
        Thu,  7 Jul 2022 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657201226; x=1659015627; bh=l+ZCvWqqdWG5+QB5dYesLdnfInnK5ws/Bwk
        DJG/Scd4=; b=Nv2B7Ran7fRG+/Dew1MdOpxm2mYrwKx8cR7HoMAyBqigoQugnKA
        wyrsHRQnK2tPhGzpdOknqoKVKCBN3EYt/nXrNaSvst1zg985XlhZXpqtFAMDWwVQ
        mkYo075tTB0QYz/fXerJPzAjJpUiBB63BVEid3hR7Ksbw63S0n753ECE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id quE-4-1Nrszy; Thu,  7 Jul 2022 16:40:26 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 65E9241273;
        Thu,  7 Jul 2022 16:40:25 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 16:40:25 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 16:40:24 +0300
Date:   Thu, 7 Jul 2022 16:40:24 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 08/36] target: Refactor core_tmr_abort_task
Message-ID: <20220707134024.GF23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <5b89eee29b74fbafaa9df34ca3f6170d1cfc5728.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5b89eee29b74fbafaa9df34ca3f6170d1cfc5728.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2022 at 04:35:14PM -0700, Thinh Nguyen wrote:
> Minor refactoring of core_tmr_abort_task to avoid duplicate code. No
> functional change here.
Regardless that previous patch on that place is incorrect,
this patch also breaks the statistic counters.
dev->aborts_no_task counter is incremented on the end of the function,
and should not be incremented for the case when command to be aborted is
found.

> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_tmr.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 718d985e4860..3e73f60319d5 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -158,15 +158,13 @@ void core_tmr_abort_task(
>  			list_del_init(&se_cmd->state_list);
>  			target_put_cmd_and_wait(se_cmd);
>  
> -			pr_err("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %llu\n",
> -			       ref_tag);
> -			tmr->response = TMR_FUNCTION_COMPLETE;
>  			atomic_long_inc(&dev->aborts_complete);
> -			return;
> +			goto exit;
>  		}
>  		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
>  	}
>  
> +exit:
>  	printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %lld\n",
>  			tmr->ref_task_tag);
>  	tmr->response = TMR_FUNCTION_COMPLETE;
