Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848DBC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B2E20B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eO+7WRLk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgJHCiW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:38:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35892 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgJHCiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:38:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982YBDF097588;
        Thu, 8 Oct 2020 02:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=jVX6BYs6D+ADjsIwsE2TJdVcxnNlbLogOAjg8oufDuA=;
 b=eO+7WRLkT31OLbHVpIc0Z6kSIqQEmOQCTmvupQ1JgNdRaHXA75GIz4Zecrk4ilp3yccM
 /EF0BIOjOio/RcsUR5q55Neu0JhvkFbFkRr5vV/n41Q4xSeGjINEjIuTObKNemJrde7i
 C/KKLJPS9ScWVewmEaA34+xlLrhE3zXGNbQROq6AScGTFvYcjP1YNyoVn2KxMfRGt6pf
 UFlAXi/kHArUDCL7MFYAJpo/e0IuVnJCxTKhrUOZ/aH9UPK+QGNL+pPBtXLYypGncep+
 lliJF0fTZAOPY0wtO4/pRi7vDzXaK9GgcUXQEb9+1/agKbCedss4pgb2c1y/yoaU5P6f BA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33ym34t9e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:38:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982ZKx5040100;
        Thu, 8 Oct 2020 02:36:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33y2vq9gam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:36:10 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0982a97d029584;
        Thu, 8 Oct 2020 02:36:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:36:09 -0700
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] snic: simplify the return expression of
 svnic_cq_alloc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pn5txx4e.fsf@ca-mkp.ca.oracle.com>
References: <20200921082455.2592190-1-liushixin2@huawei.com>
Date:   Wed, 07 Oct 2020 22:36:07 -0400
In-Reply-To: <20200921082455.2592190-1-liushixin2@huawei.com> (Liu Shixin's
        message of "Mon, 21 Sep 2020 16:24:55 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Liu,

> Simplify the return expression.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
