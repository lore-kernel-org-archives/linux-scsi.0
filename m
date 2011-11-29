From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] [SCSI] aacraid: Use kcalloc instead of kzalloc to allocate
 array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.328.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c 2011-11-13 11:07:45.697125064 +0100
+++ b/drivers/scsi/aacraid/aachba.c 2011-11-28 20:02:37.129376267 +0100
@@ -381,8 +381,8 @@ int aac_get_containers(struct aac_dev *d
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-	fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) * maximum_num_containers,
-			GFP_KERNEL);
+	fsa_dev_ptr = kcalloc(maximum_num_containers, sizeof(*fsa_dev_ptr),
+			      GFP_KERNEL);
 	if (!fsa_dev_ptr)
 		return -ENOMEM;
 
