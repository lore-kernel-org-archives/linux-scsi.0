Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C942C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 181B8207DD
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 04:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="u0LxX/9F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgGVEdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 00:33:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39148 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgGVEdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 00:33:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4WJl3047566;
        Wed, 22 Jul 2020 04:33:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=J2fEzzNGUVzJ4ZbdlpTm+D50R4Q6CThWuywlJAkGQT4=;
 b=u0LxX/9FpvObub6LpDKIEcVYoXtxHjiBWMbGDdX6r2NTT2B149fFio8yhHnMYECoEKoh
 N/HEAzTeMhRhACrwd6Xfr7xhlbBugEiRODSXIJnyU/tSeKV/Y6HLXK58VleFLi+JeHWy
 MhBJeMnJ/ZUJb8CHUuKPRF7nGuFIV/B9YeG+WtYnlDkK0p5xv6QVO7Lq9+ZXuwbz9H9H
 8jCBYr6OJFD/xFwNnVc3WlZ+Ca4/cjXLAMqqbDufWkXCIvS1SRa+pG/Eh6se630v8mIQ
 kv11u5ybGsOrnDl4j2IbHVFUqE/3vcYTgaq5f6VGUU4mfGGCRBoHW8iRed1Q4Cm00iON wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6ksn2g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 04:33:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4S20q028410;
        Wed, 22 Jul 2020 04:33:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32eberxcyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 04:33:38 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06M4SY3N017326;
        Wed, 22 Jul 2020 04:28:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 21:28:34 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aic79xx: restore modes when exiting ahd_linux_queue_abort_cmd()
Date:   Wed, 22 Jul 2020 00:28:30 -0400
Message-Id: <159539205429.31352.15820894947015700995.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714160301.4482-1-hare@suse.de>
References: <20200714160301.4482-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=809 mlxscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=832 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020 18:03:01 +0200, Hannes Reinecke wrote:

> ahd_linux_queue_abort_cmd() calls ahd_save_modes() without calling
> ahd_restore_modes() before exiting.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: aic79xx: Restore modes when exiting ahd_linux_queue_abort_cmd()
      https://git.kernel.org/mkp/scsi/c/6422e3c3b521

-- 
Martin K. Petersen	Oracle Linux Engineering
