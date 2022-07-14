Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C183EC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 04:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiGNEW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 00:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiGNEWl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 00:22:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CEA27B23
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 21:22:40 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26E3n4VB000305;
        Thu, 14 Jul 2022 04:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=0NKKPHeoWxavl6Qhunb3yW0ek09dXtWGUsfk8eUqFOg=;
 b=ismLSbusz10V/T4gfH3eVzwEIW14Y09fkcQUoksLQLT/x8i5CDGs5OGrSQ7nKI4WxVzM
 ZJKZIVwv4FM3kGO9N6miJIEREvwGoM8rchNfwTS/CiqoQ7na1dbnNcDA12FaZiEjKRAp
 TWT8yDcBgVIklAR1clPvB8+zCDN9I9rns0X8ylmp2rc1laUmP5/iOFpk1QQn30vEPjAo
 KR0/PSmHoOQM1dAlv//yA0li7w7tTVhYB8kOF3XkXHYNBBZ6+K29UDr/CQpDy06sURi0
 mQs64b7y9KMZF0slm9XDPS0aNboC3TfFM+om6VhFU9zdoSS2YyJy2fkbNml4BTUC0sPQ 1Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71sgubx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26E4Aop6040444;
        Thu, 14 Jul 2022 04:22:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 04:22:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 26E4MWBh023864;
        Thu, 14 Jul 2022 04:22:33 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h70451jnc-2;
        Thu, 14 Jul 2022 04:22:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v2 0/2] Reduce ATA disk resume time
Date:   Thu, 14 Jul 2022 00:22:22 -0400
Message-Id: <165777182483.7272.8448048942289944785.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630195703.10155-1-bvanassche@acm.org>
References: <20220630195703.10155-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: BfsN40y6iFdR99r-cUwnQNfXOJYMTuzc
X-Proofpoint-ORIG-GUID: BfsN40y6iFdR99r-cUwnQNfXOJYMTuzc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 30 Jun 2022 12:57:01 -0700, Bart Van Assche wrote:

> Recently it was reported that patch "scsi: core: pm: Rely on the device driver
> core for async power management" causes resuming to take longer if an ATA disk
> is present. This patch series fixes that regression. Please consider this
> patch series for kernel v5.20.
> 
> Thanks,
> 
> [...]

Applied to 5.20/scsi-queue, thanks!

[1/2] scsi: core: Move the definition of SCSI_QUEUE_DELAY
      https://git.kernel.org/mkp/scsi/c/90552cd2d1f9
[2/2] scsi: sd: Rework asynchronous resume support
      https://git.kernel.org/mkp/scsi/c/88f1669019bd

-- 
Martin K. Petersen	Oracle Linux Engineering
