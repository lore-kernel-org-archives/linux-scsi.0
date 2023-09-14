Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90889EE0217
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 01:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbjINBky (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbjINBkx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 21:40:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F250A1720
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 18:40:48 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DN2wLN000712;
        Thu, 14 Sep 2023 01:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=HQwDN6jpgh39nojU0SqWapUxtciMWHeg2Xtb6i0IsEY=;
 b=LU/R9C0Ws0n4NM7r2DcuxkpmKRiBFsEjtTvqxsBuKcdKCj5XAUVDR4DeMtzlLjq91vEK
 egVzxiNTnxyqphE80yL6sFcn0Ey7wI52i8bEFrcuFx4h8USxdspRRiV0KEvzvKOtUjGY
 b8tFMR0mJ3wNZlmJoIDxhmwCTi0TeF1M/RLQ2JvTSCZqzzyb17lT5i4iilqVsMpelOdT
 toHR/ZacEfCzZi50/JuTrxBLHwoGWTIcY/Hps7L+2J+emdH+lX+mnPwq+RI52tvMuXIs
 k13NJapZOTi5mMk36w+SQ8KKe1bjwMUgQNJ0JR3qE4tob6KPGDzvYmE5DHwanxa6CJzu Zw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7hbq2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:47 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNr84Z007718;
        Thu, 14 Sep 2023 01:40:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f581r22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 01:40:46 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38E1efpV038417;
        Thu, 14 Sep 2023 01:40:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3t0f581qyy-5;
        Thu, 14 Sep 2023 01:40:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Junxiao Bi <junxiao.bi@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Subject: Re: [PATCH] scsi: megaraid_sas: fix deadlock on firmware crashdump
Date:   Wed, 13 Sep 2023 21:40:28 -0400
Message-Id: <169465549426.730690.34838215302244371.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230828221018.19471-1-junxiao.bi@oracle.com>
References: <20230828221018.19471-1-junxiao.bi@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=840 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140013
X-Proofpoint-ORIG-GUID: XWjOvQvIyu5nvXh1QByBx0sS69HG63-u
X-Proofpoint-GUID: XWjOvQvIyu5nvXh1QByBx0sS69HG63-u
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 28 Aug 2023 15:10:18 -0700, Junxiao Bi wrote:

> The following processes run into a deadlock. CPU 41 was waiting for CPU 29
> to handle a CSD request while holding spinlock "crashdump_lock", but CPU 29
> was hung by the that spinlock with irq disable.
> 
>   PID: 17360    TASK: ffff95c1090c5c40  CPU: 41  COMMAND: "mrdiagd"
>   !# 0 [ffffb80edbf37b58] __read_once_size at ffffffff9b871a40 include/linux/compiler.h:185:0
>   !# 1 [ffffb80edbf37b58] atomic_read at ffffffff9b871a40 arch/x86/include/asm/atomic.h:27:0
>   !# 2 [ffffb80edbf37b58] dump_stack at ffffffff9b871a40 lib/dump_stack.c:54:0
>    # 3 [ffffb80edbf37b78] csd_lock_wait_toolong at ffffffff9b131ad5 kernel/smp.c:364:0
>    # 4 [ffffb80edbf37b78] __csd_lock_wait at ffffffff9b131ad5 kernel/smp.c:384:0
>    # 5 [ffffb80edbf37bf8] csd_lock_wait at ffffffff9b13267a kernel/smp.c:394:0
>    # 6 [ffffb80edbf37bf8] smp_call_function_many at ffffffff9b13267a kernel/smp.c:843:0
>    # 7 [ffffb80edbf37c50] smp_call_function at ffffffff9b13279d kernel/smp.c:867:0
>    # 8 [ffffb80edbf37c50] on_each_cpu at ffffffff9b13279d kernel/smp.c:976:0
>    # 9 [ffffb80edbf37c78] flush_tlb_kernel_range at ffffffff9b085c4b arch/x86/mm/tlb.c:742:0
>    #10 [ffffb80edbf37cb8] __purge_vmap_area_lazy at ffffffff9b23a1e0 mm/vmalloc.c:701:0
>    #11 [ffffb80edbf37ce0] try_purge_vmap_area_lazy at ffffffff9b23a2cc mm/vmalloc.c:722:0
>    #12 [ffffb80edbf37ce0] free_vmap_area_noflush at ffffffff9b23a2cc mm/vmalloc.c:754:0
>    #13 [ffffb80edbf37cf8] free_unmap_vmap_area at ffffffff9b23bb3b mm/vmalloc.c:764:0
>    #14 [ffffb80edbf37cf8] remove_vm_area at ffffffff9b23bb3b mm/vmalloc.c:1509:0
>    #15 [ffffb80edbf37d18] __vunmap at ffffffff9b23bb8a mm/vmalloc.c:1537:0
>    #16 [ffffb80edbf37d40] vfree at ffffffff9b23bc85 mm/vmalloc.c:1612:0
>    #17 [ffffb80edbf37d58] megasas_free_host_crash_buffer [megaraid_sas] at ffffffffc020b7f2 drivers/scsi/megaraid/megaraid_sas_fusion.c:3932:0
>    #18 [ffffb80edbf37d80] fw_crash_state_store [megaraid_sas] at ffffffffc01f804d drivers/scsi/megaraid/megaraid_sas_base.c:3291:0
>    #19 [ffffb80edbf37dc0] dev_attr_store at ffffffff9b56dd7b drivers/base/core.c:758:0
>    #20 [ffffb80edbf37dd0] sysfs_kf_write at ffffffff9b326acf fs/sysfs/file.c:144:0
>    #21 [ffffb80edbf37de0] kernfs_fop_write at ffffffff9b325fd4 fs/kernfs/file.c:316:0
>    #22 [ffffb80edbf37e20] __vfs_write at ffffffff9b29418a fs/read_write.c:480:0
>    #23 [ffffb80edbf37ea8] vfs_write at ffffffff9b294462 fs/read_write.c:544:0
>    #24 [ffffb80edbf37ee8] SYSC_write at ffffffff9b2946ec fs/read_write.c:590:0
>    #25 [ffffb80edbf37ee8] SyS_write at ffffffff9b2946ec fs/read_write.c:582:0
>    #26 [ffffb80edbf37f30] do_syscall_64 at ffffffff9b003ca9 arch/x86/entry/common.c:298:0
>    #27 [ffffb80edbf37f58] entry_SYSCALL_64 at ffffffff9ba001b1 arch/x86/entry/entry_64.S:238:0
> 
> [...]

Applied to 6.6/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: fix deadlock on firmware crashdump
      https://git.kernel.org/mkp/scsi/c/0b0747d507bf

-- 
Martin K. Petersen	Oracle Linux Engineering
