From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: Fri, 14 May 2004 15:33:15 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405141514470.20244-100000@ida.rowland.org>
References: <20040514165956.GA8122@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:20996 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261416AbUENTdQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 15:33:16 -0400
In-Reply-To: <20040514165956.GA8122@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alberto Bertogli <albertogli@telpin.com.ar>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 14 May 2004, Mike Anderson wrote:

> I was incorrect in my previous statement. Well we may hold a reference
> count on the struct device passed into the scsi_add_host until all
> references on the host instance are gone and there maybe a positive ref
> count on the hostt module until all devices are closed a instance of
> LLDD should be able to do cleanup post return of scsi_remove_host. This
> needs to be true or SCSI mid-layer would not honor the requirement for
> the pci remove call.
> 
> I believe in the past you or someone else has mentioned that post the
> return of scsi_remove_host a Scsi_Host instance still has a hostt and a
> transportt which may be dangerous if all code paths are not correctly
> handling a host in the SHOST_DEL state.

Yes, that was me.

> I guess we still have this current issue on what is happening in the
> usb storage that it believes SCSI mid is still using the device. Is
> something not cleaning up, or is something in SCSI mid not honoring the
> SHOST_DEL state.

usb-storage checks the state of its kernel thread after calling
scsi_remove_host(), while preparing to kill the thread.  This can only
be done while the thread is idle, not processing any queued commands or
error handler requests.  The BUG in Alberto's log was triggered because
the thread was not idle.  Unfortunately the log doesn't say whether it was
executing a queued command or an error handler request at the time.

It does appear to have been some sort of race, as Alberto mentioned in his 
original message:

http://marc.theaimsgroup.com/?l=linux-usb-devel&m=108449593410567&w=2

It might not be easy to find out where the race is occurring.

Alan Stern

