Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB37C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiLADrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLADqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:46:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E159FEC7
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:46:11 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B12976v022942;
        Thu, 1 Dec 2022 03:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=eb25r+P/UedhAAES9uZCpKR2HBKgcvQKZzTR/6mlpf0=;
 b=SyhqEh1DAJ24yTw9MGTtAkJmR9v843ewbE8+CoLflh3cgmegiQPPJO81pihpNkMcOini
 NcqyxSm6sQXk27RjGrPT8tyS86fbOfa1AP3JJZ1OKoC28OnZp+ngKh7f5hTXg6VWvqk4
 5jBCJyT4dACJjmP+rIHzwksJwrtOuYGNT+MvUcmMQU27GYANaanxzssT+MwPB5duVKOj
 cpR0jnBRi4PBymocXabi4mc2Cs0Ll1G5tQ8JMsrW8EU3OKEoAhrg2do+5WmrFCCzekym
 RYrntP6/SUjh6GYF5zdYtQnAOqCgD4PTr/VOj+ZW3q2TnjvtW5MjpnajG7gHReR2UYNL 3Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xhtbnqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B13f2v3007584;
        Thu, 1 Dec 2022 03:46:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2d0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:02 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbqC033801;
        Thu, 1 Dec 2022 03:46:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-26;
        Thu, 01 Dec 2022 03:46:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     storagedev@microchip.com, linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, don.brace@microchip.com
Subject: Re: [PATCH] scsi: hpsa: fix possible memory leak in hpsa_add_sas_device()
Date:   Thu,  1 Dec 2022 03:45:27 +0000
Message-Id: <166986602277.2101055.12254757452015242381.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111043012.1074466-1-yangyingliang@huawei.com>
References: <20221111043012.1074466-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=951 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-GUID: SudeS3MsNBi3UUMW2KiSrEopet7kpUAp
X-Proofpoint-ORIG-GUID: SudeS3MsNBi3UUMW2KiSrEopet7kpUAp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 11 Nov 2022 12:30:12 +0800, Yang Yingliang wrote:

> If hpsa_sas_port_add_rphy() returns error, the 'rphy' allocated
> in sas_end_device_alloc() need be free, fix this by calling
> sas_rphy_free() in the error path.
> 
> 

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: hpsa: fix possible memory leak in hpsa_add_sas_device()
      https://git.kernel.org/mkp/scsi/c/fda34a5d304d

-- 
Martin K. Petersen	Oracle Linux Engineering
