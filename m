Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893DBC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:03:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64E3C2072E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 02:03:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A890azgF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgFJCDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 22:03:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgFJCDN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 22:03:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A22rRC028473;
        Wed, 10 Jun 2020 02:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=OyjqTL3RFU3qhRhjl1q+nR+l4wbwyQdM/xh+BDHyC/Q=;
 b=A890azgFkB3wqpRI89CnZldQ8yTmMpDXaWngJiW8JTxbsqhLe1M8vVoG7Ngl8bxMTt/+
 0pD/DFFXcmw1uMnwDqc91EaTouHiO54UexWUGwF3B302GLRFcEG5l0vOUBVc0p9UMDVk
 hC0V8Zc5nFToM02wRMEqFEOwQtIlwrkGgrHNL/MGAlI4XwDeHfUk5msexZj6equoRBqX
 BB3aAEfIKXn70IsL01jJFDJZTACI6GZfUpQ+0VIh9ZzqIV77+80Aaiky1uXZaGW7qqdJ
 VaO7JFUrxja9Uxaa3vnK4OcXKZ+C8mAqaxf0V4zwAORLtTL7v30bpOdRyKVV0i4Scycq Xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31jepnsq8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 10 Jun 2020 02:02:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05A1wPNd020921;
        Wed, 10 Jun 2020 02:02:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 31gmwsbn7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 02:02:52 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05A22pcH004447;
        Wed, 10 Jun 2020 02:02:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jun 2020 19:02:50 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Uma Krishnan <ukrishn@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] cxlflash: remove an unnecessary NULL check
Date:   Tue,  9 Jun 2020 22:02:44 -0400
Message-Id: <159175452258.16072.8552277193377320754.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605110258.GD978434@mwanda>
References: <20200605110258.GD978434@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=941 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006100013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9647 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 cotscore=-2147483648 adultscore=0 spamscore=0
 mlxlogscore=980 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006100013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 5 Jun 2020 14:02:58 +0300, Dan Carpenter wrote:

> The "cmd" pointer was already dereferenced a couple lines earlier so
> this NULL check is too late.  Fortunately, the pointer can never be NULL
> and the check can be removed.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: cxlflash: Remove an unnecessary NULL check
      https://git.kernel.org/mkp/scsi/c/89dd9ce784fb

-- 
Martin K. Petersen	Oracle Linux Engineering
