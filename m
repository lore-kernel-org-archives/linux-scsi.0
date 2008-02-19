From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Tue, 19 Feb 2008 10:22:20 -0600
Message-ID: <1203438140.3103.24.camel@localhost.localdomain>
References: <479FB3ED.3080401@hopnet.net>
	 <20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>
	 <20080130192947.GA21785@tree.beaverton.ibm.com>
	 <47B4682C.4020505@hopnet.net>
	 <1203089323.3058.20.camel@localhost.localdomain>
	 <47B9958A.8080104@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48947 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041AbYBSQW2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 11:22:28 -0500
In-Reply-To: <47B9958A.8080104@hopnet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Hopkins <vger@hopnet.net>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org

On Mon, 2008-02-18 at 22:26 +0800, Keith Hopkins wrote:
> Well, that made life interesting....
>   but didn't seem to fix anything.
> 
> The behavior is about the same as before, but with more verbose
> errors.  I failed one member of the raid and had it rebuild as a
> test...which hangs for a while and the drive falls off-line.
> 
> Please grab the dmesg output in all its gory glory from here:
> http://wiki.hopnet.net/dokuwiki/lib/exe/fetch.php?media=myit:sas:dmesg-20080218-wpatch-fail.txt.gz

I had a look through this.  Amazingly, in spite of the message spew, up
to here:

> sas: Enter sas_scsi_recover_host
> sas: trying to find task 0xffff81033c3d3d80
> sas: sas_scsi_find_task: aborting task 0xffff81033c3d3d80
> aic94xx: tmf timed out
> aic94xx: tmf came back

Everything is going normally (the REQ_TASK_ABORT are properly aborted an
retried).  At this point (around L3449 in the trace) the aborts start
failing.

Unfortunately, there's a bug in TMF timeout handling in the driver, it
leaves the sequencer entry pending, but frees the ascb.  If the
sequencer ever picks this up it will get very confused, as it does a
while down in the trace:

> aic94xx: BUG:sequencer:dl:no ascb?!
> aic94xx: BUG:sequencer:dl:no ascb?!

That's where the sequencer adds an ascb to the done list that we've
already freed.  From this point on confusion reigns and the error
handler eventually offlines the device.

I'll see if I can come up with patches to fix this ... or at least
mitigate the problems it causes.

James


