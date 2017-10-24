From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] usb: storage: uas: mark expected switch fall-through
Date: Tue, 24 Oct 2017 11:48:19 -0500
Message-ID: <20171024164819.GA1240@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 115016
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/usb/storage/uas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 63cf981..bd4671d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -668,6 +668,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		break;
 	case DMA_BIDIRECTIONAL:
 		cmdinfo->state |= ALLOC_DATA_IN_URB | SUBMIT_DATA_IN_URB;
+		/* fall through */
 	case DMA_TO_DEVICE:
 		cmdinfo->state |= ALLOC_DATA_OUT_URB | SUBMIT_DATA_OUT_URB;
 	case DMA_NONE:
-- 
2.7.4
