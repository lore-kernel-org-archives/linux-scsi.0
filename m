From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCHv2 2/4] scsi: make scsi/scsi.h headers_check clean
Date: Tue, 29 Sep 2009 12:34:19 +0200
Message-ID: <20090929103419.GC11183@redhat.com>
References: <cover.1254220284.git.mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbZI2Kgc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2009 06:36:32 -0400
Content-Disposition: inline
In-Reply-To: <cover.1254220284.git.mst@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Sam Ravnborg <sam@ravnborg.org>

place extern declarations in scsi/scsi.h within ifdef __KERNEL__
so that make headers_install strips them out.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/scsi/scsi.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index dfcfaab..418465a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -150,6 +150,7 @@ struct scsi_varlen_cdb_hdr {
 	/* service specific data follows */
 };
 
+#ifdef __KERNEL__
 static inline unsigned
 scsi_varlen_cdb_length(const void *hdr)
 {
@@ -165,6 +166,7 @@ scsi_command_size(const unsigned char *cmnd)
 	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
+#endif
 
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
@@ -281,8 +283,10 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
+#ifdef __KERNEL__
 /* Returns a human-readable name for the device */
 extern const char * scsi_device_type(unsigned type);
+#endif
 
 /*
  * standard mode-select header prepended to all mode-select commands
-- 
1.6.5.rc2

