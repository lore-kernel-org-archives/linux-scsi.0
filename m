Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08186C54E8F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4FF02070B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DHVW76ic"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgELD3N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:29:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38980 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgELD3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:29:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3RLqu105359;
        Tue, 12 May 2020 03:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ni9oIwBF0kFHO90YyUt6O8N/ONfe3kHQBUvre9Dt3Mk=;
 b=DHVW76icYRe5Se4DZ2nSN/ERtzcWIqjfUs4ZKQy9mcvVjyL+Dk2tlVMpGLXRsA49KcH/
 7rVn/mOfmIxQdbdiE2PAyABFTYtRUGfmT79duHvIYPscadmJ/AJMTPyvuOtU4++I8eS9
 noIl5FZ5LpHrDdFAS1+QzADOIKrLxvYzmeIU8hWPA5zl64IK3feyfbUkHMjmFVe/sLUO
 fspY88mRsjCRxjObAyHpDi2IyCsM591g9tcx9XPDtPdHBNaihYw4mmNyB+k0lO8Oq6Ub
 0olMUQtHUFod2I3I4/6q8ummjV32DfGVUusFJQizd8TXe6xP26OgfWqbpfv5X5YbU40f pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30x3gmghst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:28:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3PF4N095882;
        Tue, 12 May 2020 03:28:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30x69s9scu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:28:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C3SoHC029048;
        Tue, 12 May 2020 03:28:50 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 20:28:50 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        sudarsana.kalluru@qlogic.com, tglx@linutronix.de,
        Jason Yan <yanaijie@huawei.com>, anil.gurumurthy@qlogic.com,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: bfa: make bfad_iocmd_ioc_get_stats() static
Date:   Mon, 11 May 2020 23:28:35 -0400
Message-Id: <158925392373.17325.11476546344986832669.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505073807.40332-1-yanaijie@huawei.com>
References: <20200505073807.40332-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=965 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 5 May 2020 15:38:07 +0800, Jason Yan wrote:

> Fix the following sparse warning:
> 
> drivers/scsi/bfa/bfad_bsg.c:140:1: warning: symbol
> 'bfad_iocmd_ioc_get_stats' was not declared. Should it be static?

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: bfa: Make bfad_iocmd_ioc_get_stats() static
      https://git.kernel.org/mkp/scsi/c/102026483d2b

-- 
Martin K. Petersen	Oracle Linux Engineering
