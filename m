Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D79CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 03:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378339AbhLCDG4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 22:06:56 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47660 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239667AbhLCDGz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 22:06:55 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B30lctI008309;
        Fri, 3 Dec 2021 03:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=B7Wt9Jlgx+mmpm8Ls0ySZB7jPnH8vwPxknfqQqCUGJU=;
 b=TOQbqSGO1P+cYd48Y7k+63QTuAdG0uQqstgiojTaL3i/+tZOOCyP5skXarEX4HadUA7m
 WVACHiOqlHcdcF4IBqZEaSFiK8ck2RP+C/s5ksRxQz9nR35IUt9NjrVoVqsTVe/PfsNW
 v+HZJmhlIA8COoSxemlG1rQSGUsqMYIoaDQMwzl3Le5N6vP5gfN99ojliJX6ammjmn5G
 Ai5r9a/xmUzKu4j9SqH063aZvs00XnYWLCyJqdQu+rs1Gc4GuUOVdd2lF0y3fu+ZC+i/
 6nbPE4jLj0UfjAIxWOsKYrwnE8SDs/crXSLKM8Ku45zkjDlvSRp61gW+mpRY3cmSSnb4 GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cp7t1vshc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 03:03:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B332uFL005354;
        Fri, 3 Dec 2021 03:03:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3ck9t5dswd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Dec 2021 03:03:13 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1B333C7x006710;
        Fri, 3 Dec 2021 03:03:12 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3ck9t5dsvh-1;
        Fri, 03 Dec 2021 03:03:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Igor Pylypiv <ipylypiv@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Viswas G <Viswas.G@microchip.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>
Subject: Re: [PATCH] scsi: pm80xx: Do not call scsi_remove_host() in pm8001_alloc()
Date:   Thu,  2 Dec 2021 22:03:11 -0500
Message-Id: <163850057786.29121.3572131363494831341.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201041627.1592487-1-ipylypiv@google.com>
References: <20211201041627.1592487-1-ipylypiv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: qL39CsBmd2ZJPMsrR8Oyh07x7vy2hyHo
X-Proofpoint-GUID: qL39CsBmd2ZJPMsrR8Oyh07x7vy2hyHo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Nov 2021 20:16:27 -0800, Igor Pylypiv wrote:

> Calling scsi_remove_host() before scsi_add_host() results in a crash:
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000108
>  RIP: 0010:device_del+0x63/0x440
>  Call Trace:
>   device_unregister+0x17/0x60
>   scsi_remove_host+0xee/0x2a0
>   pm8001_pci_probe+0x6ef/0x1b90 [pm80xx]
>   local_pci_probe+0x3f/0x90
> 
> [...]

Applied to 5.16/scsi-fixes, thanks!

[1/1] scsi: pm80xx: Do not call scsi_remove_host() in pm8001_alloc()
      https://git.kernel.org/mkp/scsi/c/653926205741

-- 
Martin K. Petersen	Oracle Linux Engineering
