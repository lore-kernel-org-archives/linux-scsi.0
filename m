From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: (as141b) Unaligned scatter-gather buffers and usb-storage
Date: 03 Feb 2004 10:55:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075823707.2097.7.camel@mulgrave>
References: <Pine.LNX.4.44L0.0402031044390.1161-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:30906 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266009AbUBCPzK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Feb 2004 10:55:10 -0500
In-Reply-To: <Pine.LNX.4.44L0.0402031044390.1161-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2004-02-03 at 10:47, Alan Stern wrote:
> Really?  I'm surprised.  Although I know nothing about the details of 
> using gcc on a 64-bit platform, it seems odd that an explicit cast would 
> generate a warning.  Was that done deliberately, to try and catch 
> inadvertent bugs in address arithmetic?

Yes, it's specifically to detect incorrect casting.  The warning is
'cast from pointer to integer of different size'.  If you specifically
mean the truncation, you have to first cast to the correct integer size
and then truncate:

(unsigned int)((unsigned long)buf)

To tell the compiler you really, really mean it.

James


