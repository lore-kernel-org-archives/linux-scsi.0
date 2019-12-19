Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9660BC2D0D1
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AD2D24679
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 23:05:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="fTm9xXat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLSXFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:05:16 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:33322 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726880AbfLSXFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Dec 2019 18:05:16 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 3F3C443E4A;
        Thu, 19 Dec 2019 23:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1576796713;
         x=1578611114; bh=vxbY+61kqRPvvUVsKszJ+EXGNlqLWwgESkvFbC0zDYg=; b=
        fTm9xXat5vARPybdZRILrifCVS755+Vc+NJIRRbOAN6vd+O2y74TqnHFGNwWAU4F
        6Ygjx87G9kJ9dZVT6+jT1e5NI8NQjasYthAksCLWRK62y8XaIJkLlldaz7Lxjvjh
        OkRBY+mVEJk4wFLU4vQZlIlxhk8H9ltsomaieE/bXCw=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uDNwsBtAtXKJ; Fri, 20 Dec 2019 02:05:13 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 535F942F14;
        Fri, 20 Dec 2019 02:05:11 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 20
 Dec 2019 02:05:10 +0300
Date:   Fri, 20 Dec 2019 02:05:10 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH] qla2xxx: Fix sparse warnings triggered by the PCI state
 checking code
Message-ID: <20191219230510.fikl67ynbozkofst@SPB-NB-133.local>
References: <20191219004412.37639-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191219004412.37639-1-bvanassche@acm.org>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 18, 2019 at 04:44:12PM -0800, Bart Van Assche wrote:
> This patch fixes the following sparse warnings:
> 
> drivers/scsi/qla2xxx/qla_mbx.c:120:21: warning: restricted pci_channel_state_t degrades to integer
> drivers/scsi/qla2xxx/qla_mbx.c:120:37: warning: restricted pci_channel_state_t degrades to integer
> 
> This patch does not change any functionality. From include/linux/pci.h:
> 
> enum pci_channel_state {
> 	/* I/O channel is in normal state */
> 	pci_channel_io_normal = (__force pci_channel_state_t) 1,
> 
> 	/* I/O to channel is blocked */
> 	pci_channel_io_frozen = (__force pci_channel_state_t) 2,
> 
> 	/* PCI card is dead */
> 	pci_channel_io_perm_failure = (__force pci_channel_state_t) 3,
> };
> 
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 5 ++---
>  drivers/scsi/qla2xxx/qla_mr.c  | 5 ++---
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 

Hi Bart,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thank you,
Roman
