From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/16] Convert FibreChannel bsg code to use bsg-lib
Date: Wed, 12 Oct 2016 17:54:45 +0200
Message-ID: <7ad9f92c-e0e9-fa44-ccbf-a6719f040387@linux.vnet.ibm.com>
References: <cover.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39672 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753659AbcJLRGC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Oct 2016 13:06:02 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9CFs7PE079156
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 11:54:53 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 261p50q0hp-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 11:54:53 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Wed, 12 Oct 2016 16:54:49 +0100
In-Reply-To: <cover.1476276823.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, linux-s390@vger.kernel.org

Hi Johannes,

On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> This series converts the current bsg usage in the FibreChannel drivers over
> to use bsg-lib. SAS will follow once FC is in a good enough shape.
>
> I did take some inspiration from a similar patchset from Mike Christie
> dating back to 2011 but it's not a 1:1 copy. Patch 15/16 is heavily based
> on his series and attribution is given to him in the commit message.
>
> It is currently regression tested on FCoE using the 'fcns' and
> 'fcrls' utilities.  I'm still trying to figure out how to test the other
> LLDDs. So any pointer from the respective maintainers are appreciated

The first thing that comes to mind for zfcp is libzfcphbaapi and simply 
run its tools for starters. They issue a few different CT GLS requests.
http://www.ibm.com/support/knowledgecenter/linuxonibm/com.ibm.linux.z.lhdd/lhdd_t_fcp_api_runappl.html
or
http://www.ibm.com/support/knowledgecenter/linuxonibm/com.ibm.linux.z.lgdd/lgdd_t_fcp_api_runappl.html
(upstream: 
http://www.ibm.com/developerworks/linux/linux390/zfcp-hbaapi.html)

Theoretically above tools could be built against libHBAAPI on other 
architectures.
Currently I don't have anything handy for ELS requests.

Maybe there is some common code tool (possibly building directly on BSG 
IOCTL) to exercise more code paths?

Just as a heads up the result of my example run (need to dig deeper why 
it crashed):

# zfcp_show -n

Local Port List:
<<<end of ssh output, Linux console following...>>>
> [  799.640378] Oops: 0038 ilc:3 [#1] [  799.640387] PREEMPT  SMP [  799.640393]
> [  799.640399] Modules linked in: nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ghash_s390 prng ecb aes_s390 des_s390 dm_mod des_generic sha512_s390 sha256_s390 qeth_l2 sha1_s390 qeth zfcp sha_common ccwgroup qdio autofs4
> [  799.640542] CPU: 1 PID: 2210 Comm: zfcp_show Not tainted 4.8.0fcbsg+ #6
> [  799.640550] Hardware name: IBM              2964 N96              702              (z/VM)
> [  799.640558] task: 0000000047b60008 task.stack: 0000000062428000
> [  799.640567] Krnl PSW : 0404e00180000000 00000000001b125c[  799.640581]  (__lock_acquire+0x104/0x7d8)
> [  799.640590]
> [  799.640599]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0[  799.640618]  RI:0 EA:3
> [  799.640621]
> [  799.640621] Krnl GPRS: 0000000000000000 0000000000000008 07f40707c0040000 0000000000000000
> [  799.640624]            0000000000000000 0000000000000000 0000000000000001 0000000000000000
> [  799.640627]            0000000000000000 0000000000355cb4 0000000000000000 0000000047b60008
> [  799.640630]            0300000000000000 00000000009b17b0 000000006242b800 000000006242b778
> [  799.640643] Krnl Code: 00000000001b124c: b9040029            lgr     %r2,%r9
> [  799.640648]            00000000001b1250: c0e5ffffd6a4        brasl   %r14,1abf98
>                          #00000000001b1256: ec28ffad007c       cgij    %r2,0,8,1b11b0
> [  799.640659]           >00000000001b125c: eb012198006a        asi     408(%r2,1
>                           00000000001b1262: 5830ba10           l       %r3,2576(%r11)
> [  799.640669]            00000000001b1266: 5030f0a4            st      %r3,164(%r15)
>                           00000000001b126a: c01000e3f9db       larl    %r1,1e30620
> [  799.640678]            00000000001b1270: e31010000012        lt      %r1,0(%r1)
> [  799.640682]
> [  799.640684] Call Trace:
> [  799.640687] ([<ffffffffffffffff>] 0xffffffffffffffff)
> [  799.640691] ([<00000000001b21f4>] lock_acquire+0x30c/0x358)
> [  799.640699] ([<000000000099fdae>] mutex_lock_interruptible_nested+0x7e/0x4f8)
> [  799.640717] ([<000003ff8047a090>] zfcp_fc_wka_port_get+0x40/0x128 [zfcp])
> [  799.640724] ([<000003ff8047bd54>] zfcp_fc_exec_bsg_job+0x244/0x2d8 [zfcp])
> [  799.640732] ([<00000000007c8b1e>] fc_bsg_dispatch+0x20e/0x280)
> [  799.640739] ([<00000000006dea1a>] bsg_request_fn+0x132/0x1e0)
> [  799.640746] ([<00000000006b8e0a>] __blk_run_queue+0x52/0x68)
> [  799.640751] ([<00000000006c549a>] blk_execute_rq_nowait+0xf2/0x110)
> [  799.640754] ([<00000000006c557a>] blk_execute_rq+0xa2/0x110)
> [  799.640757] ([<00000000006de0ee>] bsg_ioctl+0x1f6/0x268)
> [  799.640763] ([<000000000036ca20>] do_vfs_ioctl+0x680/0x6d8)
> [  799.640767] ([<000000000036caf4>] SyS_ioctl+0x7c/0xb0)
> [  799.640771] ([<00000000009a50de>] system_call+0xd6/0x270)
> [  799.640774] INFO: lockdep is turned off.
> [  799.640776] Last Breaking-Event-Address:
> [  799.640779]  [<00000000001b1244>] __lock_acquire+0xec/0x7d8
> [  799.640782]  [  799.640785] Kernel panic - not syncing: Fatal exception: panic_on_oops


> although the LLDD changes are purely mechanical. All they do is change from
> 'struct fc_bsg_job' to 'struct bsg_job' and corresponding changes in order
> to get the series bisectable.
>
> The idea for this change arose when discussing racy sysfs handling the FC
> bsg code with Christoph and is a next step in moving all bsg clients to
> bsg-lib to eventually clean up the in kernel bsg API.
>
> Changes to v1:
> * Reduce the number of individual patches (44 -> 16)

nice

> * Fix s390 build failure (forgotten to kill fc_bsg_job from zfcp_ext.h)

I pushed your patches on today's linux.git, i.e. post v4.8 with zfcp 
fixes of v4.9 merge window already included and it did build with our 
default_defconfig but qdio and zfcp as modules rather than built-in.

> * Make bsg_job_get() call kref_get_unless_zero() and use it in scsi_transport_fc.c

Perfect, I had planned to suggest this based on v1 of the patch set.

> Johannes Thumshirn (16):
>   scsi: Get rid of struct fc_bsg_buffer
>   scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly
>   scsi: fc: Export fc_bsg_jobdone and use it in FC drivers
>   scsi: Unify interfaces of fc_bsg_jobdone and bsg_job_done
>   scsi: fc: provide fc_bsg_to_shost() helper
>   scsi: fc: provide fc_bsg_to_rport() helper
>   scsi: libfc: don't set FC_RQST_STATE_DONE before calling
>     fc_bsg_jobdone()
>   scsi: fc: implement kref backed reference counting
>   block: add reference counting for struct bsg_job
>   scsi: change FC drivers to use 'struct bsg_job'
>   scsi: fc: Use bsg_destroy_job
>   scsi: fc: use bsg_softirq_done
>   scsi: fc: use bsg_job_done
>   block: add bsg_job_put() and bsg_job_get()
>   scsi: fc: move FC transport's bsg code to bsg-lib
>   block: unexport bsg_softirq_done() again
>
>  block/bsg-lib.c                  |  19 +-
>  drivers/s390/scsi/zfcp_ext.h     |   4 +-
>  drivers/s390/scsi/zfcp_fc.c      |  33 +--
>  drivers/scsi/Kconfig             |   1 +
>  drivers/scsi/bfa/bfad_bsg.c      |  62 +++---
>  drivers/scsi/bfa/bfad_im.h       |   4 +-
>  drivers/scsi/ibmvscsi/ibmvfc.c   |  40 ++--
>  drivers/scsi/libfc/fc_lport.c    |  47 ++--
>  drivers/scsi/lpfc/lpfc_bsg.c     | 375 +++++++++++++++++++-------------
>  drivers/scsi/lpfc/lpfc_crtn.h    |   4 +-
>  drivers/scsi/qla2xxx/qla_bsg.c   | 449 ++++++++++++++++++++++-----------------
>  drivers/scsi/qla2xxx/qla_def.h   |   2 +-
>  drivers/scsi/qla2xxx/qla_gbl.h   |   4 +-
>  drivers/scsi/qla2xxx/qla_iocb.c  |  13 +-
>  drivers/scsi/qla2xxx/qla_isr.c   |  52 +++--
>  drivers/scsi/qla2xxx/qla_mr.c    |  15 +-
>  drivers/scsi/scsi_transport_fc.c | 409 ++++++-----------------------------
>  include/linux/bsg-lib.h          |   4 +
>  include/scsi/libfc.h             |   2 +-
>  include/scsi/scsi_transport_fc.h |  62 ++----
>  20 files changed, 745 insertions(+), 856 deletions(-)
>

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

