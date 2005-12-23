From: Andrew Morton <akpm@osdl.org>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Fri, 23 Dec 2005 07:38:40 -0800
Message-ID: <20051223073840.7110dbb0.akpm@osdl.org>
References: <200512212359.jBLNxluV016971@hera.kernel.org>
	<20051222221329.5f317b8d.akpm@osdl.org>
	<20051223121534.GM2361@parisc-linux.org>
	<1135351652.3728.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:21726 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030560AbVLWPjC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 10:39:02 -0500
In-Reply-To: <1135351652.3728.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>
> There is a potential improvement, in that could be done which is only to
> use the workqueue if we're in atomic context.  However, I elected to
> leave playing with that cleanup until after 2.6.15

We don't have a way of determining whether we're in atomic context
(in_atomic() only works with CONFIG_PREEMPT).  If scsi internally knows what
context things are in then that'll work OK.

> There is also the point that I now have two of these allocations of
> structures containing a workqueue and a pointer in separate instances.
> It does look like this might be an improvement to the API (i.e. a
> workqueue use that manages the allocation of the actual work_struct).

Perhaps you could use work_struct.data for the scsi_target* and get back to
the work_struct via container_of().

