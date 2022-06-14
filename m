Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E92BC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jun 2022 04:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbiFNEBi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jun 2022 00:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiFNEBg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2022 00:01:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4B531392
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 21:01:36 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25E1N0tA025679;
        Tue, 14 Jun 2022 02:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=3q4C9k4PfL74O2k0U5tTCFm4wT0wnwufhiviu1lFK+c=;
 b=f/Icit+1mU/TVCntoRGmU9YuCH3Zl1EMq2aUtuIBHZhrIy5YYNmP7Obvj954BOHKmTfv
 RDnOGU08cZrOgJ97JtFT1y/88HKnYnJ+KfSJWSULfOrvJZowuiUqhJdKKpacLIiyZJPd
 Hs76GB+2zPy1gvrpjYTDsa4/DzfRMP6qRqMsI09ywepN32PzS04F5sheb65C74bpo+wg
 LkQR6gufAG6sYoYOgVb+Ziinde1WKCQvCVtrOYiKy/pxbJE7w10elYJz7gOH0P3TEqq/
 WkhC4OcRbNdjkfckHxgFnW6QjziWFfGlEn4xf7LmZjCN8lDA+1nG0yMqBYceZe5VcIeO wA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx9cgr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 02:23:08 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25E2M8Tl033579;
        Tue, 14 Jun 2022 02:23:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gphfy80ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 02:23:07 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25E2N6Fs034641;
        Tue, 14 Jun 2022 02:23:07 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gphfy80g2-2;
        Tue, 14 Jun 2022 02:23:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH 00/10] Additional EDiF bug fixes
Date:   Mon, 13 Jun 2022 22:23:01 -0400
Message-Id: <165517336591.25359.10933776483207057072.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: -jUFYKq21iy7kWvs-vspoLkv9ZzF9ctV
X-Proofpoint-GUID: -jUFYKq21iy7kWvs-vspoLkv9ZzF9ctV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 8 Jun 2022 04:58:39 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver additional EDiF bug fixes to the scsi
> tree at your earliest convenience.
> 
> Thanks,
> Nilesh
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[01/10] qla2xxx: edif: Fix IO timeout due to over subscription
        https://git.kernel.org/mkp/scsi/c/63ab6cb582fa
[02/10] qla2xxx: edif: send logo for unexpected IKE message
        https://git.kernel.org/mkp/scsi/c/2b659ed67a12
[03/10] qla2xxx: edif: reduce disruption due to multiple app start
        https://git.kernel.org/mkp/scsi/c/0dbfce5255fe
[04/10] qla2xxx: edif: fix no login after app start
        https://git.kernel.org/mkp/scsi/c/24c796098f53
[05/10] qla2xxx: edif: tear down session if keys has been removed
        https://git.kernel.org/mkp/scsi/c/d7e2e4a68fc0
[06/10] qla2xxx: edif: fix session thrash
        https://git.kernel.org/mkp/scsi/c/a8fdfb0b39c2
[07/10] qla2xxx: edif: Fix no logout on delete for n2n
        https://git.kernel.org/mkp/scsi/c/ec538eb838f3
[08/10] qla2xxx: edif: Reduce N2N thrashing at app_start time
        https://git.kernel.org/mkp/scsi/c/37be3f9d6993
[09/10] qla2xxx: edif: Fix slow session tear down
        https://git.kernel.org/mkp/scsi/c/bcf536072f74
[10/10] qla2xxx: Update version to 10.02.07.600-k
        https://git.kernel.org/mkp/scsi/c/0f4d7d556125

-- 
Martin K. Petersen	Oracle Linux Engineering
