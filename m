Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287A1C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0179D2075F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 02:13:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="skmxi2a/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgE0CNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 22:13:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgE0CNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2020 22:13:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R2C7Ep164703;
        Wed, 27 May 2020 02:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=iJ0FxeYAoW6XWzps/AW7nNE2tfx+F1GWnBhPxVZz7Sc=;
 b=skmxi2a/lyGfFnAY5Sqm3b6LBUGzw7hK4Sjn7XyqeVKJgK12UtPSPB18AW66e3vM2S2Y
 4lVh+0IZv7lLUf1Wrb4+nqZ4hyXgELPR6C4ZWsRkLSQxo5vOdAhqC4S8gpf3XBb8eDq0
 tRzPtRgJ74nPTUzcV58mU9z4OUkp6PqM3pcVErdMCHRlno15kgZcfXiUHn4Tlx8u33Qe
 QkPmIU30cy7mEhdDyVVq44uU06HapCvo15VCnK6noUmxZ1CzyiLCFX+61HZyGbxXT+7j
 HmD0RurmsJ7IKWjyxgOaSuOmY6LdeGuWy5BMA0MXWOkK+mx9gvr466REjZIAPWcQZlIn 6g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 318xe1cxv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 02:13:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R27XKe133177;
        Wed, 27 May 2020 02:13:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 317j5q903p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 02:13:11 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04R2DAf8024044;
        Wed, 27 May 2020 02:13:10 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 19:13:10 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] qla2xxx: Remove return value from qla_nvme_ls()
Date:   Tue, 26 May 2020 22:12:56 -0400
Message-Id: <159054550934.12032.4167882456247793442.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520130819.90625-1-dwagner@suse.de>
References: <20200520130819.90625-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=772 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=807
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270013
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 May 2020 15:08:19 +0200, Daniel Wagner wrote:

> The function always returns QLA_SUCCESS and the caller
> qla2x00_start_sp() doesn't even evalute the return value. So there is
> no point in returning a status.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Remove return value from qla_nvme_ls()
      https://git.kernel.org/mkp/scsi/c/ac988c49367a

-- 
Martin K. Petersen	Oracle Linux Engineering
