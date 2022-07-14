Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771C7C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiGNEWy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiGNEWj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DCA27CD3;
        Wed, 13 Jul 2022 21:22:38 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3n7PI031506;
        Thu, 14 Jul 2022 04:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=zkR1kfQCLFVIGjreMssTYk9ZCz2VifauAYtjvEEoxhU=;
 b=xDL1Udysl/gT1Fkk5fLhcAnljcMp5uoKDV5Li7WIAymWW6L4NeMTRwIaixUtaU3a9sL6
 7tBvanHV88BezhzAOghPWrBrzY73Ay/4Junq4T7RQJGQz21ik5j8NerDrwmR59IratFH
 qQc+dbSeh9f5Ln39fIosaF6lZ3vBbdVqPIc+LBfmJdjEY+1A+1FMxkBTyuqi2Chp8Ylk
 tZPDmPslUdhjPf9PjBOmT6aNPf97b9tjP4zCle5Rm2fCq5SXLEq4LgmcpHx4Uag4gRJp
 36rGdqy8xmIEpSPIGf2KbPNavWNZki1vyjCfOppI1PYNKaaDMp9g4y7Y3L/fx08b6Ap8 Mg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h727smbr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4Afkr039900;
        Thu, 14 Jul 2022 04:22:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MWBj023864;
        Thu, 14 Jul 2022 04:22:34 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnc-3;
        Thu, 14 Jul 2022 04:22:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Quinn Tran <qutran@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2] scsi: qla2xxx: scsi: qla2xxx: check correct variable in qla24xx_async_gffid()
Date:   Thu, 14 Jul 2022 00:22:23 -0400
Message-Id: <165777182481.7272.2984460212824899265.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <YrK1A/t3L6HKnswO@kili>
References: <YrK1A/t3L6HKnswO@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: S_SFgjHUiUTGIRRnfMLFyvf8Swgp9wAc
X-Proofpoint-GUID: S_SFgjHUiUTGIRRnfMLFyvf8Swgp9wAc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 22 Jun 2022 09:21:55 +0300, Dan Carpenter wrote:

> There is a copy and paste bug here.  It should check ".rsp" instead of
> ".req".  The error message is copy and pasted as well so update that too.
> 
> 

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: qla2xxx: scsi: qla2xxx: check correct variable in qla24xx_async_gffid()
      https://git.kernel.org/mkp/scsi/c/7c33e477bd88

-- 
Martin K. Petersen	Oracle Linux Engineering
