Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1D1C3F68F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 02:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AC1C2465E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 02:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kLjce4NZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfLQCto (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 21:49:44 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfLQCtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2019 21:49:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH2nDPB083233;
        Tue, 17 Dec 2019 02:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=1vfCVbXV52nSW5PKMPpCIv5u2jUc6DOjqXvAQfAGHX8=;
 b=kLjce4NZVmKjxPxMLi8Ohs03L4QwgdOwFBf0B8nULAiBdhbnTYgrXGvoB+Cn/3UrorEQ
 X5BlF9kO9J4i011T7nzd3FDlqJ7+mUeHT3R/YQvN5QrmyOh1EZb29ESyEbduMOOUbXUM
 rHOy+xeHNoBaR9tVUCihygOi+J9nd/ItdBzAM/QJWlRszxJjGaQwnZ684u6fQU9KoP5h
 5hBnO2XeSIEmC0C6Z3PuDMmespVtwfbYwUB/7CKGzWFpgFu2KlPPIxFtaHGb6iDUsFS5
 vl5pEbhDc9Vt6BdP37rZOIldiZbsMIg657mmU+87qi2w8VwWBCRD+qDkBRyfEqV8h9/b cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wvqpq3n57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 02:49:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBH2m1Wt183136;
        Tue, 17 Dec 2019 02:49:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2wxm6xv50b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 02:49:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBH2nc46004843;
        Tue, 17 Dec 2019 02:49:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Dec 2019 18:49:38 -0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix double free in attach error handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191203093652.gyntgvnkw2udatyc@kili.mountain>
Date:   Mon, 16 Dec 2019 21:49:35 -0500
In-Reply-To: <20191203093652.gyntgvnkw2udatyc@kili.mountain> (Dan Carpenter's
        message of "Tue, 3 Dec 2019 12:36:52 +0300")
Message-ID: <yq1pngnhdj4.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=810
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9473 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=891 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> The caller also calls _base_release_memory_pools() on error so it
> leads to a number of double frees:

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
