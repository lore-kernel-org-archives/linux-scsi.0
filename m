Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1F2C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbiKQS2u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240356AbiKQS2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:28:47 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127E078D60;
        Thu, 17 Nov 2022 10:28:46 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHGmTtj015890;
        Thu, 17 Nov 2022 18:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=jiQ3GHfjl6oSrqXEiKXkIfNzraWynfxR6b/3YXUuUUM=;
 b=rQZtfahjpaywIeZAH9CuTinOef4eJ1M2fRMp4Nw83IbXF7i5Nn0DgMHSccHbAOP1Ca5o
 GhfC/1uIyLRNsBqH875YEq7uAjyApbY+X77umr5rS0mMcV0yvQBlGGojTDS29lvwV/BX
 Q1Adju3UI3vGLV+Vj9GwCHd0QKaUpHlMeKUTHK7F7zRlkJl2XGHoXx3Ib8QsnSjORYhN
 iyrrcQb8sG0r9SE4RvOfOE+ZhX4MThD8/xnLcSDLXV8gGRZ1rtZLnUO7OW9Q5MGi0PPs
 MzVJyVazuLzXwHAVqP63m0HvdLynNr6irXJoTh6JPlSVudtmWlXUBdZ+hn7m6q9ONIP+ Uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kwrt6raru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHH7sOA008669;
        Thu, 17 Nov 2022 18:28:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1xft5r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:28:38 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AHISans025586;
        Thu, 17 Nov 2022 18:28:38 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3kt1xft5pj-3;
        Thu, 17 Nov 2022 18:28:38 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, hch@lst.de,
        michael.christie@oracle.com
Subject: Re: [PATCH v2] scsi: target: tcm_loop: fix possible name leak in tcm_loop_setup_hba_bus()
Date:   Thu, 17 Nov 2022 13:28:33 -0500
Message-Id: <166870940537.1572108.13020408220801458010.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221115015042.3652261-1-yangyingliang@huawei.com>
References: <20221115015042.3652261-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=856 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170133
X-Proofpoint-ORIG-GUID: mS7PNelSPxAgQs3w1XY33ECR2uQzznIN
X-Proofpoint-GUID: mS7PNelSPxAgQs3w1XY33ECR2uQzznIN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 15 Nov 2022 09:50:42 +0800, Yang Yingliang wrote:

> If device_register() fails in tcm_loop_setup_hba_bus(), the name allocated
> by dev_set_name() need be freed. As comment of device_register() says, it
> should use put_device() to give up the reference in the error path. So fix
> this by calling put_device(), then the name can be freed in kobject_cleanup().
> The 'tl_hba' will be freed in tcm_loop_release_adapter(), so it don't need
> goto error label in this case.
> 
> [...]

Applied to 6.1/scsi-fixes, thanks!

[1/1] scsi: target: tcm_loop: fix possible name leak in tcm_loop_setup_hba_bus()
      https://git.kernel.org/mkp/scsi/c/bc68e428d496

-- 
Martin K. Petersen	Oracle Linux Engineering
