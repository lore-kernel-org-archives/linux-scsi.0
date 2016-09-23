From: Borislav Petkov <bp@alien8.de>
Subject: Re: [patch v2] arcmsr: buffer overflow in arcmsr_iop_message_xfer()
Date: Fri, 23 Sep 2016 13:22:26 +0200
Message-ID: <20160923112226.rteir5ivjou64ffh@pd.tnic>
References: <20160915134456.GA30277@mwanda>
 <yq17fadz2l6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.skyhub.de ([78.46.96.112]:60181 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755175AbcIWLWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Sep 2016 07:22:35 -0400
Content-Disposition: inline
In-Reply-To: <yq17fadz2l6.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Ching Huang <ching2048@areca.com.tw>, Hannes Reinicke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org, security@kernel.org

On Thu, Sep 15, 2016 at 09:59:01AM -0400, Martin K. Petersen wrote:
> >>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> Dan> We need to put an upper bound on "user_len" so the memcpy() doesn't
> Dan> overflow.
> 
> Applied to 4.9/scsi-queue.

Yap, Tomas said the kfree was missing on the error path but can we
simplify this further by doing the user_len check first so that the
kfree() is not even needed?

Patch ontop:

---
From: Borislav Petkov <bp@suse.de>
Date: Fri, 23 Sep 2016 13:04:51 +0200
Subject: [PATCH] scsi: arcmsr: Simplify user_len checking

Do the user_len check first and then the ver_addr allocation so that
we can save us the kfree() on the error path when user_len is >
ARCMSR_API_DATA_BUFLEN.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Marco Grassi <marco.gra@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tomas Henzl <thenzl@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 110eca9eaca0..3d53d636b17b 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2391,18 +2391,20 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 		uint32_t user_len;
 		int32_t cnt2end;
 		uint8_t *pQbuffer, *ptmpuserbuffer;
-		ver_addr = kmalloc(ARCMSR_API_DATA_BUFLEN, GFP_ATOMIC);
-		if (!ver_addr) {
+
+		user_len = pcmdmessagefld->cmdmessage.Length;
+		if (user_len > ARCMSR_API_DATA_BUFLEN) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
 			goto message_out;
 		}
-		ptmpuserbuffer = ver_addr;
-		user_len = pcmdmessagefld->cmdmessage.Length;
-		if (user_len > ARCMSR_API_DATA_BUFLEN) {
+
+		ver_addr = kmalloc(ARCMSR_API_DATA_BUFLEN, GFP_ATOMIC);
+		if (!ver_addr) {
 			retvalue = ARCMSR_MESSAGE_FAIL;
-			kfree(ver_addr);
 			goto message_out;
 		}
+		ptmpuserbuffer = ver_addr;
+
 		memcpy(ptmpuserbuffer,
 			pcmdmessagefld->messagedatabuffer, user_len);
 		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
-- 
1.8.5.2

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
