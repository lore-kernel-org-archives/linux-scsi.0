From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Discussion: soft unbinding
Date: Sat, 03 May 2008 19:22:11 +0200
Message-ID: <481C9F43.9040406@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0805031148530.16732-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:60168 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761431AbYECRWY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 13:22:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.0805031148530.16732-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> When talking about "soft" unbinding, the main question seems to be: How 
> soft?
> 
> It would be easy, for instance, to change usb-storage so that unbinding
> would wait until the current command was finished.  But clearly one
> wants to do more: Give the upper-level SCSI drivers a chance to
> shutdown cleanly and issue their FLUSH CACHE commands, wait for all
> pending commands to complete, and so on.

scsi_remove_host is potentially able to do this, and unless my memory 
betrays me, did so in the past.

> It's the "wait for pending commands to complete" part that is hard.  
> Some commands have relatively long timeouts.

Is there reason to be less patient during soft unbinding?

If so, the decision which commands can be aborted should IMO be made by 
the application layer.

> Error handler operations have no timeouts.  Commands submitted through
> sg can have effectively infinite timeouts.

Hmm, I can't comment on these two.

> So how long should we wait?

I presume if a user launches a "remove safely" command, he means it.  Or 
if he doesn't mean it, he still can hot-unplug before completion of the 
shutdown procedures.  The only exception is a locked drive door or a 
similar ejection mechanism which forces the user to wait for software 
coming to terms.

> Should there be a scsi_soft_remove_host() routine that accepts a
> timeout value?  It would remove the devices under the host and wait
> until the timeout expires (if necessary) before aborting all pending
> commands.  Unlike scsi_remove_host(), it would really abort these
> commands as though they had timed out, instead of simply cancelling
> them.  It would guarantee that when it returned, no commands were still
> running on the host and no more commands would be submitted.

It would be an API with more guarantees/ clearer semantics than 
scsi_remove_host() and even also...

> This would essentially be a standardized version of the special code 
> Stefan has put into the sbp2 and firewire-sbp2 drivers.

...with more guarantees/ clearer semantics than the scsi_remove_device() 
API which the SBP-2 drivers happen to use.  They use them merely because 
this has been found to work more satisfyingly at some point, and they 
don't have difficulties to use this API (i.e. look up the logical units 
to feed to scsi_remove_device()).

Curious; scsi_mid_low_api.txt says in the context of scsi_remove_host:

     When an HBA is being removed it could be as part of an orderly
     shutdown associated with the LLD module being unloaded (e.g. with
     the "rmmod" command) or in response to a "hot unplug" indicated by
     sysfs()'s remove() callback being invoked. In either case, the
     sequence is the same [...]

while it says in the context of scsi_remove_device:

     In a similar fashion, an LLD may become aware that a SCSI device has
     been removed (unplugged) or the connection to it has been
     interrupted. [...] An LLD that detects the removal of a SCSI device
     can instigate its removal from upper layers with this sequence [...]

AFAIR scsi_remove_host once simply worked just as if the LLD itself 
called scsi_remove_device() for each device on that host beforehand. 
Eventually there was a change in the SCSI core internal state model 
which reduced what scsi_remove_device(), when called internally from 
within scsi_remove_host(), was able to do.  This is contrary to the text 
quoted above.  I haven't tested for some time now how the SCSI core 
behaves right nowadays.

Back to scsi_soft_remove_host():

Does the SCSI core actually need separate APIs for soft unbinding 
(a.k.a. orderly shutdown) and hot removal?  We surely have different 
requirements in both cases:  Give pending commands some time to finish 
and send some finalizing commands (e.g. synchronize cache, unlock door) 
in the shutdown case, fail all commands and stop any error retries in 
the hot unplug case.

But isn't hot unplug just a special case of orderly shutdown --- 
basically a case where the transport driver's responsibility is to fail 
commands (pending ones and new ones) quickly?  In addition, fail them 
with failure indicators which tell upper layers that it is no use to 
retry them.

Actually, quick failure and suppression of retries in the hot unplug 
case is IMO not even as critical as the proper execution of pending and 
finalizing commands in the soft unbinding case.  The only critical 
aspect of hot unplug is that IO terminates eventually, i.e. applications 
don't hang.

So, rather than adding a scsi_soft_remove_host API, wouldn't it be 
appropriate and possible to make sure that

   - scsi_remove_host is able to initiate and perform soft unbinding,

   - LLDs return proper failure codes in the hot unplug case, and SCSI
     core and upper layers properly interpret them i.e. don't initiate
     futile retries.
-- 
Stefan Richter
-=====-==--- -=-= ---==
http://arcgraph.de/sr/
