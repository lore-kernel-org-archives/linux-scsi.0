From: <random1@o-o.yi.org>
Subject: scsi error handling and ACPI suspend
Date: 19 Jul 2002 15:54:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <uvg7b334f.fsf@o-o.yi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from list by main.gmane.org with local (Exim 3.33 #1 (Debian))
	id 17VdpV-0002JY-00
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jul 2002 21:54:21 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The power-management code in 2.5 presently signals all running threads
in an attempt to make them reach a quiescent state so that it can
write to disk without fighting with them over kernel resources.

When the error handler is signalled, it wakes up and exits.  On
resume, there is no error handler, and the system panics near
scsi_error.c:233

The recommended solution is to set the PF_IOTHREAD flag for the error
handler threads, which indicates that suspend should not try to stop
them.  

*** drivers/scsi/scsi_error.c	Fri Jul 19 14:48:40 2002
--- drivers/scsi/scsi_error.c.orig	Fri Jul 19 14:50:32 2002
***************
*** 1870,1876 ****
           * to any signals.
           */
  	siginitsetinv(&current->blocked, SHUTDOWN_SIGS);
- 	current->flags |= PF_IOTHREAD; /* don't let suspend stop us */
  
  	lock_kernel();
  
--- 1870,1875 ----






