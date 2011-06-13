From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 8/8] scsi/sun3: Remove commented out merge_contiguous_buffers
Date: Mon, 13 Jun 2011 20:39:22 +0200
Message-ID: <1307990362-22768-9-git-send-email-geert@linux-m68k.org>
References: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:58974 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1FMSjk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2011 14:39:40 -0400
In-Reply-To: <1307990362-22768-1-git-send-email-geert@linux-m68k.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Sam Creasey <sammy@sammy.net>

This fixes:

drivers/scsi/sun3_NCR5380.c:475: warning: =E2=80=98merge_contiguous_buf=
fers=E2=80=99 defined but not used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>
---
 drivers/scsi/sun3_NCR5380.c |   58 -----------------------------------=
--------
 1 files changed, 0 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index f3cffdf..7e12a2e 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -49,13 +49,6 @@
  *    inside the execution of NCR5380_intr(), leading to recursive
  *    calls.
  *
- *  - I've added a function merge_contiguous_buffers() that tries to
- *    merge scatter-gather buffers that are located at contiguous
- *    physical addresses and can be processed with the same DMA setup.
- *    Since most scatter-gather operations work on a page (4K) of
- *    4 buffers (1K), in more than 90% of all cases three interrupts a=
nd
- *    DMA setup actions are saved.
- *
  * - I've deleted all the stuff for AUTOPROBE_IRQ, REAL_DMA_POLL, PSEU=
DO_DMA
  *    and USLEEP, because these were messing up readability and will n=
ever be
  *    needed for Atari SCSI.
@@ -460,47 +453,6 @@ static void free_all_tags( void )
=20
=20
 /*
- * Function: void merge_contiguous_buffers(struct scsi_cmnd *cmd)
- *
- * Purpose: Try to merge several scatter-gather requests into one DMA
- *    transfer. This is possible if the scatter buffers lie on
- *    physical contiguous addresses.
- *
- * Parameters: struct scsi_cmnd *cmd
- *    The command to work on. The first scatter buffer's data are
- *    assumed to be already transferred into ptr/this_residual.
- */
-
-static void merge_contiguous_buffers(struct scsi_cmnd *cmd)
-{
-    unsigned long endaddr;
-#if (NDEBUG & NDEBUG_MERGING)
-    unsigned long oldlen =3D cmd->SCp.this_residual;
-    int		  cnt =3D 1;
-#endif
-
-    for (endaddr =3D virt_to_phys(cmd->SCp.ptr + cmd->SCp.this_residua=
l - 1) + 1;
-	 cmd->SCp.buffers_residual &&
-	 virt_to_phys(SGADDR(&(cmd->SCp.buffer[1]))) =3D=3D endaddr; ) {
-=09
-	MER_PRINTK("VTOP(%p) =3D=3D %08lx -> merging\n",
-		   SGADDR(&(cmd->SCp.buffer[1])), endaddr);
-#if (NDEBUG & NDEBUG_MERGING)
-	++cnt;
-#endif
-	++cmd->SCp.buffer;
-	--cmd->SCp.buffers_residual;
-	cmd->SCp.this_residual +=3D cmd->SCp.buffer->length;
-	endaddr +=3D cmd->SCp.buffer->length;
-    }
-#if (NDEBUG & NDEBUG_MERGING)
-    if (oldlen !=3D cmd->SCp.this_residual)
-	MER_PRINTK("merged %d buffers from %p, new length %08x\n",
-		   cnt, cmd->SCp.ptr, cmd->SCp.this_residual);
-#endif
-}
-
-/*
  * Function : void initialize_SCp(struct scsi_cmnd *cmd)
  *
  * Purpose : initialize the saved data pointers for cmd to point to th=
e=20
@@ -521,11 +473,6 @@ static __inline__ void initialize_SCp(struct scsi_=
cmnd *cmd)
 	cmd->SCp.buffers_residual =3D scsi_sg_count(cmd) - 1;
 	cmd->SCp.ptr =3D (char *) SGADDR(cmd->SCp.buffer);
 	cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
-
-	/* ++roman: Try to merge some scatter-buffers if they are at
-	 * contiguous physical addresses.
-	 */
-//	merge_contiguous_buffers( cmd );
     } else {
 	cmd->SCp.buffer =3D NULL;
 	cmd->SCp.buffers_residual =3D 0;
@@ -2076,11 +2023,6 @@ static void NCR5380_information_transfer (struct=
 Scsi_Host *instance)
 		    --cmd->SCp.buffers_residual;
 		    cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
 		    cmd->SCp.ptr =3D SGADDR(cmd->SCp.buffer);
-
-		    /* ++roman: Try to merge some scatter-buffers if
-		     * they are at contiguous physical addresses.
-		     */
-//		    merge_contiguous_buffers( cmd );
 		    INF_PRINTK("scsi%d: %d bytes and %d buffers left\n",
 			       HOSTNO, cmd->SCp.this_residual,
 			       cmd->SCp.buffers_residual);
--=20
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
