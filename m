Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BF8C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 12:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiGGMme (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 08:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbiGGMmd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 08:42:33 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D912C12A;
        Thu,  7 Jul 2022 05:42:32 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id EA3A341284;
        Thu,  7 Jul 2022 12:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1657197749; x=1659012150; bh=SFbBymaiUxvrKTqJtE5EErQrVuTsnYRNJgd
        ycIyafUc=; b=eBBj2PFoG17PuLFITuGJfNwD6Sx8XSizGi7kJsx5J5MUf1DijMY
        D13qNNbDoV4Ql4gEmO8XocF7pPNYbb0CXvVE4Oy8tXtJkf4dig7PH7YeXbQxfjru
        Ui9z4e7URMhWhoO6Hp4eGjh+rMZkA4mmEBbNK2zyO3iwLZKMyLwdQkgE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2N-QhsxFOTy1; Thu,  7 Jul 2022 15:42:29 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 7F1024127F;
        Thu,  7 Jul 2022 15:42:27 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Thu, 7 Jul 2022 15:42:27 +0300
Received: from yadro.com (10.178.114.42) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 7 Jul 2022
 15:42:26 +0300
Date:   Thu, 7 Jul 2022 15:42:26 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 03/36] target: Don't drain empty list
Message-ID: <20220707124226.GA23838@yadro.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <0af951cacb921def80b5dfbc0ca82b39b1ecd1cc.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0af951cacb921def80b5dfbc0ca82b39b1ecd1cc.1657149962.git.Thinh.Nguyen@synopsys.com>
X-Originating-IP: [10.178.114.42]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2022 at 04:34:42PM -0700, Thinh Nguyen wrote:
> If the preempt_and_abort_list is NULL, don't attempt to drain it.
> Otherwise, it may lead to invalid access.
> 
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
>  drivers/target/target_core_tmr.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
> index bac111456fa1..7a7e24069ba7 100644
> --- a/drivers/target/target_core_tmr.c
> +++ b/drivers/target/target_core_tmr.c
> @@ -383,9 +383,11 @@ int core_tmr_lun_reset(
>  		(preempt_and_abort_list) ? "Preempt" : "TMR",
>  		dev->transport->name, tas);
>  
> -	core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
> -	core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
> -				preempt_and_abort_list);
> +	if (preempt_and_abort_list) {
> +		core_tmr_drain_tmr_list(dev, tmr, preempt_and_abort_list);
> +		core_tmr_drain_state_list(dev, prout_cmd, tmr_sess, tas,
> +					  preempt_and_abort_list);
> +	}
Those functions are not about to drain preempt_and_abort_list. And there
are no invalid access inside.
This patch breaks the tmf_abort functionality.
NACK
>  
>  	/*
>  	 * Clear any legacy SPC-2 reservation when called during
