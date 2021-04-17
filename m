Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B0EC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Apr 2021 09:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CE2361208
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Apr 2021 09:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhDQJkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Apr 2021 05:40:03 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:44938 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229972AbhDQJkC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 17 Apr 2021 05:40:02 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id CEDC7413D2;
        Sat, 17 Apr 2021 09:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1618652373;
         x=1620466774; bh=nNLbfatnt9znI+gpSdF8GgAQ2dxWCosWkubC/S0bxQc=; b=
        nVZqGR0VCxsEwpBFH1I0LwmxQl12167oWJKDtT49NPH5q160JDjSh3dzbDwMSiz8
        h7aC/1pV9yguXsK4BhFe/nzcUg4SGh9Cy5wVjxgP4wO9wq0t54fnGilW6YKsMSyg
        GhZwBPhTEEDWk+VDdjT+EimTZhaBu6gvlYbOO8hEe/k=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M6vuVwMTIk2N; Sat, 17 Apr 2021 12:39:33 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id BC196413C8;
        Sat, 17 Apr 2021 12:39:33 +0300 (MSK)
Received: from yadro.com (10.199.0.198) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Sat, 17
 Apr 2021 12:39:32 +0300
Date:   Sat, 17 Apr 2021 12:39:31 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v2] target: core: remove from tmr_list at lun unlink
Message-ID: <YHqs0xUAP/AbOhgY@yadro.com>
References: <20210416092146.3201-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210416092146.3201-1-d.bogdanov@yadro.com>
X-Originating-IP: [10.199.0.198]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 16, 2021 at 12:21:46PM +0300, Dmitry Bogdanov wrote:
> @@ -719,8 +726,16 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
>  	if (!lun)
>  		return;
>  
> +	target_remove_from_state_list(cmd);
> +	target_remove_from_tmr_list(cmd);
> +
>  	if (cmpxchg(&cmd->lun_ref_active, true, false))
>  		percpu_ref_put(&lun->lun_ref);
> +
> +	/*
> +	 * Clear struct se_cmd->se_lun before the handoff to FE.
> +	 */
> +	cmd->se_lun = NULL;
>  }

Sadly we just found out that this code is racing with
core_tmr_drain_tmr_list(). If LUN RESET comes in while there are still
some outstanding ABORT TASK functions left, the following sequence is
possible:

  1. During LUN RESET processing core_tmr_drain_tmr_list() is called
  2. During ABORT TASK processing transport_lun_remove_cmd() is called
     at the sime time
  3. core_tmr_drain_tmr_list() acquires &dev->se_tmr_lock lock and moves
     TMRs to the on-stack drain_tmr_list
  4. core_tmr_drain_tmr_list() releases &dev->se_tmr_lock and starts
     working on the drain_tmr_list
  5. At the same moment target_remove_from_tmr_list() is called
  6. It acquires &dev->se_tmr_lock, removes TMR from the list by
     list_del_init() and releases &dev->se_tmr_lock

What happens next is this:

  [  391.438244] LUN_RESET:  releasing TMR 00000000e2ee2634 Function: 0x01, Response: 0x05, t_state: 11
  [  391.438246] LUN_RESET:  releasing TMR 00000000e2ee2634 Function: 0x01, Response: 0x05, t_state: 11

The same TMR is being pulled out twice out of the drain_tmr_list. This
happens because there are no locks that prevent the list traversal in
core_tmr_drain_tmr_list() and the list element removal in
target_remove_from_tmr_list() from being executed concurrently. So
list_del_init() in target_remove_from_tmr_list() calls INIT_LIST_HEAD()
and tmr_p->next now points to tmr_p.

Hence the following warnings:

  [  391.438300] WARNING: CPU: 12 PID: 20064 at ../drivers/target/target_core_transport.c:2785
  ...
  [  391.438448] WARNING: CPU: 12 PID: 20064 at ../lib/refcount.c:28 refcount_warn_saturate+0x224/0x240

This issue also prevents other TMRs from being released, resulting in a
stuck session. Not always, since sometimes drain_tmr_list only contains
one element, but still possible.
