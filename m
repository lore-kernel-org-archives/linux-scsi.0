From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Thu, 28 May 2009 08:45:32 -0700
Message-ID: <m18wkhw7s3.fsf@fess.ebiederm.org>
References: <Pine.LNX.4.44L0.0905281105310.3037-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:60236 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZE1Ppn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2009 11:45:43 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905281105310.3037-100000@iolanthe.rowland.org> (Alan Stern's message of "Thu\, 28 May 2009 11\:24\:05 -0400 \(EDT\)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

Alan Stern <stern@rowland.harvard.edu> writes:

> There's another point to consider.  If you do accept my argument that 
> empty targets can be removed from visibility regardless of the host's 
> state, then this removal races with addition of a new child.  Since 
> removal involves calling device_del(), it can't be protected by the 
> host lock.  Instead we'd have to use a mutex to protect both target 
> addition and target removal.

Careful.  Holding a lock over device_del is an easy and hidden way
to trigger a rare deadlocks.

Eric
