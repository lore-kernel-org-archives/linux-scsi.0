From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: 27 Feb 2004 13:34:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077910452.2157.110.camel@mulgrave>
References: <1077906383.2157.98.camel@mulgrave>
	<3462370000.1077909838@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:64745 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262954AbUB0TeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 14:34:16 -0500
In-Reply-To: <3462370000.1077909838@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Fri, 2004-02-27 at 13:23, Justin T. Gibbs wrote:
> 1) The mid-layer doesn't correctly handle this situation.  The mid-layer
>    uses blk_plug_device() to implement this behavior rather than
>    blk_stop_queue().  The leaves the implementation vulnerable to
>    any code that does a manual unplug (e.g. the SCSI scan code) or a
>    blk_run_queues() (e.g. MD) which can alter the duration of the delay.
>    While the host may be able to tune the delay to HZ, the default values
>    are not.  I'm also not sure that leaving the default blk_unplug delay
>    as 0 gives you a deterministic jiffy long delay before the request
>    function will be hit again.

There's no guaranteed minimum delay time required by the specs.  We
pause for a predetermined number of unplugs if you look at the code,
which is actually under the control of the driver.  The trade off is
that we want to try faster under heavy I/O pressure, so the delay isn't
fixed, it's bounded by the I/O pressure in the system, which is as it
should be.

> 2) These drivers both include Domain Validation support.  These commands
>    do not go through the mid-layer at all yet require proper queue full
>    and busy handling.

Well, if the driver used the correct command handling infrastructure for
that, they would go through the mid-layer and there would be no problem.

James


