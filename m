Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D10C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 02:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356138AbiFVCKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 22:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348547AbiFVCKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 22:10:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A12338AD
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 19:10:23 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M0IirI002236;
        Wed, 22 Jun 2022 02:10:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=3Fiq1vRqw+R8nBcOgL+jNDuPPiPvrFpDJkjcoL2Zo6M=;
 b=Hw4mzsAMZ/rHQQ+XpgsEwFqEt2tZDEWyC2LcMceAzJfk4mrdBMNJOemW0cWnu/eANmC1
 5D2o69xIChaDBBYjITTKVa2z+HTRbp7eEp24afIyV3vBVD4+ycB6MXCxzIUMefL7t/4V
 Zy6Ex/gB6hfq1R0oummxYuJjBuhOeT0iD2WHSYLekFoSSQ1tPyhW41ssRiN2Xu6Le+pg
 E9xYUVkWld68yGmNdbRhoAz8xZFW6LnezH9dOk99FlTRjxRUKSW5//Zm1ZqgIVRtAepG
 D8SgmtDnf0umJOIshekdUR9yL7q6ju9ldmWd9KdIV1SSRdS91fFe+e45Ik2mQNJXwB7o 5A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5a0f6wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 02:10:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25M26Xqm037995;
        Wed, 22 Jun 2022 02:10:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9usx44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 02:10:19 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 25M29Bis002724;
        Wed, 22 Jun 2022 02:10:19 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9usx36-4;
        Wed, 22 Jun 2022 02:10:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        michael.christie@oracle.com
Subject: Re: [PATCH 1/1] scsi: iscsi: Make iscsi_unregister_transport() return void
Date:   Tue, 21 Jun 2022 22:10:14 -0400
Message-Id: <165586371838.21830.15026183541893648928.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220616080210.18531-1-mgurtovoy@nvidia.com>
References: <20220616080210.18531-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: aHa4Acpbxv0LO9dj9S3L8NgeH8eFqZsH
X-Proofpoint-GUID: aHa4Acpbxv0LO9dj9S3L8NgeH8eFqZsH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Jun 2022 11:02:10 +0300, Max Gurtovoy wrote:

> This function always returns 0. We can make it return void to simplify
> the code. Also, no caller ever checks the return value of this function.
> 
> 

Applied to 5.20/scsi-queue, thanks!

[1/1] scsi: iscsi: Make iscsi_unregister_transport() return void
      https://git.kernel.org/mkp/scsi/c/6a33ed506416

-- 
Martin K. Petersen	Oracle Linux Engineering
