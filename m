From: Helge Deller <deller@gmx.de>
Subject: [PATCH][SCSI] 53c700: Use proper debug printk format specifiers
Date: Fri, 10 Jun 2016 22:39:45 +0200
Message-ID: <20160610203945.GA18046@p100.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-parisc-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When enabling the debug options NCR_700_DEBUG and NCR_700_TAG_DEBUG
various printk format warnings can be seen like:
drivers/scsi/53c700.c:357:2: warning: format =E2=80=98%p=E2=80=99 expec=
ts argument of type =E2=80=98void *=E2=80=99, but argument 4 has type =E2=
=80=98dma_addr_t=E2=80=99 [-Wformat=3D]
  script_patch_32(hostdata->dev, script, MessageLocation,

=46ix them by using the right printk format specifiers.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index d4c2856..56bec27 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1892,7 +1892,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, v=
oid (*done)(struct scsi_cmnd *)
 		slot->SG[i].ins =3D bS_to_host(SCRIPT_RETURN);
 		slot->SG[i].pAddr =3D 0;
 		dma_cache_sync(hostdata->dev, slot->SG, sizeof(slot->SG), DMA_TO_DEV=
ICE);
-		DEBUG((" SETTING %08lx to %x\n",
+		DEBUG((" SETTING %p to %x\n",
 		       (&slot->pSG[i].ins),
 		       slot->SG[i].ins));
 	}
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index e06bdfe..fd32971 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -423,23 +423,25 @@ struct NCR_700_Host_Parameters {
 #define script_patch_32(dev, script, symbol, value) \
 { \
 	int i; \
+	dma_addr_t da =3D value; \
 	for(i=3D0; i< (sizeof(A_##symbol##_used) / sizeof(__u32)); i++) { \
-		__u32 val =3D bS_to_cpu((script)[A_##symbol##_used[i]]) + value; \
+		__u32 val =3D bS_to_cpu((script)[A_##symbol##_used[i]]) + da; \
 		(script)[A_##symbol##_used[i]] =3D bS_to_host(val); \
 		dma_cache_sync((dev), &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEV=
ICE); \
-		DEBUG((" script, patching %s at %d to 0x%lx\n", \
-		       #symbol, A_##symbol##_used[i], (value))); \
+		DEBUG((" script, patching %s at %d to %pad\n", \
+		       #symbol, A_##symbol##_used[i], &da)); \
 	} \
 }
=20
 #define script_patch_32_abs(dev, script, symbol, value) \
 { \
 	int i; \
+	dma_addr_t da =3D value; \
 	for(i=3D0; i< (sizeof(A_##symbol##_used) / sizeof(__u32)); i++) { \
-		(script)[A_##symbol##_used[i]] =3D bS_to_host(value); \
+		(script)[A_##symbol##_used[i]] =3D bS_to_host(da); \
 		dma_cache_sync((dev), &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEV=
ICE); \
-		DEBUG((" script, patching %s at %d to 0x%lx\n", \
-		       #symbol, A_##symbol##_used[i], (value))); \
+		DEBUG((" script, patching %s at %d to %pad\n", \
+		       #symbol, A_##symbol##_used[i], &da)); \
 	} \
 }
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-parisc"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
