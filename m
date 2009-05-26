From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bug in SCSI async probing
Date: Tue, 26 May 2009 10:34:23 -0500
Message-ID: <1243352063.2815.34.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905261040230.5554-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41315 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbZEZPeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 11:34:23 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905261040230.5554-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Tue, 2009-05-26 at 11:22 -0400, Alan Stern wrote:
> James & Arjan:
> 
> Am I missing something here?  It looks like
> 
> 	fastboot: make scsi probes asynchronous
> 
> has introduced a bug in the sd probing code.  AFAICT, there is now
> nothing to prevent do_scan_async() from returning before
> sd_probe_async() has run.

True, but this isn't really a problem.

> Doesn't this mean that there's nothing to prevent sd_remove() from 
> being called and trying to unregister the disk _before_ 
> sd_probe_async() has managed to register it?

Yes, we've been discussing this ... most of the removal functions now
need async_synchronize calls to mitigate this type of race.

James


