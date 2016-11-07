From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 0/2] qla2xxx: fix errors in PCI device remove with ongoing I/O
Date: Mon,  7 Nov 2016 17:53:29 -0200
Message-ID: <1478548411-17932-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750926AbcKGTxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2016 14:53:41 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uA7Jn1HY047990
        for <linux-scsi@vger.kernel.org>; Mon, 7 Nov 2016 14:53:40 -0500
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26jsq5ncmj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Nov 2016 14:53:40 -0500
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 7 Nov 2016 17:53:38 -0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patchset addresses a couple of errors that might happen during
PCI device remove (e.g., PCI hotplug, PowerVM DLPAR), which prevent
the successful removal and re-addition of the adapter to the system,
and cause an oops and/or invalid DMA access (triggers an EEH event).

It allowed several cycles of PCI device add/remove with ongoing I/O,
to complete successfully without triggering oopses or EEH events.

Verified on v4.9-rc3.

Test-case:
---
    # lspci
    <...>
    001d:70:00.0 Fibre Channel: QLogic Corp. ISP2532-based ...
    001d:70:00.1 Fibre Channel: QLogic Corp. ISP2532-based ...
    <...>

    # for sd in $(find /sys/bus/pci/devices/001d:70:00.*/ \
                       -name 'sd*' -printf "%f\n"); do \
        dd if=/dev/$sd of=/dev/null iflag=nocache & done

    # echo 1 | tee /sys/bus/pci/devices/001d:70:00.*/remove
    (this either works or not)

    # echo 1 > /sys/bus/pci/rescan

Before:
---
    <...>
    EEH: Frozen PHB#1d-PE#700000 detected
    qla2xxx [001d:70:00.1]-8042:2: PCI/Register disconnect, exiting.
    <...>
    EEH: Detected PCI bus error on PHB#29-PE#700000
    <...>
    (and/or)
    Unable to handle kernel paging request for data at address 0x00000138
    <...>
    NIP [d000000004700a40] qla2xxx_queuecommand+0x80/0x3f0 [qla2xxx]
    LR [d000000004700a10] qla2xxx_queuecommand+0x50/0x3f0 [qla2xxx]

    (command does not return; adapter cannot be re-added)

After:
---
    <...>
    qla2xxx [001d:70:00.0]-801c:1: Abort command issued nexus=1:0:0 --  1 2003.
    <...>
    qla2xxx [001d:70:00.1]-801c:2: Abort command issued nexus=2:3:0 --  1 2003.
    <...>

    (command does return; adapter can be re-added correctly)


Mauricio Faria de Oliveira (2):
  qla2xxx: do not queue commands when unloading
  qla2xxx: fix invalid DMA access after command aborts in PCI device
    remove

 drivers/scsi/qla2xxx/qla_os.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

-- 
1.8.3.1

