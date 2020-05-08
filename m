Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24EEC47247
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A1A20731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W1TZLquj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgEHCzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:55:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33732 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgEHCy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:54:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482rnIN085497;
        Fri, 8 May 2020 02:54:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=XpRGuVgeJRX4OI4EInAf3/cLNEN+gXC/JZqneCqpGO0=;
 b=W1TZLqujL+j2LSoks+Se/7iBdqyEXmzXXp+rpQUUd1uDAy85MjPkmoVSWtiwQ7h8CxBc
 UDqP2R3x9G97vihp1ha4VtGA0qj9jPeO02yciFHcL4/7heVTh1c8AdXkRqkDPQYQ38BV
 ZiqTDsBYn82qrVznPxqKhtULzb4kWUJPr9qVdd8QFFnUFQ2TAJYTtUDoKNj1CePnbWr6
 dyTRejCCP5yT3S9D0ScZQL6GCLplRsuHP/V3qiWnwJ5DLd3ooAKXPFqAHTeRKVIZK+RC
 e1fHSYWh1WcgvIWGLSdI5lheQs9AM7V13J0PZccPZ2qnqN/zY8apvHjQPndlNe9gPJ8r sQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30vtexrrm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482qudH138317;
        Fri, 8 May 2020 02:54:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30vtdmp5am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:47 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0482sk9b028797;
        Fri, 8 May 2020 02:54:46 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:45 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, hmadhani@marvell.com,
        Jason Yan <yanaijie@huawei.com>, njavali@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: make qlafx00_process_aen() return void
Date:   Thu,  7 May 2020 22:54:32 -0400
Message-Id: <158890633245.6466.6334279063078587636.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200506061757.19536-1-yanaijie@huawei.com>
References: <20200506061757.19536-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 mlxlogscore=841 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=888 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 6 May 2020 14:17:57 +0800, Jason Yan wrote:

> No other functions use the return value of qlafx00_process_aen() and the
> return value is always 0 now. Make it return void. This fixes the
> following coccicheck warning:
> 
> drivers/scsi/qla2xxx/qla_mr.c:1716:5-9: Unneeded variable: "rval".
> Return "0" on line 1768

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Make qlafx00_process_aen() return void
      https://git.kernel.org/mkp/scsi/c/88bfdf565cbe

-- 
Martin K. Petersen	Oracle Linux Engineering
