From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: aic7xxx: mark expected switch fall-throughs
Date: Thu, 4 Oct 2018 08:59:11 +0200
Message-ID: <20181004065641.GA11681@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embededdor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114961 ("Missing break in switch")
Addresses-Coverity-ID: 114962 ("Missing break in switch")
Addresses-Coverity-ID: 114963 ("Missing break in switch")
Addresses-Coverity-ID: 114964 ("Missing break in switch")
Addresses-Coverity-ID: 114965 ("Missing break in switch")
Addresses-Coverity-ID: 114966 ("Missing break in switch")
Addresses-Coverity-ID: 114967 ("Missing break in switch")
Addresses-Coverity-ID: 114968 ("Missing break in switch")
Addresses-Coverity-ID: 114969 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index f3362f4..5fe5384 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -4920,24 +4920,30 @@ ahc_fini_scbdata(struct ahc_softc *ahc)
 		}
 		ahc_dma_tag_destroy(ahc, scb_data->sg_dmat);
 	}
+		/* fall through */
 	case 6:
 		ahc_dmamap_unload(ahc, scb_data->sense_dmat,
 				  scb_data->sense_dmamap);
+		/* fall through */
 	case 5:
 		ahc_dmamem_free(ahc, scb_data->sense_dmat, scb_data->sense,
 				scb_data->sense_dmamap);
 		ahc_dmamap_destroy(ahc, scb_data->sense_dmat,
 				   scb_data->sense_dmamap);
+		/* fall through */
 	case 4:
 		ahc_dma_tag_destroy(ahc, scb_data->sense_dmat);
+		/* fall through */
 	case 3:
 		ahc_dmamap_unload(ahc, scb_data->hscb_dmat,
 				  scb_data->hscb_dmamap);
+		/* fall through */
 	case 2:
 		ahc_dmamem_free(ahc, scb_data->hscb_dmat, scb_data->hscbs,
 				scb_data->hscb_dmamap);
 		ahc_dmamap_destroy(ahc, scb_data->hscb_dmat,
 				   scb_data->hscb_dmamap);
+		/* fall through */
 	case 1:
 		ahc_dma_tag_destroy(ahc, scb_data->hscb_dmat);
 		break;
@@ -6002,8 +6008,8 @@ ahc_search_qinfifo(struct ahc_softc *ahc, int target, char channel,
 				if ((scb->flags & SCB_ACTIVE) == 0)
 					printk("Inactive SCB in Waiting List\n");
 				ahc_done(ahc, scb);
-				/* FALLTHROUGH */
 			}
+				/* fall through  */
 			case SEARCH_REMOVE:
 				next = ahc_rem_wscb(ahc, next, prev);
 				break;
@@ -7008,8 +7014,8 @@ ahc_download_instr(struct ahc_softc *ahc, u_int instrptr, uint8_t *dconsts)
 		}
 		address -= address_offset;
 		fmt3_ins->address = address;
-		/* FALLTHROUGH */
 	}
+		/* fall through */
 	case AIC_OP_OR:
 	case AIC_OP_AND:
 	case AIC_OP_XOR:
@@ -7035,7 +7041,7 @@ ahc_download_instr(struct ahc_softc *ahc, u_int instrptr, uint8_t *dconsts)
 			fmt1_ins->opcode = AIC_OP_AND;
 			fmt1_ins->immediate = 0xff;
 		}
-		/* FALLTHROUGH */
+		/* fall through */
 	case AIC_OP_ROL:
 		if ((ahc->features & AHC_ULTRA2) != 0) {
 			int i, count;
-- 
2.7.4
