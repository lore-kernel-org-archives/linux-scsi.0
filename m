Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89E1C2D0E2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B0C23A34
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 03:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VZ12jT5Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgIVD5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 23:57:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42054 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgIVD5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 23:57:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3nR9R149195;
        Tue, 22 Sep 2020 03:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=uhpV3Ss0BxKt/5J8envv+AMw8JJXiP+jqjuvqhwiNHg=;
 b=VZ12jT5YUDSw0jCTN0xbhT4UWbSlNT/8gF4LIpxsTwwuHPaSOiLJ2wbmJuG5cktrKha0
 oZbT7GXIB1Ed4NZYW5y11o3YLVYlRVlHiKDAXqEWXZij/KBEBZ+UI/2OKqN4MhFfVlpx
 S5R98yoFR6Ap9O2Da1evMjH25N3YvfOrv2C+xDlDRaUhYRaECfPzcxxOgs99lhJ/1HEc
 Wb30F/s9zYIWkOQhMiTJNEajcB9HWZ+xcyqcEt30KF4F5tqav83c/gy8LuZ6Vx1CoAaf
 PDgyiEyYHVOu7CGY3BK/X8Fqna/7cB6mcqSxts7LZIml+XACacJ5pf8ZVTzDfIa+tMmU +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33n7gad5t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 03:57:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08M3uIro149698;
        Tue, 22 Sep 2020 03:57:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33nujmm8s4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 03:57:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08M3vWpB032621;
        Tue, 22 Sep 2020 03:57:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 20:57:31 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        megaraidlinux.pdl@broadcom.com, damien.lemoal@wdc.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, kashyap.desai@broadcom.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: megaraid: make smp_affinity_enable static
Date:   Mon, 21 Sep 2020 23:57:01 -0400
Message-Id: <160074695009.411.5259865999081644299.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915083948.2826598-1-yanaijie@huawei.com>
References: <20200915083948.2826598-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=961 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxlogscore=975 clxscore=1015 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Sep 2020 16:39:48 +0800, Jason Yan wrote:

> This addresses the following sparse warning:
> 
> drivers/scsi/megaraid/megaraid_sas_base.c:80:5: warning: symbol
> 'smp_affinity_enable' was not declared. Should it be static?

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: megaraid: Make smp_affinity_enable static
      https://git.kernel.org/mkp/scsi/c/62aa501dc9dd

-- 
Martin K. Petersen	Oracle Linux Engineering
