From: <Joshua_Giles@Dell.com>
Subject: [PATCH] megaraid_sas: Support 16 byte CDB's or > 2.2 Terabyte Volumes
Date: Mon, 30 Jan 2006 17:23:29 -0600
Message-ID: <22EC09E0B6C7614E90055362D384B16AA7DB2A@ausx3mps308.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:4988 "EHLO
	ausc60pc101.us.dell.com") by vger.kernel.org with ESMTP
	id S965037AbWA3XXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2006 18:23:31 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, hch@lst.de
Cc: Neela.Kolli@engenio.com


This patch properly registers the 16 byte command length capability of
the megaraid_sas controlled hardware with the scsi midlayer.  All
megaraid_sas hardware supports 16 byte CDB's.

Signed-off-by: Joshua Giles <joshua_giles@dell.com>

--- linux-2.6.15.1.orig/drivers/scsi/megaraid/megaraid_sas.c
2006-01-30 17:15:49.000000000 -0500
+++ linux-2.6.15.1/drivers/scsi/megaraid/megaraid_sas.c 2006-01-30
17:15:30.000000000 -0500
@@ -1990,6 +1990,7 @@
        host->max_channel = MEGASAS_MAX_CHANNELS - 1;
        host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
        host->max_lun = MEGASAS_MAX_LUN;
+       host->max_cmd_len = 16;

        /*
         * Notify the mid-layer about the new controller
