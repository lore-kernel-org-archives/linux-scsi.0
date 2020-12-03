Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E00C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 20:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC35221EA
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 20:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgLCUr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:47:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgLCUr5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 15:47:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Kj26T051468;
        Thu, 3 Dec 2020 20:47:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cly3CzUIK+ABp/S/bwpM0IyTNv/OAKOXjQUjIPT8DsI=;
 b=ZK1IZQyPkIKPmKODXfxalNma/nE6+fgya45xZe+EoThW+TS2gLTQe7NSZTuA2FnWQrzN
 NsYjYnnv1m264IieU5ROyTVHIh0w/0zbm9jGiVfq3pCYGmNZS+farUYcq1pUoheEpAjM
 zKJUjJYctteHvFES1uyjB/YJ+W5LwbDI6d23TbIYiOSLUnrbPw80+vBf38lwQ4P9V0o2
 0kD27nYzB9bqNKR07QacQykgLaQ93EopqL6+Le1BWGlPHtgFSiEJNp6cZPSUSfc6m48C
 i1gYh2QyDG/PCb5gXlmUCqxFbpsv5iN1aDiLTjXpMWIhEwmhQXTysUS12NMrCG13HofE KQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 353egm046e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 20:47:06 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KeOhp164167;
        Thu, 3 Dec 2020 20:45:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3540awta9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 20:45:06 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B3Kj5kB007064;
        Thu, 3 Dec 2020 20:45:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 12:45:04 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SCSI: bnx2i: requires MMU
Date:   Thu,  3 Dec 2020 15:45:02 -0500
Message-Id: <160702820882.27665.4977544975755067401.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201129070916.3919-1-rdunlap@infradead.org>
References: <20201129070916.3919-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=865 bulkscore=0
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=879 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 28 Nov 2020 23:09:16 -0800, Randy Dunlap wrote:

> The SCSI_BNX2_ISCSI kconfig symbol selects CNIC and CNIC selects UIO,
> which depends on MMU.
> Since 'select' does not follow dependency chains, add the same MMU
> dependency to SCSI_BNX2_ISCSI.
> 
> Quietens this kconfig warning:
> 
> [...]

Applied to 5.10/scsi-fixes, thanks!

[1/1] SCSI: bnx2i: requires MMU
      https://git.kernel.org/mkp/scsi/c/2d586494c4a0

-- 
Martin K. Petersen	Oracle Linux Engineering
