From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 20:21:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924202121.B4409@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924190809.GB1330@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020924190809.GB1330@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Sep 24, 2002 at 12:08:09PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 12:08:09PM -0700, Mike Anderson wrote:
> Patrick Mansfield [patmans@us.ibm.com] wrote:
> > The problem is that we try to send a command via scsi_request_fn() to
> > a device that has no command blocks allocated - it's initializatin
> > is incomplete.
> > 
> > Moving the empty check up sounds like good and simple fix for 2.4, or
> > check if queue_depth == 0. Anything else would be difficult to get right.
> 
> Since error handling running during scan is kinda casuing the problem a
> a patch like the one below to  scsi_restart_operations sould also work. 

No.  There are still deadlock cases.  This is the _wrong_ fix.

Been there.  Tried it.  It failed.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

