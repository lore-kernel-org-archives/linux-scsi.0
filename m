From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 37/54] libfc: fix RNN_ID smashing skb payload
Date: Tue, 03 Nov 2009 11:48:50 -0800
Message-ID: <20091103194850.4085.11404.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9638 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbZKCTs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:48:57 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
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
 

