Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B51C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343697AbiDGNiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343700AbiDGNhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BDE2BCD
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237CIOms000849;
        Thu, 7 Apr 2022 13:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=9nCTYiLSYwu/rmvcx1gU/vvK5wgtcWkrK+BzqaOgLQc=;
 b=qel0ruWG2s9yZM4N9TwHGkyxuLLuHqc+osapCdURflhqmJm++EJQzlt3wTB0xymDQsvr
 SngfQi0e05DMx9gaipKRbFOcUvQwHP2wScgvynqRGhM3pskozQ477X80DcquWABHRWZv
 aWSdO9j2+5g2X9V5wC3axA3djwuWXhYNvUKeYWTU0GPJpH9ZsRM14lDDUxf1FAFzhH+j
 cdRDC7epA2VtFbBVDf5gzivbCqjLEsALEeeF1gzVTKayNj2uWQVSx/eSDqtxps/95Nsi
 kjwSCO19tgAKYwK2kAHlZ73+v3xlDWTGXIT22oxP+jpONAcAIgpdkceiV90sj/o6BDgc QQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3suw25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 13:35:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVBA036848;
        Thu, 7 Apr 2022 13:35:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 13:35:24 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJLs032479;
        Thu, 7 Apr 2022 13:35:24 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-7;
        Thu, 07 Apr 2022 13:35:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Wu Bo <wubo40@huawei.com>,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>, linfeilong@huawei.com
Subject: Re: [PATCH] scsi:libiscsi: remove unnecessary memset in iscsi_conn_setup
Date:   Thu,  7 Apr 2022 09:35:06 -0400
Message-Id: <164929678998.15424.5271215300515961574.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220317150116.194140-1-haowenchao@huawei.com>
References: <20220317150116.194140-1-haowenchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: hxL4SOCBlDTz5YGKTbhjaeQgR3PQElSH
X-Proofpoint-GUID: hxL4SOCBlDTz5YGKTbhjaeQgR3PQElSH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 17 Mar 2022 11:01:16 -0400, Wenchao Hao wrote:

> iscsi_cls_conn is alloced by kzalloc(), the whole iscsi_cls_conn is
> zero filled already including the dd_data. So it is unnecessary to
> call memset again.
> 
> 

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi:libiscsi: remove unnecessary memset in iscsi_conn_setup
      https://git.kernel.org/mkp/scsi/c/ebfe3e0c5e80

-- 
Martin K. Petersen	Oracle Linux Engineering
