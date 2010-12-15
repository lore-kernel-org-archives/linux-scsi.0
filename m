From: matthew-Ztpu424NOJ8@public.gmane.org
Subject: [PATCH 5/5] uas: Use GFP_NOIO instead of GFP_KERNEL in I/O submission path
Date: Wed, 15 Dec 2010 15:44:06 -0500
Message-ID: <1292445846-12101-5-git-send-email-matthew@wil.cx>
References: <20101215204147.GA1263@parisc-linux.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101215204147.GA1263-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>

If swap is on a UAS device, we could recurse into the driver by using
GFP_KERNEL.  Using GFP_NOIO ensures we won't.

Reported-by: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/usb/storage/uas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 0ebe7f6..23f0dd9 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -141,7 +141,7 @@ static void uas_do_work(struct work_struct *work)
 		struct scsi_pointer *scp = (void *)cmdinfo;
 		struct scsi_cmnd *cmnd = container_of(scp,
 							struct scsi_cmnd, SCp);
-		uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_KERNEL);
+		uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_NOIO);
 	}
 }
 
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
