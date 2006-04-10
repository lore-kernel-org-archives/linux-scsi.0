From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: command queueing cmd_per_lun, queue_depth and tags
Date: Mon, 10 Apr 2006 16:42:07 -0700
Message-ID: <20060410234207.GA21449@us.ibm.com>
References: <20060407214954.GA4990@us.ibm.com> <4436E7C8.5030204@us.ibm.com> <20060410185919.GA15124@us.ibm.com> <443ABA5F.9010306@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:12235 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S932182AbWDJXm0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 19:42:26 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k3ANgQE5029117
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 19:42:26 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k3ANjh6e164610
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 17:45:43 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k3ANgPbF000584
	for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2006 17:42:26 -0600
Content-Disposition: inline
In-Reply-To: <443ABA5F.9010306@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Apr 10, 2006 at 03:04:47PM -0500, Brian King wrote:
> Patrick Mansfield wrote:

> > I should not have used "untagged", that is misleading and a problem with
> > current scsi core, where we reference tcq, tags, and don't seem to mention
> > task attributes.
> > 
> > But LLDD can override anything in slave_configure.
> 
> I guess my biggest problem with this part of the patch is that it prevents an
> LLDD that wants this behavior from being able to use scsi_adjust_queue_depth
> to set the queue depth, whether it be in slave_configure, change_queue_depth, etc.
> 
> > Also, it looks like we could safely use cmd_per_lun as the default
> > queue_depth, rather than setting it to 1 as done in my previous
> > post/patch.
> 
> Ok. If we do that and also allow scsi_adjust_queue_depth
> to adjust the queue depth when tagged == 0, as is allowed today,
> then I think most of my objections to the patch should disappear,
> although it may require me to make a couple ipr changes.

Yeh, and then there is not really anything left of my patch, small as it
was, just the check for BQUE and calling scsi_activate_tcq(). And calling
scsi_activate_tcq if tagged_supported should be a separate patch that also
includes any required driver changes (like with ipr to call
scsi_deactivate_tcq, and an audit of all other drivers ...).

Really I was confused by scsi_mid_low_api.txt and code mentioning tags
along with cmd_per_lun and LLD abilities, like this:

	The mid level invokes scsi_adjust_queue_depth() with tagged
	queuing off and "cmd_per_lun" for that host as the queue length.
	These settings can be overridden by a slave_configure() supplied
	by the LLD.

But it makes no sense to set "tagged queuing off" on transports like FCP.

So, it is fine to use cmd_per_lun as the default queue_depth, without
any adjustments (in slave_configure) via scsi_adjust_queue_depth or
scsi_activate_tcq.

-- Patrick Mansfield
