From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [0/15]  qla2xxx: summary of changes...
Date: Thu, 6 May 2004 22:48:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507054845.GA4858@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:30199 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263169AbUEGFrB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:47:01 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

James,

Please apply the following patches I'm about to send to update the
qla2xxx driver.  A summary of the patches can be found towards the end
of this message.

With the exception of the rather large firmware image update
(direct pointer to bzip'd patch listed), subsequent messages will
contain inlined patches.

All patches can be found at the following URL:

	ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b12k/

Regards,
Andrew Vasquez
QLogic Corporation

ChangeSet@1.1922, 2004-04-29 14:20:53-07:00, andrew.vasquez@apc.qlogic.com
  ISP dump routine fixes:
  
  	o Properly release hardware_lock in failure path.
  
  	o Fix inability to complete ISP2100 dump, by properly
  	  reseting the RISC after register reads.

ChangeSet@1.1923, 2004-04-29 14:40:24-07:00, andrew.vasquez@apc.qlogic.com
  Remove flash support from embedded driver:
  
  	o Remove unused option-rom variables from host structure.
  	o Remove flash manipulation routines.

ChangeSet@1.1924, 2004-04-30 10:39:56-07:00, andrew.vasquez@apc.qlogic.com
  Older, notably the ISP2100, chips have some contraints for the request
  queue depth and number of scatter-gather elements allowed for a 
  given command.  For this chip, reduce request queue size to 128 and 
  maximum number of scatter-gather entries for a command to 32.   

ChangeSet@1.1925, 2004-04-30 10:48:48-07:00, andrew.vasquez@apc.qlogic.com
  Fix problem where port ID binding would not be honoured when
  a device was moved within the fabric.

ChangeSet@1.1926, 2004-04-30 11:07:02-07:00, andrew.vasquez@apc.qlogic.com
  Issue a kernel warning message before initiating an ISP abort (big
  hammer) -- additional debugging mechanism in case of event.

ChangeSet@1.1927, 2004-04-30 11:12:45-07:00, andrew.vasquez@apc.qlogic.com
  Fix problem where the driver would incorrectly down-cast the target
  loop_id while retrieving link statistics.

ChangeSet@1.1928, 2004-04-30 12:47:27-07:00, andrew.vasquez@apc.qlogic.com
  Cleanup retrieval and update of firmware options:
  
  	o Update only valid for non-(2[12]00) ISPs.
  	o Instruct firmware to return completed IOCBs without
  	  waiting for an ABTS to complete.

ChangeSet@1.1929, 2004-04-30 13:15:14-07:00, andrew.vasquez@apc.qlogic.com
  Fix problem where during ISP initialization in a volatile topology
  (i.e. fabric environment with large number of streaming RSCNs) the
  driver would loop indefinitely or hang due to termination of an 
  invalid thread pid.

ChangeSet@1.1930, 2004-04-30 14:01:16-07:00, andrew.vasquez@apc.qlogic.com
  Fix several problems when handling commands issued to tape devices:
  
  	1) insure commands are not prematurely returned to the mid-layer
  	   with a failed status during loop/fabric transitions.
  
  	2) tape commands tend to have rather 'long' timeout values,
  	   unfortunately, as the these values increase into the 17 to
  	   20 minute range (and larger), the cumulative skew of the
  	   RISC's own timer result in commands being held for seconds
  	   beyond their defined timeout values.  Compensate for this
  	   in the driver's command timeout function.

ChangeSet@1.1931, 2004-04-30 14:32:56-07:00, andrew.vasquez@apc.qlogic.com
  Jeremy Higdon <jeremy () sgi ! com>:
  
  	For those to whom this is new (it was discussed on linux-kernel
  	and linux-ia64 I believe), normal PCI register reads imply that
  	PCI DMA writes that occured prior to the PCI MMR (memory mapped
  	register) read (on the PCI bus) will be reflected in system
  	memory once the MMR read is complete.
  
  	On our platforms, we can speed up the MMR read significantly if
  	that ordering requirement is "relaxed".
  
  	So I attempted to find the common register reads that don't
  	have a need for this ordering so that I could make them use
  	this faster read.

ChangeSet@1.1932, 2004-04-30 15:06:20-07:00, andrew.vasquez@apc.qlogic.com
  /proc file updates:
  
  	o Address 'unaligned access' message on ia64 platorms
  	  while displaying bit-field flags.
  
  	o Iterate through the the OS target array to display 
  	  target ID bindings.
  

ChangeSet@1.1933, 2004-04-30 15:24:16-07:00, andrew.vasquez@apc.qlogic.com
  RIO/ZIO fixes:
  
  	o Reduce register access during RIO operation by checking
  	  for a 'dirtied' signature.
  
  	o Fix problem where ZIO mode handling could result in a 
  	  nasty recursive call-frame.

ChangeSet@1.1934, 2004-04-30 15:31:33-07:00, andrew.vasquez@apc.qlogic.com
  Misc. driver scrubbing:
  
  	o Use kernel #define for PCI command register bit.
  
  	o Fix rate-limiting check the queue-depth module
  	  parameter.
  
  	o Clean-up comments.

ChangeSet@1.1935, 2004-04-30 15:36:51-07:00, andrew.vasquez@apc.qlogic.com
  Resync with latest released firmware -- 3.02.28.

ChangeSet@1.1936, 2004-04-30 15:39:30-07:00, andrew.vasquez@apc.qlogic.com
  Update version number to 8.00.00b12-k.

