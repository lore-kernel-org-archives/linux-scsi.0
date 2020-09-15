Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89063C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E2720872
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LPvho3pW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgIOWJe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:09:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38750 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727813AbgIOUSq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 16:18:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FK9x5Z029965;
        Tue, 15 Sep 2020 20:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=J0f88TJ3MzuRKzgrTsYuX79FV3NFRBLaRMSD7V87SeU=;
 b=LPvho3pW6Id2HkxvMLHY7wqwvFk/he0l9L2+Sdj+ffIjIUgHeGCmdANuIhzxIC7iJWI0
 ZurDjaBWwWJe7FVeakPesjMS3BHCqzL4AlfZOj2w/aiRL0fJm/Tb3XIDLg6GsGC7dDdM
 VHivKLITBlSR3MiutQ/kx2/RbE+pTIxHkCBZqcy3/6cZdAPqRSoxieN02sHF856xoMuU
 QxZBEfTndP7yAt+TsyJ9RhwDutguqqnHZdOWyYX0GokIgiP7AYzeCTX8eHiX9Cwyz6io
 Gznxj5BC2jZj4lQaAx7wGab6RZAFzEKhYUPK5F8x2zHynS7VMLJW1XzfcHy4ccOeJvbO cQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 33gnrqyebt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 20:18:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FKFvck127273;
        Tue, 15 Sep 2020 20:16:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33h7wppqed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 20:16:39 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FKGdtY006667;
        Tue, 15 Sep 2020 20:16:39 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 20:16:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/8] qedf: Misc fixes for the driver.
Date:   Tue, 15 Sep 2020 16:16:24 -0400
Message-Id: <160020074002.8134.14134333892194634729.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907121443.5150-1-jhasan@marvell.com>
References: <20200907121443.5150-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150157
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Sep 2020 05:14:35 -0700, Javed Hasan wrote:

> This series has misc bug fixes and code enhancements.
> 
> Kindly apply this series to scsi-queue at your earliest convenience.
> 
> Thanks,
> ~Javed
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/8] scsi: qedf: Change the debug parameter permission to read & write
      https://git.kernel.org/mkp/scsi/c/066664645d9a
[2/8] scsi: qedf: Correct the comment in qedf_initiate_els
      https://git.kernel.org/mkp/scsi/c/31fc82d7fbd8
[3/8] scsi: qedf: Fix for the session’s E_D_TOV value
      https://git.kernel.org/mkp/scsi/c/f78f8126264b
[4/8] scsi: qedf: FDMI attributes correction
      https://git.kernel.org/mkp/scsi/c/41715c6292b6
[5/8] scsi: qedf: Return SUCCESS if stale rport is encountered
      https://git.kernel.org/mkp/scsi/c/10aff62fab26
[6/8] scsi: qedf: Add schedule_hw_err_handler callback for fan failure
      https://git.kernel.org/mkp/scsi/c/55e049910e08
[7/8] scsi: qedf: Retry qed->probe during recovery
      https://git.kernel.org/mkp/scsi/c/988100a7de0f

-- 
Martin K. Petersen	Oracle Linux Engineering
