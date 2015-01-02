From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: aic7xxx: aic7770:  Remove unused function
Date: Fri,  2 Jan 2015 21:30:56 +0100
Message-ID: <1420230656-2240-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove the function aic7770_find_device() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/aic7xxx/aic7770.c |   14 --------------
 drivers/scsi/aic7xxx/aic7xxx.h |    1 -
 2 files changed, 15 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770.c b/drivers/scsi/aic7xxx/aic7770.c
index 5000bd6..cbe10755 100644
--- a/drivers/scsi/aic7xxx/aic7770.c
+++ b/drivers/scsi/aic7xxx/aic7770.c
@@ -107,20 +107,6 @@ struct aic7770_identity aic7770_ident_table[] =
 };
 const int ahc_num_aic7770_devs = ARRAY_SIZE(aic7770_ident_table);
 
-struct aic7770_identity *
-aic7770_find_device(uint32_t id)
-{
-	struct	aic7770_identity *entry;
-	int	i;
-
-	for (i = 0; i < ahc_num_aic7770_devs; i++) {
-		entry = &aic7770_ident_table[i];
-		if (entry->full_id == (id & entry->id_mask))
-			return (entry);
-	}
-	return (NULL);
-}
-
 int
 aic7770_config(struct ahc_softc *ahc, struct aic7770_identity *entry, u_int io)
 {
diff --git a/drivers/scsi/aic7xxx/aic7xxx.h b/drivers/scsi/aic7xxx/aic7xxx.h
index f695774..ead8924 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.h
+++ b/drivers/scsi/aic7xxx/aic7xxx.h
@@ -1144,7 +1144,6 @@ void			 ahc_pci_resume(struct ahc_softc *ahc);
 #endif
 
 /*************************** EISA/VL Front End ********************************/
-struct aic7770_identity *aic7770_find_device(uint32_t);
 int			 aic7770_config(struct ahc_softc *ahc,
 					struct aic7770_identity *,
 					u_int port);
-- 
1.7.10.4
