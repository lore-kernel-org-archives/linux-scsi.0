From: Josh Hunt <johunt@akamai.com>
Subject: [RFC/PATCH] mptscsih: Set DRIVER_SENSE when sense data present
Date: Sun, 20 May 2012 07:32:49 -0700
Message-ID: <1337524369-8622-1-git-send-email-johunt@akamai.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:44779 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755635Ab2ETOkB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 May 2012 10:40:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josh Hunt <johunt@akamai.com>

While looking into some drive errors on a few of our systems I noticed that
DRIVER_SENSE was not being set by mptscsih even though there was sense data
present. DRIVER_SENSE does eventually get set by scsi_finish_command() when
it detects the sense data. I won't pretend I'm an expert in this area, I'm
just looking for an explanation as to why the patch below or something like
it is not currently in the driver? Is it sufficient enough that we're detecting
this case later on in the scsi code?

Thanks
Josh

---

Currently when sense data is present only check condition is set. This
sets DRIVER_SENSE as well.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/message/fusion/mptscsih.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0c3ced7..3ccf5cf 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -889,6 +889,8 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 			} else if (scsi_state &
 			    MPI_SCSI_STATE_AUTOSENSE_VALID) {
 
+				sc->result |= (DRIVER_SENSE << 24);
+
 				/*
 				 * For potential trouble on LSI53C1030.
 				 * (date:2007.xx.)
-- 
1.7.0.4

