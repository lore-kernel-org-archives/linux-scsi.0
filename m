Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB138C2D0C9
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 760FD2467A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="l8UwJuty"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfLLQEU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 11:04:20 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:50584 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729605AbfLLQEU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Dec 2019 11:04:20 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6DD3A41207;
        Thu, 12 Dec 2019 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1576166658;
         x=1577981059; bh=sVt5L5TTrp+U47zMMq7ZSO+n1Mf+kWfN+qd3CJ9knrI=; b=
        l8UwJutyEdFWM74HYZvItQx7pKEy6NR8SVVBdP15s3uJUiKUlJ7cqjCXfBJC3TkQ
        KR+p7W7epLsCr2bjebYio0dFj2kuuniDKVsl2WHsRtlFBg1YZOdRy5kkKv8jktR4
        fyj6727db64tuL07q2CsjazppuH8VsvFtXD6QqXalgo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XmWJD4KFJOpo; Thu, 12 Dec 2019 19:04:18 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 66079411FF;
        Thu, 12 Dec 2019 19:04:17 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Dec 2019 19:04:17 +0300
Date:   Thu, 12 Dec 2019 19:04:16 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 2/4] qla2xxx: Simplify the code for aborting SCSI commands
Message-ID: <20191212160416.xzq3x26xwt6ya7n5@SPB-NB-133.local>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191209180223.194959-3-bvanassche@acm.org>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 09, 2019 at 10:02:21AM -0800, Bart Van Assche wrote:
> Since the SCSI core does not reuse the tag of the SCSI command that is
> being aborted by .eh_abort() before .eh_abort() has finished it is not
> necessary to check from inside that callback whether or not the SCSI command
> has already completed. Instead, rely on the firmware to return an error code
> when attempting to abort a command that has already completed. Additionally,
> rely on the firmware to return an error code when attempting to abort an
> already aborted command.
> 
> In qla2x00_abort_srb(), use blk_mq_request_started() instead of
> sp->completed and sp->aborted.
> 
> This patch eliminates several race conditions triggered by the removed member
> variables.
> 

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
