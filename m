From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Tue, 03 Sep 2002 09:35:02 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200209031435.g83EZ2F03562@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> Doug Ledford writes:
> 
>  > took the device off line.  So, in short, the mid layer isn't waiting
> long   > enough, or when it gets sense indicated not ready it needs to
> implement a   > waiting queue with a timeout to try rekicking things a
> few times and don't   > actually mark the device off line until a longer
> period of time has   > elasped without the device coming back.
> 
> There is a kernel config CONFIG_AIC7XXX_RESET_DELAY_MS (default 15s).
> Would increasing it help?

Justin Gibbs writes:
> This currently only effects the initial bus reset delay.  If the
> driver holds off commands after subsequent bus resets, it can cause
> undeserved timeouts on the commands it has intentionally deferred.
> The mid-layer has a 5 second delay after bus resets, but I haven't
> verified that this is honored correctly during error recovery.

I'm planning a major re-write of this area in the error handler.  The way I 
think it should go is:

1) Quiesce host (set in_recovery flag)
2) Suspend active timers on this host
3) Proceed down the error correction track (eliminate abort and go down 
device, bus and host resets and finally set the device offline).
5) On each error recovery wait out a recovery timer for the device to become 
active before talking to it again.  Send all affected commands back to the 
block layer to await reissue (note: it would now be illegal for commands to 
lie to the mid layer and say they've done the reset when they haven't).
6) issue a TUR using a command allocated to the eh for that purpose.  Process 
the return code (in particular, if the device says NOT READY, wait some more). 
 Only if the TUR definitively fails proceed up the recovery chain all the way 
to taking the device offline.

I also plan to expose the suspend and resume timers API in some form for FC 
drivers to use.

James
