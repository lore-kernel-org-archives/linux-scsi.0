From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 16/32] scsi/be2iscsi,qla2xxx: convert to
 alloc_workqueue()
Date: Wed, 2 Feb 2011 11:25:21 +0100
Message-ID: <20110202102521.GA24115@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-17-git-send-email-tj@kernel.org>
 <4D489B09.9010906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1BBKZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 05:25:27 -0500
Content-Disposition: inline
In-Reply-To: <4D489B09.9010906@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohank@serverengines.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Hello,

On Tue, Feb 01, 2011 at 05:45:13PM -0600, Mike Christie wrote:
> I think these are used in the main IO path, so would you also want
> WQ_HIGHPRI | WQ_CPU_INTENSIVE to be set?

Maybe HIGHPRI but definitely not CPU_INTENSIVE, but even HIGHPRI isn't
usually necessary.  The queue of pending works tend to be short and
consumed pretty fast.

> I think qla2xxx was using this in a path they expected to have high
> throughput/low latency, and from the interrupt handler they would
> try to queue the work on the same cpu the isr was answered on. With
> the new workqueue code could you possibly get queued onto a
> workqueue that is doing other work for other drivers?

There are no separate workqueues.  There's one per cpu which is used
by all workqueue users.  HIGHPRI boosts the queueing order in that
queue.

> Should qla2xxx be using the blkiopoll framework instead of a
> workqueue or will workqueues still provide the same performance when
> setting WQ_HIGHPRI | WQ_CPU_INTENSIVE?

CPU_INTENSIVE isn't applicable at all unless you want to run crypto or
zlib from the driver.

blk_iopoll runs off softirq and will always have lower latency than
workqueue which requires scheduling, so it depends on the
requirements.  I guess the best thing would be playing with things a
bit and make decisions on test results.  It shouldn't be too difficult
to switch among them.

Thanks.

-- 
tejun
