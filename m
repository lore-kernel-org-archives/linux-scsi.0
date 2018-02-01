From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: test results
Date: Thu,  1 Feb 2018 20:27:56 -0200
Message-ID: <1517524076-11346-1-git-send-email-mauricfo@linux.vnet.ibm.com>
References: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38536 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751547AbeBAW2O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2018 17:28:14 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w11MPHcg057600
        for <linux-scsi@vger.kernel.org>; Thu, 1 Feb 2018 17:28:14 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fv77mkjtk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 01 Feb 2018 17:28:13 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Thu, 1 Feb 2018 15:28:12 -0700
In-Reply-To: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

The test-case results with PATCH v2.

scsih_abort()
=============

Without patch:

    [  362.669743] setting logging_level(0x10000000)
    [  362.705074] mpt3sas_cm0: skip free_smid/scsi_done scmd(c000001fd4f2bd40)
    [  363.956579] sd 16:0:1:0: [sdf] Synchronizing SCSI cache
    [  363.956844] sd 16:0:0:0: [sde] Synchronizing SCSI cache
    [  363.957147] mpt3sas_cm0: sending diag reset !!
    [  365.073568] mpt3sas_cm0: diag reset: SUCCESS
    [  365.090316] mpt3sas_cm0: sleep on shutdown
    [  366.120209] mpt3sas_cm0: sleep on shutdown
    ...
    [  373.419954] sd 16:0:1:0: attempting task abort! scmd(c000001fd4f2bd40)
    ...
    [  373.420256] mpt3sas_scsih_issue_tm: mpt3sas_cm0: host reset in progress!
    [  373.420300] sd 16:0:1:0: task abort: FAILED scmd(c000001fd4f2bd40)
    [  373.459961] sd 16:0:1:0: attempting device reset! scmd(c000001fd4f2bd40)
    ...
    [  373.460271] mpt3sas_scsih_issue_tm: mpt3sas_cm0: host reset in progress!
    [  373.460315] sd 16:0:1:0: device reset: FAILED scmd(c000001fd4f2bd40)
    [  373.460362] scsi target16:0:1: attempting target reset! scmd(c000001fd4f2bd40)
    ...
    [  373.460628] mpt3sas_scsih_issue_tm: mpt3sas_cm0: host reset in progress!
    [  373.460673] scsi target16:0:1: target reset: FAILED scmd(c000001fd4f2bd40)
    [  373.460720] mpt3sas_cm0: attempting host reset! scmd(c000001fd4f2bd40)
    [  373.460764] sd 16:0:1:0: [sdf] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
    [  373.460821] Unable to handle kernel paging request for data at address 0xd0003800817d0000
    [  373.460876] Faulting instruction address: 0xd000000017b169b8
    [  373.460921] Oops: Kernel access of bad area, sig: 11 [#1]
    ...
    [  373.462028] NIP [d000000017b169b8] mpt3sas_base_get_iocstate+0x38/0xb0 [mpt3sas]
    [  373.462085] LR [d000000017b1a3f0] mpt3sas_base_hard_reset_handler+0x1a0/0x6d0 [mpt3sas]
    [  373.462138] Call Trace:
    [  373.462160] [c000001fdf5f7ab0] [d000000017b1a3f0] mpt3sas_base_hard_reset_handler+0x1a0/0x6d0 [mpt3sas]
    [  373.462225] [c000001fdf5f7b80] [d000000017b20f6c] scsih_host_reset+0x7c/0x100 [mpt3sas]
    [  373.462281] [c000001fdf5f7c00] [c00000000076f34c] scsi_try_host_reset+0x5c/0x140
    [  373.462335] [c000001fdf5f7c40] [c00000000077107c] scsi_eh_ready_devs+0x73c/0x960
    [  373.462390] [c000001fdf5f7d10] [c000000000772800] scsi_error_handler+0x4c0/0x4e0
    [  373.462444] [c000001fdf5f7dc0] [c000000000107ed4] kthread+0x164/0x1b0
    [  373.462490] [c000001fdf5f7e30] [c00000000000b5a0] ret_from_kernel_thread+0x5c/0xbc
    [  373.468473] Instruction dump:

With patch:

    [  332.994654] setting logging_level(0x10000000)
    [  333.024246] mpt3sas_cm0: skip free_smid/scsi_done scmd(c000003c97348140)
    [  334.232041] sd 16:0:1:0: [sdf] Synchronizing SCSI cache
    [  334.232324] sd 16:0:0:0: [sde] Synchronizing SCSI cache
    [  334.232598] mpt3sas_cm0: sending diag reset !!
    [  335.352533] mpt3sas_cm0: diag reset: SUCCESS
    [  335.372075] mpt3sas_cm0: sleep on shutdown
    [  336.440544] mpt3sas_cm0: sleep on shutdown
    ...
    [  343.100179] sd 16:0:1:0: attempting task abort! scmd(c000003c97348140)
    ...
    [  343.100488] sd 16:0:1:0: device been deleted! scmd(c000003c97348140)
    [  343.100532] sd 16:0:1:0: task abort: SUCCESS scmd(c000003c97348140)
    [  343.140185] sd 16:0:1:0: [sdf] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
    [  343.140275] sd 16:0:1:0: [sdf] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
    [  343.140338] print_req_error: I/O error, dev sdf, sector 0


scsih_dev/target/host_reset()
===========================

Without patch:

    [  101.077946] setting logging_level(0x11000000)
    [  101.110029] mpt3sas_cm0: skip free_smid/scsi_done scmd(c000001fb7a2dd40)
    [  102.356108] sd 16:0:1:0: [sdf] Synchronizing SCSI cache
    [  102.356396] sd 16:0:0:0: [sde] Synchronizing SCSI cache
    [  102.356647] mpt3sas_cm0: sending diag reset !!
    [  103.476380] mpt3sas_cm0: diag reset: SUCCESS
    [  103.492696] mpt3sas_cm0: sleep on shutdown
    [  104.512914] mpt3sas_cm0: sleep on shutdown
    ...
    [  111.732912] sd 16:0:1:0: attempting task abort! scmd(c000001fb7a2dd40)
    ...
    [  111.733202] mpt3sas_cm0: fail task abort scmd(c000001fb7a2dd40)
    [  111.733246] sd 16:0:1:0: task abort: FAILED scmd(c000001fb7a2dd40)
    [  111.772919] sd 16:0:1:0: attempting device reset! scmd(c000001fb7a2dd40)
    ...
    [  111.773177] mpt3sas_scsih_issue_tm: mpt3sas_cm0: host reset in progress!
    [  111.773222] sd 16:0:1:0: device reset: FAILED scmd(c000001fb7a2dd40)
    [  111.773266] scsi target16:0:1: attempting target reset! scmd(c000001fb7a2dd40)
    ...
    [  111.773528] mpt3sas_scsih_issue_tm: mpt3sas_cm0: host reset in progress!
    [  111.773574] scsi target16:0:1: target reset: FAILED scmd(c000001fb7a2dd40)
    [  111.773617] mpt3sas_cm0: attempting host reset! scmd(c000001fb7a2dd40)
    [  111.773662] sd 16:0:1:0: [sdf] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
    [  111.773721] Unable to handle kernel paging request for data at address 0xd000380081790000
    [  111.773773] Faulting instruction address: 0xd0000000179d69b8
    [  111.773818] Oops: Kernel access of bad area, sig: 11 [#1]
    ...
    [  111.774925] NIP [d0000000179d69b8] mpt3sas_base_get_iocstate+0x38/0xb0 [mpt3sas]
    [  111.774980] LR [d0000000179da3f0] mpt3sas_base_hard_reset_handler+0x1a0/0x6d0 [mpt3sas]
    [  111.775032] Call Trace:
    [  111.775054] [c000001fd995bab0] [d0000000179da3f0] mpt3sas_base_hard_reset_handler+0x1a0/0x6d0 [mpt3sas]
    [  111.775118] [c000001fd995bb80] [d0000000179e0f6c] scsih_host_reset+0x7c/0x100 [mpt3sas]
    [  111.775173] [c000001fd995bc00] [c00000000076f34c] scsi_try_host_reset+0x5c/0x140
    [  111.775227] [c000001fd995bc40] [c00000000077107c] scsi_eh_ready_devs+0x73c/0x960
    [  111.775280] [c000001fd995bd10] [c000000000772800] scsi_error_handler+0x4c0/0x4e0
    [  111.775333] [c000001fd995bdc0] [c000000000107ed4] kthread+0x164/0x1b0
    [  111.775378] [c000001fd995be30] [c00000000000b5a0] ret_from_kernel_thread+0x5c/0xbc
    [  111.778393] Instruction dump:

With patch:

    [   56.316855] setting logging_level(0x11000000)
    [   56.347607] mpt3sas_cm0: skip free_smid/scsi_done scmd(c000001fc3afb540)
    [   57.604052] sd 16:0:1:0: [sdf] Synchronizing SCSI cache
    [   57.604319] sd 16:0:0:0: [sde] Synchronizing SCSI cache
    [   57.604615] mpt3sas_cm0: sending diag reset !!
    [   58.725154] mpt3sas_cm0: diag reset: SUCCESS
    [   58.741245] mpt3sas_cm0: sleep on shutdown
    [   59.803191] mpt3sas_cm0: sleep on shutdown
    ...
    [   67.103187] sd 16:0:1:0: attempting task abort! scmd(c000001fc3afb540)
    ...
    [   67.103521] mpt3sas_cm0: fail task abort scmd(c000001fc3afb540)
    [   67.103569] sd 16:0:1:0: task abort: FAILED scmd(c000001fc3afb540)
    [   67.143193] sd 16:0:1:0: attempting device reset! scmd(c000001fc3afb540)
    ...
    [   67.143514] sd 16:0:1:0: device been deleted! scmd(c000001fc3afb540)
    [   67.143564] sd 16:0:1:0: device reset: SUCCESS scmd(c000001fc3afb540)
    [   67.143613] scsi target16:0:1: attempting target reset! scmd(c000001fc3afb540)
    ...
    [   67.143897] scsi target16:0:1: target been deleted! scmd(c000001fc3afb540)
    [   67.143944] scsi target16:0:1: target reset: SUCCESS scmd(c000001fc3afb540)
    [   67.143992] mpt3sas_cm0: attempting host reset! scmd(c000001fc3afb540)
    [   67.144040] sd 16:0:1:0: [sdf] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
    [   67.144096] mpt3sas_cm0: Blocking the host reset
    [   67.144133] mpt3sas_cm0: host reset: FAILED scmd(c000001fc3afb540)
    [   67.144179] sd 16:0:1:0: Device offlined - not ready after error recovery
    [   67.144228] sd 16:0:1:0: [sdf] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
    [   67.144295] sd 16:0:1:0: [sdf] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
    [   67.144351] print_req_error: I/O error, dev sdf, sector 0
