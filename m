Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB78C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 226DA23B51
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbgLIRYs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:24:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53338 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732200AbgLIRYe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:24:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HJwqh078310;
        Wed, 9 Dec 2020 17:23:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=5Zx6gGYBv1twjEiZEeKE229v8R8lxWyd3YNzIzSTGe8=;
 b=o/Z8E/8SIokqQNm3FpLY5FJGw7p2FGzO0fuhkvfNKGHo5PNjeU02Z2D9khoYXnP7Kzo5
 L2djXwmomP8h0EDpLtm20KKHKSFy8qseWEc85i/QdHLca6SkmQV8yHf6jTL8BHKYlAWk
 BO942WWATQh6JUFVFXO/nbJwqJ65Kxd1VXk/SreNTXrvd1O88/gq2swMuywGxD/EIPeH
 bGLjOoaVxbo/at+OnCrQk+LeznE3bKeYofSTi2KeCz04LJ+UwCFjGXplwOoOWgK6rJ0Z
 b6HGwmSX/Ybl2xZDnOgH1MJvSwBHxGic4C23V8h4y2PIyI1IAQiVxf8SkerFXaKGzoV9 ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3581mr1a3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 17:23:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9HKqhf099961;
        Wed, 9 Dec 2020 17:23:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 358ksqdjms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 17:23:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B9HNUEM017666;
        Wed, 9 Dec 2020 17:23:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 09:23:29 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        clang-built-linux@googlegroups.com, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] ufshcd: fix Wsometimes-uninitialized warning
Date:   Wed,  9 Dec 2020 12:23:14 -0500
Message-Id: <160753457755.14816.4979467058172336849.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203223137.1205933-1-arnd@kernel.org>
References: <20201203223137.1205933-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9829 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090122
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Dec 2020 23:31:26 +0100, Arnd Bergmann wrote:

> clang complains about a possible code path in which a variable is
> used without an initialization:
> 
> drivers/scsi/ufs/ufshcd.c:7690:3: error: variable 'sdp' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>                 BUG_ON(1);
>                 ^~~~~~~~~
> include/asm-generic/bug.h:63:36: note: expanded from macro 'BUG_ON'
>  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
>                                    ^~~~~~~~~~~~~~~~~~~
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/1] ufshcd: fix Wsometimes-uninitialized warning
      https://git.kernel.org/mkp/scsi/c/4c60244dc372

-- 
Martin K. Petersen	Oracle Linux Engineering
