From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5/8] [SCSI] tgt: Pass pointers to virt_to_page(), not
 integers
Date: Wed, 21 Dec 2011 01:34:20 +0000
Message-ID: <1324431260.2844.150.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324430940.2844.144.camel@deadeye>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_tgt_if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 6209110..7199753 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -286,7 +286,7 @@ static int uspace_ring_map(struct vm_area_struct *vma, unsigned long addr,
 	int i, err;
 
 	for (i = 0; i < TGT_RING_PAGES; i++) {
-		struct page *page = virt_to_page(ring->tr_pages[i]);
+		struct page *page = virt_to_page((void *)ring->tr_pages[i]);
 		err = vm_insert_page(vma, addr, page);
 		if (err)
 			return err;
-- 
1.7.7.3
