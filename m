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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDECC433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 256D221D7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RDDRJrx3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgJMWoU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:44:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728927AbgJMWnY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:43:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYPqA023467;
        Tue, 13 Oct 2020 22:43:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=fpKfILKysPwGf+lx41VOH7aScruYbGsVss0CW+qCs2s=;
 b=RDDRJrx3NfcS9ITQ8QYkMGCUhgVkueMi6iEvb8g7vcT9VFJTlmbJfF0OBKXsH66/P+cM
 ra0j0xnw+54FgnCwhWauQRMeJSBUHODE95D5RIR49q16W2uLIT1cgf227FtwDzsDTU8R
 AhD2WAv4WvbfsyVdSdOnZBisPzl++2yR32yLeY9NSodsn+RLMMg3Qi/6ekeYi2LXAHdB
 ApMA0OjCGOFGM8tw1YA6NIJzgoj8AEa7yNiJ68eFzwUG8nCLW2cXBzfCa6WrOUJhsvtT
 AcDsxwFsMDLYjhEACK+ChWOiaNn+ZPvA6J6PwnsyWOGKT+KpPJ2XhWsrLJ55Ywrp+1aq Bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3434wkmr7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:43:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZDIM155592;
        Tue, 13 Oct 2020 22:43:15 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 343puyjx0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:14 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DMh9io005685;
        Tue, 13 Oct 2020 22:43:09 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:09 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Colin King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: sym53c8xx_2: fix sizeof mismatch
Date:   Tue, 13 Oct 2020 18:42:46 -0400
Message-Id: <160262862435.3018.4642298428321942870.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201006110252.536641-1-colin.king@canonical.com>
References: <20201006110252.536641-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 spamscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 6 Oct 2020 12:02:52 +0100, Colin King wrote:

> An incorrect sizeof is being used, struct sym_ccb ** is not correct,
> it should be struct sym_ccb *. Note that since ** is the same size as
> * this is not causing any issues.  Improve this fix by using the
> idiom sizeof(*np->ccbh) as this allows one to not even reference the
> type of the pointer.
> 
> [ Note: this is an ancient 2005 buglet, the sha is from the
>   tglx/history repo ]

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: sym53c8xx_2: Fix sizeof() mismatch
      https://git.kernel.org/mkp/scsi/c/1725ba8d6ff1

-- 
Martin K. Petersen	Oracle Linux Engineering
