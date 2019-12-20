Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 597C9C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A0C621D7D
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:15:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="j7U5znNe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfLTOP4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 09:15:56 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:60942 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727359AbfLTOP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Dec 2019 09:15:56 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4486543E4A;
        Fri, 20 Dec 2019 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1576851354;
         x=1578665755; bh=4SD7fPvSFMmmxRvjlaxu40bhd35Fr/7UsEvVsP68Hkc=; b=
        j7U5znNelISzkvJdU+KzSbav0LD5TVPddrki4yA+efd+et6D6uYGLwtoghYzCglN
        HcfQJJcwe2u4X7l4d+vB2h1VHNlLiUMGzrgaL8K6mmptwpIynjyOKmPseJ4Rjd6m
        frD3VpEDv9bHdrrbYWCvBuYH+//ARk7ykmxn9DyHhI8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4xCaqT_iNPl9; Fri, 20 Dec 2019 17:15:54 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 6FB9342F14;
        Fri, 20 Dec 2019 17:15:52 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 20
 Dec 2019 17:15:52 +0300
Date:   Fri, 20 Dec 2019 17:15:51 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH] qla2xxx: Use get_unaligned_*() instead of open-coding
 these functions
Message-ID: <20191220141551.j2yyewaea6sxey2h@SPB-NB-133.local>
References: <20191219005050.40193-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191219005050.40193-1-bvanassche@acm.org>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 04:50:50PM -0800, Bart Van Assche wrote:
> This patch improves readability and does not change any functionality.
> 
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c    |  2 +-
>  drivers/scsi/qla2xxx/qla_isr.c    | 12 ++++++------
>  drivers/scsi/qla2xxx/qla_nx.c     |  6 +++---
>  drivers/scsi/qla2xxx/qla_target.c | 12 ++++++------
>  drivers/scsi/qla2xxx/qla_target.h |  3 +--
>  5 files changed, 17 insertions(+), 18 deletions(-)
> 

Hi Bart,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thank you,
Roman
