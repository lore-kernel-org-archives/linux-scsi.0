From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Tue, 15 Oct 2002 16:52:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015205218.GG4391@redhat.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021015130445.A829@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: "Jeffery, David" <David_Jeffery@adaptec.com>, 'Dave Hansen' <haveblue@us.ibm.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Oct 15, 2002 at 01:04:45PM -0700, Patrick Mansfield wrote:
> 
> I totally agree the queue depth should not be limited based on the number of
> devices, but there should be a maximum limit - as Justin noted with the
> aic driver, using a large default queue depth (he had 253 or so) is not
> good with linux.

That's largely due to the scsi_request_fn() in its current form.

> The queue depth should be as small as possible without limiting the
> performance.

Which happens to be a magic number that no one really knows I think ;-)  
Current goals of the work I'm doing include making this adjustable so you
aren't wasting queue depth on devices that have a hard limit less than
your initial queue depth value and changing the scsi_request_fn() to be
more fair with command allocation on a controller in the presence of
starvation (and of course, starvation is only possible when the queue
depth of all devices is greater than the depth of the controller, so
obviously the starvation code in scsi_request_fn() is something
controllers have been avoiding by limiting queue depths on individual
devices).

The adjustable queue depth work has been mostly done and sent to linus.  
I'm trying to finish up the last few controllers that haven't been 
modified to the new scheme yet.  The request_fn work is on hold until this 
is done (because the breakage made everyone moan so loadly that I dropped 
everything else until this is taken care of).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
