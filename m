Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2055AC433F7
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B942070E
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZXGZ2k+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGYCvW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40060 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGYCvW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2lGq1077080;
        Sat, 25 Jul 2020 02:51:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=2262tYASm2m0wmW5pnxCZEVAIbRNOM0X3KdwApLmeAs=;
 b=ZXGZ2k+i9u3dALWgSUHICUOpqC+ZhHGZcUGzqMq8HWU/gaZeo1vZSRgkCQiaJg5BP/mT
 K2BGRzfwL5tEJXMeFfJa3MU43G1TvB8mkLpQ91W4hG9IteOol2fHlO3865aKsfoeRLta
 9nFmCnqaTFVGMlf36NtKtFOvoiuT6xmY76yTBxfsQTNDwvVp9zkC+1dCe8d4Bqx7rDTq
 w72BRiWhT0Uvzn4aApBArichLizWVH8ltLP7Qo3fWpm8XIE+BrnsnLhY+/P1A55jiaW/
 HhUEXlqp+vXLEyLkoOGZRpDL3XkWTAF4bIqS9ammyRnhyRS+YHFQY8XR2eiTDlHCV70t jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32gc5qr0d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:51:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2nBam024079;
        Sat, 25 Jul 2020 02:51:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32g9uu6pxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:06 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2p6DS004239;
        Sat, 25 Jul 2020 02:51:06 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:51:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Ye Bin <yebin10@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sashal@kernel.org, bvanassche@acm.org
Subject: Re: [PATCH] scsi: Delete unnecessary allocate buffer for every loop when print command
Date:   Fri, 24 Jul 2020 22:50:46 -0400
Message-Id: <159564519423.31464.10229326949845693673.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717090921.29243-2-yebin10@huawei.com>
References: <20200717090921.29243-1-yebin10@huawei.com> <20200717090921.29243-2-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 17 Jul 2020 17:09:21 +0800, Ye Bin wrote:

> We can allocate buffer once, and reuse it. There is unnecessary allocate
>  buffer for every loop.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: core: Delete unnecessary buffer allocation for every loop iteration
      https://git.kernel.org/mkp/scsi/c/811f39479c0c

-- 
Martin K. Petersen	Oracle Linux Engineering
