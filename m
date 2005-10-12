From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [patch] fix unnecessary activation of blk tag queue for qla2x00
Date: Wed, 12 Oct 2005 13:00:16 -0700
Message-ID: <20051012200016.GA24096@us.ibm.com>
References: <B05667366EE6204181EABE9C1B1C0EB5086AEC35@scsmsx401.amr.corp.intel.com> <20051007170356.GC8370@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:20938 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751526AbVJLUAV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Oct 2005 16:00:21 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id j9CJwJo8003512
	for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2005 15:58:19 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j9CK18Dv546658
	for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2005 14:01:08 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j9CK0J1h025466
	for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2005 14:00:19 -0600
Content-Disposition: inline
In-Reply-To: <20051007170356.GC8370@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "Chen, Kenneth W" <kenneth.w.chen@intel.com>, linux-scsi@vger.kernel.org

On Fri, Oct 07, 2005 at 10:03:56AM -0700, Andrew Vasquez wrote:
> On Fri, 07 Oct 2005, Chen, Kenneth W wrote:
> 
> > Regarding to discussion on LKML:
> > http://marc.theaimsgroup.com/?t=112865351000001&r=1&w=2
> 
> Ok, I had expected something like this to show on ls after the
> discussion on lk.
> 
> > It turns out that qla2x00 driver unnecessarily activated generic
> > blk tag queue without actually use any of the tag maintained by
> > the block layer.  I suggest we turn that off until there is a
> > real consumer of the tag queuing in the qla driver. Please apply.
> > 
> > Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
> > 
> 
> ACK.

And then also remove scsi_populate_tag_msg() calls also in qla2xxx, as
that becomes dead code?

And then we can't pass down the task attribute. That does not matter now
as long as there are still no blk barriers for scsi (with can_queue or
queue_depth > 0, and some other scsi_host value set).

-- Patrick Mansfield
