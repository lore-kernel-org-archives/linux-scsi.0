From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: list_for_each_entry_safe() regarded as unsafe
Date: Thu, 9 Jun 2005 19:19:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506091907520.30626-100000@netrider.rowland.org>
References: <20050609215915.GA3105@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.247.233.35] ([140.247.233.35]:44789 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262424AbVFIXTO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 19:19:14 -0400
In-Reply-To: <20050609215915.GA3105@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Dag Nygren <dag@newtech.fi>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 9 Jun 2005, Mike Anderson wrote:

> Well we need a updated scsi_host state model that would prevent scanning
> while we are removing the host. I would believe that if the oopses in
> __scsi_remove_target where prevent there maybe some other oopses showing
> up as the host started going away.

More than that is needed -- you have to guarantee that two threads won't 
try to add or remove a target or device to the same host at the same time.

> > I don't know what the best way is fix this.  Even if scsi_forget_host() 
> > acquired the host's scan_mutex, that wouldn't be enough to guarantee the 
> > __targets and __devices lists won't change, would it?  And it might cause 
> > interference with other pathways.
> > 
> 
> Yes if scsi_forget_host acquired the scan_mutex it would deadlock when
> scsi_remove_device acquired it later on in the call stack.

How about not acquiring the scan_mutex in scsi_remove_device, and 
insisting that the caller hold it instead?  There aren't that many places 
where it gets called.  In fact, one of those places (an error pathway in 
scsi_sysfs_add_sdev) looks like it already will cause a deadlock.

Then it would be necessary also to have scanning threads check whether the
host is in the process of removal.  This means that scsi_forget_host will
have to change the host state somehow.  What do you think would be the
best to mark a host being removed?

On the plus side, neither forget_host nor remove_target would need to
acquire the host_lock, because holding the scan_mutex would already
guarantee the necessary exclusion.

Alan Stern

