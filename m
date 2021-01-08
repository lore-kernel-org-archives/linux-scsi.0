Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12165C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D058D207A8
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 04:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbhAHEWn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 23:22:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54114 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbhAHEWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 23:22:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10849j0o096801;
        Fri, 8 Jan 2021 04:21:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7FkAnWaCZS3Bs4hxyLCFtZjraeMHp1ZAL+y/Yigzdh8=;
 b=laD7DxK9Bn8NoBQJNesLVWrys5xXc5Njk5OrG1h1dRNJeONcX3I9HH8v/9hnvQVnlXmT
 oYrDiBbGuaGqqgPXvwvQwJflT4dAr4X1tvNyInbzeoiEo3LNTbSar/pVx/ijVCXAAkRh
 1MWjAWcnUzKXb5O24uTyaf0AbXctPGYg2d4yHUuC+s5s5ROn/vfu4Zc6nebvo3b7lm4t
 XqA6cDGj8Qo3Vupq9P07K/vgz/78EnfsodUkYMYy4aTTrZotAA+ThWmJCtAvy3bmmkhR
 5//Widq5WunEYoyrHQodV+sans/BowjJPjf4KHCZOGzKPP+YPxLG1JV161FUfTdXCYDH IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35wepmfddt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 04:21:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1084AueG079346;
        Fri, 8 Jan 2021 04:19:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 35v1fc2x8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 04:19:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1084JrfF031011;
        Fri, 8 Jan 2021 04:19:53 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 04:19:53 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     lduncan@suse.com, Nilesh Javali <njavali@marvell.com>,
        cleech@redhat.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qedi: Correct max length of CHAP secret
Date:   Thu,  7 Jan 2021 23:19:38 -0500
Message-Id: <161007949338.9892.5837970838931674073.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217105144.8055-1-njavali@marvell.com>
References: <20201217105144.8055-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Dec 2020 02:51:44 -0800, Nilesh Javali wrote:

> The CHAP secret displayed garbage characters causing iSCSI login
> authentication failure. Correct the CHAP password max length.

Applied to 5.11/scsi-fixes, thanks!

[1/1] qedi: Correct max length of CHAP secret
      https://git.kernel.org/mkp/scsi/c/d50c7986fbf0

-- 
Martin K. Petersen	Oracle Linux Engineering
