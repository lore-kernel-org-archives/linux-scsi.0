From: Abhishek Rai <abba@cs.sunysb.edu>
Subject: Re: Help - how to identify the callers in a SCSI lower-leveldriver
Date: Wed, 7 Apr 2004 21:09:15 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.53.0404072106530.12925@compserv1>
References: <519672568F040C41B6FAC21ADF51B18FEFA0@mailnode1.commstor.crossroads.com>
 <20040407205701.GA27311@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sbcs.sunysb.edu ([130.245.1.15]:29885 "EHLO sbcs.cs.sunysb.edu")
	by vger.kernel.org with ESMTP id S261378AbUDHBLw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2004 21:11:52 -0400
In-Reply-To: <20040407205701.GA27311@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org


> > The shim (a pseudo SCSI lower-level driver) we are working on sits in
> > between Linux SCSI mid-level driver and our existing kernel driver which
> > interfaces with a FC driver which interacts with the FC HBA.
>
> wow that sounds like a great way to kill performance, that many extra layers
>
> >
> > To track SCSI initiators' tasks, it would be great if our existing kernel
> > driver knows which application makes the (SCSI passthrough ioctl) call to
> > /dev/sda.
>
> well... it's a fundamentally hard problem. For example the application that
> submitted the IO may no longer exist on disk by the time you get to see the
> IO, or the process may already have exited. It sounds like a fundamentally
> fragile/broken concept to use this information for *anything*, it's still
> not clear to me what you'd use it for (other than doing a gross hack by
> faking IO priorities based on application name but that's sooo not the right
> solution to that problem)
>

If it is just a feature you want in your development driver, you can do it
at the file system level, e.g., modify an existing file system, or better
still, have a thin stackable file system layer that does that. Then you
can mount the file system on your /dev/sda so that the stackable file
system sits in between the underlying file system and the VFS.

Abhishek
