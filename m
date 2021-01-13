Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9BCC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3EC82225E
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbhAMFvd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:51:33 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35260 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbhAMFvd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:51:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5npu9170814;
        Wed, 13 Jan 2021 05:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3aTGR28ZQ7/qlWyIHk7iuIcdv1I6c3bO857k2v3eGD4=;
 b=Y5VmEnfSL3qYCRIGz8Us9+YPgHUGLk/6IY/hIY9CB39aG56oFTCSavoi60rDTbc78mOI
 yjvFfMJmkO4MQln3Te58AA/FqxxSb/SK8EnWEYepdbb33M0cvZN+Z5JpSOKuEbnXxo/s
 /dwfPr1bqf72I8jH/iXcYnMxuN+SQUc4EA7tar5tOFUNTUrEy3s+Gka7ZAJiuUsTFZJE
 p+XtnkX3GgDAYVMSJl2HRhYmDxhmmHNEGocl1vdHb4xjTypynXD+IPoz9g6ZbsahzFIR
 TzrO7iJv6HT3Cf2ZmF3ZfQfzt7eSj6bQdBPBeMATI+QmaXMW638/DR0KZO/oFBEl4Xbf Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1sp05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:50:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5eWPr058820;
        Wed, 13 Jan 2021 05:48:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kf6vyt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:48:39 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10D5mUUu028497;
        Wed, 13 Jan 2021 05:48:33 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 21:48:30 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     stanley.chu@mediatek.com, beanhuo@micron.com, jejb@linux.ibm.com,
        Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        bvanassche@acm.org, tomas.winkler@intel.com,
        asutoshd@codeaurora.org, avri.altman@wdc.com, cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: Replace sprintf and snprintf with sysfs_emit
Date:   Wed, 13 Jan 2021 00:48:21 -0500
Message-Id: <161050726819.14224.2936301272114808437.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106211541.23039-1-huobean@gmail.com>
References: <20210106211541.23039-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=958 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130034
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=968 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 Jan 2021 22:15:41 +0100, Bean Huo wrote:

> sprintf and snprintf may cause output defect in sysfs content, it is
> better to use new added sysfs_emit function which knows the size of the
> temporary buffer.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: ufs: Replace sprintf and snprintf with sysfs_emit
      https://git.kernel.org/mkp/scsi/c/d9edeb8b4768

-- 
Martin K. Petersen	Oracle Linux Engineering
