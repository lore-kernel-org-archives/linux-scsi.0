Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B20C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85ED220792
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:19:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G/h5pSbr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgHEBTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:19:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51846 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbgHEBTu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:19:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0751Hl1r179278;
        Wed, 5 Aug 2020 01:19:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=22G/+yy8Bfbyplrrau9tUI/no15T53YqU4Sb75YuVss=;
 b=G/h5pSbro8vbhNJNpDrSnc60DEvHBZypmyeyDHBiWi/j2glRktaSnUwxniw56YeGf/Gd
 Ch95gBOP3f8tdHkhM7H8MYEvTMFqjdAomrID3foRkLE/Tdd4aIU3ozS51RQA+xW9t0tv
 cEMHgKPqISe1gh5GAIDkfyuAl47fVKW+b+6fjGwVA2OgJVaF7UrzMxFRZgIji8kJvZDB
 GWmc2PmklTBxVtdzJtnFOdRBstQuVgsMjvUGpRJUAVGBINM/NUT52nHUjlXhq8IZvX82
 OQiQZyKRaplsawoAZS0eDCn6/jYzrW4yUHFHcUXj4k5INR83metLgpfOBcMF4YMt8kLT bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32pdnqap3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 05 Aug 2020 01:19:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 075198LD088130;
        Wed, 5 Aug 2020 01:17:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 32p5gt1mwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Aug 2020 01:17:40 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0751HdHl013730;
        Wed, 5 Aug 2020 01:17:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Aug 2020 18:17:38 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        james.smart@broadcom.com, Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Add the missed misc_deregister() for lpfc_init()
Date:   Tue,  4 Aug 2020 21:17:31 -0400
Message-Id: <159659019689.15726.17823455104976058315.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731065639.190646-1-jingxiangfeng@huawei.com>
References: <20200731065639.190646-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9703 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008050009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 31 Jul 2020 14:56:39 +0800, Jing Xiangfeng wrote:

> lpfc_init() misses to call misc_deregister() in an error path. Add a
> label 'unregister' to fix it.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: lpfc: Add missing misc_deregister() for lpfc_init()
      https://git.kernel.org/mkp/scsi/c/1eaff53649b8

-- 
Martin K. Petersen	Oracle Linux Engineering
