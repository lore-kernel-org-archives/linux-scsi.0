From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 06/17] Update the infiniband uverbs driver to use idr helper functions.
Date: Wed, 16 Sep 2015 10:50:24 -0700
Message-ID: <da24a58bf9766c2cf1d2fe4019c9efc586306a9c.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jthumshirn@suse.de, hch@infradead.org, Lee Duncan <lduncan@suse.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/infiniband/core/uverbs_cmd.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bbb02ffe87df..1e5b2a66a501 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -120,24 +120,16 @@ static int idr_add_uobj(struct idr *idr, struct ib_uobject *uobj)
 {
 	int ret;
 
-	idr_preload(GFP_KERNEL);
-	spin_lock(&ib_uverbs_idr_lock);
-
-	ret = idr_alloc(idr, uobj, 0, 0, GFP_NOWAIT);
+	ret = idr_get_index(idr, &ib_uverbs_idr_lock, uobj);
 	if (ret >= 0)
 		uobj->id = ret;
 
-	spin_unlock(&ib_uverbs_idr_lock);
-	idr_preload_end();
-
 	return ret < 0 ? ret : 0;
 }
 
 void idr_remove_uobj(struct idr *idr, struct ib_uobject *uobj)
 {
-	spin_lock(&ib_uverbs_idr_lock);
-	idr_remove(idr, uobj->id);
-	spin_unlock(&ib_uverbs_idr_lock);
+	idr_put_index(idr, &ib_uverbs_idr_lock, uobj->id);
 }
 
 static struct ib_uobject *__idr_get_uobj(struct idr *idr, int id,
-- 
2.1.4
