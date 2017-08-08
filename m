From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/4] scsi_devinfo: fixup string compare
Date: Tue, 8 Aug 2017 11:25:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1708081103580.2055-100000@iolanthe.rowland.org>
References: <1502203017-101403-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57870 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1752254AbdHHPZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 11:25:49 -0400
In-Reply-To: <1502203017-101403-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, 8 Aug 2017, Hannes Reinecke wrote:

> When checking the model and vendor string we need to use the
> minimum value of either string, otherwise we'll miss out on
> wildcard matches.
> And we should avoid matching anything with zero size as this
> match will be incorrect.
> Without this patch certain Hitachi arrays will not be presenting
> VPD pages correctly.
> 
> Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
> Signed-off-by: Hannes Reinecke <hare@suse.com>

This is very questionable.  As described in commit b704f70ce200 ("SCSI: 
fix bug in scsi_dev_info_list matching"), there are devices which have 
vendor or model strings of length 0, and there are entries in the 
global device list like that too.  With this patch, such devices and 
such entries would never match anything.

Also, the idea of using the minimum length of either string doesn't 
sound right.  It would allow a device with string "abc" to match an 
entry in the list with string "abcd", which would be wrong.

Suggestion:

	Allow a device string to match a list entry if the lengths
	are equal or the list entry is shorter (this would be a 
	wildcard match), but not if the list entry is longer.  Here
	the device string length is after leading and trailing blanks
	have been removed.

	As a corollary, allow an empty device string to match an empty 
	list entry but nothing else.

Alan Stern
