From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Thu, 5 Jun 2003 09:41:34 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306050935160.793-100000@ida.rowland.org>
References: <20030604173413.A9632@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1284 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264666AbTFEN2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2003 09:28:03 -0400
In-Reply-To: <20030604173413.A9632@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 4 Jun 2003, Patrick Mansfield wrote:

> I thought that USB sending a command after online cleared was likely the
> last prepped request being sent. This can't be fixed within scsi_prep_fn,
> since it will not be called for the last request after online is cleared.
> 
> So we might as well move all the checking of online into the
> scsi_request_fn.

As far as USB is concerned, it doesn't matter very much if any commands
are sent after online is cleared, provided it's a relatively limited
number of commands.  I just would like to clarify whether or not there is
a guarantee that _no_ commands will be sent.  If it's explicitly agreed
(and it would help to put it into a comment or kerneldoc) that there is no
such guarantee, then little code needs to be changed.

Of course, it goes without saying that if a command is sent when online is
clear, the midlayer must be prepared to deal gracefully with the
inevitable error or failure of that command -- don't start a lengthy
series of retries or are-you-still-alive probes.

Alan Stern

