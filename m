From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Thu, 30 Oct 2003 11:26:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031030112621.A7844@beaverton.ibm.com>
References: <20031030100501.A7250@beaverton.ibm.com> <Pine.LNX.4.44L0.0310301351380.1440-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:61875 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262775AbTJ3T1N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 14:27:13 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0310301351380.1440-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Thu, Oct 30, 2003 at 01:56:36PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pat LaVarre <p.lavarre@ieee.org>, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

On Thu, Oct 30, 2003 at 01:56:36PM -0500, Alan Stern wrote:

> Why bother to test and shorten len in __scsi_mode_sense() if the callers 
> have already taken care of that?  Right now the only users of 
> __scsi_mode_sense() are the read-write-flag and cache-type routines in 
> sd.c, and your patch makes them use the values you want for len.  If in 
> the future other routines decide to call __scsi_mode_sense(), they might 
> not appreciate having len changed out from under them.

I wanted the auto-retry in __scsi_mode_sense to use the length we would
want if called from sd.c for mode page 8.

But you are right, decreasing the len there is wrong, I can yank that
part. 

And per Pat L's comment, should we decrement the len by four if going from
MODE SENSE 10 to MODE SENSE? Or request four more bytes than required?

-- Patrick Mansfield
