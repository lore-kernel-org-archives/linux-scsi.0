From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 14:58:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924145852.A28042@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200209241346.g8ODkER09516@localhost.localdomain>; from James.Bottomley@steeleye.com on Tue, Sep 24, 2002 at 09:46:14AM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 09:46:14AM -0400, James Bottomley wrote:
> I think it's method of operation is misplaced.

I think it is misplaced.  It locks the doors of devices that aren't even
in use, which is just plain stupid.

> However, for your case does simply moving the queue empty check to the top 
> cause the problems to go away? (That would be hiding the problem not fixing 
> it, but still...)

I #if 0'd it out, and it makes the problem go away.

One thing to note is the comment that Eric left in the code about it -
it seems to indicate that he believes it to be misplaced, but its there
because we have host drivers using the old error handling code.

I'm wondering if this behaviour only happens with host drivers that use
the new error handling.  If so, one possibility would be to follow Eric's
suggestion there, and lock the door in the error handler "as Eric intended"
and leave that door locking behind for the old error handling.

Incidentally, I've found another weirdness in the code.  We decide that
we need to lock the door based on the "was_reset" flag, which we clear.
However, st.c uses "was_reset" to decide whether to suspend operations
(due to a bus reset).  The two uses of this flag seem to conflict each
other.  How can we guarantee that st.c will see was_reset set if the
request function clears it?  st.c appears to use scsi_request_fn, so
I guess there's a conflict of use there.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

