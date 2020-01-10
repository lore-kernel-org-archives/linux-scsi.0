Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A8DC33C99
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C58B2077C
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 06:04:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aFkngOfj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbgAJGEE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jan 2020 01:04:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42810 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgAJGED (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2020 01:04:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A63RCJ087414;
        Fri, 10 Jan 2020 06:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=q3VxyJTOy9ZHQGP5KSRVM4PO0ylUd4m6r2Z4mGx30b8=;
 b=aFkngOfjKzacVvzLFynXdsQA1KbgvHKsvEoYG4Jr5+c7cR0YgtLFl6S1a+PlN+7ZM5sC
 UdLtaBmtgzeD/g0H55gwbMxSsuwUk6ZHZ4O6xhru2/VopruhQLGYMFErKqLQ4bOtVGyy
 Gsg6UZaPiOdJPYSGCRf4hrcRwEq6VYJfO0eB1N8jpt3flaIbJHJ4w58SiPT6C6djOSoJ
 oaxUSmxgUwdEOTLeiOAogAqNe/MA9SCBLhKsNYomMFDB+YNFr2gCvySbwQWA7TGCeZks
 zYxj2Q375GLir0AAI03XIK1gwcFwsvOTSJjvjcGsEJb9ZLTnp6iHHfLI61O9OdC3QFTg GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xaj4ug0t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:04:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00A63s1n002902;
        Fri, 10 Jan 2020 06:03:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xdrxf89pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jan 2020 06:03:56 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00A63gXY017273;
        Fri, 10 Jan 2020 06:03:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 22:03:41 -0800
To:     Anand Lodnoor <anand.lodnoor@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, kiran-kumar.kasturi@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: Re: [PATCH 03/11] megaraid_sas: Update queue_depth of SAS and NVMe devices
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
        <1578051155-14716-4-git-send-email-anand.lodnoor@broadcom.com>
Date:   Fri, 10 Jan 2020 01:03:39 -0500
In-Reply-To: <1578051155-14716-4-git-send-email-anand.lodnoor@broadcom.com>
        (Anand Lodnoor's message of "Fri, 3 Jan 2020 17:02:27 +0530")
Message-ID: <yq17e1zx2ys.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=882
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001100051
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=948 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001100051
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Anand,

>  /* JBOD Queue depth definitions */
>  #define MEGASAS_SATA_QD	32
> -#define MEGASAS_SAS_QD	64
> +#define MEGASAS_SAS_QD 256
>  #define MEGASAS_DEFAULT_PD_QD	64
> -#define MEGASAS_NVME_QD		32
> +#define MEGASAS_NVME_QD        64
>  
>  #define MR_DEFAULT_NVME_PAGE_SIZE	4096
>  #define MR_DEFAULT_NVME_PAGE_SHIFT	12

Please justify this change.

-- 
Martin K. Petersen	Oracle Linux Engineering
