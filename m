From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [v2] sbitmap, scsi/target: add seq_file forward declaration
Date: Fri,  6 Jul 2018 22:19:07 +0200
Message-ID: <20180706201920.2185565-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Felipe Balbi <felipe.balbi@linux.intel.com>, Matthew Wilcox <willy@infradead.org>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The target core runs into a warning in the linux/sbitmap.h
file in some configurations:

In file included from include/target/target_core_base.h:7,
                 from drivers/target/target_core_fabric_lib.c:41:
include/linux/sbitmap.h:331:46: error: 'struct seq_file' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
 void sbitmap_show(struct sbitmap *sb, struct seq_file *m);
                                              ^~~~~~~~

In general, headers should not depend on others being included first,
so this fixes it with a forward declaration for that struct name, but
we probably want to merge the patch through the scsi tree to help
bisection.

Fixes: 10e9cbb6b531 ("scsi: target: Convert target drivers to use sbitmap")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: move declaration to the start of the header, as suggested by Bart
---
 include/linux/sbitmap.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/sbitmap.h b/include/linux/sbitmap.h
index e6539536dea9..804a50983ec5 100644
--- a/include/linux/sbitmap.h
+++ b/include/linux/sbitmap.h
@@ -23,6 +23,8 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
+struct seq_file;
+
 /**
  * struct sbitmap_word - Word in a &struct sbitmap.
  */
-- 
2.9.0
