Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FA7C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D4F2075E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:32:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="Z5LunKKw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgEKHc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 03:32:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39090 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728014AbgEKHc4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 03:32:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04B7Vvhq010414;
        Mon, 11 May 2020 00:32:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=IYqyxWa0bBeqziphfJ/mEaCN1LURyxS72oXhB5Ggdxw=;
 b=Z5LunKKwRj8c1x7tl03NJ7ansnpLG/rx8DMfEliO84ITaDh9rAFJb7e1ayTwgH6Nq5cK
 eZR9UcdLjHfrdn6xS9wsV7yykCH0UsAHYMQjRal78cd03zSU6xA5vcykrDDZdLIQJzE0
 1N7pBJnYXjI13v9Z6lgJU2lPZXmVUIhS+a9BMXygWCDyBmycmbW8fJcR42QGqWgw1vxO
 ykP6ZR2dkubh9YBGmJDMXFtDJksHynAhwN0lKDz4yxQpjuTDl0gnino19dNmPnHYZREA
 70fLwQVxrAkiYNxc5YxF9ve0wYne1CpwqRkPqjLealGMM0FXwfnyKNpj856gDVqTJLi1 tg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvqdw8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 00:32:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:32:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:32:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 May 2020 00:32:43 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id AF68E3F703F;
        Mon, 11 May 2020 00:32:43 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 04B7Whlq022750;
        Mon, 11 May 2020 00:32:43 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 11 May 2020 00:32:43 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>,
        "Nilesh Javali" <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        "Daniel Wagner" <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v4 03/11] qla2xxx: Sort BUILD_BUG_ON() statements
 alphabetically
In-Reply-To: <20200427030310.19687-4-bvanassche@acm.org>
Message-ID: <alpine.LRH.2.21.9999.2005110032360.23618@irv1user01.caveonetworks.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-4-bvanassche@acm.org>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_02:2020-05-11,2020-05-11 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 26 Apr 2020, 8:03pm, Bart Van Assche wrote:

> Before adding more BUILD_BUG_ON() statements, sort the existing statements
> alphabetically.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d190db5ea7d9..497544413aa0 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7835,11 +7835,11 @@ qla2x00_module_init(void)
>  	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
>  	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
>  	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
> +	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
> +	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
>  	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
>  	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
>  	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
> -	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
> -	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
>  
>  	/* Allocate cache for SRBs. */
>  	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
> 

Reviewed-by: Arun Easi <aeasi@marvell.com>
