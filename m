Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6BEC43467
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 077B221D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vS8Q1Jy4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgJMWpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:45:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43158 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728167AbgJMWpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:45:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZoKs072095;
        Tue, 13 Oct 2020 22:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5vDoOHxCaATzTH5lljBrPW+NPhOfQUhzm3A0gK+metA=;
 b=vS8Q1Jy42k5bs8PM1iFEpdCxGO4hGT63IyRlOOlqSGMqMaXeEhipz09KCwp+F4ZLUniB
 KyVPvJDjZAYC9XMO26yPliGgOhYi5S3O96nTiaJAjRv06Lu3yJ6zbXRtNt0d9E04H/h9
 DmhAjccab0SdQltw61wNEu6BHCWsOp75Mna210dbrrunrhgoq4pf/AmEbAjFrnFJ8MB4
 o9x3uc/klc9VAevFtcZ2EQ9/9J8Qx5PHLZJ/F0L1Ez39WWFO0VC/L0rZYZOVPqCKhLQ5
 3WuUZWU8O7Xb04ryp7IKAuYBYDov7Yp7YGotbm9PiYBBStxTQ7E21Tks/EK/EtuVrAbc OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 343vaeb2j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:45:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZEEF155674;
        Tue, 13 Oct 2020 22:43:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 343puyjx2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:21 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMhLUM014543;
        Tue, 13 Oct 2020 22:43:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:20 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Liu Shixin <liushixin2@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] snic: simplify the return expression of svnic_cq_alloc
Date:   Tue, 13 Oct 2020 18:42:56 -0400
Message-Id: <160262862433.3018.16912626841305699482.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921082455.2592190-1-liushixin2@huawei.com>
References: <20200921082455.2592190-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Sep 2020 16:24:55 +0800, Liu Shixin wrote:

> Simplify the return expression.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: snic: Simplify the return expression of svnic_cq_alloc()
      https://git.kernel.org/mkp/scsi/c/6afc12fa6e50

-- 
Martin K. Petersen	Oracle Linux Engineering
