Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51843CCA480
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 13:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbiGGNQL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 09:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbiGGNQK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 09:16:10 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2446424BDD;
        Thu,  7 Jul 2022 06:16:08 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B614B40416;
        Thu,  7 Jul 2022 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657199765; x=1659014166; bh=X8bBWp1l2bHD3vYIkQPPmvsbTczBXYy+Bfq
        V0Vmpb34=; b=GVXOWImPn4f3nsqIQvoBxQGzCEJu9l1ZTRcLg37NN1b930s9sIE
        l1ZRrS/uMrNtL/dqp2Kj3c3MCDTwDWbkPCUHkSfwcWvprmJSb7gOY1cUeaUALTUY
        bueoPVEJ3aM+ksglX01Ez9b/Mlttsrwd69HT2nL9ECbhKH9qLkNVCJV0=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8tyPnkjaud1E; Thu,  7 Jul 2022 16:16:05 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 92D074124A;
        Thu,  7 Jul 2022 16:16:04 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 16:16:04 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 16:16:03 +0300
Date:   Thu, 7 Jul 2022 16:16:03 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 05/36] target: Don't remove command too early
Message-ID: <20220707131603.GC23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <bb728dcbc73942cda3ae64d0d26195c9a284996d.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bb728dcbc73942cda3ae64d0d26195c9a284996d.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,

On Wed, Jul 06, 2022 at 04:34:55PM -0700, Thinh Nguyen wrote:
> A command completion is asynchronous, regardless if an abort command is
> executed. Don't just free the command before its completion. Similarly,
> a TMR command is not completed until its response is completed. The
> freeing of the command can be done by the target user through
> target_generic_free_cmd().
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_transport.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 7838dc20f713..105d3b0e470f 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -836,10 +836,6 @@ static void target_handle_abort(struct se_cmd *cmd)
>  	}
>  
>  	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);
> -
> -	transport_lun_remove_cmd(cmd);
> -
> -	transport_cmd_check_stop_to_fabric(cmd);
>  }
>  
>  static void target_abort_work(struct work_struct *work)
> @@ -3553,9 +3549,6 @@ static void target_tmr_work(struct work_struct *work)
>  		goto aborted;
>  
>  	cmd->se_tfo->queue_tm_rsp(cmd);
> -
> -	transport_lun_remove_cmd(cmd);
> -	transport_cmd_check_stop_to_fabric(cmd);
>  	return;
>  
>  aborted:
Those functions are not about to free the command.
transport_lun_remove_cmd is for remove command from the state/tmr list.
transport_cmd_check_stop_to_fabric is for notify a fabric driver to
decrease the command kref that it owns. And eventually to wake
target_put_cmd_and_wait() in core_tmr_abort_task().

Those functions do always are called after a final response has been sent
(STATUS, CHECK_CONDITION,etc).
Those functions do not break the abort functionality. But this patch
does.


