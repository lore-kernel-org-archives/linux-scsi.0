Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 740F5C4167B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C28323B51
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbgLIR0D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:26:03 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:34692 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732429AbgLIRYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:53 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJYaE058918;
        Wed, 9 Dec 2020 17:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xpqsimqGwADwDKSd2iHXr8pwNvFxRUKVED8YK60U/lI=;
 b=KNNvksw4HS6pAMRWUc1CmCdPTOMZBrSWph4hTnehrgK+ZAblO9ZNgDfdwSGyQAvtGjRy
 hcsc4+PWQgyDQWrPVJj9m6gb562dNu9yfl4yP1+0KfHiPZSrbbYUaIhkytgLehclrHXz
 3cKJiSalGLuuUh/tiNbgFdaqFDAAeN/KTo6QDnBEpHBAWl5kP8cLp78f5e9CXICL1Bmq
 NhJv/+AWA4krIPtupcQY44BqgRhEDIKNZefNac5ad0C9il220MyYEMCaPEiJMEU5cBVc
 IfSByAUjH7Ed5PJMccn1zX19lERzduD04uKNdd2B97Vi51xM4nHbnS30JNJNH+x3j+k7 Sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 357yqc1fnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:23:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKrQd100131;
        Wed, 9 Dec 2020 17:23:57 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 358ksqdk2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:23:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9HNtau022787;
        Wed, 9 Dec 2020 17:23:55 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:23:55 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qedi: fix missing destroy_workqueue() on error in __qedi_probe
Date:   Wed,  9 Dec 2020 12:23:19 -0500
Message-Id: <160753457752.14816.4402851230023439146.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109091518.55941-1-miaoqinglang@huawei.com>
References: <20201109091518.55941-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 9 Nov 2020 17:15:18 +0800, Qinglang Miao wrote:

> Add the missing destroy_workqueue() before return from
> __qedi_probe in the error handling case when fails to
> create workqueue qedi->offload_thread.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: qedi: fix missing destroy_workqueue() on error in __qedi_probe
      https://git.kernel.org/mkp/scsi/c/62eebd5247c4

-- 
Martin K. Petersen	Oracle Linux Engineering
