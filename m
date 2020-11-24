Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11218C64E69
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1AA320866
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AcspC8Zy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgKXD6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:24 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50508 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbgKXD6U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3sc0m090551;
        Tue, 24 Nov 2020 03:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=B7qpSPzLhRHp32EartlGRYpmdK3hMwiUarUICiHFgd4=;
 b=AcspC8ZyPehh790q9iYt73c4oWU+OnP4ZhxT5LI3bbLLBzlum6+12ngkBa59pZ33EEXl
 rvfmKOFpVRniRdfYnUwoybLHwpKdXJKTM7W1Q7Lzhp/1e0K27VPORD3Iu81EyyiJ8iWg
 t605m8TIDcw4mU3NMS6xZ+JjLo/uwn4Im2LK/35uiwFifV8F8tQztI/h2Up5a4DSYLrK
 8kv4zQ5PoYHA8rMXpwtINpiOxZULPRRBCW6+WR2AihLQkLNeGDuGXFdtTCsDrYl4hHgT
 BgkDvK+x990Y79I4TGLelPGxEfQv0a+fMk5T74byHCqzq0EeAT/cQ5kDIuAStibTdkCk zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34xrdarmby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3ssEW115550;
        Tue, 24 Nov 2020 03:58:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34yctvu0sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:16 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3wFJG009626;
        Tue, 24 Nov 2020 03:58:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:15 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: fix missing prototype for lpfc_nvmet_prep_abort_wqe
Date:   Mon, 23 Nov 2020 22:58:03 -0500
Message-Id: <160618683553.24173.9787549027884735063.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119203316.121725-1-james.smart@broadcom.com>
References: <20201119203316.121725-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=980 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Nov 2020 12:33:16 -0800, James Smart wrote:

> lpfc_nvmet_prep_abort_wqe needs to be declared static

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix missing prototype for lpfc_nvmet_prep_abort_wqe()
      https://git.kernel.org/mkp/scsi/c/185d17e11e7f

-- 
Martin K. Petersen	Oracle Linux Engineering
