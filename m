Return-Path: <SRS0=CpYn=AB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC461C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9886923123
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Jun 2020 03:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kn5Ey95Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgFTD2z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 23:28:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732724AbgFTD2z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 23:28:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3Slbe127305;
        Sat, 20 Jun 2020 03:28:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=LcF2q6oMmSa7YtKuR3BDORedAB+bdACVBYOQFoloR6M=;
 b=kn5Ey95Y5WxBO5UtguFy9Je3O7RnB9jHZHGGAQ/em5T6QadCownM5i9SJderYyyb2TP6
 L8mFeDq9xk+EHjfWVRRdVdueRJm182WqyxW7ehfh1D54i9R8ooFKKxvMcpwvL5tb8nOE
 6YGJTTciM4QTlpaQChAV4Piw671T1IqCHeLFLVGxceK18gbsLmcY7duxB1OGBTFW2m8X
 4LxETc5Qr2Yhg9y8TmF2nt5AhXl9RzrMZW5PPZBqqDzcqRBUkC9qX0DJcg8A0p0uzHEp
 2pT5fG/5x/PRdKMZar03Bmn0eolyj5ZRi15A+FZSMtpxwo08WEgo5XpafC52S9lzzfGZ Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31qg35fdgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 20 Jun 2020 03:28:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05K3JH9I035722;
        Sat, 20 Jun 2020 03:26:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31s8g8c4wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Jun 2020 03:26:46 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05K3Qi5H011093;
        Sat, 20 Jun 2020 03:26:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jun 2020 20:26:44 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     bvanassche@acm.org, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bean Huo <huobean@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        beanhuo@micron.com
Subject: Re: [PATCH v2 0/2] scsi: remove scsi_sdb_cache
Date:   Fri, 19 Jun 2020 23:26:37 -0400
Message-Id: <159262354734.7800.4948661939239497553.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619154117.10262-1-huobean@gmail.com>
References: <20200619154117.10262-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9657 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
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

On Fri, 19 Jun 2020 17:41:15 +0200, Bean Huo wrote:

> Changelog:
> v1 -- v2:
>     1. split patch
>     2. fix more coding errors in the scsi_lib.c
> 
> Bean Huo (2):
>   scsi: remove scsi_sdb_cache
>   scsi: fix coding style errors in scsi_lib.c
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: core: Remove scsi_sdb_cache
      https://git.kernel.org/mkp/scsi/c/71df6fb976c3
[2/2] scsi: core: Fix formatting errors in scsi_lib.c
      https://git.kernel.org/mkp/scsi/c/4c7b4d63273d

-- 
Martin K. Petersen	Oracle Linux Engineering
