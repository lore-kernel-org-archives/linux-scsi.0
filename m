Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81595C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DB9D22B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X8fqePoE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgGUDoX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 23:44:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54764 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUDoX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 23:44:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3cLkb088831;
        Tue, 21 Jul 2020 03:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=I+JM15lcinMwfiXuwOlA/X3rIoh24odWPWx5h9YBAeM=;
 b=X8fqePoE13ps2E4LpQRb+c2qqKRYSazUDaNn1W8WT0Zs9fjhSOxwzBu1xnNCS1a/LOv2
 7QB2IF+X2ou+B593AnQ0auE4n6HzPHTFkbSfSdk6r6CCdzzPjUAFeuGv2Y0PlqD9BHez
 zoI++kmYmjstUhyPGMZ5EJYlyU+Swa1kSpn++iS5iHQmlPZ03PTvOBzzDi+IsqVT37+u
 mGyKZ3N4rZMTgjsOHNuzODu5m9Cfh6HiUItxeNQ/8UYXwjeAYM524FFi5/wcaWQ1Qt12
 BQtvBP6QxDOr/YC2muWyyHSkw6XY065Kz9VLHNvPztqnbnfwhb425NnI4ImXk8zyK1IO LQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 32bpkb2nk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 03:44:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3d19b005288;
        Tue, 21 Jul 2020 03:42:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32dnmqfayg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 03:42:14 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06L3gCx4014201;
        Tue, 21 Jul 2020 03:42:12 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 03:42:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hy50.seo@samsung.com, asutoshd@codeaurora.org, bvanassche@acm.org,
        alim.akhtar@samsung.com, grant.jung@samsung.com,
        linux-scsi@vger.kernel.org, sc.suh@samsung.com, beanhuo@micron.com,
        jejb@linux.ibm.com, sh425.lee@samsung.com, avri.altman@wdc.com,
        Kiwoong Kim <kwmad.kim@samsung.com>, cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 0/3] ufs: exynos: introduce the way to get cmd info
Date:   Mon, 20 Jul 2020 23:42:07 -0400
Message-Id: <159530290480.22526.15318134249960762889.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1594798514.git.kwmad.kim@samsung.com>
References: <CGME20200715074757epcas2p344b4e188af3221655c1697405b9e17f4@epcas2p3.samsung.com> <cover.1594798514.git.kwmad.kim@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Jul 2020 16:39:54 +0900, Kiwoong Kim wrote:

> v5 -> v6
> replace put_aligned with get_unaligned_be32 to set lba and sct
> fix null pointer access symptom
> 
> v4 -> v5
> Rebased on Stanley's patch (scsi: ufs: Fix and simplify ..
> Change cmd history print order
> rename config to SCSI_UFS_EXYNOS_DBG
> feature functions in ufs-exynos-dbg.c by SCSI_UFS_EXYNOS_DBG
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/3] scsi: ufs: Introduce callback to capture command completion information
      https://git.kernel.org/mkp/scsi/c/679d4ca6c93f
[2/3] scsi: ufs: exynos: Introduce command history
      https://git.kernel.org/mkp/scsi/c/c3b5e96ef515
[3/3] scsi: ufs: exynos: Implement dbg_register_dump
      https://git.kernel.org/mkp/scsi/c/957ee40d413b

-- 
Martin K. Petersen	Oracle Linux Engineering
