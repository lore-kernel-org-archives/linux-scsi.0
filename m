From: Jeff Smith <lkml.sepix@code.wastedcycles.net>
Subject: [PATCH] SCSI: userspace cannot use scsi_device_type
Date: Wed, 11 Nov 2009 18:16:52 +0000
Message-ID: <4AFAFF94.4050500@code.wastedcycles.net>
Reply-To: lkml.sepix@code.wastedcycles.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thinkula.hx3.notconnected.net ([192.207.141.44]:56689 "EHLO
	sardonic.codimension.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbZKKSZw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 13:25:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>

The following patch fixes the 'make headers_check' warning:
    include/scsi/scsi.h:288: userspace cannot call function or variable defined in the kernel
It is similar to a patch from Jaswinder Singh Rajput back in July, which did not initially compile.

I have compiled this patch, and as expected it generates the same kernel code with and without,
modulo the confusion caused by printk pollution that uses __DATE__ and __TIME__ and compressions
thereof. This indicates that the patch is harmless to apply from the kernel's POV. A search on google
and google/codesearch indicated that there is no obvious userland use of the scsi_device_type
identifier in a way that depends on the scsi.h code.

A similar patch for the scsi_command_size code should be feasible, but a code search reveals some 
explicit use of the include file for the command_size definitions, in OpenAFS in particular,
so I figure that should be submitted as a separate patch (or more likely, RFC) after I have 
worked through the usages I can see (none of which, in theory, should be valid anyway) and 
after any comment on this patch.

Jeff

Signed-off-by: Jeff Smith <lkml.sepix@code.wastedcycles.net>
--- linux-2.6.32-rc6-wio/include/scsi/scsi.h    2009-11-03 19:37:49.000000000 +0000
+++ linux-2.6.32-rc6-wii/include/scsi/scsi.h    2009-11-10 22:54:01.000000000 +0000
@@ -284,8 +284,10 @@
        SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
+#ifdef __KERNEL__
 /* Returns a human-readable name for the device */
 extern const char * scsi_device_type(unsigned type);
+#endif /* __KERNEL__ */
 
 /*
  * standard mode-select header prepended to all mode-select commands
