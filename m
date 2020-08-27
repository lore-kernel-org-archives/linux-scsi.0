Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541A3C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 15:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CCA822BEB
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 15:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lC491zsq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgH0PUE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 11:20:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbgH0PUA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Aug 2020 11:20:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RF9YqT151617;
        Thu, 27 Aug 2020 15:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=1HQfcc7LdYM/rXmtkBtdrjrROi55axGAB+68+HHwzqk=;
 b=lC491zsqbQ4g1A9HcYkK1I0b24MSJp0mPUrv3FalU0YwycpE/cKPKs6uB6JJX841T5tS
 /0XCAEfuyo3OzdQ9xiH0aXLcYs3xtz7jkGeGgTInd3MS2BbVdAxXxvrdktCLfm+1C/OM
 jgo+U5rSFKOM8z01eH8lLjvCG5+jTxwdkh78qK4mqs6CYduASmUOUbJpelDDeVjIEb1V
 qzyq1Rlg6tnmYZYv0R6szUsPbDx0TqMZhIylNCUMLnkajYmHsWyMO30jrxOP2Om9+mc7
 JENOOZtPlT1o2ZScfGmwBVSXWqzcPrPFdmL5Ce/vC4+hL4DA/J102k7Fo5tYs4BpZe+7 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 333w6u5jhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 15:19:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RFB00H084067;
        Thu, 27 Aug 2020 15:17:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 333ru1kbfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 15:17:49 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07RFHmUv025324;
        Thu, 27 Aug 2020 15:17:48 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 08:17:47 -0700
To:     Denis Efremov <efremov@linux.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] scsi: libcxgbi: use kvzalloc instead of opencoded
 kzalloc/vzalloc
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7som83l.fsf@ca-mkp.ca.oracle.com>
References: <20200731215524.14295-1-efremov@linux.com>
        <20200801133123.61834-1-efremov@linux.com>
        <d77c0967-d879-14cc-bf75-c38ad8879b76@linux.com>
Date:   Thu, 27 Aug 2020 11:17:45 -0400
In-Reply-To: <d77c0967-d879-14cc-bf75-c38ad8879b76@linux.com> (Denis Efremov's
        message of "Thu, 27 Aug 2020 18:13:13 +0300")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=963 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=981 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270115
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Denis,

> Ping?

It's in my staging branch.

-- 
Martin K. Petersen	Oracle Linux Engineering
