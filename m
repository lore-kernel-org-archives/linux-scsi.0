From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Wed, 25 Sep 2002 00:45:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925004504.E9952@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com> <20020924233941.A9952@flint.arm.linux.org.uk> <20020924233346.GE1330@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17tzMX-00017h-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 00:45:05 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17tzMW-00039f-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 00:45:04 +0100
Content-Disposition: inline
In-Reply-To: <20020924233346.GE1330@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Sep 24, 2002 at 04:33:46PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 04:33:46PM -0700, Mike Anderson wrote:
> Russell King [rmk@arm.linux.org.uk] wrote:
> 
> looks good.
> 
> One nit is that scsi_report_bus_reset sets was_reset which is only
> called by two drivers I currently see. The new code does not catch this
> case, but the trade of is probably worth it.

I opted for the safe method here for two reasons (why am I making lists
of stuff all the time 8)):

a) There seems to exist a hole with the device reset handling, where we
   want to reset one device.  We make no attempt to mark this device has
   having been reset.

   The other (bus and host) reset functions in scsi_error.c set was_reset
   and the unit attention flag.

b) st.c certainly uses was_reset for its own purposes.  We could introduce
   a new flag "needs_locking" or something like that, but to be honest I
   didn't see the point.  If we entered the error handler, commands have
   gone horribly wrong, and the host is quiet, so we aren't going to
   eat bus bandwidth sending these commands.

(a) I'm going to think about tomorrow; IMHO it should be plugged anyway,
but I want to make sure we get the right approach there, and end up with
something sane.  I also want to review your work; I'm sure there's ideas
that will be mutually beneficial to each other in both of our the error
handler efforts.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

