From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/2] convert libsas to the libata new eh
Date: Sun, 13 Feb 2011 13:18:37 -0600
Message-ID: <1297624717.3001.2.camel@mulgrave.site>
References: <1295797260.3007.118.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1295797260.3007.118.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-ide <linux-ide@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-01-23 at 09:41 -0600, James Bottomley wrote:
> The bad news is that this is a pretty horrific conversion.  Because of
> the amount of control the new eh wants (and the slew of monolithic
> assumptions it makes), the entire error handler routine has to be sliced
> apart and sewn back together to make it callable as part of an existing
> error handler (rather than trying to do everything on its own).
> 
> The even worse news is that unless you have an existing strategy
> handler, you can't make use of this.  That means that ipr is
> unconvertable in its current form.  Given the two really nasty options:
> give ipr its own error handler via its own transport class, or attach
> ipr to libsas and let it do the work, I'd choose the latter.
> Unfortunately, my power box with IPR has been non-functional for a year
> (and all pleas to IBM to fix it have so far gone unanswered), so I can't
> really do this myself.
> 
> Once we carve up libata, it's still a rather complex call sequence for
> libsas because of libata's annoying insistance on calling the error
> handler at the drop of a hat.  The principle differentiator used is the
> fact that if a SCSI command no longer has an associated SAS task, (i.e.
> libsas thinks it's complete) it must be destined for libata.  This works
> correctly in all the ATAPI sense processing instances I've tested.
> Finally, we still have to call port recovery.  Currently, it's
> impossible to tell which port libata thinks is in error (libata knows
> because it has one host per port, but libsas doesn't), so the final
> solution is just to call port recovery for every SATA/STP attached port.
> 
> I've tested all of this with mvsas over expander attached ATA devices
> using STP (aic94xx seems to have developed some handling fault for STP,
> which I'll look into next).

Since there's been remarkably little discussion of the ata changes, I
think it's time to put this in linux-next to see what shakes out.

James


