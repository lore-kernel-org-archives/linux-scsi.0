From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 4/4] 2.4 SCSI error handling fixes
Date: Mon, 23 Sep 2002 19:57:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020923195751.A31564@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209231554.g8NFsRA02460@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200209231554.g8NFsRA02460@localhost.localdomain>; from James.Bottomley@steeleye.com on Mon, Sep 23, 2002 at 11:54:27AM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Sep 23, 2002 at 11:54:27AM -0400, James Bottomley wrote:
> rmk@arm.linux.org.uk said:
> > *** NOTE *** This needs a better solution.  Setting the FUA bit
> > bypasses the drives cache altogether.  You should read the message at
> > the URL above *before* commenting for a detailed explaination of the
> > problem, and why I've had to make this change. 
> 
> I read the message.  I think your drive is out of spec in its behaviour.

I do too.  But you you want to take a chance that other drives don't behave
the same way?

> Patches 1-3 look fine. Patch 4 would kill our performance on huge cache RAID 
> arrays (guess what most benchmarks are done on).
> 
> I think the correct (but much more invasive) fix for this is to return all 
> MEDIUM errors immediately to the upper level driver (sd or sr) and let them do 
> error recovery (i.e. determine whether retry should be done).  Once the upper 
> level drivers do the retry, you can reliably add the FUA bit to the command 
> for the retry.  Thus we'd only use FUA in the retry case and normal caching 
> performance shouldn't be impacted.
> 
> Do you want to try doing it this way?

No, because I don't know enough about the upper layers.

I thought I made the above crystal clear as well in my patch explainations.
Also, I believe David Brownell found a way to achieve the desired result
without killing performance.

I'm trying to sort out the error handling at the moment, which appears to
be rather bogus.  It simply doesn't work, even for _simple_ uninteligent
HBA drivers.

For example, if I force a permantent parity error to one selected device
and insert the HBA driver, the error handling kicks in and totally screws
the SCSI subsystem - it leaves requests behind in the driver and expects
a mere request for abort (not reset) to clear them.  The only thing that
can clear a stuck bus from an initiator is a bus reset.  The scsi error
handling doesn't do that.  It just expects to be able to queue another
command and have everything work.

Another bug I've found is that if we declare a device dead, we tell the
upper levels that the command completed successfully, even if it went
through all the error handling and failed!

Anyway, I'm currently trying to sort out these messes in my current 2.4.19
tree.  Hopefully I'll be able to get the Linux error handling into some
sort of usable state in the coming months.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

