Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACBEC2D0A3
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 01:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F02920756
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 01:58:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FFfxaeCe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJ3B6D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 21:58:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37178 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ3B6D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 21:58:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U1nkJG194397;
        Fri, 30 Oct 2020 01:57:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=k491AmM/Y+1/TVwdU3qb5wP/MX/pqSxeRxtsPbFX+Wo=;
 b=FFfxaeCegHHoeVKKlMdjBk/b0CJ11fojYVJxCMIsWel5kTKmAyMKIPUa7SWzM1XeJgUj
 x12zQ5vc5cn/40tp5BpSj/k2nk3QS7s3RhN4BAOr6Ker7PHbl0qdtA8wIpBCo+oS0KEY
 6dHnZd4kZbYpdVn5+CFhoYvbMbtDDye7Va2GoT19/7EZ3lXUoKZ55vnEBsVG3uwWjjYV
 A8nOkTU8t5ZFRE2gaDSbPBErkGq7aalhHoGVDHcQlyG+VR4hRgD6exbiQUPbRAOx0N/5
 32JhjF5BvGTRTavd+DdCvipKfYNdqlpPu43zK/5sTue/+T42pcga1j4sqgE1L1mTdXSm Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34cc7m7pht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 30 Oct 2020 01:57:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09U1sXbu007434;
        Fri, 30 Oct 2020 01:57:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwuqf3e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 01:57:53 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09U1vpxP008819;
        Fri, 30 Oct 2020 01:57:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 18:57:50 -0700
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com
Subject: Re: [PATCH] ibmvfc: add new fields for version 2 of several MADs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7qc1nmy.fsf@ca-mkp.ca.oracle.com>
References: <20201026013649.10147-1-tyreld@linux.ibm.com>
        <yq1v9ew4ekf.fsf@ca-mkp.ca.oracle.com>
        <c94f0f87-1863-9c0a-3561-4cbc9330e011@linux.ibm.com>
Date:   Thu, 29 Oct 2020 21:57:48 -0400
In-Reply-To: <c94f0f87-1863-9c0a-3561-4cbc9330e011@linux.ibm.com> (Tyrel
        Datwyler's message of "Tue, 27 Oct 2020 14:52:09 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tyrel,

> I'm going to have to ask that this patch be unstaged.

Done!

-- 
Martin K. Petersen	Oracle Linux Engineering
