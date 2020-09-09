Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B814C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF7FE2177B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F99m21MS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgIICKe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:10:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40324 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIICKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:10:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08929wGo153585;
        Wed, 9 Sep 2020 02:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=RA5KU7hC/4RZDaVvqLweitGeGaEEcpxcs09QIiSSOKw=;
 b=F99m21MSZRInKB49TaY3cxp1Y/TaHGaKVfrbGNtQ+YsW31l0Q/RWvTH/7lL0HJpu40Yj
 W3cz2oT+ACPCxuzcLQ1ceculkcyw0ILVaWsvD0l20J/y6nzpQ8OqgMpw0G2PFMiaFosb
 cWiAVtgmAu64naqtxV2PWtZCV4apOY0ElKGL5nVE0l5f/X21ASHz5MTvf5RUlJw6XCuH
 qJxKDWL/M22Es+D1CRDy++x0hxO5HQbhtPqXMo7z5XGnIn8PEaQSfoUXRJnA7Iz4KrNZ
 B/c3tSZjbpX++XmwE2N0G+wNL+vDQYKz7n391nVwJ+M8npn7RYYXCD7lvrVGj8paFWiu /g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33c3amxttw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:10:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08925Zu3069209;
        Wed, 9 Sep 2020 02:08:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33dacjq2pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:08:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08928LlD022247;
        Wed, 9 Sep 2020 02:08:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:08:20 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel-janitors@vger.kernel.org, Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: libsas: Fix error path in sas_notify_lldd_dev_found()
Date:   Tue,  8 Sep 2020 22:08:19 -0400
Message-Id: <159961727333.18958.11850401583995372808.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200905125836.GF183976@mwanda>
References: <20200905125836.GF183976@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=781 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=795 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 5 Sep 2020 15:58:36 +0300, Dan Carpenter wrote:

> In sas_notify_lldd_dev_found(), if we can't find a device, then it seems
> like the wrong thing to mark the device as found and to increment the
> reference count.  None of the callers ever drop the reference in that
> situation.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: libsas: Fix error path in sas_notify_lldd_dev_found()
      https://git.kernel.org/mkp/scsi/c/fdcb7900d9ab

-- 
Martin K. Petersen	Oracle Linux Engineering
