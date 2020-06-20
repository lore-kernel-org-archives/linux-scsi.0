Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1610C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F76B2311E
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YVL3OFx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbgFTD2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 23:28:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732271AbgFTD2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 23:28:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3IjZl106351;
        Sat, 20 Jun 2020 03:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=YofdP2zob0wdhkUH8l7zd41hnwEqoQbfWveMqOrqcEY=;
 b=YVL3OFx5Wz8LYGrmezF+Dsy1NEI8HxMmZzHHR4X6OPwgZFvNdb5deu48Sr6ubR9NviVe
 Bu1CPr2H04BxIAFiCNj8adj+Sy81hQcocB58gPF4ajHJpd1fdwUVyDh3UzHPNsoQdDbV
 72Gd5ld8ki5M6xWeydrRGmI2FkMgIxTjmZjs9iwaXTSLEoa79Df2uAly7GCUO3ZiIudj
 X7pAcxoKZjaYG5wKFuouYbXIu9w56bjbt+qFtNcJlaNgzQRCm3gQPjofWlIA1heOT+kN
 tdyeovKWziedN+u31flk6zONVZXz3avVpl21deb0WFK6FTi40OBibkpwho1WqOb88Jhu IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31qg35fdg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 20 Jun 2020 03:28:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3IfXZ160418;
        Sat, 20 Jun 2020 03:26:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31s7jqefxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Jun 2020 03:26:42 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05K3QeCS011084;
        Sat, 20 Jun 2020 03:26:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 20:26:40 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Remove unnecessary bit TCMU_CMD_BIT_INFLIGHT
Date:   Fri, 19 Jun 2020 23:26:34 -0400
Message-Id: <159262354734.7800.12324526277284503765.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
References: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006200022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0
 cotscore=-2147483648 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006200022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 19 Jun 2020 19:38:06 +0200, Bodo Stroesser wrote:

> Since
> commit 61fb24822166 ("scsi: target: tcmu: Userspace must not complete
>  queued commands")
> tcmu_cmd bit TCMU_CMD_BIT_INFLIGHT is set but never checked.
> So we can remove it safely.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Remove unnecessary bit TCMU_CMD_BIT_INFLIGHT
      https://git.kernel.org/mkp/scsi/c/da3f28da1c27

-- 
Martin K. Petersen	Oracle Linux Engineering
