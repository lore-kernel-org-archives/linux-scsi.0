From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Thu, 15 Sep 2016 15:01:42 +0300
Message-ID: <20160915120142.GA2349@mwanda>
References: <CAFkTriJHaO0-O0AXKWSZW6bXT_2m+VqRdwshFsgeq1=Bjfn_OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46311 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763064AbcIOMCF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2016 08:02:05 -0400
Content-Disposition: inline
In-Reply-To: <CAFkTriJHaO0-O0AXKWSZW6bXT_2m+VqRdwshFsgeq1=Bjfn_OQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Marco Grassi <marco.gra@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ching Huang <ching2048@areca.com.tw>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinicke <hare@suse.de>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, security@kernel.org

We need to put an upper bound on "user_len" so the memcpy() doesn't
overflow.

Reported-by: Marco Grassi <marco.gra@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 7640498..73ddd45 100644
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
@@ -2397,6 +2398,10 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 		}
 		ptmpuserbuffer = ver_addr;
 		user_len = pcmdmessagefld->cmdmessage.Length;
+		if (user_len > ARCMSR_API_DATA_BUFLEN) {
+			retvalue = ARCMSR_MESSAGE_FAIL;
+			goto message_out;
+		}
 		memcpy(ptmpuserbuffer,
 			pcmdmessagefld->messagedatabuffer, user_len);
 		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
