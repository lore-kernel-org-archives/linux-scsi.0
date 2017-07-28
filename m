From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 12/22] zfcp: trace high part of "new" 64 bit SCSI LUN
Date: Fri, 28 Jul 2017 12:30:58 +0200
Message-ID: <ade49024ff006ff9316d8e1f6195141b3b2e6106.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49342 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751776AbdG1KbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:14 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASvW5056057
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bywagyb3f-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:13 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:11 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAVAWk35258554
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A8CB4C0AC
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:40 +0100 (BST)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80BA84C0B3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:40 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:40 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, stable@vger.kernel.org, Jens Remus <jremus@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Steffen Maier <maier@linux.vnet.ibm.com>

Complements debugging aspects of the otherwise functionally complete
v3.17 commit 9cb78c16f5da ("scsi: use 64-bit LUNs").

While I don't have access to a target exporting 3 or 4 level LUNs,
I did test it by explicitly attaching a non-existent fake 4 level LUN
by means of zfcp sysfs attribute "unit_add".
In order to see corresponding trace records of otherwise successful
events, we had to increase the trace level of area SCSI and HBA to 6.

$ echo 6 > /sys/kernel/debug/s390dbf/zfcp_0.0.1880_scsi/level
$ echo 6 > /sys/kernel/debug/s390dbf/zfcp_0.0.1880_hba/level

$ echo 0x4011402240334044 > \
  /sys/bus/ccw/drivers/zfcp/0.0.1880/0x50050763031bd327/unit_add

Example output formatted by an updated zfcpdbf from the s390-tools
package interspersed with kernel messages at scsi_logging_level=4605:

Timestamp      : ...
Area           : REC
Subarea        : 00
Level          : 1
Exception      : -
CPU ID         : ..
Caller         : 0x...
Record ID      : 1
Tag            : scsla_1
LUN            : 0x4011402240334044
WWPN           : 0x50050763031bd327
D_ID           : 0x00......
Adapter status : 0x5400050b
Port status    : 0x54000001
LUN status     : 0x41000000
Ready count    : 0x00000001
Running count  : 0x00000000
ERP want       : 0x01
ERP need       : 0x01

scsi 2:0:0:4630896905707208721: scsi scan: INQUIRY pass 1 length 36
scsi 2:0:0:4630896905707208721: scsi scan: INQUIRY successful with code 0x0

Timestamp      : ...
Area           : HBA
Subarea        : 00
Level          : 6
Exception      : -
CPU ID         : ..
Caller         : 0x...
Record ID      : 1
Tag            : fs_norm
Request ID     : 0x<inquiry2-req-id>
Request status : 0x00000010
FSF cmnd       : 0x00000001
FSF sequence no: 0x...
FSF issued     : ...
FSF stat       : 0x00000000
FSF stat qual  : 00000000 00000000 00000000 00000000
Prot stat      : 0x00000001
Prot stat qual : ........ ........ 00000000 00000000
Port handle    : 0x...
LUN handle     : 0x...
|
Timestamp      : ...
Area           : SCSI
Subarea        : 00
Level          : 6
Exception      : -
CPU ID         : ..
Caller         : 0x...
Record ID      : 1
Tag            : rsl_nor
Request ID     : 0x<inquiry2-req-id>
SCSI ID        : 0x00000000
SCSI LUN       : 0x40224011
SCSI LUN high  : 0x40444033 <=======================
SCSI result    : 0x00000000
SCSI retries   : 0x00
SCSI allowed   : 0x03
SCSI scribble  : 0x<inquiry2-req-id>
SCSI opcode    : 12000000 a4000000 00000000 00000000
FCP rsp inf cod: 0x00
FCP rsp IU     : 00000000 00000000 00000000 00000000
                 00000000 00000000

scsi 2:0:0:4630896905707208721: scsi scan: INQUIRY pass 2 length 164
scsi 2:0:0:4630896905707208721: scsi scan: INQUIRY successful with code 0x0
scsi 2:0:0:4630896905707208721: scsi scan: peripheral device type of 31, \
no device added

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: 9cb78c16f5da ("scsi: use 64-bit LUNs")
Cc: <stable@vger.kernel.org> #3.17+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 2 +-
 drivers/s390/scsi/zfcp_dbf.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index c801f9782cb2..34367d172961 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -563,8 +563,8 @@ void zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *sc,
 	rec->scsi_retries = sc->retries;
 	rec->scsi_allowed = sc->allowed;
 	rec->scsi_id = sc->device->id;
-	/* struct zfcp_dbf_scsi needs to be updated to handle 64bit LUNs */
 	rec->scsi_lun = (u32)sc->device->lun;
+	rec->scsi_lun_64_hi = (u32)(sc->device->lun >> 32);
 	rec->host_scribble = (unsigned long)sc->host_scribble;
 
 	memcpy(rec->scsi_opcode, sc->cmnd,
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index 8e7f8e6037d2..b60667c145fd 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -204,7 +204,7 @@ enum zfcp_dbf_scsi_id {
  * @id: unique number of recovery record type
  * @tag: identifier string specifying the location of initiation
  * @scsi_id: scsi device id
- * @scsi_lun: scsi device logical unit number
+ * @scsi_lun: scsi device logical unit number, low part of 64 bit, old 32 bit
  * @scsi_result: scsi result
  * @scsi_retries: current retry number of scsi request
  * @scsi_allowed: allowed retries
@@ -214,6 +214,7 @@ enum zfcp_dbf_scsi_id {
  * @host_scribble: LLD specific data attached to SCSI request
  * @pl_len: length of paload stored as zfcp_dbf_pay
  * @fsf_rsp: response for fsf request
+ * @scsi_lun_64_hi: scsi device logical unit number, high part of 64 bit
  */
 struct zfcp_dbf_scsi {
 	u8 id;
@@ -230,6 +231,7 @@ struct zfcp_dbf_scsi {
 	u64 host_scribble;
 	u16 pl_len;
 	struct fcp_resp_with_ext fcp_rsp;
+	u32 scsi_lun_64_hi;
 } __packed;
 
 /**
-- 
2.11.2
