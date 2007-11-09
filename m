From: "Chris Friesen" <cfriesen@nortel.com>
Subject: getting QUEUE_FULL/SAM_STAT_TASK_SET_FULL from userspace sg operations
Date: Fri, 09 Nov 2007 15:59:25 -0600
Message-ID: <4734D83D.8090202@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zrtps0kn.nortel.com ([47.140.192.55]:58598 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbXKIWSl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2007 17:18:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, DL-MPTFusionLinux@lsi.com


Hi all,

I've been asked to look into a SCSI problem.  I know my way around the 
kernel, but I'm new to SCSI/disk operations, so please bear with me (and 
educate me) if my terminology is off.

We have an x86-based blade with dual LSI 53c1030 devices.

We recently moved to a new kernel version, and now some of our userspace 
apps are getting QUEUE_FULL/SAM_STAT_TASK_SET_FULL errors when issuing 
SCSI requests on the sg device nodes.  The requests were generally 
related to the health of the disks (ie, LOG_SENSE, REQUEST_SENSE, 
TEST_UNIT_READY, MODE_SENSE_10, that sort of thing).

We had been using a vendor-supplied 2.6.10 kernel with version 3.01.18 
of the Fusion MPT driver.  The new kernel is based on 2.6.14 and uses 
version 3.02.57 of the Fusion MPT driver.

So....first, what is the proper way to handle this type of error in 
userspace?  Should the app immediately retry, or wait a bit then retry? 
  Should there be a cap on the number of retries?  If so, what's a 
reasonable limit?

Second, can anyone think of why we would suddenly get more of these 
errors when moving between these kernel versions when using the same 
hardware?

Third, what do we do to get rid of the errors?  Updating the driver may 
be an option, updating the kernel itself is not.

Thanks,

Chris
