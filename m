Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC1DC47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 045E62082E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="L71i0SKE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgEKHfA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 03:35:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7244 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728564AbgEKHfA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 03:35:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04B7V03s008680;
        Mon, 11 May 2020 00:34:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=CkzDnCmO2yTX1QCI+XskSIoor/OasxFMQ4/2zFuyf+M=;
 b=L71i0SKEB8a2i7jebo3KxrQpIAl3XAN/w1lcnDIxcCxYjUbzoH2t9N2ELbbzE3M5UFCx
 C96UGDaFoW+Zn+ll2zMOfx6G1ruvdjakUrxzrEkAc/sEGGqaYAthQ9XiropFvgPlAJJN
 uyw3jq05oB92+aixTfzVisQOm83Z2kAaK5XRfOexnyDOGMwW3V2kejKTD5IomNYFpfhf
 oeZA+fYqwBahAPYcLbU7pkVM+uPCvxUnlw8bRVUppXRcqeOaebcB6CtxWZEg79ZE5m84
 aXweXdBDv2odrICfNPfRg9dMhKL0MG/OpHeBU8HfAPDuFvRH6KkBS8bso7NxhVLkR20h QA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvqdwed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 00:34:53 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:34:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 May 2020 00:34:51 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 732EF3F703F;
        Mon, 11 May 2020 00:34:51 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 04B7Yp7a024562;
        Mon, 11 May 2020 00:34:51 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 11 May 2020 00:34:51 -0700
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
Subject: Re: [PATCH v4 05/11] qla2xxx: Make a gap in struct qla2xxx_offld_chain
 explicit
In-Reply-To: <20200427030310.19687-6-bvanassche@acm.org>
Message-ID: <alpine.LRH.2.21.9999.2005110034430.23618@irv1user01.caveonetworks.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-6-bvanassche@acm.org>
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

> This patch makes struct qla2xxx_offld_chain compatible with ARCH=i386.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index 433e95502808..b106b6808d34 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -238,6 +238,7 @@ struct qla2xxx_offld_chain {
>  	uint32_t chain_size;
>  
>  	uint32_t size;
> +	uint32_t reserved;
>  	u64	 addr;
>  };
>  
> 

Reviewed-by: Arun Easi <aeasi@marvell.com>
