Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB299C433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89FCE20773
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 03:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p/aiMNf9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgICDBW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 23:01:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgICDBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 23:01:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832xvnY044048;
        Thu, 3 Sep 2020 03:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Qy2IlO9dWP4DqKOdywpLTMGCrMRM7t/UMmSCwrDpvfM=;
 b=p/aiMNf9z+CPLH7k3QT3phFGApno6TMJzuZupkSNeugcImbei2TfRb8WliLyUFeDbJFH
 evZWMa/UKigJEY0p6/SD74BiRjgkVT+rimfydlTVk9oAXFuPCwc4Iy6D8aSlUg1rb6ac
 S1arNDdCyzFD91sL1tc5+7p8EuK1zMkSebC4yvTDdEiP6Izi8CAjwP2wIyeoTvq7bzTc
 X8AlpxHhaoEe9SX/Siy9rKflVR29WUuH3sja9wLWiQKR3cFb60BPBtoI4CDjtv0VMef0
 CTNhkGM5M5l75SB41U9CIunPKTUiIP9CohZ9nthxUYRHJUfNW9/rHv8FDdgcK56R77UD 3Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eer67m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Sep 2020 03:01:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0832tGlM175939;
        Thu, 3 Sep 2020 03:01:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 3380kr1d3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Sep 2020 03:01:09 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 083316fY031526;
        Thu, 3 Sep 2020 03:01:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 20:01:06 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kjlu@umn.edu, Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
Date:   Wed,  2 Sep 2020 23:00:57 -0400
Message-Id: <159910202091.23499.5526601082834790688.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200823091453.4782-1-dinghao.liu@zju.edu.cn>
References: <20200823091453.4782-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=864 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=883 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009030027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 23 Aug 2020 17:14:53 +0800, Dinghao Liu wrote:

> When pm8001_tag_alloc() fails, task should be freed just
> like what we've done in the subsequent error paths.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort
      https://git.kernel.org/mkp/scsi/c/ea403fde7552

-- 
Martin K. Petersen	Oracle Linux Engineering
