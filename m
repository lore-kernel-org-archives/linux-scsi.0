Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D329C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Mar 2022 03:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242027AbiCSD6u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 23:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241978AbiCSD6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 23:58:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179F7103B81;
        Fri, 18 Mar 2022 20:57:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22J1VWwc017377;
        Sat, 19 Mar 2022 03:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=UbUn62tq/Iut1ObrszGLQAMYQYwL5SE5SVUJLY86U00=;
 b=d8Sj1Ikn0IAlWtwfE/mj5pqvYadR9dZDaxkWWu/VWmaLd6W5R0ABTRzVo5ouJuy/N901
 lpyMousM/Ezsd50jz4N++Yzna79Z4zwsfRIOVyDJNArS8vt4vVgzeVySlh3+Gc/pWnhi
 yqxEfL77mdgay8w4MVTW26C9yAFIdGSK4hYI7+AKISQYrSFWhIZNALx99DYCirYeQPKf
 PnbSFAAa53aQ/GDgTcrVJDMxFfQKaZqtunjbaf1fEhZ9rns9Z6qj1ufNNx+H0os2roY4
 JPX88OQdHhArZhx9Q2lu+vqv9F8xCcy/PB+QW6WnIfsFVLca5wCIRDvE/x6+dhHyEI4O 4Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcg2m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22J3v9RT007209;
        Sat, 19 Mar 2022 03:57:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Mar 2022 03:57:17 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22J3v5Qs007126;
        Sat, 19 Mar 2022 03:57:17 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ew5kyshmn-9;
        Sat, 19 Mar 2022 03:57:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_ioctl:drop needless assignment in sg_io()
Date:   Fri, 18 Mar 2022 23:56:59 -0400
Message-Id: <164766213032.31329.16003266228300460404.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220315061520.30745-1-lukas.bulwahn@gmail.com>
References: <20220315061520.30745-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 4ohGNjZjhqOEO8sF--M4NmcGx3J8t6es
X-Proofpoint-ORIG-GUID: 4ohGNjZjhqOEO8sF--M4NmcGx3J8t6es
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Mar 2022 07:15:20 +0100, Lukas Bulwahn wrote:

> Commit ce70fd9a551a ("scsi: core: Remove the cmd field from struct
> scsi_request") refactored sg_io(), so that it does not allocate directly
> and hence does not return -ENOMEM in its error case. That makes a
> remaining assignment of -ENOMEM to the return variable needless.
> 
> Drop this needless assignment in sg_io().
> 
> [...]

Applied to 5.18/scsi-queue, thanks!

[1/1] scsi: scsi_ioctl:drop needless assignment in sg_io()
      https://git.kernel.org/mkp/scsi/c/66daf3e6b993

-- 
Martin K. Petersen	Oracle Linux Engineering
