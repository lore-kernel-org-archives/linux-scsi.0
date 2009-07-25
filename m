From: Dave Jones <davej@redhat.com>
Subject: [PATCH] Don't export scsi kernel variables in userspace headers.
Date: Fri, 24 Jul 2009 22:10:26 -0400
Message-ID: <20090725021026.GA6942@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34991 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZGYCK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2009 22:10:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

Found with make headers_check

/usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
/usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..689570e 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -156,7 +156,9 @@ scsi_varlen_cdb_length(const void *hdr)
 	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
 }
 
+#ifdef __KERNEL__
 extern const unsigned char scsi_command_size_tbl[8];
+#endif
 #define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
 
 static inline unsigned
@@ -281,8 +283,10 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
+#ifdef __KERNEL__
 /* Returns a human-readable name for the device */
 extern const char * scsi_device_type(unsigned type);
+#endif
 
 /*
  * standard mode-select header prepended to all mode-select commands
