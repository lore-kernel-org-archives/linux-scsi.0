Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD08C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73DF61B04
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 04:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbhKSEUA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 23:20:00 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15772 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233949AbhKSET6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 23:19:58 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ2NDaT000720;
        Fri, 19 Nov 2021 04:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=9GBklgfH13zKdx62kKyy8T5rnCGw/2oKdNNu145Mma8=;
 b=oW3Kco0PNMd6Dj5yvud1LxpS+dLqoHK5x44/gq8uKdf8sCV/iDIoQqijXHDpNehmzNfE
 CgXPmzK3xk5LODK8+LFhHfi1/2M1oEUU1RFgUmRPotfOZfSBVXEHwgzQRM+0W0igmw7J
 i9nthkNswUE+J2ZUR3FnVmgVpRndjuDXic4Xl5HMJSqjdSfFq2JS6BxsY1EkaLV7IWZA
 OggPft8KZEMBuXRCu2IpcxlmG5QLs6uxqiepF7sCQszk08mdtCgWTOX7euntTYtRGOYQ
 D3ObNix/L3cHyfeAl+5OTf++Io457p/pM0gSja/Js+52mmiF/lCdvnza6WOHlyuy4HHV cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cd205mjq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ4FBjp020398;
        Fri, 19 Nov 2021 04:16:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3caq4x7c3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 04:16:55 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AJ4Giwe024731;
        Fri, 19 Nov 2021 04:16:55 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3020.oracle.com with ESMTP id 3caq4x7bx2-13;
        Fri, 19 Nov 2021 04:16:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        suganath-prabu.subramani@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix system falling into readonly mode
Date:   Thu, 18 Nov 2021 23:16:42 -0500
Message-Id: <163729506338.21244.103615664339408235.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117105058.3505-1-sreekanth.reddy@broadcom.com>
References: <20211117105058.3505-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 2FId7ZTrkuiH9OtjnZFeJ8cUrx4VRhSD
X-Proofpoint-GUID: 2FId7ZTrkuiH9OtjnZFeJ8cUrx4VRhSD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Nov 2021 16:20:58 +0530, Sreekanth Reddy wrote:

> While determining the SAS address of a drive, the driver checks whether
> the handle number is less than the HBA phys count or not.
> If the handle number is less than the HBA phy’s count then driver
> assumes that this handle belongs to HBA and hence it assigns the
> HBA SAS address.
> During IOC firmware downgrade operation, if the number of HBA phys got
> reduced and the OS drive’s device handle falls below start of the day
> HBA phys count then while determining the OS drive’s SAS address
> driver uses the HBA SAS address. This leads to a mismatch of drive’s
> SAS address and hence the driver unregisters the OS drive and the
> system falls into read only mode.
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] mpt3sas: Fix system falling into readonly mode
      https://git.kernel.org/mkp/scsi/c/91202a01a2fb

-- 
Martin K. Petersen	Oracle Linux Engineering
