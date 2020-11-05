Return-Path: <SRS0=zqxZ=EL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E87C388F9
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 04:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CD9720795
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Nov 2020 04:21:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pqWnFrjc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgKEEVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 23:21:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58826 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgKEEVz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 23:21:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A54K20t146391;
        Thu, 5 Nov 2020 04:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=xd9c8oQl95kc6kHWZbW3G6Q5b8JLutLP7OHMPXIx1ew=;
 b=pqWnFrjc1cIWcHRwdMsUPk+3cKRbhp0XkRAofkcbwhipS9FYcGpw5WNVPO8coNKf/MeV
 vECud+ZINB2ASW8gYwZcqm30Tpb1QQwS46LMqdwdrSE3Iudq+IHCsJWEFESDRYsu9Pi7
 mBCbD7uUrA/kmcNktiyTvAfWvBcmn4p0zxJxJSvxWIFZO/ytC002GgE7bjcqQNZV7ZZN
 +uPO5+qhjyJC9SQc7Vw3d+/ozmjXZEyY+Z0+U4yr9y4bbA6IG0qiHaG3EN3keeTFAOvO
 EgS2mY3PEdgeq4xxMXFychN19LA7rpIdxBTmdiVvlpO6NbgN+18QCob76pjcL9zS5rl9 aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34hhvchy9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 05 Nov 2020 04:21:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A54Kkaw020885;
        Thu, 5 Nov 2020 04:21:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34hw0m0e66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Nov 2020 04:21:52 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A54Lpre031185;
        Thu, 5 Nov 2020 04:21:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Nov 2020 20:21:51 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-s390@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 0/5] zfcp: cleanups, refactorings and features for 5.11
Date:   Wed,  4 Nov 2020 23:21:46 -0500
Message-Id: <160455005256.26277.4237038702456087390.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1603908167.git.bblock@linux.ibm.com>
References: <cover.1603908167.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011050030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9795 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 28 Oct 2020 19:30:47 +0100, Benjamin Block wrote:

> here is a series of changes for our zfcp driver for 5.11.
> 
> Other than 2 smaller cleanups and clarifications for maintainability we
> have a refactoring of how zfcp uses s390's qdio layer, and we have a
> small feature improving our handling of out-of-band version changes to our
> adapters (or firmware).
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/5] scsi: zfcp: Lift Input Queue tasklet from qdio
      https://git.kernel.org/mkp/scsi/c/0b524abc2dd1
[2/5] scsi: zfcp: Remove orphaned function declarations
      https://git.kernel.org/mkp/scsi/c/84e7b4169f94
[3/5] scsi: zfcp: Clarify & assert the stat_lock locking in zfcp_qdio_send()
      https://git.kernel.org/mkp/scsi/c/efd321768d2e
[4/5] scsi: zfcp: Process Version Change events
      https://git.kernel.org/mkp/scsi/c/a6c37abe6988
[5/5] scsi: zfcp: Handle event-lost notification for Version Change events
      https://git.kernel.org/mkp/scsi/c/d90196317484

-- 
Martin K. Petersen	Oracle Linux Engineering
