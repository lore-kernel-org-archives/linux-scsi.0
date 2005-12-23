From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 09:27:32 -0600
Message-ID: <1135351652.3728.4.camel@mulgrave>
References: <200512212359.jBLNxluV016971@hera.kernel.org>
	 <20051222221329.5f317b8d.akpm@osdl.org>
	 <20051223121534.GM2361@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50618 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964994AbVLWP1o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 10:27:44 -0500
In-Reply-To: <20051223121534.GM2361@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Fri, 2005-12-23 at 05:15 -0700, Matthew Wilcox wrote:
> On Thu, Dec 22, 2005 at 10:13:29PM -0800, Andrew Morton wrote:
> > Given that this can run an arbitrary amount of time later on, how do we
> > know that *shost is still live?
> 
> If there's still an starget, its parent shost must still be around, no?

Precisely, starget holds a reference to shost.  Even if this
put_device(&starget->dev) is the last put, triggering a final put of the
shost, we've stopped referring to it by that point.

There is a potential improvement, in that could be done which is only to
use the workqueue if we're in atomic context.  However, I elected to
leave playing with that cleanup until after 2.6.15

There is also the point that I now have two of these allocations of
structures containing a workqueue and a pointer in separate instances.
It does look like this might be an improvement to the API (i.e. a
workqueue use that manages the allocation of the actual work_struct).

James


