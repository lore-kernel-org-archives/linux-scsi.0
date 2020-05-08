Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B479C47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF2D20731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LTofqDZ8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgEHCzH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:55:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33766 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgEHCy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482roCO085506;
        Fri, 8 May 2020 02:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=j87H2zhImmv42ymjgeEv+Aqxm8iN731BNIlqg0RTtK8=;
 b=LTofqDZ8fQqbLv5BFSk9dJCpOw/UJlKvFU5yBUnnqSS9t/LSlyrrRuYGU4Pux9c2DcNZ
 7xqa1CfSaS9oHIShArIUJ1r8kxHdkW1+0CvupyGKRkBsABEO2DXPd8nmxlb3vnDSG39c
 qEupGl/HlnIKC3gQo4ObNNisCR73Py5x329E49RARKGWhdcgIEbBGz/idB9oD458Dyd/
 3RLaJlS8nDSsvGk28AEzhNwvt2baFgOZEpbHYr33Wd6UWEXW2wP0hZmRt92Q4lS9PGAe
 0OcbbJloB0gWCTLzdAQvO3H6hmGpv5IpjvGpGjtFsT3QbEuZuXg7OWmN3GKb/+isCBFx Aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30vtexrrm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482quHF138370;
        Fri, 8 May 2020 02:54:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30vtdmp5an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:47 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0482slpl028811;
        Fri, 8 May 2020 02:54:47 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:47 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, hmadhani@marvell.com,
        Jason Yan <yanaijie@huawei.com>, njavali@marvell.com,
        joe.carnuccio@cavium.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: use true,false for ha->fw_dumped
Date:   Thu,  7 May 2020 22:54:33 -0400
Message-Id: <158890633245.6466.16079762113899462190.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200430121800.15323-1-yanaijie@huawei.com>
References: <20200430121800.15323-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Apr 2020 20:18:00 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/qla2xxx/qla_tmpl.c:1120:2-20: WARNING: Assignment of 0/1 to
> bool variable

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Use true, false for ha->fw_dumped
      https://git.kernel.org/mkp/scsi/c/dbe6f49259da

-- 
Martin K. Petersen	Oracle Linux Engineering
