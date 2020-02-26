Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C5C1C4BA09
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 00:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6D821D7E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 00:28:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="rbcXGWyI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgBZA2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 19:28:16 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:40816 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728756AbgBZA2P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Feb 2020 19:28:15 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id E6AE241273;
        Wed, 26 Feb 2020 00:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1582676891;
         x=1584491292; bh=WedSfKeqc1zyGNbtC4jXPgZg3Uq2c72mEw1tYMH2yGo=; b=
        rbcXGWyI4LinALWFVS7U7i36Z4ylczKGvDlnDDePvkuGD5+iHpx6WgU+YDBxdZOt
        gnCqxR+wmMSBX0sin7dteL7h7tgKn5iFycMxQIUImcQeRy7lB7hBBdm/+l7hGqmu
        +JIXoI6p7MPhMo7VcV39cq0cOVd6RNoU2y/TLPXyR2s=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wW-viEYMCRss; Wed, 26 Feb 2020 03:28:11 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 75921412F5;
        Wed, 26 Feb 2020 03:28:10 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-01.corp.yadro.com
 (172.17.10.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 26
 Feb 2020 03:28:10 +0300
Date:   Wed, 26 Feb 2020 03:28:10 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH v3 4/5] qla2xxx: Convert MAKE_HANDLE() from a define into
 an inline function
Message-ID: <20200226002810.cyy7f3yms3vljb45@SPB-NB-133.local>
References: <20200220043441.20504-1-bvanassche@acm.org>
 <20200220043441.20504-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200220043441.20504-5-bvanassche@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-01.corp.yadro.com (172.17.10.101)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 19, 2020 at 08:34:40PM -0800, Bart Van Assche wrote:
> This patch allows sparse to verify the endianness of the arguments passed
> to make_handle().
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h    |  5 ++++-
>  drivers/scsi/qla2xxx/qla_iocb.c   | 22 +++++++++++-----------
>  drivers/scsi/qla2xxx/qla_mbx.c    | 10 +++++-----
>  drivers/scsi/qla2xxx/qla_mr.c     |  8 ++++----
>  drivers/scsi/qla2xxx/qla_nvme.c   |  2 +-
>  drivers/scsi/qla2xxx/qla_target.c |  6 +++---
>  6 files changed, 28 insertions(+), 25 deletions(-)
> 

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman
