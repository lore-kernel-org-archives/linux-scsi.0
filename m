From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/24] libfc: fix RNN_ID smashing skb payload
Date: Fri, 18 Sep 2009 15:50:22 -0700
Message-ID: <20090918225022.5928.28596.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64050 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827AbZIRWu3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:50:29 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The code that filled in the name server RNN_ID (register node name)
request had somehow gotten a line in it from the RFT_ID code
which copies 32 bytes of data over the relatively short payload.
This caused some corruption and hangs.

Simply deleted the extraneous line.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/fc_encode.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 9afcbb9..c8968d3 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -134,7 +134,6 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rn_id));
 		hton24(ct->payload.rn.fr_fid.fp_fid,
 		       fc_host_port_id(lport->host));
-		ct->payload.rft.fts = lport->fcts;
 		put_unaligned_be64(lport->wwnn, &ct->payload.rn.fr_wwn);
 		break;
 

