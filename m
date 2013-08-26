From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 3/9] target: Make helpers non static for EXTENDED_COPY command setup
Date: Mon, 26 Aug 2013 22:03:02 +0000
Message-ID: <1377554588-28394-4-git-send-email-nab@daterainc.com>
References: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Both target_alloc_sgl() and transport_generic_map_mem_to_cmd() are
required by EXTENDED_COPY logic when setting up internally dispatched
command descriptors, so go ahead and make both of these non static.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Zach Brown <zab@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |    4 ++--
 include/target/target_core_backend.h   |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 526e5ba..6d0e523 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1253,7 +1253,7 @@ int transport_handle_cdb_direct(
 }
 EXPORT_SYMBOL(transport_handle_cdb_direct);
 
-static sense_reason_t
+sense_reason_t
 transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
 		u32 sgl_count, struct scatterlist *sgl_bidi, u32 sgl_bidi_count)
 {
@@ -2116,7 +2116,7 @@ void transport_kunmap_data_sg(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(transport_kunmap_data_sg);
 
-static int
+int
 target_alloc_sgl(struct scatterlist **sgl, unsigned int *nents, u32 length,
 		 bool zero_page)
 {
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 77f25e0..5ebe21c 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -74,6 +74,10 @@ int	transport_set_vpd_ident(struct t10_vpd *, unsigned char *);
 /* core helpers also used by command snooping in pscsi */
 void	*transport_kmap_data_sg(struct se_cmd *);
 void	transport_kunmap_data_sg(struct se_cmd *);
+/* core helpers also used by xcopy during internal command setup */
+int	target_alloc_sgl(struct scatterlist **, unsigned int *, u32, bool);
+sense_reason_t	transport_generic_map_mem_to_cmd(struct se_cmd *,
+		struct scatterlist *, u32, struct scatterlist *, u32);
 
 void	array_free(void *array, int n);
 
-- 
1.7.2.5
