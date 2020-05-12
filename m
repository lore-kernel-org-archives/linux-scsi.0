Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29B6C54E8B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F16F20674
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NDNT41ab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgELD2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:28:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgELD2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:28:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3N1U3130524;
        Tue, 12 May 2020 03:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=EvhwvSUMvUb7X/M6iVF7L84Qav9leBAoaFDl0rRegxc=;
 b=NDNT41abgOxhRsAULc5g2j8oxTQlR7cK864x0S6aBjjoK0s6fH2d0NLWu0e5gIMkSJuL
 6TQtgOp7xLLUjJRkhbArUVlsSYLiwsaqhQe5dnJo4oCsmuBVBX8nLVGYn7sTJdeQS8KP
 2eIdDGahSkgH7XV4jbglTTkvcuJfPUHEXM8j8qbHMedYXGhMAb+fkdcM80gYCAZ1l5vc
 jGc69e+LETywGK0U/LjF0Lf7Dk09S5MA7a1OHfX9GwpWBM7MFXg+xgMKanU3yxp1cEHt
 8a5NQSDaieXF5GKGVDTM3t6iq1A9aGLiGrE1Ntf0Pn0RGnY0gjShF8sdmice+uiJR83v Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30x3gsggnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:28:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3PDsR095766;
        Tue, 12 May 2020 03:28:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 30x69s9rwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:28:41 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04C3Sev2007114;
        Tue, 12 May 2020 03:28:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 20:28:38 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH 0/8] zfcp: fix DIF/DIX support with scsi-mq host-wide tag-set
Date:   Mon, 11 May 2020 23:28:26 -0400
Message-Id: <158925392374.17325.3358760553480361613.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1588956679.git.bblock@linux.ibm.com>
References: <cover.1588956679.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1011 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 May 2020 19:23:27 +0200, Benjamin Block wrote:

> some time ago we noticed - Fedor did - that our DIV and DIX support in
> zfcp broke at some point. I tracked that down to a commit made for v5.4
> (737eb78e82d5), but we didn't notice it back than, because our CI
> doesn't currently run with either DIV, nor DIX enabled (time allowing
> this is something we want to improve so we catch stuff like this
> earlier). It also turned out that the commit in v5.4 was not really the
> root-cause, and was only making the problem visible more easy.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/8] scsi: zfcp: Move shost modification after QDIO (re-)open into fenced function
      https://git.kernel.org/mkp/scsi/c/978857c7e367
[2/8] scsi: zfcp: Move shost updates during xconfig data handling into fenced function
      https://git.kernel.org/mkp/scsi/c/bd1684817d7d
[3/8] scsi: zfcp: Move fc_host updates during xport data handling into fenced function
      https://git.kernel.org/mkp/scsi/c/52e61fde5ec9
[4/8] scsi: zfcp: Fence fc_host updates during link-down handling
      https://git.kernel.org/mkp/scsi/c/990486f3a850
[5/8] scsi: zfcp: Move p-t-p port allocation to after xport data
      https://git.kernel.org/mkp/scsi/c/ac007adc4d2d
[6/8] scsi: zfcp: Fence adapter status propagation for common statuses
      https://git.kernel.org/mkp/scsi/c/971f2abb4ca4
[7/8] scsi: zfcp: Fence early sysfs interfaces for accesses of shost objects
      https://git.kernel.org/mkp/scsi/c/71159b6ecb06
[8/8] scsi: zfcp: Move allocation of the shost object to after xconf- and xport-data
      https://git.kernel.org/mkp/scsi/c/d0dff2ac98dd

-- 
Martin K. Petersen	Oracle Linux Engineering
