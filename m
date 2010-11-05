From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 1/3] USB: sd: sd_start_stop_device proper error codes
Date: Fri, 5 Nov 2010 11:09:12 +0100
Message-ID: <201011051109.12410.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36798 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab0KEKIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2010 06:08:51 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 8CD6A93F46
	for <linux-scsi@vger.kernel.org>; Fri,  5 Nov 2010 11:08:50 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, hare@suse.de, linux-scsi@vger.kernel.org

>From 8497ed3a68f19cfc8246c88716a5224cf24947b5 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Mon, 25 Oct 2010 11:45:59 +0200
Subject: [PATCH 1/3] USB: sd: sd_start_stop_device proper error codes

sd_start_stop_device leaks SCSI specific error codes
to the generic driver code

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b9ab3a5..fcba7d2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2551,7 +2551,11 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 			sd_print_sense_hdr(sdkp, &sshdr);
 	}
 
-	return res;
+	/* SCSI error codes must not go to the generic layer */
+	if (res)
+		return -EIO;
+
+	return 0;
 }
 
 /*
-- 
1.7.1

