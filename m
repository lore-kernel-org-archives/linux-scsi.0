From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [RFC 0/2] scsi: Add poll_queue mechanism
Date: Thu, 16 Mar 2017 14:40:46 -0700
Message-ID: <20170316214048.20481-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0044.outbound.protection.outlook.com ([104.47.36.44]:27566
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752562AbdCPWRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 18:17:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, darren.trapp@cavium.com

Hi James/Martin,

This is RFC to get comment about propose poll_queue interface in scsi layer.

The blk_mq layer allows polling a transport for a specific completion if
the HIPRI request flag is set. This can be accomplished by using
"libengine=pvsync2 –hipri" option in FIO tool. This flag then allows
polling into LLDD to service specific compeletion queue for IOs. It also
removes the interrupt latency and significantly improved performance in NVMeF 
that utilizes it. There is expense of higher CPU utlization due to active polling.
    
Here's sample results for comparision
    
FiO command line with synchronous IO’s results in latency avg=32.73us reported by FIO

./fio/fio  --time_based --ioengine=sync --direct=1 --runtime=30 --readwrite=read \
    --iodepth=1 --blocksize=4k --name=job0 --group_reporting --filename=/dev/sdd
    
FIO command line with active polling IO’s results in latency avg=26.04 reported by FIO

./fio/fio  --time_based --ioengine=pvsync2 --hipri --direct=1 --runtime=30 \
    --readwrite=read --iodepth=1 --blocksize=4k --name=job0 --group_reporting \
    --filename=/dev/sdd
    
FIO version 2.17

Thanks,
Himanshu

Darren Trapp (2):
  scsi: Provide mechanism for SCSI layer to poll for LLDD.
  qla2xxx: Driver changes to use new poll_queue() callback

 drivers/scsi/qla2xxx/qla_os.c | 36 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c       | 39 +++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_host.h      | 12 ++++++++++++
 3 files changed, 87 insertions(+)

-- 
2.12.0
