From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as284) Add BLIST_INQUIRY_36 to existing blacklist USB
 entries
Date: Thu, 20 May 2004 10:23:34 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0405201010400.1002-100000@ida.rowland.org>
References: <20040519153642.A23286@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2308 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265113AbUETOXg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 10:23:36 -0400
In-Reply-To: <20040519153642.A23286@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 19 May 2004, Patrick Mansfield wrote:

> Alan -
> 
> How is it being overridden? I don't see usb storage setting
> BLIST_INQUIRY_36.
> 
> -- Patrick Mansfield

It doesn't currently, but I recently submitted a change that does set the 
flag.  According to Matt Dharm the extra INQUIRY data bytes are for use by 
the host adapter driver, and since usb-storage doesn't use them there's no 
reason to get them from the device.  Just the opposite; we want to _avoid_ 
trying to read them because lots of USB mass storage devices choke when 
asked to transfer more than 36 INQUIRY bytes.

I recently saw an example of a drive which reports that 37 bytes are
available and _still_ dies when asked to transfer more than 36.  That's 
why I decided to add the flag.

Alan Stern



