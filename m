From: Doug Ledford <dledford@redhat.com>
Subject: Re: Possible bug handling bad I/Os?
Date: Thu, 29 Aug 2002 12:41:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020829124142.D31625@redhat.com>
References: <B9939B24.2BFC%mheinz@infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B9939B24.2BFC%mheinz@infiniconsys.com>; from mheinz@infiniconsys.com on Thu, Aug 29, 2002 at 09:34:28AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Michael Heinz <mheinz@infiniconsys.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Aug 29, 2002 at 09:34:28AM -0400, Michael Heinz wrote:
> The last thing to happen seemed to be that my driver would get a call to
> queue_command while I knew the connection was down. Since I knew the
> connection was down I would simply immediately return an error and do
> nothing else.

[ You didn't specify your kernel version, so the below comment is for 2.4 
kernels, on 2.5 kernels all drivers are treated as new eh drivers ]
Does your driver use the new eh code?  If not, then this is your problem.  
Non new eh code based drivers are not allowed to fail a queue_command 
call, and the return value isn't checked.

> So, my question is: Is this the right way to handle this problem, or is
> there another issue? At least part of the SCSI system knows the command was
> bad, because it never tries to abort it - but it never issues another
> command, either.

Summary.  If your driver is not a new eh code driver (it still uses the 
old recovery interface), then queue_command() may not fail and if you need 
to bail on a command, then you might as well just call the done() function 
with this command as the argument from queue_command then return.  If it 
is a new eh driver, then you need to make sure you never bail out on a 
request when there are no commands currently active/busy on that device or 
else the new queue code will quit sending commands to this device 
permanently.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
