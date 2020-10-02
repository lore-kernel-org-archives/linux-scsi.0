Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF6BC35257
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 23:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EA23207DE
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 23:03:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JSfeg5CB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgJBXDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 19:03:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48306 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBXDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2020 19:03:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092N0hUP170727;
        Fri, 2 Oct 2020 23:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=SeF6lR9Q8IBZl8EEr47NX3tCB5pwA6YnuaJ5WqdRG7o=;
 b=JSfeg5CBYP6mtaZtJQIoMHqxKF4h293in/7JE1c5l14c3JBteeKjFAMPsBv9JqFi0tqV
 VqyScCH8yHbrQ9/tYDrwhd5M4+GSDygEnewzz8tRrctwhFxWju3Mi6CpaBxyxfr3r7yu
 3OjM8O86VgjlW3fPqsKjotvcUJhn9oo95/IkEqpQU99QP61fUVwUV3SLR58++KVaJtyx
 yii9KpOy84hHhQduhXEUTO7zp9/8qUgM0b2fosoB08u8+qZdfVBVEQN+nuBJM4QQE88l
 oMAImMmmg42woDEeW6+laPg46VpFcu8f2jBdewj7kqPg4BO1gCPAk1if32MjP04LTRjk 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkmd9ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 02 Oct 2020 23:03:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 092N16Ku037742;
        Fri, 2 Oct 2020 23:03:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33uv2jwg59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Oct 2020 23:03:28 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 092N3Qjn005927;
        Fri, 2 Oct 2020 23:03:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 02 Oct 2020 16:03:25 -0700
To:     Ye Bin <yebin10@huawei.com>
Cc:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/3] Fix inconsistent of format with argument type
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pn60dydn.fsf@ca-mkp.ca.oracle.com>
References: <20200930022515.2862532-1-yebin10@huawei.com>
Date:   Fri, 02 Oct 2020 19:03:24 -0400
In-Reply-To: <20200930022515.2862532-1-yebin10@huawei.com> (Ye Bin's message
        of "Wed, 30 Sep 2020 10:25:12 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9762 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1011 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010020176
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ye,

> Ye Bin (3):
>   scsi: qla2xxx: Fix inconsistent of format with argument type in
>     tcm_qla2xxx.c
>   scsi: qla2xxx: Fix inconsistent of format with argument type in
>     qla_os.c
>   scsi: qla2xxx: Fix inconsistent of format with argument type in
>     qla_dbg.c

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
