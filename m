Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4445AC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2194A20756
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0VG26ibh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgETChX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:37:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33586 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgETChW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:37:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2RFM8084713;
        Wed, 20 May 2020 02:30:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=kUGQDr/v7sUBLEwDb3Xz/wcZpIxXeDLcJONr9yOjouM=;
 b=0VG26ibhj4o06wk5NIrulWnIbUFLGsNIIdbQxMijaOKLRluFV/d2rrBlv+CSOu/M1gV5
 qQ/mbVtPg4m6fsoryBM0fApAWQ/O4r+pk1QAWQV3RS8z77XQTwrIgElSedcHo4Z86DpQ
 QGAW/DJvIE/f4w/GcfA0X/5DRuk9dWrN1UVNGjEbWMTykR+9S7AXsr2ZxPPgTspRzVi6
 HWnCEbcGvs8/O/vkLMBlzLbgA7YajdcGK8z8QZP0eDpVFEzhBhmJi11EOyzBUw6oifIJ
 +UNtA95siBDFG1SpeeYvaTErkSOdlJ/XA3xjVqEzC0c5P0LTXd8PvXInvI8gTqsdajWC MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127kr8n9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:30:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2SZ5v064335;
        Wed, 20 May 2020 02:30:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 313gj2mf8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:24 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K2UNTS011820;
        Wed, 20 May 2020 02:30:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:22 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ye Bin <yebin10@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Refactor scsi_mq_setup_tags function
Date:   Tue, 19 May 2020 22:30:10 -0400
Message-Id: <158994171818.20861.13541589109613423066.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518074732.39679-1-yebin10@huawei.com>
References: <20200518074732.39679-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=952
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=998 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 18 May 2020 15:47:32 +0800, Ye Bin wrote:

>   "shost->tag_set" is used too many times, introduce temporary parameter
> "tag_set" instead of "&shost->tag_set".

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: core: Refactor scsi_mq_setup_tags function
      https://git.kernel.org/mkp/scsi/c/840e1b55bb75

-- 
Martin K. Petersen	Oracle Linux Engineering
