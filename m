From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
Date: Wed, 29 Jul 2009 23:56:28 +0300
Message-ID: <20090729205626.GA3592@redhat.com>
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <4A705831.3010002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZG2U5l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 16:57:41 -0400
Content-Disposition: inline
In-Reply-To: <4A705831.3010002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 05:09:53PM +0300, Boaz Harrosh wrote:
> TODO:
> * Fix up Kernel headers by complying to check_headers

This is accomplished by applying the following on top
of my previous patch:

Subject: scsi: make scsi/scsi.h headers_check clean

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
1.6.2.5


