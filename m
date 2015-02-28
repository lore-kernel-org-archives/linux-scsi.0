From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/3] scsi: storvsc: Always send on the selected outgoing channel
Date: Fri, 27 Feb 2015 17:01:47 -0800
Message-ID: <1425085307-27897-3-git-send-email-kys@microsoft.com>
References: <1425084227-27224-1-git-send-email-kys@microsoft.com>
 <1425085307-27897-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37460
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393AbbB0Xqg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2015 18:46:36 -0500
In-Reply-To: <1425085307-27897-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

The current code always sent packets without data on the primary channel.
Properly distribute sending of packets with no data amongst all available
channels. I would like to thank Long Li for noticing this problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 5a12897..be8f12e 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1362,7 +1362,7 @@ static int storvsc_do_io(struct hv_device *device,
 				vmscsi_size_delta),
 				(unsigned long)request);
 	} else {
-		ret = vmbus_sendpacket(device->channel, vstor_packet,
+		ret = vmbus_sendpacket(outgoing_channel, vstor_packet,
 			       (sizeof(struct vstor_packet) -
 				vmscsi_size_delta),
 			       (unsigned long)request,
-- 
1.7.4.1

