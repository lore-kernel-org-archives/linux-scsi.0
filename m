Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E151AC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiGNEWW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGNEWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A22252A8
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 21:22:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3nC89031560;
        Thu, 14 Jul 2022 04:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=rzKE6GWt94Bmit/WPJoRO+nylXzjq8pk7j/fuzD7uA8=;
 b=nHPdjtXS/0T8ij1EC0JiBISBdnK822C375X0v6ek+Rr182AfNzJJJHqfshXbE5ZfKAf9
 SSOXWkq99ahH4tPfiJzDuiBUcDxYWpy4HVrhDQ7OiDtGTirkwUSs6uX4RpzFli42bmoZ
 W8ew4gVNYZx+RCgX2Y4uxgmps9lHoRTB1oBHk/SaA+aQmoxvw70wGwJyQn/KDNeMDcbj
 Qy5RDUkUp6StN51JeS4Vo20LMpehZE4TGkajb0DEXdhSK24bCStmbtayeHWkwpb8HAtt
 VeHLfPLG3QPLsdm9s0A2rypUVSF1HmTz2R7W/5gjIvpgRBdUNf3nSCMpZZwQ4GmrZ32r 2w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71r1bjds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4Av2U001056;
        Thu, 14 Jul 2022 04:22:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045au2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:15 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MD5H024736;
        Thu, 14 Jul 2022 04:22:15 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045au20-3;
        Thu, 14 Jul 2022 04:22:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Changyuan Lyu <changyuanl@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Set stopped phy's linkrate to Disabled
Date:   Thu, 14 Jul 2022 00:22:10 -0400
Message-Id: <165777180153.4401.5558040550265717186.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708205026.969161-1-changyuanl@google.com>
References: <20220708205026.969161-1-changyuanl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: FF-b6rLTtdoeWtdL1Mgr7-_hNSEcOx2I
X-Proofpoint-GUID: FF-b6rLTtdoeWtdL1Mgr7-_hNSEcOx2I
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 Jul 2022 13:50:26 -0700, Changyuan Lyu wrote:

> Negotiated link rate needs to be updated to Disabled when phy is
> stopped.
> 
> 

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: pm80xx: Set stopped phy's linkrate to Disabled
      https://git.kernel.org/mkp/scsi/c/355bf2e036c9

-- 
Martin K. Petersen	Oracle Linux Engineering
