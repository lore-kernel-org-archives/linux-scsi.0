From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Retry scsi_mode_sense if UNIT ATTENTION occurs
Date: 29 Jul 2003 19:23:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059520994.2298.263.camel@mulgrave>
References: <Pine.LNX.4.44L0.0307281005590.797-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:53508 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S272382AbTG2XXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 19:23:46 -0400
In-Reply-To: <Pine.LNX.4.44L0.0307281005590.797-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2003-07-28 at 10:10, Alan Stern wrote:
> Jens:
> 
> This patch changes the scsi_mode_sense() routine to retry up to a total of 
> 3 times if a command fails with a UNIT ATTENTION sense key value.
> 
> Without this change, sr.c does not properly read the capabilities mode 
> page for a just-powered-up cdrom drive -- it gives up upon receiving a 
> Device Reset Occurred code.
> 
> The patch looks lengthy, but most of it just changes the indentation 
> level.

Actually, this isn't really the correct place for it.  The problem
occurs in sr not sd because sd already does an initial TUR to clear the
unit attention.

Before OLS got in the way and I got submerged in writing presentations,
I had some patches that Matt Dharm was testing out to add the TUR to the
initial sr code.

I'll pick that up (...er, when I get caught back up at work).

James


