From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: Wed, 24 Dec 2003 21:31:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2304040000.1072326693@aslan.scsiguy.com>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	<3637050000.1054690456@aslan.s	csiguy.com>
 <2113050000.1072285128@aslan.scsiguy.com>	<1072288242.1906.35.camel@mulgrave> 	<2148850000.1072292121@aslan.scsiguy.com>
 <1072292714.2415.39.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aslan.scsiguy.com ([63.229.232.106]:27396 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S262092AbTLYEbr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Dec 2003 23:31:47 -0500
In-Reply-To: <1072292714.2415.39.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

> On Wed, 2003-12-24 at 12:55, Justin T. Gibbs wrote:
>> The last 10% is a change to having the driver completely do its own
>> error recovery.  This change originated in late July and has received
>> extensive testing since then.  This is the reason that a major driver
>> version number bump was required for both drivers.  It is just not
>> possible to get sane error recovery behavior if the mid-layer ever
>> sees a timeout, so this really is a *bug fix*.
> 
> Elaborate on this more please...the error handling has been
> substantially revised between 2.4 and 2.6 with a view to making it more
> robust.  I don't recall seeing any bug reports from adaptec on the
> issue, but if there's a mid-layer problem, I'm sure we can fix it.

Other than some "refactoring" of code, the 2.4 and 2.6 SCSI layer
error recovery model and behavior is largely unchanged.  In fact,
the behavior is almost identical to the new-eh 2.2 SCSI layer.  I
listed most of my complaints about the error recovery model back
in late 2000 and early 2001, so I was under the impression that my
comments in this area were widely known.  I will list them here again
briefly.  If you want to go into more details about my concerns, I'd
be happy to do so after the first of the year - I hope to be spending
very little time in front of a computer until then.

The crux of the problem is that *watchdog error recovery* is happening
at entirely the wrong level in Linux.  [I emphasize *watchdog* since
real-time applications must have the ability to shoot down arbitrary
commands that take too long.  The current driver hooks being used by
the mid-layer error recovery work sufficiently for this purpose.]
Certainly, having common error recovery code provides all of the benefits
of having centralized code, but code operating at the mid-layer cannot
know with sufficient details what is actually going on with the storage
subsystem to make intelligent decisions.  To illustrate my point, lets
review the current error recovery strategy:

  1) When a command times out, it increments the host_failed count.
     We also stop the queuing of new commands to the host by setting
     the "in recovery" host flag.
  
  2) Once all commands have either timed-out or completed
     (host_failed == host_busy), the recovery thread is woken up
     to recover any failed commands.
  
  3) We loop through all failed commands and:
  
  	a) Issue an abort request to the HBA.
  	b) If the abort is successful, use that same
  	   command structure to issue a TUR.
  
  3) If any abort requests fails we loop through each device on the
     host that has failed commands and issue a BDR.
  
  4) If any BDR requests fail, we perform a bus reset.
  
  Also keep in mind that any timed-out command that completes via
  scsi_done() is ignored.
  
Some of the problems with this strategy are:

1) During recovery, access to perfectly viable devices is cut off.

2) The mid-layer doesn't know which of the timed-out commands is the root
   cause of the failure.  It assumes, since it doesn't have access to
   better information, that all commands that have timed-out are equally
   dead.

3) If the mid-layer happens to abort a command that *is* the root cause
   of the failure, the completions of all the "released" commands are
   ignored.  This causes the mid-layer to request aborts for commands
   that are not outstanding and then replay these commands that have
   already completed successfully.  The replay may have unintended
   side-effects - replay order is not maintained and no thought is given
   to non-DASD devices where replay is destructive.  The replay may
   also occur on a device that never really failed, but what held off
   due to an error on another device.

4) The TUR that occurs after each abort causes the recovery process to
   take an inordinate amount of time.  Consider that the mid-layer can't
   pick the most likely command to abort and that with lots of commands
   outstanding chances are that at least half of the commands will have
   to be aborted before the *right one* is aborted.

In general, the HBA driver has sufficient information to greatly limit
the scope of its recovery efforts.  It can also do this with the least
amount of impact to perfectly operational devices.  For example, when
a command times-out, the HBA can determine things like:

 o Has this command actually been issued to a device?
 o Is some other command currently *hogging* the wire/bus?
 o Is this command currently active on the wire/bus?

etc.  This allows both the HBA drivers to quickly decide if there is
sufficient information to perform a targeted recovery (command stuck on
the bus is the problem) and if not, immediately elevate recovery to
harsher measures.  In the aic7xxx and aic79xx drivers, recovery is
completed within a few milliseconds of a timeout and at worse, in 5
seconds.  With the current mid-layer strategy and 10s of commands
outstanding, recovery typically takes minutes.  In the case of 2.4,
you're lucky if recovery *ever* completes. 8-)

In general, I prefer the CAM model.  Briefly, this means, let the
HBA drivers do what they can do best, provide as much information to
the peripheral drivers so they can do their job correctly, and provide
a "mid-layer" to simply route commands between the two.  This avoids
having a mid-layer that second guesses, often incorrectly, both ends
of the system.

--
Justin

