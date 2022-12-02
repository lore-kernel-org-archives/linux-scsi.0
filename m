Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B72C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 10:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiLBKhu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 05:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiLBKht (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 05:37:49 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3481A22C;
        Fri,  2 Dec 2022 02:37:48 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 448C7411FF;
        Fri,  2 Dec 2022 10:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received:received; s=mta-01; t=
        1669977466; x=1671791867; bh=ZWp1MMAsAJAHYPIe3irwq+JygYGJU8/aDGe
        tX8eqb0A=; b=Yyj2csGY/0z0/2tY3HSIL1c9H7B2CCK7iBzch1RmA9FWng4xb0F
        018dYYAu24f5etgGcUqx1uMrJ/I7TirYaRFZqF6iJtuXofw5pTsWV4VOwtUCH0F+
        CPFgredLtFukW4qcBM/eWYDd/3V/Z+QMy3/spQff60jdc+5proGmhOrc=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aW-J5o5d2v0V; Fri,  2 Dec 2022 13:37:46 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (T-EXCH-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4EBC740889;
        Fri,  2 Dec 2022 13:37:45 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Fri, 2 Dec 2022 13:37:45 +0300
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 2 Dec 2022
 13:37:44 +0300
Date:   Fri, 2 Dec 2022 13:37:44 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [RESEND v2 0/4] target: fix bugs in Persistent Reservations
Message-ID: <20221202103744.GA15327@yadro.com>
References: <20221202103331.14297-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221202103331.14297-1-d.bogdanov@yadro.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 02, 2022 at 01:33:27PM +0300, Dmitry Bogdanov wrote:
> This patch set fixes few rare bugs and deviations from standard in
> PREEMPT AND ABORT and REGISTER AND MOVE operations.
> 
> v2:
>   remove superfluous parentheses
>   fix indentation
> 
> Dmitry Bogdanov (4):
>   target: core: fix preempt and abort for allreg res
>   target: core: fix memory leak in preempt_and_abort
>   target: core: abort all preempted regs if requested
>   target: core: new key must be used for moved PR
> 
>  drivers/target/target_core_pr.c | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
> 
> -- 
> 2.25.1
> 


Sorry, found it in 6.1.
Thought it was not merged because I did not find it in 6.2/scsi-*
branches.
