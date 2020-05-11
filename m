Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3ACC54E8E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E18382075E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:36:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="RTvHeOdP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgEKHgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 03:36:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37024 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725790AbgEKHgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 03:36:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04B7VCMi008798;
        Mon, 11 May 2020 00:36:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=326gXKwjhi/cHRo3Z/Mow392m2UFKsRyOxkjerIe/ug=;
 b=RTvHeOdPKFnobtk2g7RrvlASB/3yvbA5NPGf6FBkaI+2EieIkIlJO8xapsKJQlTpy9Kh
 yeE28fHIUzBpTO9SSk9v7TVUBX5ZNQAKrKXZoJ3frHm/IOHWwjQAs4rPxzjKL3EMDLAF
 228zgIpAaBw4TYXPC40SYxAJb1lWZdG5SSX+6bg7h2QuBcPeixJV3CtFgilYNerV7xps
 VJvpfESII+T9+grC3E5dP5EVNZPIG8SIGl9yp5o7GVgP9113NYJGnw20RDFfS32GQ9c+
 CkwCpc1GRdIVUhE43+NIn14HKSj3dT8l3sxr7mv6EUjvSkjkQ8+3ZjqsSdTIszb0ld0b pA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvqdwhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 00:36:02 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:36:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 May 2020 00:36:01 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 0F96D3F703F;
        Mon, 11 May 2020 00:36:01 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 04B7a0eF025897;
        Mon, 11 May 2020 00:36:00 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 11 May 2020 00:36:00 -0700
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
Subject: Re: [PATCH v4 06/11] qla2xxx: Increase the size of struct qla_fcp_prio_cfg
 to FCP_PRIO_CFG_SIZE
In-Reply-To: <20200427030310.19687-7-bvanassche@acm.org>
Message-ID: <alpine.LRH.2.21.9999.2005110035150.23618@irv1user01.caveonetworks.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-7-bvanassche@acm.org>
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

> This patch fixes the following Coverity complaint without changing any
> functionality:
> 
> CID 337793 (#1 of 1): Wrong size argument (SIZEOF_MISMATCH)
> suspicious_sizeof: Passing argument ha->fcp_prio_cfg of type
> struct qla_fcp_prio_cfg * and argument 32768UL to function memset is
> suspicious because a multiple of sizeof (struct qla_fcp_prio_cfg) /*48*/
> is expected.
> 
> memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_fw.h | 3 ++-
>  drivers/scsi/qla2xxx/qla_os.c | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index b364a497e33d..4fa34374f34f 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -2217,8 +2217,9 @@ struct qla_fcp_prio_cfg {
>  #define FCP_PRIO_ATTR_PERSIST   0x2
>  	uint8_t  reserved;      /* Reserved for future use          */
>  #define FCP_PRIO_CFG_HDR_SIZE   0x10
> -	struct qla_fcp_prio_entry entry[1];     /* fcp priority entries  */
> +	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
>  #define FCP_PRIO_CFG_ENTRY_SIZE 0x20
> +	uint8_t  reserved2[16];
>  };
>  
>  #define FCP_PRIO_CFG_SIZE       (32*1024) /* fcp prio data per port*/
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 2dd9c2a39cd5..30c2750c5745 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7877,6 +7877,7 @@ qla2x00_module_init(void)
>  	BUILD_BUG_ON(sizeof(struct qla82xx_uri_data_desc) != 28);
>  	BUILD_BUG_ON(sizeof(struct qla82xx_uri_table_desc) != 32);
>  	BUILD_BUG_ON(sizeof(struct qla83xx_fw_dump) != 51196);
> +	BUILD_BUG_ON(sizeof(struct qla_fcp_prio_cfg) != FCP_PRIO_CFG_SIZE);
>  	BUILD_BUG_ON(sizeof(struct qla_fdt_layout) != 128);
>  	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
>  	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
> 

The changes themselves look ok, but..

Could the warning be avoided by memset of FCP_PRIO_CFG_HDR_SIZE
before first read_optrom(), and another memset of
"FCP_PRIO_CFG_SIZE - FCP_PRIO_CFG_HDR_SIZE" before second
read_optrom() call?

The reason I ask is that, the kind of "1" element array
declaration in a struct is a common way of mapping a header
followed by N records of some nature. It is a bit sad if we are
moving away from that style and hard computing the structure by hand.
