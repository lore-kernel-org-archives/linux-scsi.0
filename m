From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: SCSI woes (followup)
Date: Wed, 25 Sep 2002 09:41:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020925094137.A24532@flint.arm.linux.org.uk>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com> <20020924233941.A9952@flint.arm.linux.org.uk> <20020924170857.A15340@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17u7jm-00031M-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 09:41:39 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17u7jm-0006T6-00
	for linux-scsi@vger.kernel.org; Wed, 25 Sep 2002 09:41:38 +0100
Content-Disposition: inline
In-Reply-To: <20020924170857.A15340@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Sep 24, 2002 at 05:08:57PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 05:08:57PM -0700, Patrick Mansfield wrote:
> On Tue, Sep 24, 2002 at 11:39:42PM +0100, Russell King wrote:
> > Ok, as promised here's the first patch.
> 
> Looks nice.  I have the same comment as before about no commands.

I fail to see what the problem here is.  I've repeatedly explained this.
I'm not going to explain it again; maybe it would be wise to read the
2.4.19 code?  Please re-read all my mails since Sunday.

> > +static void scsi_eh_lock_done(struct scsi_cmnd *SCpnt)
> > +{
> > +	struct scsi_request *SRpnt = SCpnt->sc_request;
> > +
> > +	SCpnt->sc_request = NULL;
> > +	SRpnt->sr_command = NULL;
> > +
> > +	scsi_release_command(SCpnt);
> > +	scsi_release_request(SRpnt);
> > +}
> 
> This is back to my orginal point (i.e. case 1 in your other response
> about "restarting operations after error handling", I haven't figured
> out case 2 yet) - the above will not be called if there are no commands.

It seems that you've misunderstood what this code is doing.

We queue up a set of door lock requests onto the head of the queue for
each device.  Each of these requests needs a "done" function (read some
of the other subsystem code to find out why, I'm not going to explain
the basics of the subsystem here) and the above code that you quoted
is it.  Since we are the last user of the request and command structures
for this door lock request, we must free them to avoid leaking memory.
So we do exactly that.

The above code has _nothing_ to do with any other request what so ever
nor the state of the queues.

I fail to see what is soo difficult to grasp here.

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

