From: Olaf Hering <olaf@aepfle.de>
Subject: Re: storvsc loops with No Sense messages
Date: Wed, 30 Jan 2013 14:35:11 +0100
Message-ID: <20130130133511.GA6290@aepfle.de>
References: <20130129152801.GA671@aepfle.de>
 <a120050e059c40c2a1d1be4eadc42dfd@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130129185600.GA31738@aepfle.de>
 <05a4f02fe12545f489dd053175990b8d@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130129212743.GA8052@aepfle.de>
 <20130130095947.GA6626@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:55553 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3A3NfV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 08:35:21 -0500
Content-Disposition: inline
In-Reply-To: <20130130095947.GA6626@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jan 30, Olaf Hering wrote:

> Is there a way to not use WRITE_SAME at all? While browsing the code its
> not clear if there is a conditional for this command.

It seems scsi_device->no_write_same may avoid this command, I will
test this patch:

# Subject: [PATCH] scsi: storvsc: avoid usage of WRITE_SAME

Set scsi_device->no_write_same because the host does not support it.
Also blacklist WRITE_SAME to avoid (and log) accident usage.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 drivers/scsi/storvsc_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 0144078..21f788a 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1155,6 +1155,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
+	sdevice->no_write_same = 1;
+
 	return 0;
 }
 
@@ -1241,6 +1243,7 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	 * smartd sends this command and the host does not handle
 	 * this. So, don't send it.
 	 */
+	case WRITE_SAME:
 	case SET_WINDOW:
 		scmnd->result = ILLEGAL_REQUEST << 16;
 		allowed = false;
-- 
1.8.1.1

