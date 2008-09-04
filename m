From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: [RFC 0/2] pass through support through bsg interface
Date: Wed, 3 Sep 2008 19:55:10 -0700
Message-ID: <16F95320-F295-46EC-A6F3-7B9F06120034@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:39114 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYIDCzN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2008 22:55:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, Robert W Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>

Hi,

This is updated patch set for both FC transport and qla2xxx module in  
an effort of supporting pass through, ELS and CT services. For the  
reference, http://marc.info/?t=121569558300005&r=1&w=2 is the previous  
discussion triggered the implementation.

Based on the discussion, following are remarks for the implementations,
- the SMP in the SAS transport has referenced, so the layout of the  
changes are quite similar to it
- at this stage, the ELS/CT service packet serviced one at a time,  
synchronously
- in the scsi_transport_fc module, there is dedicated handler in the  
LLDD for ELS and CT, respectively
- device files are created in following directories for each of  
discovered initiator/targets,
	= /sys/class/bsg/rport-<host_no>:<bus>-<id>
	= dev/rport-<host_no>:<bus>-<id>
- the qla2xxx module has been tested with the simple application that  
issues some of ELS and CT service requests
- abort mechanism is in place

Any comments on the implementations are appreciated.
One thing, sometimes, patches from my email client may get mangled for  
some reason, so the actual patches have attached  separately at the  
end of each email.
Sorry for the inconvenience, will get fix as soon as possible.

Thank you,
Seokmann
