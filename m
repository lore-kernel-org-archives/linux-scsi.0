From: akpm@linux-foundation.org
Subject: [patch 16/26] scsi/sd.c: quiet all sparse noise
Date: Mon, 24 May 2010 12:22:33 -0700
Message-ID: <201005241922.o4OJMX6A011330@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756850Ab0EXTWi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 May 2010 15:22:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, hartleys@visionengravers.com, James.Bottomley@suse.de, hsweeten@visionengravers.com

From: H Hartley Sweeten <hartleys@visionengravers.com>

In sd_store_cache_type the symbol 'len' is declared twice.  Remove the
second declaration to quiet the following sparse warning.

warning: symbol 'len' shadows an earlier one

In sd_probe the variable 'index' is declared as a u32.  This variable is
used in a call to ida_get_new which is expecting an int *.  Make the
variable an int to quiet the following sparse warning.

warning: incorrect type in argument 2 (different signedness)

There are 4 symbols in the file that are not exported and produce
the following sparse warnings.

warning: symbol 'sd_cdb_cache' was not declared. Should it be static?
warning: symbol 'sd_cdb_pool' was not declared. Should it be static?
warning: symbol 'sd_read_protection_type' was not declared. Should it be static?
warning: symbol 'sd_read_app_tag_own' was not declared. Should it be static?

Make them static to quiet the warnings.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/sd.c~scsi-sdc-quiet-all-sparse-noise drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~scsi-sdc-quiet-all-sparse-noise
+++ a/drivers/scsi/sd.c
@@ -117,8 +117,8 @@ static DEFINE_IDA(sd_index_ida);
  * object after last put) */
 static DEFINE_MUTEX(sd_ref_mutex);
 
-struct kmem_cache *sd_cdb_cache;
-mempool_t *sd_cdb_pool;
+static struct kmem_cache *sd_cdb_cache;
+static mempool_t *sd_cdb_pool;
 
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
@@ -145,7 +145,7 @@ sd_store_cache_type(struct device *dev, 
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(sd_cache_types); i++) {
-		const int len = strlen(sd_cache_types[i]);
+		len = strlen(sd_cache_types[i]);
 		if (strncmp(sd_cache_types[i], buf, len) == 0 &&
 		    buf[len] == '\n') {
 			ct = i;
@@ -1373,7 +1373,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 /*
  * Determine whether disk supports Data Integrity Field.
  */
-void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
+static void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdp = sdkp->device;
 	u8 type;
@@ -1919,7 +1919,7 @@ defaults:
  * The ATO bit indicates whether the DIF application tag is available
  * for use by the operating system.
  */
-void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
+static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	int res, offset;
 	struct scsi_device *sdp = sdkp->device;
@@ -2244,7 +2244,7 @@ static int sd_probe(struct device *dev)
 	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	u32 index;
+	int index;
 	int error;
 
 	error = -ENODEV;
_
