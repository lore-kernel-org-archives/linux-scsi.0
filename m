Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5992C35E04
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 19:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE35121744
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 19:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="ci2E5F/x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbgBYTOG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 14:14:06 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:41386 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728443AbgBYTOG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Feb 2020 14:14:06 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id DBF7741279;
        Tue, 25 Feb 2020 19:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1582658042;
         x=1584472443; bh=1MkyS4ITB+yxiRyssMgjGuURTQCXJX8TsN3FuJaIJhc=; b=
        ci2E5F/xH95bgnO7L0Bs9+AL5c/IkBHpS/48Nj7jawyNNzah4kx0M7ClhU4L+NcJ
        lSW+ThKIFo5XKPRC3Hd1itOcyNKJXySz0i9YUizOzVgUGTugMYCY0qbFE2QZuy1P
        oh2Xyw+5qd51x7jtBMhzjTipOjnLJdmbBclHYD4IRXk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TPVs09tTN9Qg; Tue, 25 Feb 2020 22:14:02 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id C773D4127F;
        Tue, 25 Feb 2020 22:13:59 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-01.corp.yadro.com
 (172.17.10.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 25
 Feb 2020 22:13:59 +0300
Date:   Tue, 25 Feb 2020 22:13:59 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Daniel Wagner <dwagner@suse.de>,
        Quinn Tran <qutran@marvell.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 3/5] qla2xxx: Fix sparse warnings triggered by the PCI
 state checking code
Message-ID: <20200225191359.3mvdrjjfzm5ubl5h@SPB-NB-133.local>
References: <20200220043441.20504-1-bvanassche@acm.org>
 <20200220043441.20504-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200220043441.20504-4-bvanassche@acm.org>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-01.corp.yadro.com (172.17.10.101)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 19, 2020 at 08:34:39PM -0800, Bart Van Assche wrote:
> This patch fixes the following sparse warnings:
> 
> drivers/scsi/qla2xxx/qla_mbx.c:120:21: warning: restricted pci_channel_state_t degrades to integer
> drivers/scsi/qla2xxx/qla_mbx.c:120:37: warning: restricted pci_channel_state_t degrades to integer
> 
> From include/linux/pci.h:
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
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 5 ++---
>  drivers/scsi/qla2xxx/qla_mr.c  | 5 ++---
>  2 files changed, 4 insertions(+), 6 deletions(-)
> 

I'm sorry, replied to wrong version in previous email,

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
