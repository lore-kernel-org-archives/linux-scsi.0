From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] saved and restore result for timed out commands
Date: Mon, 16 May 2005 15:42:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0505161535380.5370-100000@iolanthe.rowland.org>
References: <20050516174215.GA23974@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50828 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261851AbVEPTmk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 15:42:40 -0400
In-Reply-To: <20050516174215.GA23974@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 16 May 2005, Patrick Mansfield wrote:

> Save and restore the scmd->result, so that timed out commands do not
> return the result of the TEST UNIT READY or the start/stop commands. Code
> is already in place to save and restore the result for the request sense
> case.
> 
> The previous version of this patch erroneously removed the "if" check,
> instead add a comment as to why the "if" is needed.

I can confirm that this patch does help; the correct status is now
returned to the sg user.  However there are still a few things that should
be fixed up:

First, this doesn't erase the sense data after error recovery.  I tried it 
with two different scenarios, one where the command returned a phase error 
and one where the command timed out.  In both cases the sg user got back a 
buffer with valid sense data, from the TUR commands issued by the error 
handler.  This could be highly misleading.

Second, as Patrick has noted, this doesn't prevent the error handler from 
issuing those TURs in the first place.  If some sort of Unit Attention 
came up, the sg user wouldn't be able to handle it correctly because the 
error handler would have swallowed it.  Of course, once this is fixed the 
first problem will no longer be an issue (no TUR, hence no unsolicited 
sense data).

Alan Stern

