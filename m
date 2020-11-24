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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B063C64E75
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A94320857
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bWib3YtB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgKXD6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48260 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727869AbgKXD6W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3sw4Q153382;
        Tue, 24 Nov 2020 03:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7EHNjMaSGdycTi4T4kYmXIZgrmMfrJgt42KR2jSE5Xg=;
 b=bWib3YtBcbslGv18X3D2oEXuX9or8CSVmFpG7Ol5Tjtj66C1RaqrhTylieVFaXvq7+Jd
 1DCYTRkZnR3MeRS7UMFxKEfjKvPFuuniahfGC3pQHjDebzT2Ci2yWefK5BgQFBa3BOZg
 WIdltisTbfPKAgPD8mzE1PMeuzmhvxaANQQzE5q7ysmrLaZFSrahOVUH+HjrSeHs2NHA
 uallLmy4dYPI2C0Lb2Sg7tJKoMWD28LA6nx+JfRt2s+BREshDx5vlyDv/SX5eFORgmJP
 BusXdUhogbfqkfOKowG+bnDUfrKGe528B+nzi7BI6rsMtuVy1ZkqNA6f8QCV4hdkHKdr kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34xtum0e4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3tdm9066570;
        Tue, 24 Nov 2020 03:58:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34yx8ja38c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3wHv0006145;
        Tue, 24 Nov 2020 03:58:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:17 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] lpfc: Fix set but unused variables in lpfc_dev_loss_tmo_handler
Date:   Mon, 23 Nov 2020 22:58:06 -0500
Message-Id: <160618683553.24173.14095195614285342813.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119203353.121866-1-james.smart@broadcom.com>
References: <20201119203353.121866-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 mlxlogscore=957 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=988 impostorscore=0 spamscore=0 mlxscore=0
 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 19 Nov 2020 12:33:53 -0800, James Smart wrote:

> Remove set but not used variable shost in lpfc_dev_loss_tmo_handler()

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix set but unused variables in lpfc_dev_loss_tmo_handler()
      https://git.kernel.org/mkp/scsi/c/09b15e35071d

-- 
Martin K. Petersen	Oracle Linux Engineering
