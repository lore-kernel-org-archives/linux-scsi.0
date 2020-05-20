Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22420C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76232075F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:32:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBuAl5fW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgETCcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:32:32 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728476AbgETCcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:32:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2Vt7F126178;
        Wed, 20 May 2020 02:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=HzhG297ioBOB/YzfdikV1L+kCAUZ8qyPl4LE6DrrEvA=;
 b=EBuAl5fWmxfK7DZv4SfAiYm1am23NdV8qijR2fWVxrSylgeLWxxyA1s30sU10rcs0DCE
 AyrVar4PyNvYl2qX4pBbwJC7ADW7jcsEksxvl011NsRx2l5Skju+5WCsMqfTCql1ZDX7
 uKaAgj756X8Q+zWhGZiqrrYzVv0ILOidVeZVAyUN02GTI2YjFLiWuRgCWuFbSFObtUTc
 9G4sCsFFTW7bUL1RVGr3Ac28sNe91c+aIAah4U6W6oeSTwsQgl0n0OXAJfd4NfjMkBqr
 rxsDwd1hRka//fSMZT+SggKRgufLL1LYS1ZvQOG/qhGkwEBDPERXNYoORFmlYcD4bko1 kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3128tngj23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:32:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2T9Ax162915;
        Wed, 20 May 2020 02:30:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 312sxtvfe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:22 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K2ULKJ024147;
        Wed, 20 May 2020 02:30:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:21 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "Manoj N . Kumar" <manoj@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: cxlflash: Fix error return code in cxlflash_probe()
Date:   Tue, 19 May 2020 22:30:08 -0400
Message-Id: <158994171817.20861.9312326618891332978.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428141855.88704-1-weiyongjun1@huawei.com>
References: <20200428141855.88704-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Apr 2020 14:18:55 +0000, Wei Yongjun wrote:

> Fix to return negative error code -ENOMEM from create_afu error
> handling case instead of 0, as done elsewhere in this function.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: cxlflash: Fix error return code in cxlflash_probe()
      https://git.kernel.org/mkp/scsi/c/d0b1e4a638d6

-- 
Martin K. Petersen	Oracle Linux Engineering
