Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A31C2D0A8
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36E220791
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:35:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IM5M06DM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgI3DfB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 23:35:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgI3DfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 23:35:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3P4hH178693;
        Wed, 30 Sep 2020 03:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=XI1g9fYcldngXijmgxQ0vTHeCH0RD2obYMnKOd0J/nk=;
 b=IM5M06DMXK9VHKxTVohjJrIS1oJ00djtmAKFaWEF0x+StD0j+pjNX5xs6IVMCpUhrpB3
 MypxC4G1F6qPiTTVqvSA78/vTFPf/fUV9D9nT9IudFox+m5VP6dWdhesW4QHKeSmHC/M
 d9kv28LV0OQP4rhkIkO1vNlEyRYttPvTqIDETiKUPSvQH+tAf8nrQP8Jel23hbTItaSR
 w/F+4QeAyVfd2j+jwG8Wp/AwFWbAWYF+wCN3Jr3KEPcdodRTtxRbhJU/fpVwwAvAbIu6
 Z287yH2NZBqbiXN6RxGpY95L+GCPr+x4E0qzTdY1rSALuT8TaG4cwKphv2fqCFbHa8Jp 6g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkkx9pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 03:34:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3OklE004028;
        Wed, 30 Sep 2020 03:34:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33tfdt3kyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 03:34:56 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08U3YrsL030420;
        Wed, 30 Sep 2020 03:34:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 20:34:53 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] target: scsi: tcmu: code rework and speed up of read data handling
Date:   Tue, 29 Sep 2020 23:34:46 -0400
Message-Id: <160143685412.27701.100112187449074876.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 10 Sep 2020 17:50:38 +0200, Bodo Stroesser wrote:

> This small series is made on top of Martin's 5.10/scsi-queue branch.
> 
> The patches simplify some code, splits off new helper functions
> or implement a cleaner code sequence to prevent double work.
> The 3rd patch speeds up buffer preparation for SCSI commands with
> long read data.
> The series is also base for cleaned up version v3 of my patch
>   scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/3] scsi: target: tcmu: Join tcmu_cmd_get_data_length() and tcmu_cmd_get_block_cnt()
      https://git.kernel.org/mkp/scsi/c/52ef2743f16c
[2/3] scsi: target: tcmu: Optimize queue_cmd_ring()
      https://git.kernel.org/mkp/scsi/c/7e98905e9d0d
[3/3] scsi: target: tcmu: Optimize scatter_data_area()
      https://git.kernel.org/mkp/scsi/c/3c9a7c58ea3d

-- 
Martin K. Petersen	Oracle Linux Engineering
