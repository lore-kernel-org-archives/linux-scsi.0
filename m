From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: no errors allowed during async probing
Date: Tue, 02 Jun 2009 13:19:31 -0500
Message-ID: <1243966771.4280.4.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.0906021401350.3228-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60698 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782AbZFBSTc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2009 14:19:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.0906021401350.3228-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2009-06-02 at 14:05 -0400, Alan Stern wrote:
> This patch (as1252) fixes a bug in the sd probing code.  When the
> probe routine was split up into a synchronous and an asynchronous
> part, too much was put into the asynchronous part.  It's important
> that all the possible failure modes occur synchronously, so that the
> driver core knows whether the probe was successful even before the
> async part is complete.
> 
> Another bug is that device removal has to wait for the async probing
> to finish!  The patch addresses both bugs, by moving some code back
> from sd_probe_async() to sd_probe() and by adding a call to
> async_synchronize_full() at the start of sd_remove().
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

This is pretty much line by line identical to the patch I already
posted, isn't it?  If not, help me understand what's different.

James


