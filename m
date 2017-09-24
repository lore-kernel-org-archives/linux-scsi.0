From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC] apparently broken error recovery in vhost_scsi_iov_to_sgl()
Date: Sun, 24 Sep 2017 23:36:33 +0100
Message-ID: <20170924223633.GV32076@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48108 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753122AbdIXWgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 18:36:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-scsi@vger.kernel.org

Suppose vhost_scsi_iov_to_sgl() got a two-iovec array, mapped
e.g. 20 pages from the first one just fine and failed on the
second.

static int
vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
                      struct iov_iter *iter,
                      struct scatterlist *sg, int sg_count)
{
        size_t off = iter->iov_offset;
        int i, ret;

        for (i = 0; i < iter->nr_segs; i++) {
                void __user *base = iter->iov[i].iov_base + off;
                size_t len = iter->iov[i].iov_len - off;

                ret = vhost_scsi_map_to_sgl(cmd, base, len, sg, write);
                if (ret < 0) {
                        for (i = 0; i < sg_count; i++) {
                                struct page *page = sg_page(&sg[i]);
                                if (page)
                                        put_page(page);
                        }
                        return ret;
                }
                sg += ret;
                off = 0;
        }
        return 0;
}

What are we trying to drop in the if (ret < 0) in there?  In the case
above we step into it on the second pass through the loop.  The first
20 entries of sg had been filled... and sg had been increased by 20,
so whatever we find and feed to put_page(), it won't be those 20 pages.
Moreover, the caller will reset cmd->tvc_{prot_,}sgl_count to zero,
so vhost_scsi_release_cmd() won't find them either.

Am I missing something subtle here, or should that thing be doing
something like

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 046f6d280af5..e47c5bc3ddca 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -688,6 +688,7 @@ vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
 		      struct scatterlist *sg, int sg_count)
 {
 	size_t off = iter->iov_offset;
+	struct scatterlist *p = sg;
 	int i, ret;
 
 	for (i = 0; i < iter->nr_segs; i++) {
@@ -696,8 +697,8 @@ vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
 
 		ret = vhost_scsi_map_to_sgl(cmd, base, len, sg, write);
 		if (ret < 0) {
-			for (i = 0; i < sg_count; i++) {
-				struct page *page = sg_page(&sg[i]);
+			while (p < sg) {
+				struct page *page = sg_page(p++);
 				if (page)
 					put_page(page);
 			}
