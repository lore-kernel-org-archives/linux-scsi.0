From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug #1] arcmsr: read past end of array in arcmsr_report_sense_info()
Date: Fri, 7 Feb 2014 16:00:55 +0300
Message-ID: <20140207130055.GB6971@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24340 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaBGNA7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 08:00:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich@areca.com.tw
Cc: linux-scsi@vger.kernel.org

Hello Erich Chen,

The patch 1c57e86d75cf: "[SCSI] arcmsr: initial driver, version
1.20.00.13" from Jul 12, 2006, leads to the following static checker
warning:

	drivers/scsi/arcmsr/arcmsr_hba.c:816 arcmsr_report_sense_info()
	error: memcpy() 'ccb->arcmsr_cdb.SenseData' too small (15 vs 18)

drivers/scsi/arcmsr/arcmsr_hba.c
   805  static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
   806  {
   807  
   808          struct scsi_cmnd *pcmd = ccb->pcmd;
   809          struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
   810          pcmd->result = DID_OK << 16;
   811          if (sensebuffer) {
   812                  int sense_data_length =
   813                          sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
   814                          ? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
   815                  memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
   816                  memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
                                            ^^^^^^^^^^^^^^^^^^^^^^^^^
This buffer is 15 bytes but we copy 18 bytes so we are reading past the
end of the array.

   817                  sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
   818                  sensebuffer->Valid = 1;
   819          }
   820  }

regards,
dan carpenter
