Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600AEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 12:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349359AbiEDMQ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 08:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343788AbiEDMQ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 08:16:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFA52D1E4
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 05:13:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 242KZ9w4019152;
        Tue, 3 May 2022 00:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=7wFuGAxSW/QrlAvOS3Q7C147YQ9nYomTLWr/V383U4Q=;
 b=mN7DASbZdoro+lEMo+48pzfj+tiZWCWPLh6mLULq58+xKfshYERcUbp31I7FDTvQEsQ7
 L9UG32WXiePBn3M8liR4HPa3qgZCKBe5z6+CkwgdeKYNZpWdWeKnBYUomHs5nbSYZGoN
 7i08F/y8OcvdV1APZsQs2Xvd+N0RxswytPHraMz5NuolrJPi3YU/SmeA36Hvtn5D8y01
 dExl9IYZHfvtVi+3PPbuT2X0I5bhv8SmesbO/Pa92KeJgx/hVDpO8qrhW3dCMn6bRAqY
 Suy08WdjHfKZXe1gKEJnR/0c/vY7YzLHnQARi0dJTOGK3RAe3mdV4Oe3nWjtMgi+ErQU nA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0amhjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2430opCY008935;
        Tue, 3 May 2022 00:52:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83xaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 00:52:01 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2430pljk010389;
        Tue, 3 May 2022 00:52:00 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj83x4g-25;
        Tue, 03 May 2022 00:52:00 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: Re: [PATCH] lpfc: Fix resource leak in lpfc_sli4_send_seq_to_ulp()
Date:   Mon,  2 May 2022 20:51:35 -0400
Message-Id: <165153836364.24053.4974026632260068633.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220426181419.9154-1-jsmart2021@gmail.com>
References: <20220426181419.9154-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: kmRTLpQWxHqH8xUPJWCy-gKn6tNQjDcd
X-Proofpoint-ORIG-GUID: kmRTLpQWxHqH8xUPJWCy-gKn6tNQjDcd
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 26 Apr 2022 11:14:19 -0700, James Smart wrote:

> If no handler is found in lpfc_complete_unsol_iocb() to match the rctl
> of a received frame, the frame is dropped and resources are leaked.
> 
> Fix by returning resources when discarding an unhandled frame type.
> Update lpfc_fc_frame_check() handling of NOP basic link service.
> 
> 
> [...]

Applied to 5.19/scsi-queue, thanks!

[1/1] lpfc: Fix resource leak in lpfc_sli4_send_seq_to_ulp()
      https://git.kernel.org/mkp/scsi/c/646db1a560f4

-- 
Martin K. Petersen	Oracle Linux Engineering
