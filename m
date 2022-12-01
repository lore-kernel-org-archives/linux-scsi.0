Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EA4C4321E
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLADrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiLADqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:46:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0529FED5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:46:08 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B13PNEl016224;
        Thu, 1 Dec 2022 03:46:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=qZ2QCEmNPAI35wLLdCYIWlJNm1rgwL4wjaFjkEhzIJM=;
 b=XD06gCVEUIY6LxOQwp3TGYeZdkWqR2nBFZAibLXj0j8F9+MrZPTSjX3QcGew1JuFtfSE
 5lIcmDPNRjOFHcNQDZ/lV79Yk56ddiDuhzq2of4qN+s6WaqPAsVbX+zm7dI1PScKRE4/
 C+TWfe9Oq2zIXXzPleuuLG9bZTOP6aujtweW+1jcgKswDKBKHiWC+u2vu99I7LfEI4vZ
 SQae1eXMk9QHzBDVNVhqnYhiB4lSmHKRo3si8BVS5+MaRIqotMY/GHLB9QHPFynoBz08
 FB2rZWW9uQcj0H7EU4/hpcQWRMdyXTkWLVtByxoZuoPFsz8Zi1m1mhAWbUgqHivgnqb+ Vg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m4aemjjp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B13NGr7007605;
        Thu, 1 Dec 2022 03:46:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2d10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:03 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbqE033801;
        Thu, 1 Dec 2022 03:46:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-27;
        Thu, 01 Dec 2022 03:46:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH] scsi: mpt3sas: fix possible resource leaks in mpt3sas_transport_port_add()
Date:   Thu,  1 Dec 2022 03:45:28 +0000
Message-Id: <166986602277.2101055.4476238868542667251.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109032403.1636422-1-yangyingliang@huawei.com>
References: <20221109032403.1636422-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=971 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-ORIG-GUID: 6auhRqI-Z7NflppXcqJVPB1qtwKV0VVt
X-Proofpoint-GUID: 6auhRqI-Z7NflppXcqJVPB1qtwKV0VVt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Nov 2022 11:24:03 +0800, Yang Yingliang wrote:

> In mpt3sas_transport_port_add(), if sas_rphy_add() returns error,
> sas_rphy_free() need be called to free the resource allocated in
> sas_end_device_alloc().
> 
> Besides, it will lead a kernel crash:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000108
> CPU: 45 PID: 37020 Comm: bash Kdump: loaded Tainted: G        W          6.1.0-rc1+ #189
> pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : device_del+0x54/0x3d0
> lr : device_del+0x37c/0x3d0
> Call trace:
>  device_del+0x54/0x3d0
>  attribute_container_class_device_del+0x28/0x38
>  transport_remove_classdev+0x6c/0x80
>  attribute_container_device_trigger+0x108/0x110
>  transport_remove_device+0x28/0x38
>  sas_rphy_remove+0x50/0x78 [scsi_transport_sas]
>  sas_port_delete+0x30/0x148 [scsi_transport_sas]
>  do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
>  device_for_each_child+0x68/0xb0
>  sas_remove_children+0x30/0x50 [scsi_transport_sas]
>  sas_rphy_remove+0x38/0x78 [scsi_transport_sas]
>  sas_port_delete+0x30/0x148 [scsi_transport_sas]
>  do_sas_phy_delete+0x78/0x80 [scsi_transport_sas]
>  device_for_each_child+0x68/0xb0
>  sas_remove_children+0x30/0x50 [scsi_transport_sas]
>  sas_remove_host+0x20/0x38 [scsi_transport_sas]
>  scsih_remove+0xd8/0x420 [mpt3sas]
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: mpt3sas: fix possible resource leaks in mpt3sas_transport_port_add()
      https://git.kernel.org/mkp/scsi/c/78316e9dfc24

-- 
Martin K. Petersen	Oracle Linux Engineering
