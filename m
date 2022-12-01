Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C80FC47089
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Dec 2022 03:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiLADrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 22:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiLADqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 22:46:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7FC9FAA5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 19:46:10 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B12976t022942;
        Thu, 1 Dec 2022 03:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=AbPdQaWlEwqIXv+1+duFZca8RrqaqFRsHaJoMp3BDmg=;
 b=KeK6M53CJj1t38eylbi8pEuXoPgCwQQusrFAasQFtqr6WIUazuGcB2GqV37IPrEqKQlZ
 7AcKzcLAwx73VlEQOOWfsh9UZNR7Zdacu7/AH3oFTlJjrUjKKc+ImulA+OzF94kRDTSQ
 J2pik1MkSYCSnrpiGQ1qql64I6Jwb7aKMQ9322hzscaekokQFL0zdlRU9WrtoN9xnxCn
 HImBbApwukGzwjiAe3NjlZeIAAZgyH6JQFrtHlcrCandnatTM13e/LpO7ryejCN67bx0
 RXjkyAuCMqwiOecow52jzY0oXjcTeQMbXFGYynJC+kEAOFzGmKy4XzJdYIkL9YtakdWA 3w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m3xhtbnqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:46:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B110D3e007662;
        Thu, 1 Dec 2022 03:45:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m398a2cx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Dec 2022 03:45:59 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B13jbq4033801;
        Thu, 1 Dec 2022 03:45:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3m398a2cjs-22;
        Thu, 01 Dec 2022 03:45:58 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, wayneb@linux.vnet.ibm.com,
        James.Bottomley@suse.de, linux-scsi@vger.kernel.org,
        brking@us.ibm.com, Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ipr: Fix WARNING in ipr_init()
Date:   Thu,  1 Dec 2022 03:45:23 +0000
Message-Id: <166986602285.2101055.4031749141859773661.b4-ty@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221113064513.14028-1-shangxiaojing@huawei.com>
References: <20221113064513.14028-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_02,2022-11-30_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212010022
X-Proofpoint-GUID: DJfOQwv-6aJ7hRMUCLn_r-yYqDsoHWQc
X-Proofpoint-ORIG-GUID: DJfOQwv-6aJ7hRMUCLn_r-yYqDsoHWQc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 13 Nov 2022 14:45:13 +0800, Shang XiaoJing wrote:

> ipr_init() will not call unregister_reboot_notifier() when
> pci_register_driver() failed, which causes the WARNING. Call
> unregister_reboot_notifier() when pci_register_driver() failed.
> 
> notifier callback ipr_halt [ipr] already registered
> WARNING: CPU: 3 PID: 299 at kernel/notifier.c:29
> notifier_chain_register+0x16d/0x230
> Modules linked in: ipr(+) xhci_pci_renesas xhci_hcd ehci_hcd usbcore
> led_class gpu_sched drm_buddy video wmi drm_ttm_helper ttm
> drm_display_helper drm_kms_helper drm drm_panel_orientation_quirks
> agpgart cfbft
> CPU: 3 PID: 299 Comm: modprobe Tainted: G        W
> 6.1.0-rc1-00190-g39508d23b672-dirty #332
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
> RIP: 0010:notifier_chain_register+0x16d/0x230
> Call Trace:
>  <TASK>
>  __blocking_notifier_chain_register+0x73/0xb0
>  ipr_init+0x30/0x1000 [ipr]
>  do_one_initcall+0xdb/0x480
>  do_init_module+0x1cf/0x680
>  load_module+0x6a50/0x70a0
>  __do_sys_finit_module+0x12f/0x1c0
>  do_syscall_64+0x3f/0x90
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: ipr: Fix WARNING in ipr_init()
      https://git.kernel.org/mkp/scsi/c/e6f108bffc37

-- 
Martin K. Petersen	Oracle Linux Engineering
