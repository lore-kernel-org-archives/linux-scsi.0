From: Chris Friesen <chris_friesen@sympatico.ca>
Subject: BUG REPORT: terminal hangs when I load the sd_mod module
Date: Mon, 20 Oct 2003 23:30:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F94A869.9070607@sympatico.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts35-srv.bellnexxia.net ([209.226.175.109]:15315 "EHLO
	tomts35-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S262799AbTJUDbA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 23:31:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I have a 2.6.0-test8 kernel with the jumpshot card reader.  I can
compile the generic scsi driver no problem, and when I insert the flash
card I get the following log entry:

Oct 20 23:23:02 doug kernel: hub 2-1:1.0: new USB device on port 2, 
assigned address 4
Oct 20 23:23:02 doug kernel: scsi1 : SCSI emulation for USB Mass Storage 
devices
Oct 20 23:23:02 doug kernel:   Vendor: Lexar     Model: Jumpshot USB CF 
   Rev: 0001
Oct 20 23:23:02 doug kernel:   Type:   Direct-Access 
   ANSI SCSI revision: 02

When I try and load the sd_mod module, that terminal just simply freezes
and I can't break out.  Similarly, if I compile scsi disk support right
into the kernel, it sits forever at boot time.  I have the following
options set in my .config.

#
# SCSI device support
#
CONFIG_SCSI=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_REPORT_LUNS is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y



This problem has been present since at least -test6.  Any ideas what's 
going on?

Thanks,
Chris

