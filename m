Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E4EC4363C
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C56208C3
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 03:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AwK1q9ch"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgJGDuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Oct 2020 23:50:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgJGDuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2020 23:50:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973kksV167739;
        Wed, 7 Oct 2020 03:50:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wMJvyXY/zGw6MoJKeiOclcrZ7I5cC0+TYk71yxXF6H8=;
 b=AwK1q9chvkIZ1mNMNvVg1iaa05nisOhYsGXychg1CHcwGy+6SrjJoaxZNmE07Www8J/g
 c4gJabqps0roCVXm4RJ7/swC4spl0Pt3IVmPQC3fKxZ4jLYromlJ0qWp+8bwFX8XNI7T
 R1rM+Pela8+JLh+iapCviOWcOitb13xY4zqDS6Hojs+rFwKmvK6gCA9Q1FoTqCCqV2kc
 2sMLOWz+aap7FdQtmE7D0Y5SQe92GF1THYEByT0tBqFKry6cD7v8komWjy+NMGNqPfb7
 BhNfTqhWfLMQSwbs+wFId0ztEhTjTUwBqFx64iWU1mcGS9RWG4PDrFsEmM/0noWVb7Dk dQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33xhxmydgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 03:50:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0973k9xk160252;
        Wed, 7 Oct 2020 03:48:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33y37xyvg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 03:48:14 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0973mDZM012431;
        Wed, 7 Oct 2020 03:48:13 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 20:48:13 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>, skashyap@marvell.com,
        jejb@linux.ibm.com, QLogic-Storage-Upstream@cavium.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: remove redundant assignment to variable 'rc'
Date:   Tue,  6 Oct 2020 23:47:52 -0400
Message-Id: <160204240582.16940.12949486493466336257.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917021906.175933-1-jingxiangfeng@huawei.com>
References: <20200917021906.175933-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Sep 2020 10:19:06 +0800, Jing Xiangfeng wrote:

> This assignment is  meaningless, so remove it.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: qedf: Remove redundant assignment to variable 'rc'
      https://git.kernel.org/mkp/scsi/c/da7d5d72ae83

-- 
Martin K. Petersen	Oracle Linux Engineering
