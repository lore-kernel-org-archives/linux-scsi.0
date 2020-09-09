Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91543C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B4A20936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZGkZ8nYr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgIICKD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:10:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41708 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729691AbgIICJ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08920mvP087228;
        Wed, 9 Sep 2020 02:09:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6NgdItGifg263VtiVoj0X7HUu+IzTiOvKxXduWy2avU=;
 b=ZGkZ8nYrv771sNkTZOxvlKfx2jeSAKMAFzjqmMgBwk8yh5+dbO/S3So1AU5QqbI9Kh6c
 o1ekcf2kOYR7nzJjSvq3O+I/ENOKHm8Wv4iQznwvmUw9XGkDF/WhupzThJw+OQ4jXWE5
 fDmM9ar2zfPdTBxUtwFAbaEv1febQSoR2QdWpLO6CLrUyfi4gzTvTeABE+y2G8IaZ3VY
 b4+QGXC++Ho43ZnmBAyREyrJh9PKP5aAmvDjYstYByIEOzmvZlCeUMxVyxegnAgK1QUL
 dNHybtb7JPg+zjyYYHQWmDWQyMh/x3t7/Ep+b73/dqi29OF54Gyiv3SPbkRZjwFryJ/z QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33c2mkxvn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089252dV095279;
        Wed, 9 Sep 2020 02:09:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33cmk53f50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:47 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08929j1N022869;
        Wed, 9 Sep 2020 02:09:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:45 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     MPT-FusionLinux.pdl@broadcom.com, sathya.prakash@broadcom.com,
        sreekanth.reddy@broadcom.com, Jason Yan <yanaijie@huawei.com>,
        suganath-prabu.subramani@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: mptscsih: remove set but not used 'timeleft'
Date:   Tue,  8 Sep 2020 22:09:23 -0400
Message-Id: <159961731706.5787.1390939746459393484.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827125925.428357-1-yanaijie@huawei.com>
References: <20200827125925.428357-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=980 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1011 mlxlogscore=987
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 27 Aug 2020 20:59:25 +0800, Jason Yan wrote:

> This addresses the following gcc warning with "make W=1":
> 
> drivers/message/fusion/mptscsih.c: In function ‘mptscsih_IssueTaskMgmt’:
> drivers/message/fusion/mptscsih.c:1519:17: warning: variable ‘timeleft’
> set but not used [-Wunused-but-set-variable]
>  1519 |  unsigned long  timeleft;
>       |                 ^~~~~~~~

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: mptscsih: Remove set but not used 'timeleft'
      https://git.kernel.org/mkp/scsi/c/bef7afbf3bb6

-- 
Martin K. Petersen	Oracle Linux Engineering
