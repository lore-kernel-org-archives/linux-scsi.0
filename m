Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5716C35249
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 03:09:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A71D42085B
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 03:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eYD+zaez"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgBEDJv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 22:09:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48588 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbgBEDJv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 22:09:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01537wHY008232;
        Wed, 5 Feb 2020 03:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=Z0c4IbtEMuxFrmcEE8YYxebJ7faz1+yhcOuuL46PqDY=;
 b=eYD+zaezfwC8epK98aqeBEOCMIa0yFLoul2RZp4OZi+Vmk/tAWvaZTRhCna+hDVEzRwc
 5smgZFW+Px49APl2ROHooEfWn9Hljf+yXSDHeAJCZGRfPnWv16r1rTLafkxWRSsWZIBw
 eeIx2zhu/xcIhgv92GSOz85xI3I78rixT+RAp61GzXSrUf8nYZAbLn+UyKvYnV6t9Dx6
 Os1dI8J8/Er5fuDvYsiw1aXBQmXGVlZtn7bGFaaBvTxgwfuCJjJ28DCv4dOa4O779VLR
 0ISn7J1DPYwgnWJB6AT7yx3026/iVmBYmOYMctHC1rZAnFTBhlTxGD7z4VwWAH0wupj/ EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xykbp0d44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 03:09:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01538F6R044135;
        Wed, 5 Feb 2020 03:09:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xymurjbc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 03:09:36 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01539Z7b022060;
        Wed, 5 Feb 2020 03:09:35 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 19:09:34 -0800
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/4] ufs: Let the SCSI core allocate per-command UFS data
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200123035637.21848-1-bvanassche@acm.org>
Date:   Tue, 04 Feb 2020 22:09:33 -0500
In-Reply-To: <20200123035637.21848-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 22 Jan 2020 19:56:33 -0800")
Message-ID: <yq1mu9xzq4y.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=954
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050025
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series lets the SCSI core allocate per-command UFS data and
> hence simplifies and micro-optimizes the UFS driver. Please consider
> this patch series for the v5.6 kernel.

These changes look OK to me but I would like to see some Tested-by:
tags.

-- 
Martin K. Petersen	Oracle Linux Engineering
