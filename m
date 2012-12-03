From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 10/13] Make scsi_remove_host() wait for device removal
Date: Mon, 3 Dec 2012 08:42:57 -0800
Message-ID: <20121203164257.GE19802@htj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B608C1.6080803@acm.org>
 <20121202134515.GJ15930@mtj.dyndns.org>
 <50BC619F.7060707@acm.org>
 <20121203161510.GA19802@htj.dyndns.org>
 <50BCD59C.2020909@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43761 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab2LCQnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2012 11:43:02 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so2031694pad.19
        for <linux-scsi@vger.kernel.org>; Mon, 03 Dec 2012 08:43:02 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50BCD59C.2020909@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hello, Bart.

On Mon, Dec 03, 2012 at 05:38:52PM +0100, Bart Van Assche wrote:
> It is indeed possible to invoke complete() only if the device list
> became empty with the host state equal to SHOST_CANCEL,
> SHOST_CANCEL_RECOVERY, SHOST_DEL or SHOST_DEL_RECOVERY and in

We can test this with !scsi_host_scan_allowed(), right?

> scsi_remove_host() to wait for that completion only if the device
> list was not empty before the host state was changed into one of the
> four mentioned states. Do you really prefer this approach over the
> approach in the patch at the start of this thread ?

Maybe I'm missing something but if possible completion tends to be
much simpler than using waitqueue directly.  I *think* that's the case
here.  Am I missing something?

Thanks.

-- 
tejun
