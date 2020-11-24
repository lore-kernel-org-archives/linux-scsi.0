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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25080C63777
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE47520866
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 03:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CEveVv48"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgKXD6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 22:58:30 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:50652 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgKXD63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2020 22:58:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3sciU090554;
        Tue, 24 Nov 2020 03:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3LBksb9nF957DUMKcEjLnwa75EJQyqUQQQph/qW9HT0=;
 b=CEveVv48Z/Xqe8ZszSWWjk2RjBse1EqCCOuy6HaZ8UZsK0xy3afDLSlfKvBpb8wWbmWZ
 dYhF4gK4BEXGWrQzBHaPGZrHmoQXWu48Q/rDhDtG2boAhTDRH2wkp9Fyq8yiGgb81Lpt
 j1H9WQDRA+772vWnuCPhoaX5Lw0oMfMrHWJ/yQTQtILC2Y0SKSh9aAjm5SC7e/RFuA7D
 7sWX1j7kebTGpUiGoQAyjEOjmSyTidr7xDSgTPkqGw82lHODScfAZfm4lt8m2aH2HVRz
 0dJtd79bWuJ+bhJHdPxWHq4wDb4bk0wJY0CcbOdyhouKY3AkHXmSt/jrJduwLTDrJjhY kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34xrdarmc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Nov 2020 03:58:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AO3toIL080886;
        Tue, 24 Nov 2020 03:58:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ycnrw00c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 03:58:16 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AO3wE9P006116;
        Tue, 24 Nov 2020 03:58:14 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Nov 2020 19:58:14 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        avri.altman@wdc.com, cang@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, alim.akhtar@samsung.com
Subject: Re: [PATCH v5 0/5] scsi: ufs: add some fixes
Date:   Mon, 23 Nov 2020 22:58:02 -0500
Message-Id: <160618683551.24173.10657707378444596650.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117165839.1643377-1-jaegeuk@kernel.org>
References: <20201117165839.1643377-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9814 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
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

On Tue, 17 Nov 2020 08:58:32 -0800, Jaegeuk Kim wrote:

> Change log from v4:
>  - add more fixes
> 
> Change log from v3:
>  - use __ufshcd_release with a fix in __ufshcd_release
> 
> Change log from v2:
>  - use active_req-- instead of __ufshcd_release to avoid UFS timeout
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/7] scsi: ufs: Avoid to call REQ_CLKS_OFF to CLKS_OFF
      https://git.kernel.org/mkp/scsi/c/fd62de114f8c
[2/7] scsi: ufs: Atomic update for clkgating_enable
      https://git.kernel.org/mkp/scsi/c/b66451129764
[3/7] scsi: ufs: Clear UAC for FFU and RPMB LUNs
      https://git.kernel.org/mkp/scsi/c/4f3e900b6282
[4/7] scsi: ufs: Use WQ_HIGHPRI for gating work
      https://git.kernel.org/mkp/scsi/c/e93e6e49fa31
[5/7] scsi: ufs: Add more contexts in the ufs tracepoints
      https://git.kernel.org/mkp/scsi/c/69a314d6a155
[6/7] scsi: ufs: Fix clkgating on/off
      https://git.kernel.org/mkp/scsi/c/8eb456be75af
[7/7] scsi: ufs: Show LBA and length for UNMAP commands
      https://git.kernel.org/mkp/scsi/c/3754cde8df91

-- 
Martin K. Petersen	Oracle Linux Engineering
