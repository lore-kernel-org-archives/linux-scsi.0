From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: 2.6.14-rc1 load average calculation broken?
Date: Sat, 17 Sep 2005 00:23:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509170014070.4420-100000@netrider.rowland.org>
References: <432B43B3.2080801@ppp0.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:28431 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1750876AbVIQEXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 00:23:31 -0400
In-Reply-To: <432B43B3.2080801@ppp0.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Dittmer <jdittmer@ppp0.net>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, Pavel Machek <pavel@suse.cz>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 17 Sep 2005, Jan Dittmer wrote:

> > Maybe the wakeup occurred before ap->ops was set correctly, or after it 
> > was unset.  Jan, at what point did the oops happen?  Was it right after 
> > the device was detected, during removal, or some other time?
> > 
> > Can you put in some debugging printk's to see what values are in ap, 
> > ap->ops, and ap->ops->eng_timeout?
> 
> ap->ops is 0, on dereferencing I get a backtrace. ap has a valid pointer
> (-573296044 whatever that maps to).

Hmm...  I imagine that when the error handler is first starting up,
->host_busy is equal to ->host_failed because both are 0.  So that really
is not the appropriate condition to wait for.  A better approach would be
to have an atomic_t variable recording the number of pending invocations.

On the whole, I wonder if using kthread_stop here is such a good idea.  
The old mechanism for stopping worked well...

Alan Stern

