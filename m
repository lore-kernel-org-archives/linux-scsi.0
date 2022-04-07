Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFB0C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbiDGNhy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343686AbiDGNhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B001326CD
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237A6u82024447
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=QrK2wQFDVXoPmgtoZ6+/dNVj46oyLLwMFfhxhENIvZ0=;
 b=Zp+BBOp7tfJHvRLGlIak0smy3hNsoUHalaG0ILYeJrrd4WWBB3gblR5UBCu+6cm5W4PI
 iPgOAOYEXjEkyi7WZOEkekOYkUz2zWknkZLwIWOSVPPR6qpnOfi4i8ZKTTFQScoPQp4W
 urAsKfJvdoPZUkvMNnO2JrW45mx9xpdThEDU8TD1iFMcL+TQEBfH1Gps0quEqu1/N0Dd
 1mtTP4YEQ0kxbkmu2jpxQjxlc4TgTJeH9HPBLw01SSrYNkim23Zs51JNlxsx6mAE2/Uh
 RpfK8bf1Pi+LOraxRRFEJ1b+187XF9gcY3gJMwu1efwiEAp1VgaD4DwBXFCIGdAEXryt Tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tc3rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVCf036824
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvy0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:30 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJMC032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:30 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-16;
        Thu, 07 Apr 2022 13:35:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_logging: fix a BUG
Date:   Thu,  7 Apr 2022 09:35:15 -0400
Message-Id: <164929678998.15424.4207266947460149939.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220324134603.28463-1-thenzl@redhat.com>
References: <20220324134603.28463-1-thenzl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: lajNe2Yg4zH3GRS3bdgBcdRCL51PrOaQ
X-Proofpoint-GUID: lajNe2Yg4zH3GRS3bdgBcdRCL51PrOaQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 24 Mar 2022 14:46:03 +0100, Tomas Henzl wrote:

> The request_queue may be NULL in a request, for example when it comes
> from scsi_ioctl_reset.
> Check it before before use.
> 
> Fixes: f3fa33acca9f ("block: remove the ->rq_disk field in struct request")
> 
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] scsi_logging: fix a BUG
      https://git.kernel.org/mkp/scsi/c/f06aa52cb272

-- 
Martin K. Petersen	Oracle Linux Engineering
