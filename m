Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E8CC54E8E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4A3A2075E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="fd9pigM5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgEKHgt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 03:36:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40318 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728017AbgEKHgt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 03:36:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04B7VCQq008807;
        Mon, 11 May 2020 00:36:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=0zV8+EZtt/0YuvkKZEBiL/aAUzd6nMlTbQXGCH1O5CY=;
 b=fd9pigM54gIN383eKTDcRo/wDcyo/BM3VBhxMvewFUnTTETd+QD8KRcrY8IhMWGjFVTT
 oURuqdf+gnlM7PO1hs/LktwxE0ku/InV6Cz4pZN+YRd5k44LUsXHbwUWlLMjyTBQOzT+
 PSLrbwb4sYbRjtHmZfOEd5gMTXpY1HridLT9G0W38Dcc8ATLXoX9leabPzTgJ3Q/Ka+c
 h4Yjz1IxvUddCfp6aoLxL9iHUGyqFSvAokcMBSzpp+OXcuFubEaAE6f+/QbMhtGtk2th
 O8Uyfj6TEtodRvGFkysbop07ECGzwYRcnCWUiqXZqbA15QTYHIvsaoBRj8VgHGzz9ktc hw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvqdwkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 00:36:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:36:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 May 2020 00:36:41 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 66CE63F703F;
        Mon, 11 May 2020 00:36:41 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 04B7afXk026621;
        Mon, 11 May 2020 00:36:41 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 11 May 2020 00:36:41 -0700
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
Subject: Re: [PATCH v4 07/11] qla2xxx: Change two hardcoded constants into
 offsetof() / sizeof() expressions
In-Reply-To: <20200427030310.19687-8-bvanassche@acm.org>
Message-ID: <alpine.LRH.2.21.9999.2005110036280.23618@irv1user01.caveonetworks.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-8-bvanassche@acm.org>
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

> This patch does not change any functionality.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_fw.h  | 3 +--
>  drivers/scsi/qla2xxx/qla_sup.c | 2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index 4fa34374f34f..f18d2d00d28c 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -2216,9 +2216,8 @@ struct qla_fcp_prio_cfg {
>  #define FCP_PRIO_ATTR_ENABLE    0x1
>  #define FCP_PRIO_ATTR_PERSIST   0x2
>  	uint8_t  reserved;      /* Reserved for future use          */
> -#define FCP_PRIO_CFG_HDR_SIZE   0x10
> +#define FCP_PRIO_CFG_HDR_SIZE   offsetof(struct qla_fcp_prio_cfg, entry)
>  	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
> -#define FCP_PRIO_CFG_ENTRY_SIZE 0x20
>  	uint8_t  reserved2[16];
>  };
>  
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
> index 3da79ee1d88e..57ffbf9d7dbf 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -3617,7 +3617,7 @@ qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *vha)
>  
>  	/* read remaining FCP CMD config data from flash */
>  	fcp_prio_addr += (FCP_PRIO_CFG_HDR_SIZE >> 2);
> -	len = ha->fcp_prio_cfg->num_entries * FCP_PRIO_CFG_ENTRY_SIZE;
> +	len = ha->fcp_prio_cfg->num_entries * sizeof(struct qla_fcp_prio_entry);
>  	max_len = FCP_PRIO_CFG_SIZE - FCP_PRIO_CFG_HDR_SIZE;
>  
>  	ha->isp_ops->read_optrom(vha, &ha->fcp_prio_cfg->entry[0],
> 

Thank you for the patch.

Reviewed-by: Arun Easi <aeasi@marvell.com>
