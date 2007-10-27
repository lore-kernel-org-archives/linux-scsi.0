From: Rob Landley <rob@landley.net>
Subject: [PATCH 7/15] Update kerneldoc comments in drivers/scsi/scsi_lib.c
Date: Fri, 26 Oct 2007 23:12:03 -0500
Message-ID: <200710262312.03364.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35971
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751485AbXJ0DMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:12:18 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id D06B273938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:15:02 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_lib.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_lib.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_lib.c	Fri Oct 26 22:44:42 2007 -0500
@@ -274,7 +274,7 @@ static void scsi_bi_endio(struct bio *bi
 /**
  * scsi_req_map_sg - map a scatterlist into a request
  * @rq:		request to fill
- * @sg:		scatterlist
+ * @sgl:	scatterlist
  * @nsegs:	number of elements
  * @bufflen:	len of buffer
  * @gfp:	memory allocation flags
@@ -365,13 +365,15 @@ free_bios:
  * @sdev:	scsi device
  * @cmd:	scsi command
  * @cmd_len:	length of scsi cdb
- * @data_direction: data direction
+ * @data_direction: DMA_TO_DEVICE, DMA_FROM_DEVICE, or DMA_NONE
  * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
  * @bufflen:	len of buffer
  * @use_sg:	if buffer is a scatterlist this is the number of elements
  * @timeout:	request timeout in seconds
  * @retries:	number of times to retry request
- * @flags:	or into request flags
+ * @privdata:	data passed to done()
+ * @done:	callback function when done
+ * @gfp:	memory allocation flags
  **/
 int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
 		       int cmd_len, int data_direction, void *buffer, unsigned bufflen,
@@ -1804,7 +1806,7 @@ void scsi_exit_queue(void)
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
- *	@sense: place to put sense data (or NULL if no sense to be collected).
+ *	@sshdr: place to put sense data (or NULL if no sense to be collected).
  *		must be SCSI_SENSE_BUFFERSIZE big.
  *
  *	Returns zero if successful; negative error number or scsi
@@ -1881,7 +1883,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	@timeout: command timeout
  *	@retries: number of retries before failing
  *	@data: returns a structure abstracting the mode header data
- *	@sense: place to put sense data (or NULL if no sense to be collected).
+ *	@sshdr: place to put sense data (or NULL if no sense to be collected).
  *		must be SCSI_SENSE_BUFFERSIZE big.
  *
  *	Returns zero if unsuccessful, or the header offset (either 4
@@ -2324,7 +2326,7 @@ EXPORT_SYMBOL_GPL(scsi_target_unblock);
 
 /**
  * scsi_kmap_atomic_sg - find and atomically map an sg-elemnt
- * @sg:		scatter-gather list
+ * @sgl:	scatter-gather list
  * @sg_count:	number of segments in sg
  * @offset:	offset in bytes into sg, on return offset into the mapped area
  * @len:	bytes to map, on return number of bytes mapped

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
