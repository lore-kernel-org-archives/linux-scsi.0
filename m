From: Doug Ledford <dledford@redhat.com>
Subject: GFP_ATOMIC allocations...
Date: Wed, 28 Aug 2002 20:25:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020828202534.G30927@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aladin.rdu.redhat.com (aladin.rdu.redhat.com [172.16.57.71])
	by lacrosse.corp.redhat.com (8.11.6/8.9.3) with ESMTP id g7T0PYY21447
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2002 20:25:34 -0400
Received: (from dledford@localhost)
	by aladin.rdu.redhat.com (8.11.6/8.11.6) id g7T0PYn31102
	for linux-scsi@vger.kernel.org; Wed, 28 Aug 2002 20:25:34 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm looking through some of the new code that has been put in the kernel 
scsi subsystem lately and I'm seeing a few of the same mistakes that the 
old code made.  So, I'm pointing out one of them here.  There are lots of 
places in the SCSI mid layer that are called outside of any spinlocks and 
not from interrupt context where there is absolutely no need to use 
GFP_ATOMIC allocations for memory.  In general, if you don't need to use 
GFP_ATOMIC, then don't use it.  You're more likely to fail the allocation 
and therefore fail the operation.  So, if you are working on a section of 
code, please think about this when doing allocations and do whatever is 
right for the code snippet you are currently hacking.  Fixing places in 
the existing code that use GFP_ATOMIC needlessly is a plus ;-)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
