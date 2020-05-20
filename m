Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E660FC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F392075F
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 02:32:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dGm5fEaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgETCc1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 22:32:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34898 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbgETCc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 22:32:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2Vs2o033096;
        Wed, 20 May 2020 02:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=X6vv7tWVQrBAO4K18SYCEFYN7GEzDFVuXe+yt1Qayfo=;
 b=dGm5fEaF7VynVI4gpxVMff3uxrEe+MFEF6j3wkkY7r9yWIR8X9NxKtPNtHJkm7eqadk0
 aQsyLcWryfMDzZ2/qBdMnZ72qskcwcDGCXT0G0OD+xlZ2V87ZvkepxEymbIaxG2/2Iex
 2ZZsbZSqhxkhpkJF88a0C5D0T0MfE2YZVf+m7P6C/LZSd4s4/JL7oaxVg8umJQIJH+PT
 Bw3ixWJGxkrlfmRY74elfPCkH8GW1NafZSqmr5FoARoY3FurwXBwcHVvOseDxvw+gVCr
 JEjNpZBfDerVK+LkJz0pIuKIOD56Gd/DLsjWO2PD7qPpmX1pneLgZgqGE9lRQpONTnjl 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284m0md8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 02:32:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K2SZJU064497;
        Wed, 20 May 2020 02:30:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 313gj2mf5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 02:30:19 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04K2UIWC028013;
        Wed, 20 May 2020 02:30:18 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 19:30:18 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.vnet.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] hisi_sas: Some misc patches
Date:   Tue, 19 May 2020 22:30:06 -0400
Message-Id: <158994171817.20861.14065822562297716117.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1589552025-165012-1-git-send-email-john.garry@huawei.com>
References: <1589552025-165012-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 May 2020 22:13:41 +0800, John Garry wrote:

> This series includes some misc patches, generally tidy-up. The most
> significant is the patch to not reset the phy up timer for when the
> phy is already up - the HW designers do not have an answer for why this
> occurs, so we workaround.
> 
> John Garry (1):
>   scsi: hisi_sas: Stop returning error code from slot_complete_vX_hw()
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/4] scsi: hisi_sas: Do not reset phy timer to wait for stray phy up
      https://git.kernel.org/mkp/scsi/c/e16b9ed61e07
[2/4] scsi: hisi_sas: Modify the commit information for DSM method
      https://git.kernel.org/mkp/scsi/c/1e954d1f002d
[3/4] scsi: hisi_sas: Add SAS_RAS_INTR0 to debugfs register name list
      https://git.kernel.org/mkp/scsi/c/1a0efb55b2bb
[4/4] scsi: hisi_sas: Stop returning error code from slot_complete_vX_hw()
      https://git.kernel.org/mkp/scsi/c/1cdee0044261

-- 
Martin K. Petersen	Oracle Linux Engineering
