Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E9AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 01:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344301AbiETBJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 21:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344218AbiETBJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 21:09:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2281E129EF4;
        Thu, 19 May 2022 18:09:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0J2p7003567;
        Fri, 20 May 2022 01:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=9k4dMuAZpzuCKvO1qraCIpcWA0Xcc7WLkprV0uhqMag=;
 b=kL8FgmYbLihEJtyajdoLjfrTFuR3ufsQVrqNPqyiRzKQH0+bpKJiBPcBDfTSOWcN6Fgp
 fXp1IReXvLDFQIzJ6X7K6TgU6VOiYL7GFKgLsJMHUxbrHdAe9h9Tb3pcO6tyRNCMewBn
 2riutgAPLoKwHSmc3Nynd9Cgz0onP1i4w6waDubG8JzaOyQVoRP+MVQogYeIbmnaF+2m
 Pjyrtj/iF5DHBvSMyreT15WDsEePhZtzOHJXipBLzjhDf+f1jgY06cgVIFCAGVkqGMdL
 GGxKpka3RuGVAn4U+28iigGdn1rIp58BkH8MdKbsUxCDd87k3wNQ4zw9EgBjMfpiiJRZ Zg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytwu9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:25 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K15nFX020165;
        Fri, 20 May 2022 01:09:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crytp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 01:09:25 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 24K19GKH030710;
        Fri, 20 May 2022 01:09:24 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37crythd-7;
        Fri, 20 May 2022 01:09:24 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        Hannes Reinecke <hare@suse.de>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH] scsi: mpi3mr: Fix a NULL vs IS_ERR() bug in mpi3mr_bsg_init()
Date:   Thu, 19 May 2022 21:09:06 -0400
Message-Id: <165300891228.11465.6861527030732595106.b4-ty@oracle.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <YnUf7RQl+A3tigWh@kili>
References: <YnUf7RQl+A3tigWh@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: dUiNNipa0FoV4_9i7lwktL0ZQouKRjUS
X-Proofpoint-ORIG-GUID: dUiNNipa0FoV4_9i7lwktL0ZQouKRjUS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 May 2022 16:17:33 +0300, Dan Carpenter wrote:

> The bsg_setup_queue() function does not return NULL.  It returns
> error pointers.  Fix the check accordingly.
> 
> 

Applied to 5.19/scsi-queue, thanks!

[1/1] scsi: mpi3mr: Fix a NULL vs IS_ERR() bug in mpi3mr_bsg_init()
      https://git.kernel.org/mkp/scsi/c/a25eafd13e5f

-- 
Martin K. Petersen	Oracle Linux Engineering
