From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix sd open/remove race
Date: 09 Apr 2004 10:35:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081524905.2203.52.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404091116020.1000-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:32157 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261416AbUDIPfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 11:35:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.0404091116020.1000-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2004-04-09 at 10:24, Alan Stern wrote:
> You're right.  However, you still want calls to sd_open to start failing
> as soon as the disconnection notice is received.  Since the
> disk-unavailable state can't be indicated by clearing disk->private_data,
> it has to be indicated in some other way.  How to do it is up to you, but
> whatever way you choose, the indicator should be cleared in sd_remove (and
> that change must be synchronized by acquiring the new semaphore).

That's what the original bug2400 thread was all about.  I think opening
with an already degraded device (one that will EIO to everything) is
just as good as refusing the open.  That's why the only race is the
reference race.  It's better to refuse the open, but the effects of
either are the same.

> Ah, yes.  However there's no reason to hold the semaphore _every_ time you 
> do a scsi_disk_put.  And once you use something else as an indicator, 
> there won't be any need to clear disk->private_data.

Actually, there is a (very obscure) three thread SMP race that this
prevents.  Thread 1 -> sd_remove; Thread 2 -> sd_close (for last close)
and Thread 3 -> sd_open

Thread 2 might end up doing the last put and if it were not protected it
would still race with sd_open.

James


