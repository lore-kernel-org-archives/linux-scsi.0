Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2A5C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 13:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiGGNgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 09:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235431AbiGGNgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 09:36:54 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47DE81EAEF;
        Thu,  7 Jul 2022 06:36:53 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C507D412C4;
        Thu,  7 Jul 2022 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657201010; x=1659015411; bh=zUvmMWD6iFCfHHkpBy7NcvluLpihixshrpR
        oASJvo/I=; b=L0FRHozSCzg7evOnJRl8KhMzrx8DZHSPTLKcOaUheIF/Dt0JQj0
        C3Xr9dzA3rC81fg2zUHgjGS0SihUaj43HwEx8gyonAwdVrKgGTDj8HEj15ZKb4Rm
        YoVKbmQc3Kx5GQ6VKEje/CS+WNv6y8Ih6mXSz6o/bOHmTeCjO+AHRUdA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hKlvNcvD0SxE; Thu,  7 Jul 2022 16:36:50 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 22E834127A;
        Thu,  7 Jul 2022 16:36:45 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-02.corp.yadro.com (172.17.10.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 16:36:45 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 16:36:44 +0300
Date:   Thu, 7 Jul 2022 16:36:44 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 07/36] target: Don't do tmr_notify on empty aborted list
Message-ID: <20220707133644.GE23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <92ec6c71a200b42c1a70ba2054087da9715741c8.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <92ec6c71a200b42c1a70ba2054087da9715741c8.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thinh,

On Wed, Jul 06, 2022 at 04:35:07PM -0700, Thinh Nguyen wrote:
> If there's no command to abort, just skip doing tmr_notify to an empty
> list.
AFAIK, that was intentionaly:
https://lore.kernel.org/all/20200726153510.13077-3-bstroesser@ts.fujitsu.com/
   'If no commands were aborted, an empty list is supplied.'

 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_tmr.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index 724ddabda488..718d985e4860 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -167,9 +167,6 @@ void core_tmr_abort_task(
>  		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
>  	}
>  
> -	if (dev->transport->tmr_notify)
> -		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
> -
>  	printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %lld\n",
>  			tmr->ref_task_tag);
>  	tmr->response = TMR_FUNCTION_COMPLETE;
