Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53161C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA4360ED3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 03:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhJUDqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 23:46:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54358 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231268AbhJUDp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 23:45:29 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L345vT029738;
        Thu, 21 Oct 2021 03:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=UoDAUTRERmYFjHxZgHZ1etj+DOHAA/A+9nvB4Euhi9Y=;
 b=iOOvpkKnEhbc3QJjhvw9O6ncgCRqBwdf/eJuF+zdXPYzneVYR1xh5EsIkD0HyKtwwd3d
 rAZuffQmQlvt676K7TmPNUAxrqBsMCryYSiVtXAU7+xpb1aLKextsnXkH7deaJoYBlSc
 uifxJChq6SkTRmgt365P9HDsgr9YKr8xOdP412OneNSk+a1TrNEshiEsMdEvdmZ7rFjc
 i7FphRn5AHuFyQR2lIJyrbFR19JuR5cgGVuYG9g7sKHycWAzXOgEUDFcKw1Ra5ueb1+c
 2W1xYqhgv5bY73lYH59eLXnSnwH+qC7qudEbaZK6iiYoFD7nRFrY6nfBoc/oNeY0tRfg aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkwj3wvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19L3esUG078127;
        Thu, 21 Oct 2021 03:43:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 3bqmshem50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 03:43:04 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 19L3gu86082116;
        Thu, 21 Oct 2021 03:43:03 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3030.oracle.com with ESMTP id 3bqmshekyd-11;
        Thu, 21 Oct 2021 03:43:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, yanaijie@huawei.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] hisi_sas: Some misc patches for next
Date:   Wed, 20 Oct 2021 23:42:42 -0400
Message-Id: <163478764102.7011.11725518798316767532.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
References: <1634041588-74824-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 9qFWdcftF0lFu21zaMpY33-LIJlPULNp
X-Proofpoint-GUID: 9qFWdcftF0lFu21zaMpY33-LIJlPULNp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Oct 2021 20:26:24 +0800, John Garry wrote:

> This small series includes the following:
> - Relocate the init device functionality to a more appropriate location
> - Make the phy control function synchronous
> - For faulty SATA disk, disable their phy to stop spinning in the error
>   handler
> - For previous patch we need to export a libsas phy control function
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/4] scsi: hisi_sas: Initialise devices in .slave_alloc callback
      https://git.kernel.org/mkp/scsi/c/36c6b7613ef1
[2/4] scsi: hisi_sas: Wait for phyup in hisi_sas_control_phy()
      https://git.kernel.org/mkp/scsi/c/046ab7d0f594
[3/4] scsi: libsas: Export sas_phy_enable()
      https://git.kernel.org/mkp/scsi/c/00aeaf329a3a
[4/4] scsi: hisi_sas: Disable SATA disk phy for severe I_T nexus reset failure
      https://git.kernel.org/mkp/scsi/c/21c7e972475e

-- 
Martin K. Petersen	Oracle Linux Engineering
