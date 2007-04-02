From: David Miller <davem@davemloft.net>
Subject: [PATCH]: Fix scsi_send_eh_cmnd scatterlist handling
Date: Mon, 02 Apr 2007 12:24:39 -0700 (PDT)
Message-ID: <20070402.122439.71098419.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48905
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965724AbXDBTYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 15:24:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, tcallawa@redhat.com


This fixes a regression caused by commit:

2dc611de5a3fd955cd0298c50691d4c05046db97

The sense buffer code in scsi_send_eh_cmnd was changed to use
alloc_page() and a scatter list, but the sense data copy was not
updated to match so what we actually get in the sense buffer is total
grabage starting with the kernel address of the struct page we got.
Basically the stack frame of scsi_send_eh_cmd() is what ends up
in the sense buffer.

Depending upon how pointers look on a given platform, you can
end up getting sr_ioctl.c errors when you mount a cdrom.  If
the CDROM gives a check condition for GPCMD_GET_CONFIGURATION issued
by drivers/cdrom/cdrom.c:cdrom_mmc_profile(), sr_ioctl will
spit out this error message in sr_do_ioctl() with the way pointers
are on sparc64:

		default:
			printk(KERN_ERR "%s: CDROM (ioctl) error, command: ", cd->cdi.name);
			__scsi_print_command(cgc->cmd);
			scsi_print_sense_hdr("sr", &sshdr);
			err = -EIO;

This is the error Tom Callaway reported in:

http://marc.info/?l=linux-sparc&m=117407453208101&w=2

Anyways, fix this by using page_address(sgl.page) which is OK
because we know this is low-mem due to GFP_ATOMIC.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b8edcf5..918bb60 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -716,7 +716,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	 */
 	if (copy_sense) {
 		if (!SCSI_SENSE_VALID(scmd)) {
-			memcpy(scmd->sense_buffer, scmd->request_buffer,
+			memcpy(scmd->sense_buffer, page_address(sgl.page),
 			       sizeof(scmd->sense_buffer));
 		}
 		__free_page(sgl.page);
