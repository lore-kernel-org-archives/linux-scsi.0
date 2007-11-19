From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 16/26] hptiop: avoid buffer overflow when returning sense
	data
Date: Mon, 19 Nov 2007 10:19:12 -0800
Message-ID: <20071119181912.GQ15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49287 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbXKSSWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 13:22:22 -0500
Content-Disposition: inline; filename="hptiop-avoid-buffer-overflow-when-returning-sense-data.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, James.Bottomley@steeleye.com
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux@highpoint-tech.com, linux-scsi@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: HighPoint Linux Team <linux@highpoint-tech.com>

patch 0fec02c93f60fb44ba3a24a0d3e4a52521d34d3f in mainline.

avoid buffer overflow when returning sense data.

With current adapter firmware the driver is working but future firmware
updates may return sense data larger than 96 bytes, causing overflow on
scp->sense_buffer and a kernel crash.

This fix should be backported to earlier kernels.

Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
Signed-off-by: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/hptiop.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -377,8 +377,9 @@ static void hptiop_host_request_callback
 		scp->result = SAM_STAT_CHECK_CONDITION;
 		memset(&scp->sense_buffer,
 				0, sizeof(scp->sense_buffer));
-		memcpy(&scp->sense_buffer,
-			&req->sg_list, le32_to_cpu(req->dataxfer_length));
+		memcpy(&scp->sense_buffer, &req->sg_list,
+				min(sizeof(scp->sense_buffer),
+					le32_to_cpu(req->dataxfer_length)));
 		break;
 
 	default:

-- 
