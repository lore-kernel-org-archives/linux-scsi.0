From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: advansys: use struct_size() in kzalloc()
Date: Fri, 4 Jan 2019 15:22:09 -0600
Message-ID: <20190104212209.GA15250@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

One of the more common cases of allocation size calculations is finding the
size of a structure that has a zero-sized array at the end, along with memory
for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can now
use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/advansys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d37584403c33..6c274e6e1c33 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7576,8 +7576,8 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 			return ASC_ERROR;
 		}
 
-		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
-			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
+		asc_sg_head = kzalloc(struct_size(asc_sg_head, sg_list, use_sg),
+				      GFP_ATOMIC);
 		if (!asc_sg_head) {
 			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_SOFT_ERROR);
-- 
2.20.1
