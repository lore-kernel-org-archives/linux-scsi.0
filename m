Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7256BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 18:11:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbiEXSLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 14:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbiEXSLv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 14:11:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDC35DD11
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 11:11:49 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHnHEO015364;
        Tue, 24 May 2022 18:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=ml3aoLMLfeakAZ5ZL+XyqeHFnaHvUrHjT2MIUkKUshc=;
 b=wSe1Zmx8UwOq2rortLxokp0HKoANzvkFsgRBZc3hdxVDrXfETa1DcYXXzO2tRelUUvJv
 3qaXHh8fUN/njS2InITZUZKlPFL6gAzQc0zVkRpF9olckdtMX3YnfpI3vLTNJCQhHThV
 PSJzztGJevPPjboVBO+3QSi4YzMyJ9/P/QGjnQfWP48XjxbJtkdAwH1UmyHTeqLWgiYM
 w8Dae2rdVJDlTEYTG6nOGiJNsc0DEPlNyCgmJjV0Aiy37E99aC9W6kMpJyrA/6EmDz49
 Jd2YgM7xg/sBrzSSgf+eCa52jcyqQLPBhSnWe7CgIzEnRFyUAizU7uoadjDyAi5eiBLv 9w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tc03uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHwST4040245;
        Tue, 24 May 2022 18:11:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:11:44 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24OIAvmw039045;
        Tue, 24 May 2022 18:11:44 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x50s3r-3;
        Tue, 24 May 2022 18:11:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: unexport scsi_bus_type
Date:   Tue, 24 May 2022 14:11:35 -0400
Message-Id: <165341587531.22286.15920133859186970723.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220523083838.227987-1-hch@lst.de>
References: <20220523083838.227987-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: HhZ1jaocBuoV5FvVtOeaYQl2nsdP8sD-
X-Proofpoint-GUID: HhZ1jaocBuoV5FvVtOeaYQl2nsdP8sD-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 23 May 2022 10:38:38 +0200, Christoph Hellwig wrote:

> scsi_bus_type is not used by any code outside of scsi_mod.ko.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: unexport scsi_bus_type
      https://git.kernel.org/mkp/scsi/c/7ad36c8b2b80

-- 
Martin K. Petersen	Oracle Linux Engineering
