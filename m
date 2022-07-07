Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28449CCA480
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 12:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiGGM55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 08:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbiGGM5V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 08:57:21 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C36317055;
        Thu,  7 Jul 2022 05:57:01 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id B121C41277;
        Thu,  7 Jul 2022 12:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657198618; x=1659013019; bh=zGCab8YrUnIyMI89cdmV30kRAh7pNMw7LPr
        tUa4kg8c=; b=vJ1Jk1jICpj2ukF+S+IYNg3EzbjtV9ySBgIsyyBLZKTIpTWUm64
        DQTSu4+z6c63b+8IAsuHdD/q/iTnzV8aCaqn8DIWTrU28Fy5hWVF9l6gHpeXwHCd
        6tn26u2v3UkxH7RmX2zJojXNmjGEsq438EnHMfvyNS6YUGD4aC5wcJQU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RzBuxTtHjwnH; Thu,  7 Jul 2022 15:56:58 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BE3D441284;
        Thu,  7 Jul 2022 15:56:57 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 15:56:57 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 15:56:56 +0300
Date:   Thu, 7 Jul 2022 15:56:57 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/36] target: Does tmr notify on aborted command
Message-ID: <20220707125657.GB23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <a15b6eb1fd62e7e8bc7ad65f77cd327a2afde07e.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a15b6eb1fd62e7e8bc7ad65f77cd327a2afde07e.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,

On Wed, Jul 06, 2022 at 04:34:49PM -0700, Thinh Nguyen wrote:
> If the tmr_notify is not implemented, simply execute a generic command
> completion to notify the command abort.
Why? What are you trying to fix?
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_tmr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 7a7e24069ba7..2af80d0998bf 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -14,6 +14,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/list.h>
>  #include <linux/export.h>
> +#include <scsi/scsi_proto.h>
>  
>  #include <target/target_core_base.h>
>  #include <target/target_core_backend.h>
> @@ -150,6 +151,9 @@ void core_tmr_abort_task(
>  			if (dev->transport->tmr_notify)
>  				dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
>  							   &aborted_list);
> +			else
> +				target_complete_cmd(se_cmd,
> +						    SAM_STAT_TASK_ABORTED);
That is wrong and breaks a command lifecycle and command kref counting.
target_complete_cmd is used to be called by a backend driver.
>  
>  			list_del_init(&se_cmd->state_list);
>  			target_put_cmd_and_wait(se_cmd);
