Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AA9C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 22:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345133AbiAJWFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 17:05:08 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39442 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345164AbiAJWFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 17:05:03 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlXiX026175;
        Mon, 10 Jan 2022 22:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=0Y6UNwICeH/WJtgeIs8Sdtx8ICiDFJgumYqTlaUdJ1g=;
 b=T2uSNYNlAxKyunBbTGQ98xKphfxw3w2PWgLyhdd7UQIR+i16avaePS4spFFCPXy70sHB
 BTU1/Jnjbd6p1ADJYMsWp13OOaXwc2NfDlZMYSIFIZsvliHuCXXx8LXModUzcIMrGL+e
 dL688YjGRykXxHnKb65YD0UDqLD57Qxt3OmBf8H5AQ5j2dUWrPZ2g0+X2SQxLf+Y+yAx
 AWGDrqrqcroI4nhZH8e0zC14sPVcCWkNgG02Lme/noW4SOJpR9nK0jvyYLn0ieiJQRcn
 E5qQTjnhZ+ldEKYxcrf/b00xLDrrmjkAUTH0Tba9NsaJja60xcdhHk9YsIah/Vo7u8uo 3w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgjtg9svc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALtv7Q139010;
        Mon, 10 Jan 2022 22:04:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:47 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20AM4iC2174082;
        Mon, 10 Jan 2022 22:04:46 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqp8-3;
        Mon, 10 Jan 2022 22:04:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, john.garry@huawei.com,
        colin.i.king@gmail.com, nathan@kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH] scsi: hisi_sas: Remove unused variable and check in hisi_sas_send_ata_reset_each_phy()
Date:   Mon, 10 Jan 2022 17:04:35 -0500
Message-Id: <164182835585.13635.6252474337803323006.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1641300126-53574-1-git-send-email-chenxiang66@hisilicon.com>
References: <1641300126-53574-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: FWI9fUYvTxRtpPNFeA2LUh3sVk2XkZri
X-Proofpoint-ORIG-GUID: FWI9fUYvTxRtpPNFeA2LUh3sVk2XkZri
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 4 Jan 2022 20:42:06 +0800, chenxiang wrote:

> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> In commit 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to
> asd_sas_port->phy_list"), we use asd_sas_port->phy_mask instead of
> accessing asd_sas_port->phy_list, and it is enough to use
> asd_sas_port->phy_mask to check the state of phy, so remove the unused
> check and variable.
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[1/1] scsi: hisi_sas: Remove unused variable and check in hisi_sas_send_ata_reset_each_phy()
      https://git.kernel.org/mkp/scsi/c/5d9224fb076e

-- 
Martin K. Petersen	Oracle Linux Engineering
