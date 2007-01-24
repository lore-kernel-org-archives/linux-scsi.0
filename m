From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: use lock per host instead of per device for
	shared queue tag host
Date: Wed, 24 Jan 2007 08:59:49 -0800
Message-ID: <1169657989.3037.15.camel@mulgrave.il.steeleye.com>
References: <NONAMEBDp7mvjkO22Zh0000056d@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41124 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752025AbXAXQ7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2007 11:59:54 -0500
In-Reply-To: <NONAMEBDp7mvjkO22Zh0000056d@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

On Tue, 2007-01-23 at 16:53 -0800, Ed Lin wrote:
> The block layer uses lock to protect request queue. Every scsi device
> has a unique request queue, and queue lock is the default lock in struct
> request_queue. This is good for normal cases. But for a  host with
> shared queue tag (e.g. stex controllers), a queue lock per device means
> the shared queue tag is not protected when multiple devices are accessed
> at a same time.  This patch is a simple fix for this situation by introducing
> a host queue lock to protect shared queue tag. Without this patch we will
> see various kernel panics (including the BUG() and kernel errors in
> blk_queue_start_tag and blk_queue_end_tag of ll_rw_blk.c) when accessing
> different devices simultaneously (e.g. copying big file from one device to
> another in smp kernels).

This patch looks OK in principle.

However, are you sure you're not using a sledgehammer to crack a nut?
If the only reason you're doing this is because of the shared tag map,
then probably that should be the area you protect with a per-tag-map
lock.   The net effect of what you've done will be to serialise all
accesses to your storage devices.  For a small number of devices, this
probably won't matter than much, but for large numbers of devices,
you're probably going to introduce artificial performance degredation in
the I/O scheduler.

James


