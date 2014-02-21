From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 7/11] arcmsr: Notify sense data report
Date: Fri, 21 Feb 2014 12:13:58 +0800
Message-ID: <CAKiknE-p8Lz+3AMR9jVBbFQFQs1DNE=b-9RKBq-w4QyunmP5XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Ching <ching2048@areca.com.tw>

Notify sense data report

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:03:28.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:04:10.000000000 +0800
@@ -906,7 +906,7 @@ static void arcmsr_report_sense_info(str

        struct scsi_cmnd *pcmd = ccb->pcmd;
        struct SENSE_DATA *sensebuffer = (struct SENSE_DATA
*)pcmd->sense_buffer;
-       pcmd->result = DID_OK << 16;
+       pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
        if (sensebuffer) {
                int sense_data_length =
                        sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
@@ -915,6 +915,7 @@ static void arcmsr_report_sense_info(str
                memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData,
sense_data_length);
                sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
                sensebuffer->Valid = 1;
+               pcmd->result |= (DRIVER_SENSE << 24);
        }
 }
