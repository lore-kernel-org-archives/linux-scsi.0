Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D47FC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41BB620882
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 02:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K37Kx8u/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgJHCr6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 22:47:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47688 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgJHCr6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 22:47:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982ixUP028663;
        Thu, 8 Oct 2020 02:47:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=oLa/zVqJJNBAbIxEtZn42ICJMMTBuhO/AzGR0iKj7hI=;
 b=K37Kx8u/Wuy/s4DqEfPfBnRK8K0fLuDrSNSj+z3EkpDxCCRjjlDbQeiCGXICHrXdG2H9
 Y0dYJk7hvYr+iHEWhNT8rBHgt/CcYAi3k8fRgjyxJUePJg6zz/TKyEa86zBwfj0Mh93F
 PqihpRM6/otLNLS4wWKkCX6aVDOVXgq60lqQfipxQnDPENaOYuV9zQeyc8qqekt6IApf
 FwBDyIgu0p5If/mJTrVjF6YrPKzX7V/q4Ap9h2Gd1pSp/Lzw2dct5eUCKuUd2Jx3DJUF
 6Kdk2LzbiMRMs01A+k7GDlzitO8rr9sN5B/37emKgEIkjR5WJlE0g9oshtF3LXoChrqO XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33xetb5bqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 02:47:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0982etsM008285;
        Thu, 8 Oct 2020 02:47:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 3410k0dk5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 02:47:45 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0982lhLQ026366;
        Thu, 8 Oct 2020 02:47:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 19:47:43 -0700
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     <hare@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: myrb: remove redundant assignment to variable
 timeout
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18schxwl4.fsf@ca-mkp.ca.oracle.com>
References: <20200929022458.40652-1-jingxiangfeng@huawei.com>
Date:   Wed, 07 Oct 2020 22:47:41 -0400
In-Reply-To: <20200929022458.40652-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Tue, 29 Sep 2020 10:24:58 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jing,

> The variable timeout has been initialized with a value '0'. The assignment
> before while loop is redundant. So remove it.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
