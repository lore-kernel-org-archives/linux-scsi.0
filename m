From: willy@parisc-linux.org (Matthew Wilcox)
Subject: [PATCH] [5/5] Fix small bug in scsi_transport_spi
Date: Fri, 18 Mar 2005 20:56:42 -0700 (MST)
Message-ID: <20050319035642.46B53496108@palinux.hppa>
Received: from palinux.external.hp.com ([192.25.206.14]:51347 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S262399AbVCSD4n
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 22:56:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Fix small bug in scsi_transport_spi

"reserved" was being printed without a trailing \n.

Signed-off-by: Matthew Wilcox <willy@parisc-linux.org>

diff -urpNX dontdiff linus-2.6/drivers/scsi/scsi_transport_spi.c parisc-2.6/drivers/scsi/scsi_transport_spi.c
--- linus-2.6/drivers/scsi/scsi_transport_spi.c	2005-03-18 06:21:12.433525226 -0700
+++ parisc-2.6/drivers/scsi/scsi_transport_spi.c	2005-03-18 06:12:13.789614671 -0700
@@ -293,9 +293,12 @@ static ssize_t show_spi_transport_period
 		picosec = tp->period * 4000;
 	}
 
-	if (picosec == -1)
-		return sprintf(buf, "reserved");
-	len = sprint_frac(buf, picosec, 1000);
+	if (picosec == -1) {
+		len = sprintf(buf, "reserved");
+	} else {
+		len = sprint_frac(buf, picosec, 1000);
+	}
+
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
