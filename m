Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5CBC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F5AA20756
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 21:07:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yPINnkBc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgIOVHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 17:07:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44896 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgIOUgG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 16:36:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKAxCT178805;
        Tue, 15 Sep 2020 20:16:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=bF3iN2TYMHRMbpwp4Ubg9ibzl7kFpOr9sTVao/DOQ9s=;
 b=yPINnkBcp0mtxY9aV+fNBaaQuGQIjo6vTDcK0mpQo/+zUfvdkIqehdgCOO1mp1rEVq9i
 HGqI8s2G8jlznFL8z3Ad49cQ0Pgje5ki291/AjVNqSciIPPNIVAeEj9Ij6xa5JqX4FpD
 2s5pTmeixPZ3jTur6a7FG2iKoig+Fv1Mius3nVpbYfSOlF13Qv9rHvZXOFwcfTeRZ5ay
 hI3mA18FMgnTXW79xpgTc1XPkiWQQEeUUiBlY3EcunenPlcRdyq4cFgu0vNQt/xKj23S
 NfrxO0yvQZd4oxXlG8ALpCFfBfaNzg33zLNjsMKDUHeXCG5sPlZQbM/OQ7RJRAepzOEf Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33j91dh0yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 20:16:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKFRJ3177333;
        Tue, 15 Sep 2020 20:16:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33h885xmb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:16:39 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FKGckp002993;
        Tue, 15 Sep 2020 20:16:38 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 20:16:37 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>, Martin Wilck <mwilck@suse.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] qla2xxx: A couple crash fixes
Date:   Tue, 15 Sep 2020 16:16:23 -0400
Message-Id: <160020074002.8134.15701828723963808362.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908081516.8561-1-dwagner@suse.de>
References: <20200908081516.8561-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150157
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Sep 2020 10:15:12 +0200, Daniel Wagner wrote:

> The first crash we observed is due memory corruption in the srb memory
> pool. Unforuntatly, I couldn't find the source of the problem but the
> workaround by resetting the cleanup callbacks 'fixes' this problem
> (patch #1). I think as intermeditate step this should be merged until
> the real cause can be identified.
> 
> The second crash is due a race condition(?) in the firmware. The sts
> entries are not updated in time which leads to this crash pattern
> which several customers have reported:
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/4] scsi: qla2xxx: Warn if done() or free() are called on an already freed srb
      https://git.kernel.org/mkp/scsi/c/c0014f94218e
[2/4] scsi: qla2xxx: Simplify return value logic in qla2x00_get_sp_from_handle()
      https://git.kernel.org/mkp/scsi/c/622299f16f33
[3/4] scsi: qla2xxx: Log calling function name in qla2x00_get_sp_from_handle()
      https://git.kernel.org/mkp/scsi/c/7d88d5dff95f
[4/4] scsi: qla2xxx: Handle incorrect entry_type entries
      https://git.kernel.org/mkp/scsi/c/31a3271ff11b

-- 
Martin K. Petersen	Oracle Linux Engineering
