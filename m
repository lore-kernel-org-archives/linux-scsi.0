From: Willem Riede <wriede@riede.org>
Subject: Re: [PATCH] sg block layer tcqing fix
Date: Tue, 6 Jan 2004 06:46:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106114630.GW4339@linnie.riede.org>
References: <3FF08EAF.9080708@us.ibm.com> <3FFA426B.2030406@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc12.comcast.net ([204.127.202.56]:23015 "EHLO
	sccrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S261889AbUAFLqb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 06:46:31 -0500
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.10/8.12.10) with ESMTP id i06BkUEM006358
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2004 06:46:30 -0500
Content-Disposition: inline
In-Reply-To: <3FFA426B.2030406@torque.net> (from dougg@torque.net on Tue, Jan 06, 2004 at 00:06:51 -0500)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2004.01.06 00:06, Douglas Gilbert wrote:
> Brian King wrote:
> > In bringing up a new LLD driver I am working on, I came across an oops 
> > related to sg and using the TCQ function provided by the block layer. 
> > The backtrace is shown below. I did some poking around and it looks like 
> > when doing SG_IO ioctls to devices running blk tagged command queuing, 
> > blk_queue_start_tag gets called, but blk_queue_end_tag never does. 
> > Attached is a patch against 2.6.0 which adds the call in sg_cmd_done and 
> > gets rid of the oops for me. Please apply.
> 
> Brian,
> Thanks for this patch. As far as I can tell this patch is needed
> for all SCSI char ULDs (in other words: sg, st and osst) when
> used with a LLD that uses block layer queueing infrastructure.
> At the moment that is only the 53c700 driver (maintained by James B.)
> and that one you are working on (I suspect).
> 
> Given that no other ULDs call blk_queue_*_tag() routines it seems
> a bit strange that sg, st and osst need to call blk_queue_end_tag()
> prior to calling scsi_release_request(). Perhaps the cleanup can be
> built into scsi_release_request() or a new variant (e.g.
> scsi_release_special_request() ) could be introduced.

IMHO, it would be much cleaner if sg, st and osst didn't need to be
aware of tagging, so I'd prefer that it be handled automagically in
the existing scsi_release_request().

Thanks, Willem Riede,
osst maintainer.
