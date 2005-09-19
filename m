From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] Re: 2.6.14-rc1 load average calculation broken?
Date: Sun, 18 Sep 2005 20:58:04 -0700
Message-ID: <20050919035804.GA5260@us.ibm.com>
References: <432B43B3.2080801@ppp0.net> <Pine.LNX.4.44L0.0509170014070.4420-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52932 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932163AbVISD6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 23:58:30 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j8J3wTER030087
	for <linux-scsi@vger.kernel.org>; Sun, 18 Sep 2005 23:58:29 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8J3wT0f075832
	for <linux-scsi@vger.kernel.org>; Sun, 18 Sep 2005 23:58:29 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j8J3wSKI032706
	for <linux-scsi@vger.kernel.org>; Sun, 18 Sep 2005 23:58:29 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0509170014070.4420-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jan Dittmer <jdittmer@ppp0.net>, James Bottomley <James.Bottomley@SteelEye.com>, Pavel Machek <pavel@suse.cz>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 17 Sep 2005, Jan Dittmer wrote:
> 
> > > Maybe the wakeup occurred before ap->ops was set correctly, or after it 
> > > was unset.  Jan, at what point did the oops happen?  Was it right after 
> > > the device was detected, during removal, or some other time?
> > > 
> > > Can you put in some debugging printk's to see what values are in ap, 
> > > ap->ops, and ap->ops->eng_timeout?
> > 
> > ap->ops is 0, on dereferencing I get a backtrace. ap has a valid pointer
> > (-573296044 whatever that maps to).
> 
> Hmm...  I imagine that when the error handler is first starting up,
> ->host_busy is equal to ->host_failed because both are 0.  So that really
> is not the appropriate condition to wait for.  A better approach would be
> to have an atomic_t variable recording the number of pending invocations.
> 
> On the whole, I wonder if using kthread_stop here is such a good idea.  
> The old mechanism for stopping worked well...
> 

Since scsi_eh_wakeup can only be called on a completion or timeout of an IO
you cannot get a comparison when both are 0 (unless we have a bug
somewhere).

If the increment of host_failed, increment of host_busy, decrement of
host_busy, and the comparison of host_busy to host_failed is all under
the host_lock why would the atomic_t be better.

-andmike
--
Michael Anderson
andmike@us.ibm.com
