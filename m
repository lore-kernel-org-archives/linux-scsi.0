Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0FDC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 05:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbiCOFwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 01:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbiCOFwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 01:52:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD4149F0D
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 22:50:52 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F3HflX008028;
        Tue, 15 Mar 2022 05:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=j4hzlWsFcNMzGk+Zbolw0xM5YnNJSYlIBF4t3D3GkyY=;
 b=GInvPIVm1qIAAgAuy7QqKoW6I7rM0M/Xf4zozMHjlFEX0c2EG5gloTqqv+lz1sJvJRtg
 dVs1bP8G83eGWS0OlzH1FZg7JqUXzhAor3MLvv3rHMnB0dD0bdQMWVC9UonRnwcs1yw5
 zBSa0ec+8b+fDhMVKjhxH79P1L901734pEYgVrZOU93VrzzcXsdXysTt0oAoF36+D7fW
 xOc7zB393XUeiZvTfOkgTDPD1KLXRMz8B/Lg/ncbodqyoTmcsPDoomBMCq9LSumbiQrR
 yp6Fkht4+GNTfvtB+Fe1ccfXtrZgDocSUk1jYjRV+BWWUBc/LVwgGNRjJTFyjvWNYFBZ iQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6j20j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:45 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 22F51KJH004914;
        Tue, 15 Mar 2022 05:02:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25ww0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 05:02:44 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 22F52cqB007094;
        Tue, 15 Mar 2022 05:02:43 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3erhy25wts-5;
        Tue, 15 Mar 2022 05:02:43 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Fix incorrect 4gb boundary check
Date:   Tue, 15 Mar 2022 01:02:35 -0400
Message-Id: <164732052813.23186.2821907604077350124.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220303140230.13098-1-sreekanth.reddy@broadcom.com>
References: <20220303140230.13098-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 1SwlyBlmEWoPpDhnzTGzP0gLiilsLb6F
X-Proofpoint-ORIG-GUID: 1SwlyBlmEWoPpDhnzTGzP0gLiilsLb6F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Mar 2022 19:32:30 +0530, Sreekanth Reddy wrote:

> Driver has to do a 4gb boundary check using the pool's
> dma address instead of using a virtual address.
> 
> 

Applied to 5.18/scsi-queue, thanks!

[1/1] mpt3sas: Fix incorrect 4gb boundary check
      https://git.kernel.org/mkp/scsi/c/208cc9fe6f21

-- 
Martin K. Petersen	Oracle Linux Engineering
