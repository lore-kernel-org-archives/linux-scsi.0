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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA1CC433E5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B12B420737
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qB8uFVXk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGYCvG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGYCvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2lkNS077452;
        Sat, 25 Jul 2020 02:51:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=CGVxu77ac9FtuAIy8X9BVU27poMwPIGXKIrYCOdS3yM=;
 b=qB8uFVXkmFVt3PqRPWWOlWyYEyGioi6losqp6/MEYzyNd/9wTDDnrX34hYy/Tsl9AZYM
 iV2DtUfM2/ch5o4HLBM2e4sMTFYD/eRH6SPIcDHKUM3z66aWcbct3DMonBI/KBoNpBeN
 Xd9lw43OmFRUqrEnlTYXHA24+dNlrl2pPFetjJueitNfJKMZXixzNrCiAcCUgmQ1DBYB
 JTWWSTsQMCte0+FOSiNtwM+B/zOy3DKQA9yU3ymJp7yIdrCvoGap9ozUtqisahKBM/f8
 95xde90k7QapNLqMVuTXI4iQ1amwXRJtBfrSISEXb+MECYe+8q7KxzR0DSmgL7ER3myF Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32gc5qr0d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:51:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2nB8w024018;
        Sat, 25 Jul 2020 02:51:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32g9uu6pq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:03 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P2p12e014826;
        Sat, 25 Jul 2020 02:51:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Jul 2020 19:51:01 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Varun Prakash <varun@chelsio.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, dt@chelsio.com,
        ganji.aravind@chelsio.com, dan.carpenter@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [next] scsi: libcxgbi: Remove unnecessary NULL checks for 'tdata' pointer
Date:   Fri, 24 Jul 2020 22:50:42 -0400
Message-Id: <159564519423.31464.10823187843799537841.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1595505391-3335-1-git-send-email-varun@chelsio.com>
References: <1595505391-3335-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=894 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 phishscore=0 mlxlogscore=918 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 23 Jul 2020 17:26:31 +0530, Varun Prakash wrote:

> 'tdata' pointer will never be NULL so remove NULL checks.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: libcxgbi: Remove unnecessary NULL checks for 'tdata' pointer
      https://git.kernel.org/mkp/scsi/c/61965bf6c142

-- 
Martin K. Petersen	Oracle Linux Engineering
