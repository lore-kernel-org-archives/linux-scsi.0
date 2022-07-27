Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877F9C19F21
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jul 2022 03:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240281AbiG0DQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 23:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240264AbiG0DQJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 23:16:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3083D591
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 20:15:51 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26R2p1i9009205;
        Wed, 27 Jul 2022 03:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=pjE//OQ1O+RSDCwFw9yj0ZKbC9zltxEwaWGxtK6R+tw=;
 b=0HZNqCrtWOTaJX8zakqT/0WQyCZ2tjGwKLxI/Ed97q9lxtxrY0VHydrWpA2H9GxjMnjR
 AFPbB3PZPmCGxSabQifrSPEJ/5XfRV8kelSFs5xkqe6XoFLN2pdFu5UJj7g4vKD+Cjrk
 tk3HeYFHvr2YOFtGfrmRikiyyCbFS5LnNAmsjqXVBRJ9x+tmcuj7qXbX/43bce72KtlN
 tQLjAji6cnNUwW2XfMR4iqhISsrucrdw3DX3C3TkQ4IbhqTJOSPX3FOzH6wEav2ktFz/
 DG9xhOiJMU+7JhyS+0bxlhilryJNGImtWTk+JR5+PrIq/UI0blwR3VZ341ZbDs48i1Qm dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9anyu2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:15:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26R1BDsI019875;
        Wed, 27 Jul 2022 03:15:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh638mksh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 03:15:15 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26R3Dx7V005078;
        Wed, 27 Jul 2022 03:15:14 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3hh638mkrj-1;
        Wed, 27 Jul 2022 03:15:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Santosh Y <santoshsy@gmail.com>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: Fix a race condition related to device management
Date:   Tue, 26 Jul 2022 23:15:10 -0400
Message-Id: <165889169552.689.16787074693111519230.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220720170228.1598842-1-bvanassche@acm.org>
References: <20220720170228.1598842-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207270009
X-Proofpoint-ORIG-GUID: bBj_zkbumSb5eckUcDC5jt8bnBrS8ZK3
X-Proofpoint-GUID: bBj_zkbumSb5eckUcDC5jt8bnBrS8ZK3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Jul 2022 10:02:23 -0700, Bart Van Assche wrote:

> If a device management command completion happens after
> wait_for_completion_timeout() times out and before ufshcd_clear_cmds() is
> called then the completion code may crash on the complete() call in
> __ufshcd_transfer_req_compl(). This patch fixes the following crash:
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
> Call trace:
>  complete+0x64/0x178
>  __ufshcd_transfer_req_compl+0x30c/0x9c0
>  ufshcd_poll+0xf0/0x208
>  ufshcd_sl_intr+0xb8/0xf0
>  ufshcd_intr+0x168/0x2f4
>  __handle_irq_event_percpu+0xa0/0x30c
>  handle_irq_event+0x84/0x178
>  handle_fasteoi_irq+0x150/0x2e8
>  __handle_domain_irq+0x114/0x1e4
>  gic_handle_irq.31846+0x58/0x300
>  el1_irq+0xe4/0x1c0
>  efi_header_end+0x110/0x680
>  __irq_exit_rcu+0x108/0x124
>  __handle_domain_irq+0x118/0x1e4
>  gic_handle_irq.31846+0x58/0x300
>  el1_irq+0xe4/0x1c0
>  cpuidle_enter_state+0x3ac/0x8c4
>  do_idle+0x2fc/0x55c
>  cpu_startup_entry+0x84/0x90
>  kernel_init+0x0/0x310
>  start_kernel+0x0/0x608
>  start_kernel+0x4ec/0x608
> 
> [...]

Applied to 5.19/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix a race condition related to device management
      https://git.kernel.org/mkp/scsi/c/f5c2976e0cb0

-- 
Martin K. Petersen	Oracle Linux Engineering
