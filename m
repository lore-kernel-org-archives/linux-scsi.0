Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6850C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 16:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353016AbiEDQXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 12:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353283AbiEDQXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 12:23:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6529246B13
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 09:19:40 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242KZ9w3019152;
        Tue, 3 May 2022 00:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=YUNQFmGyzV+g8ibxd2TeZcydDGJAM/fBmhc9kdz3WFY=;
 b=hmQm0Fe0PeSKzgVVsIu91qBLrLZ/eYVhsaJ2DFL1ysRMcHsnJhgSJ5slviXot4m7DE2G
 kr1Lqv32bmhRUhG5E+0o345saT3lhoqbuBdc1SOrOJexNEib7bMR4UwnSmofJXmG0Xv7
 TS7QxtOAnXdt6N3iZo0+Vh0Jc1O/lPNh4fbJdut+i8ssYlljXID8yiKiVX25jcv+sMzr
 rBIFYEv5E1CRXwM4ZYi5ebCUAtq7ISdw5lngPKudF+T2nICZTWzipfThkuhpsAjntk0J
 VP2HOZ3fEfSRYJ9r9CjFhW6ls2FT8gM61/q4qlaf0nLylWXr3NmRAdRpchmIvddq+hkF 5A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0amhjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430ow5M009155;
        Tue, 3 May 2022 00:51:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:51:58 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljY010389;
        Tue, 3 May 2022 00:51:57 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-19;
        Tue, 03 May 2022 00:51:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] qla2xxx: Remove free_sg command flag
Date:   Mon,  2 May 2022 20:51:29 -0400
Message-Id: <165153836357.24053.11452996733697072864.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <AS8PR10MB4952747D20B76DC8FE793CCA9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
References: <AS8PR10MB4952747D20B76DC8FE793CCA9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: lSLLjC1Px558Qby6demorZUuaMXSz8LY
X-Proofpoint-ORIG-GUID: lSLLjC1Px558Qby6demorZUuaMXSz8LY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 15 Apr 2022 12:42:24 +0000, Chesnokov Gleb wrote:

> The use of the free_sg command flag was dropped in 2c39b5ca2a8c
> ("qla2xxx: Remove SRR code"). Hence remove this flag and its check.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/2] qla2xxx: Remove free_sg command flag
      https://git.kernel.org/mkp/scsi/c/ad14649fc5ab

-- 
Martin K. Petersen	Oracle Linux Engineering
