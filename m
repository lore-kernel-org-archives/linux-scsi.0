Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F919C4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30CCE206B8
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wB9y2JZv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgI3Dff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 23:35:35 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49344 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgI3Dfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 23:35:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3PG2l147179;
        Wed, 30 Sep 2020 03:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=RmEynA6LQnNSJgRokfZmIJv2wPjJiLYa9Smp1fW3sn0=;
 b=wB9y2JZv33IrUblBmUxNwC/9buxPg/aDPh8L8XrIBHCG94ngBhhogN4hx/x82Z+ynB2m
 RBy2sq4uzTps/Hf1+ltj1YZUo2UZbyGnT9S2gx/zZ2VpgS7FEd9SylklF/iT8iyW8oUP
 2PtiQgdyvDUrI0OYFsqd79FIbH6XjdRo0jK7WRExGn3bGsIqtwRSmngJXSQrLogjP+sW
 wFN7UmuVqjWt1F3wER/MO35CYTZhrNqZmb4vkn0hj3xdqQoIHyWFOdH0itVCAGiK0mL8
 z4VJGJvJe3+bzwOsKtbsH4ykaecEkLd0TJB72i7pYagarc8cSpyXT2P5cZwpmlON45pL qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5axc0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 03:34:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3QVEX064891;
        Wed, 30 Sep 2020 03:34:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33tfhygkxa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 03:34:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08U3YsxL027460;
        Wed, 30 Sep 2020 03:34:54 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 20:34:54 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        fthain@telegraphics.com.au, linux@armlinux.org.uk,
        schmitzmic@gmail.com, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: remove redundant initialization of variable ret
Date:   Tue, 29 Sep 2020 23:34:47 -0400
Message-Id: <160143685413.27701.2383412443851810355.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918090747.44645-1-jingxiangfeng@huawei.com>
References: <20200918090747.44645-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 18 Sep 2020 17:07:47 +0800, Jing Xiangfeng wrote:

> The variable ret is being initialized with '-ENOMEM' that is
> meaningless. So remove it.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: oak: Remove redundant initialization of variable ret
      https://git.kernel.org/mkp/scsi/c/713a846884ce

-- 
Martin K. Petersen	Oracle Linux Engineering
