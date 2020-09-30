Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46B0C4727F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E4120773
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 03:35:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PZBoDBBz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgI3DfB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 23:35:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49044 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgI3DfB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 23:35:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3OHSO146701;
        Wed, 30 Sep 2020 03:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=nwdbHmgLWvvvSaivGYNupTWh52vJVIMQ+DMoaxzCFgo=;
 b=PZBoDBBznFenOWok0JW0ixz94O6UXQw7oKr7TxebHOG69TGJhMqdyUnIeCuf+NidfkGK
 ie7l39cRrD93FrkTmLJwQ3xPpl5xz9MuJpsg7kZFrjftP+YZ3VGaSI5wJ6nOMEJXLcuS
 zwijCYNi4BKQC/652Xzfyovn1vQ9rq+nBeSVRdKdeNwv9HORSaRqYuhV+LjjBOhTs4bs
 rxzPsFVm9nklUEWG90YjDT6++HzjthR+pqNsnJHRsaUwAOuiXC9cdinvwlc3W9vaOpwp
 Zh4xOGqY7sXx1PAdvwdR754mU1l/MH8rMwY8Lk4hDSSBJb21yuou/4Ne9fnXOJSWHLQQ Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 33su5axc0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 03:34:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08U3QV7L064809;
        Wed, 30 Sep 2020 03:34:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33tfhygkx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 03:34:58 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08U3Yvml015336;
        Wed, 30 Sep 2020 03:34:57 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Sep 2020 20:34:57 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v3 00/13] qla2xxx misc features and bug fixes
Date:   Tue, 29 Sep 2020 23:34:50 -0400
Message-Id: <160143685413.27701.5625876922363046859.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904045128.23631-1-njavali@marvell.com>
References: <20200904045128.23631-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9759 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Sep 2020 21:51:15 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the attached miscellaneous qla2xxx features and bug fixes
> to the scsi tree at your earliest convenience.
> 
> v1->v2:
> Fix compilation error reported by kernel test robot
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[01/13] scsi: qla2xxx: Fix I/O failures during remote port toggle testing
        https://git.kernel.org/mkp/scsi/c/dd8d0bf6fb72
[02/13] scsi: qla2xxx: Setup debugfs entries for remote ports
        https://git.kernel.org/mkp/scsi/c/1e98fb0f9208
[03/13] scsi: qla2xxx: Allow dev_loss_tmo setting for FC-NVMe devices
        https://git.kernel.org/mkp/scsi/c/27c8aa5e1b06
[04/13] scsi: qla2xxx: Honor status qualifier in FCP_RSP per spec
        https://git.kernel.org/mkp/scsi/c/3aac0c0fde17
[05/13] scsi: qla2xxx: Reduce duplicate code in reporting speed
        https://git.kernel.org/mkp/scsi/c/d68930bae477
[06/13] scsi: qla2xxx: Fix memory size truncation
        https://git.kernel.org/mkp/scsi/c/d38cb849e17a
[07/13] scsi: qla2xxx: Performance tweak
        https://git.kernel.org/mkp/scsi/c/49db4d4e02aa
[08/13] scsi: qla2xxx: Fix I/O errors during LIP reset tests
        https://git.kernel.org/mkp/scsi/c/a35f87bdcc06
[09/13] scsi: qla2xxx: Make tgt_port_database available in initiator mode
        https://git.kernel.org/mkp/scsi/c/4e5a05d1ecd9
[10/13] scsi: qla2xxx: Add rport fields in debugfs
        https://git.kernel.org/mkp/scsi/c/6152d20fa670
[11/13] scsi: qla2xxx: Add IOCB resource tracking
        https://git.kernel.org/mkp/scsi/c/89c72f4245a8
[12/13] scsi: qla2xxx: Add SLER and PI control support
        https://git.kernel.org/mkp/scsi/c/cf3c54fb49a4
[13/13] scsi: qla2xxx: Update version to 10.02.00.102-k
        https://git.kernel.org/mkp/scsi/c/767c8457b729

-- 
Martin K. Petersen	Oracle Linux Engineering
