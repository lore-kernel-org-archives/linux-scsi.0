From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: list_for_each_entry_safe() regarded as unsafe
Date: Fri, 10 Jun 2005 11:26:11 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506101122410.4975-100000@iolanthe.rowland.org>
References: <42A9982E.5020802@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:2434 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S262568AbVFJP0L
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 11:26:11 -0400
In-Reply-To: <42A9982E.5020802@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Dag Nygren <dag@newtech.fi>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 10 Jun 2005, Brian King wrote:

> > How about not acquiring the scan_mutex in scsi_remove_device, and 
> > insisting that the caller hold it instead?  There aren't that many places 
> > where it gets called.  In fact, one of those places (an error pathway in 
> > scsi_sysfs_add_sdev) looks like it already will cause a deadlock.
> 
> scsi_remove_device is an exported symbol, so requiring the caller to obtain
> the scan_mutex prior to calling it would not work. A __scsi_remove_device
> could be created, however, which would not grab the scan_mutex so that scsi
> core could do the right thing.

Okay.

How should a host be marked to indicate it's being removed?  Add another 
bit to shost_state?

Alan Stern

