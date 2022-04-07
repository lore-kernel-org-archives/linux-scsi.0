Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF349C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Apr 2022 13:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343737AbiDGNid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Apr 2022 09:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343701AbiDGNhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2022 09:37:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694E926C9
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 06:35:34 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237BuqvQ000758
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=U96FPGp27FOteNb4Ao5omjBG6t7duB2/peR+qAyb/iA=;
 b=Jul7KjTDM90qVQ1ir0L6urT2TahBBl8ibOXMfiYoOZ0Ta68UElW0Uq8UDBOxWXq2WsTQ
 ZVh4pKwIpTE/FBmhtmnpYn0rCFtvvKS9/m2h48pPe7h5GUNJul1sxrKpjF6AVTgWraOx
 +MnbE/RR2Ze+IoLta/fTYsICin3my/dkfrms1PriQ3+x30W4swzCliBKKKCtw8hLqmGU
 WqmcfGelvboDSzoHGZvk8hnpb5H+BsSeM7J6Gbv8hwpclmyNrLA8DpkGpe3Naql4gDgd
 aaUk1lrJxZScg5YVUZbD9iOotlihhGDwBJd4TpWYgtJHpEQtMIv+3rWbZv3YbOAlkoW/ AA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3suw2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVNa036835
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Thu, 07 Apr 2022 13:35:32 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 237DZJMG032479
        for <linux-scsi@vger.kernel.org>; Thu, 7 Apr 2022 13:35:31 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uwtvpy-18;
        Thu, 07 Apr 2022 13:35:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ibmvscsis: increase INITIAL_SRP_LIMIT to 1024
Date:   Thu,  7 Apr 2022 09:35:17 -0400
Message-Id: <164929678999.15424.1765961902177131391.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220322194443.678433-1-tyreld@linux.ibm.com>
References: <20220322194443.678433-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: U5AMj0MA0kW5GA9hhf-5tXUUWRXym6ZG
X-Proofpoint-GUID: U5AMj0MA0kW5GA9hhf-5tXUUWRXym6ZG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Mar 2022 12:44:43 -0700, Tyrel Datwyler wrote:

> The adapter request_limit is hardcoded to be INITIAL_SRP_LIMIT which is
> currently an arbitrary value of 800. Increase this value to 1024 which
> better matches the characteristics of the typical IBMi Initiator that
> supports 32 LUNs and a queue depth of 32.
> 
> This change also has the secondary benefit of being a power of two as
> required by the kfifo API. Since, Commit ab9bb6318b09 ("Partially revert
> "kfifo: fix kfifo_alloc() and kfifo_init()"") the size of IU pool for
> each target has been rounded down to 512 when attempting to kfifo_init()
> those pools with the current request_limit size of 800.
> 
> [...]

Applied to 5.18/scsi-fixes, thanks!

[1/1] ibmvscsis: increase INITIAL_SRP_LIMIT to 1024
      https://git.kernel.org/mkp/scsi/c/0bade8e53279

-- 
Martin K. Petersen	Oracle Linux Engineering
