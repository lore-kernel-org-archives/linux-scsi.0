From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Fri, 24 Jan 2003 16:55:33 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0301241649460.692-100000@ida.rowland.org>
References: <3E31AB91.9080400@splentec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E31AB91.9080400@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.name>, Doug Ledford <dledford@redhat.com>, David Brownell <david-b@pacbell.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, 24 Jan 2003, Luben Tuikov wrote:

> >>A LLDD should and must *not* call scsi_unregister_host().  This brakes
> >>all hierarchy.
> > 
> 
> What I probably meant is the detect()/release() pair; release() itself
> normally calls scsi_unregister(host); the point is that it got nudged
> from ``above'', i.e. SCSI Core.
> 
> How can a LLDD be certain that it can safely call scsi_unregister_host()
> whenever it wishes?  As Doug pointed out this leads to problems.

Apparently it can't.  I don't mean to say that this was the right thing to 
do; I just meant that this is what Matt's currently-proposed patch does.  
Personally, I'm not very familiar with the details of the SCSI subsystem, 
and I don't know what preconditions are required for calling the various 
API's.

> Furhtermore, are we talking about scsi_unregister_host() or
> scsi_unregister(host)?  The former does drivers and the latter
> does hosts.  This would mean that my original statement was
> nevertheless correct, how can a LLDD decide to unload itself safely?

I did indeed type it wrong.  The code first calls scsi_remove_host(host)  
and then it calls scsi_unregister(host).

Alan Stern

