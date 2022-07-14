Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28800C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiGNEWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiGNEWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0958275EE
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 21:22:20 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3mtTM014131;
        Thu, 14 Jul 2022 04:22:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=4wRPUDoXNo8M0SX2j1KGLdX13reW0WRYayDBpjhYdTU=;
 b=HxWGM2gmIm/MRBXvBKAIjYVi3p2fPwqivTMvqOOkPMSSB4oL1qKKNvg50uA8h82p0Oq7
 EFnM18DYUN2mT7d9ItWXcEwHTmlfP/LiunwTfGvn1GwYR4YI47zw/ysaSjIJp79XABH7
 5TsXpNFP7CRm1LLqHFcxhM5EuQ7191F9N7w7Qutj26r60JkhgCwvFfpdvQo+7K/bwfqE
 lFZlANCBrEeHsDeJ9iTgtLyxgBWkP7qnSQpLbNQLiyuYXKmM/SoGbSsrq49+Tx2Moqd+
 JFA5VCJ0IXnM4xAXsxE8GMdPAoa7tqxF5HV9pMxV7e4CnErUKZ+uaqXL84DkrCKcmpCs 9g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71scc27n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:15 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4ApX4000925;
        Thu, 14 Jul 2022 04:22:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045au27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:14 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MD5F024736;
        Thu, 14 Jul 2022 04:22:14 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7045au20-2;
        Thu, 14 Jul 2022 04:22:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Changyuan Lyu <changyuanl@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix 'Unknown' max/min linkrate
Date:   Thu, 14 Jul 2022 00:22:09 -0400
Message-Id: <165777180152.4401.15711239373986599582.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707175210.528858-1-changyuanl@google.com>
References: <20220707175210.528858-1-changyuanl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: VoYtH5Q1ojpu_5RQD7SX3xobvlYDkW1b
X-Proofpoint-ORIG-GUID: VoYtH5Q1ojpu_5RQD7SX3xobvlYDkW1b
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 7 Jul 2022 10:52:10 -0700, Changyuan Lyu wrote:

> Currently, the dataflow of the max/min linkrate in the driver is
> * in pm8001_get_lrate_mode():
>   hardcoded value ==> struct sas_phy
> * in pm8001_bytes_dmaed():
>   struct pm8001_phy ==> struct sas_phy
> * in pm8001_phy_control():
>   libsas data ==> struct pm8001_phy
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: pm80xx: Fix 'Unknown' max/min linkrate
      https://git.kernel.org/mkp/scsi/c/e78276cadb66

-- 
Martin K. Petersen	Oracle Linux Engineering
