From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: osst: Use struct_size() in kzalloc()
Date: Wed, 19 Jun 2019 14:41:26 -0500
Message-ID: <20190619194126.GA3069@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Willem Riede <osst@riede.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct osst_buffer {
  ...
  struct scatterlist sg[1];    /* MUST BE last item                               */
} ;

i = sizeof(struct osst_buffer) + (osst_max_sg_segs - 1) * sizeof(struct scatterlist);
instance = kzalloc(i, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, sg, count), GFP_KERNEL);

Notice that, in this case, variable i is not necessary, hence it
is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/osst.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 815bb4097c1b..a11455a7e6bf 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5307,7 +5307,6 @@ static long osst_compat_ioctl(struct file * file, unsigned int cmd_in, unsigned
 /* Try to allocate a new tape buffer skeleton. Caller must not hold os_scsi_tapes_lock */
 static struct osst_buffer * new_tape_buffer( int from_initialization, int need_dma, int max_sg )
 {
-	int i;
 	gfp_t priority;
 	struct osst_buffer *tb;
 
@@ -5316,8 +5315,7 @@ static struct osst_buffer * new_tape_buffer( int from_initialization, int need_d
 	else
 		priority = GFP_KERNEL;
 
-	i = sizeof(struct osst_buffer) + (osst_max_sg_segs - 1) * sizeof(struct scatterlist);
-	tb = kzalloc(i, priority);
+	tb = kzalloc(struct_size(tb, sg, osst_max_sg_segs - 1), priority);
 	if (!tb) {
 		printk(KERN_NOTICE "osst :I: Can't allocate new tape buffer.\n");
 		return NULL;
-- 
2.21.0
