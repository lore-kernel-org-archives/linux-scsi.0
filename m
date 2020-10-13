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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD629C43467
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9827F21D40
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 22:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g7bpPU/J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbgJMWpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 18:45:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48256 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbgJMWph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2020 18:45:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMYbTB143715;
        Tue, 13 Oct 2020 22:45:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=++M4Pj2yaIKtiGspyYyPHsQLMt7bwgrTFKCqF3BATLA=;
 b=g7bpPU/Jbvzvpr7mXqWm7PM10ne7GOIs/bEH8rmeHy3xQvLlT3Pq9i5e6IHuEPCpoSpC
 z+zl3pe32anLesSi8Lg5dS8sl2lH4bhO13NPvmRPSexHzxRuBu+2TYj57DqJMNahUK2Q
 UiJNyEAm6bmJuPJF6jr9VxDMkordVs7hPBVK2oXfAAWIRNlCL6Z+g4HcZaOG1lkk2NmG
 mIKeahnNoZRQirj9c36w+FxzhyxoRsyzMukBd9mynC7BFsZdQ77HzS7k138p+UGn+IK8
 OHwy0Ir7eeYlMyNCwKLMysZ6Gm7tVhIKT7l+W8ieTfpI5n14Tg996s2IdNlkUiG04s05 DQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 343pajucw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 22:45:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DMZWES162464;
        Tue, 13 Oct 2020 22:43:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 344by2v0h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 22:43:28 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09DMhRvE010002;
        Tue, 13 Oct 2020 22:43:27 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 15:43:27 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Ye Bin <yebin10@huawei.com>, hare@kernel.org,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: myrb: Fix inconsistent of format with argument type in myrb.c
Date:   Tue, 13 Oct 2020 18:43:03 -0400
Message-Id: <160262862434.3018.3466864361607751492.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930021637.2831618-1-yebin10@huawei.com>
References: <20200930021637.2831618-1-yebin10@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130158
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 30 Sep 2020 10:16:37 +0800, Ye Bin wrote:

> Fix follow warnings:
> [drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 1)
> 	requires 'int' but the argument type is 'unsigned int'.
> [drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 2)
> 	requires 'int' but the argument type is 'unsigned int'.
> [drivers/scsi/myrb.c:1052]: (warning) %d in format string (no. 4)
> 	requires 'int' but the argument type is 'unsigned int'.
> [drivers/scsi/myrb.c:2170]: (warning) %d in format string (no. 1)
> 	requires 'int' but the argument type is 'unsigned int'.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: myrb: Fix inconsistent format argument types
      https://git.kernel.org/mkp/scsi/c/fc29f04a5c6b

-- 
Martin K. Petersen	Oracle Linux Engineering
