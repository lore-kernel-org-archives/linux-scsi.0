From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH 4/6][RESEND] Emulex FC HBA driver: fix overflow of statically allocated array
Date: Mon, 13 Aug 2007 00:21:06 +0200
Message-ID: <200708130021.07068.jesper.juhl@gmail.com>
References: <200708130016.11281.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:44067 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbXHLWXc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 18:23:32 -0400
Received: by ug-out-1314.google.com with SMTP id j3so542189ugf
        for <linux-scsi@vger.kernel.org>; Sun, 12 Aug 2007 15:23:31 -0700 (PDT)
In-Reply-To: <200708130016.11281.jesper.juhl@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jesper Juhl <jesper.juhl@gmail.com>

(previously send on 09-Aug-2007 20:47)

Hi,

The Coverity checker noticed that we may overrun a statically allocated 
array in drivers/scsi/lpfc/lpfc_sli.c::lpfc_sli_hbqbuf_find().

The case is this; In 'struct lpfc_hba' we have 

	#define LPFC_MAX_HBQS  4
	...
	struct lpfc_hba {
		...
		struct hbq_s hbqs[LPFC_MAX_HBQS];
		...
	};

But then in lpfc_sli_hbqbuf_find() we have this code 

	hbqno = tag >> 16;
	if (hbqno > LPFC_MAX_HBQS)
		return NULL;

if 'hbqno' ends up as exactely 4, then we won't return, and then this

	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {

will cause an overflow of the statically allocated array at index 4, 
since the valid indices are only 0-3. 

I propose this patch, that simply changes the 'hbqno > LPFC_MAX_HBQS' 
into 'hbqno >= LPFC_MAX_HBQS' as a possible fix.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
---

 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ce5ff2b..e5337ad 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -675,7 +675,7 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 	uint32_t hbqno;
 
 	hbqno = tag >> 16;
-	if (hbqno > LPFC_MAX_HBQS)
+	if (hbqno >= LPFC_MAX_HBQS)
 		return NULL;
 
 	list_for_each_entry(d_buf, &phba->hbqs[hbqno].hbq_buffer_list, list) {



