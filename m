Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97666C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5704820872
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S0rAsk6M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgIOWh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:37:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbgIOWh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 18:37:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FK8pvU130516;
        Tue, 15 Sep 2020 20:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4VJNpmxVNDN5wjzmgpUrkHttEoFQWByhbcWmaEr2E9E=;
 b=S0rAsk6MkQvpLvqZxDZGDGBVyHZxZ45MQGqC3ZL3NXbg2qmS5IMcTc/Se+gtKsTxfyE3
 /rIuvO4FzN35VcbZH/Ab9dsGTxvZxw1dHCQnpYdXYoMoRpUKRIj4ZdnCpihOGYgm1Ilx
 uJgK9qQqzIm3ro5bTAp6Gr0CYefHLoYD2p/32YNTakw7EaQFsFyFroAIBLSfrQOqapDm
 XdWayKcwS5GLxQNLUsQ9vnHWnXTfcxI0kJNyV8/a6Tl+Jw4fGSWHOw1913q4WmTzHH5g
 xGfw/opDC3myVjp1H67NfphvwuykmCcxhWpr6i02mcwl9WrQat4HbJTxGKf/RZzgwSpR Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33gp9m7crg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 20:16:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKFvZW127285;
        Tue, 15 Sep 2020 20:16:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33h7wppqgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:16:44 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FKGe65006678;
        Tue, 15 Sep 2020 20:16:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 20:16:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mpe@ellerman.id.au, benh@kernel.crashing.org,
        Jing Xiangfeng <jingxiangfeng@huawei.com>, jejb@linux.ibm.com,
        paulus@samba.org, tyreld@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ibmvfc: Fix error return in ibmvfc_probe()
Date:   Tue, 15 Sep 2020 16:16:25 -0400
Message-Id: <160020074003.8134.8833608146338864897.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907083949.154251-1-jingxiangfeng@huawei.com>
References: <20200907083949.154251-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150157
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Sep 2020 16:39:49 +0800, Jing Xiangfeng wrote:

> Fix to return error code PTR_ERR() from the error handling case instead
> of 0.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: ibmvfc: Fix error return in ibmvfc_probe()
      https://git.kernel.org/mkp/scsi/c/5e48a084f4e8

-- 
Martin K. Petersen	Oracle Linux Engineering
