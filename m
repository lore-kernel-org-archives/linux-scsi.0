Return-Path: <SRS0=wS4L=DK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61ABDC4363C
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1351F20719
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Oct 2020 01:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q/oVU9CE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725613AbgJCBnk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 21:43:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJCBnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 21:43:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931dhfW051310;
        Sat, 3 Oct 2020 01:43:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=jr7g9jBDA0hKwl6jmC4FK21yEFt8GUbjoiRHm8XnRHk=;
 b=q/oVU9CEtVX/Sxh9LaUfYdApLac9rXLN7sh2oJ87NFw+0odu//NG3hzKhqVz+aM6qC7s
 kv00dkrGhcdBkuGQWS3p2J7uo3UQ04Bpf1X4VeKFPLVOztmXSS4+X4eOPyB8uamjZuUi
 5jhEmhLdPniXjTlDJ45qifyFNyPhpFH9e8bOIfBiRbPjg+0wkaVPwLlCvuH3N9Rfgu/F
 jJjv77X93/Hihwp+DKqjraNxrbHL3NE7zVPHuTL7fS0s9w4zs8K8IxBinjSYpEFR1xAE
 i9bRSxhFKWfCAjOtpn+L4krUJ/ryXQ9kN0bGDa1MwXv8gtFZxZC7i8LDM+DtuCoynM1P 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkmdgd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 03 Oct 2020 01:43:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0931eu57065334;
        Sat, 3 Oct 2020 01:43:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33tfdydh9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Oct 2020 01:43:32 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0931hVxh008342;
        Sat, 3 Oct 2020 01:43:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 18:43:31 -0700
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: mvumi: Fix error return in mvumi_io_attach()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6x4ccec.fsf@ca-mkp.ca.oracle.com>
References: <20200910123848.93649-1-jingxiangfeng@huawei.com>
Date:   Fri, 02 Oct 2020 21:43:29 -0400
In-Reply-To: <20200910123848.93649-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Thu, 10 Sep 2020 20:38:48 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010030015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010030015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jing,

> Fix to return error code PTR_ERR() from the error handling case instead
> of 0.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
