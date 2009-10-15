From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 00/10] handles queue_depth adjustments in scsi_error.c
Date: Thu, 15 Oct 2009 16:09:19 -0700
Message-ID: <1255648159.21749.138.camel@vi2.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
	 <1255471167.2855.502.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55777 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbZJOXKY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Oct 2009 19:10:24 -0400
In-Reply-To: <1255471167.2855.502.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Tue, 2009-10-13 at 16:59 -0500, James Bottomley wrote:
> OK, so this patch series isn't bisectable.  If I just apply 1  it
> won't
> compile.
> 
> To get to bisectability it looks like patches 1,3,4 need combining. It

Only 4 needs to be combined with 1 due to change_queue_depth() func
params change in 1 and all impacted drivers by this change are modified
later in patch 4 breaking patch 1. The patch 3 depended on 2, so 3
cannot be merged w/o 2, so I'll leave them as-is.

> also looks like 5,6,7 are all really the same change, so could be
> combined.
> 

Yes can be since all for added common ramp up code. I kept existing code
changes separate in 5 and 6 to help in review. I'm combining them as
well. 

Also adding one more related change as max_queue_depth field per sdev to
track max qdepth per sdev, so that ramp up won't exceed max_queue_depth
which could be modified via sysfs to limit qdepth on a sdev.

> Could you repost with at least the bisectability fixed?
> 

I'm posting revised series with each bisectable patch on scsi-misc
current top commit:-

	commit bfa27150c1ba70e2cb2d3b738025ec4803f4101e
	Author: Jing Huang <huangj@brocade.com>
	Date:   Fri Sep 25 12:29:54 2009 -0700
	[SCSI] bfa: fixed checkpatch errors for bfad files


	Thanks
	Vasu

