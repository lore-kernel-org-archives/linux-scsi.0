From: Tim Wright <timw@splhi.com>
Subject: [PATCH] Fix miscalculation of sg_io timeout in CDROM_SEND_PACKET
 handler.
Date: Sun, 27 Jul 2008 17:50:38 -0700
Message-ID: <488D17DE.5000801@splhi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759347AbYG1Auz@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

It seems cdrwtool in the udftools has been unusable on "modern" kernels 
for some time. A Google search reveals many people with the same issue 
but no solution (cdrwtool fails to format the disk). After spending some 
time tracking down the issue, it comes down to the following:

The udftools still use the older CDROM_SEND_PACKET interface to send 
things like FORMAT_UNIT through to the drive. They should really be 
updated, but that's another story. Since most distros are using libata 
now, the cd or dvd burner appears as a SCSI device, and we wind up in 
block/scsi_ioctl.c. Here, the code tries to take the "struct 
cdrom_generic_command" and translate it and stuff it into a "struct 
sg_io_hdr" structure so it can pass it to the modern sg_io() routine 
instead. Unfortunately, there is one error, or rather an omission in the 
translation. The timeout that is passed in in the "struct 
cdrom_generic_command" is in HZ=100 units, and this is modified and 
correctly converted to jiffies by use of clock_t_to_jiffies(). However, 
a little further down, this cgc.timeout value in jiffies is simply 
copied into the sg_io_hdr timeout, which should be in milliseconds. 
Since most modern x86 kernels seems to be getting build with HZ=250, the 
timeout that is passed to sg_io and eventually converted to the 
timeout_per_command member of the scsi_cmnd structure is now four times 
too small. Since cdrwtool tries to set the timeout to one hour for the 
FORMAT_UNIT command, and it takes about 20 minutes to format a 4x CDRW, 
the SCSI error-handler kicks in after the FORMAT_UNIT completes because 
it took longer than the incorrectly-calculated timeout.

Patch to correct this follows. It fixes the problem on my test system.

Signed-off-by: Tim Wright <timw@splhi.com>

--- linux-2.6.26/block/scsi_ioctl.c.orig        2008-07-27 
17:35:49.000000000 -0700
+++ linux-2.6.26/block/scsi_ioctl.c     2008-07-27 17:36:41.000000000 -0700
@@ -629,7 +629,7 @@ int scsi_cmd_ioctl(struct file *file, st
                        hdr.sbp = cgc.sense;
                        if (hdr.sbp)
                                hdr.mx_sb_len = sizeof(struct 
request_sense);
-                       hdr.timeout = cgc.timeout;
+                       hdr.timeout = jiffies_to_msecs(cgc.timeout);
                        hdr.cmdp = ((struct cdrom_generic_command 
__user*) arg)->cmd;
                        hdr.cmd_len = sizeof(cgc.cmd);
