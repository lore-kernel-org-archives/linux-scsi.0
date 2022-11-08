Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA5CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 04:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiKHECX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 23:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiKHECM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 23:02:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CBC558C
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 20:02:11 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80OLSP018169;
        Tue, 8 Nov 2022 04:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=uLH/6Gy6e4rxwBIm3H1erYE1+CKJi8gHmcO191A3EXE=;
 b=ul9sCQhrWPjsPrAk0zxxSjVSy/BE6FZO6NLp+Ju2OhTWS3TTcLdnrZUHHfGT+G4cKq47
 fzGD8zwptRT6KYlcncCelluW0wTz5dclepdIUGtWqMJNrqgb8qpRydvf5BiBXTX1BY2W
 EdFga2pfRS84Q37hN66sT0YvlEO5ST1UUtGRVrRzYcKs9amEAN5G2LRZty6swjmxKW9U
 URINbjQcnyvYq90pb/I5+a/zFHfgTjYB+ppyLTqBIK/Bm6CQ9ARvYweZSQmr6/Ie35d4
 rzPS/3X2GoiEY/UbckmQdrJR5QU4z7GWB982r3VCXHFxhAgMJfuEvQCC5xWvWgx5jd+t fg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngk6e5k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 04:02:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A81rcd4025648;
        Tue, 8 Nov 2022 04:02:02 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqfh3u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 04:02:02 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A841vcu022774;
        Tue, 8 Nov 2022 04:02:02 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kpcqfh3s5-9;
        Tue, 08 Nov 2022 04:02:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        john.g.garry@oracle.com, yanaijie@huawei.com, jejb@linux.ibm.com
Subject: Re: [PATCH v3] scsi: scsi_transport_sas: fix error handling in sas_phy_add()
Date:   Mon,  7 Nov 2022 23:01:56 -0500
Message-Id: <166787992423.644674.18242579694004785960.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221107124828.115557-1-yangyingliang@huawei.com>
References: <20221107124828.115557-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080020
X-Proofpoint-ORIG-GUID: KCix0xcRylfAQ1hh3ZI6gBiAh2GZlasC
X-Proofpoint-GUID: KCix0xcRylfAQ1hh3ZI6gBiAh2GZlasC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Nov 2022 20:48:28 +0800, Yang Yingliang wrote:

> If transport_add_device() fails in sas_phy_add(), it's not handled,
> it will lead kernel crash because of trying to delete not added device
> in transport_remove_device() called from sas_remove_host().
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000108
> CPU: 61 PID: 42829 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc1+ #173
> pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : device_del+0x54/0x3d0
> lr : device_del+0x37c/0x3d0
> Call trace:
>  device_del+0x54/0x3d0
>  attribute_container_class_device_del+0x28/0x38
>  transport_remove_classdev+0x6c/0x80
>  attribute_container_device_trigger+0x108/0x110
>  transport_remove_device+0x28/0x38
>  sas_phy_delete+0x30/0x60 [scsi_transport_sas]
>  do_sas_phy_delete+0x6c/0x80 [scsi_transport_sas]
>  device_for_each_child+0x68/0xb0
>  sas_remove_children+0x40/0x50 [scsi_transport_sas]
>  sas_remove_host+0x20/0x38 [scsi_transport_sas]
>  hisi_sas_remove+0x40/0x68 [hisi_sas_main]
>  hisi_sas_v2_remove+0x20/0x30 [hisi_sas_v2_hw]
>  platform_remove+0x2c/0x60
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: scsi_transport_sas: fix error handling in sas_phy_add()
      https://git.kernel.org/mkp/scsi/c/5d7bebf2dfb0

-- 
Martin K. Petersen	Oracle Linux Engineering
