From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Thu, 15 Sep 2016 16:44:56 +0300
Message-ID: <20160915134456.GA30277@mwanda>
References: <ff1f18b9-8e5b-93d8-1292-c74529676066@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16575 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754732AbcIONp1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 09:45:27 -0400
Content-Disposition: inline
In-Reply-To: <ff1f18b9-8e5b-93d8-1292-c74529676066@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, Hannes Reinicke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, security@kernel.org

We need to put an upper bound on "user_len" so the memcpy() doesn't
overflow.

Reported-by: Marco Grassi <marco.gra@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 7640498..110eca9 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2388,7 +2388,8 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 	}
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
 		unsigned char *ver_addr;
-		int32_t user_len, cnt2end;
+		uint32_t user_len;
+		int32_t cnt2end;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
 		ver_addr = kmalloc(ARCMSR_API_DATA_BUFLEN, GFP_ATOMIC);
 		if (!ver_addr) {
@@ -2397,6 +2398,11 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 		}
 		ptmpuserbuffer = ver_addr;
 		user_len = pcmdmessagefld->cmdmessage.Length;
+		if (user_len > ARCMSR_API_DATA_BUFLEN) {
+			retvalue = ARCMSR_MESSAGE_FAIL;
+			kfree(ver_addr);
+			goto message_out;
+		}
 		memcpy(ptmpuserbuffer,
 			pcmdmessagefld->messagedatabuffer, user_len);
 		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
