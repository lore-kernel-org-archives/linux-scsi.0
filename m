From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Repeating Scsi_Cmnd serial numbers in the error-handler
Date: Wed, 30 Apr 2003 12:44:26 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304301239040.956-100000@ida.rowland.org>
References: <20030430162641.GB2350@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:20740 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261281AbTD3QcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 12:32:05 -0400
In-Reply-To: <20030430162641.GB2350@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 30 Apr 2003, Mike Anderson wrote:

> Alan,
> 
> Is the requirement that all serial numbers in flight be unique or that
> once a serial number is used that is not be used again.

It's actually somewhere in between.  Because of the possibility of the 
device and the driver getting out-of-sync, we want to be sure that the 
same serial number is not used twice within a short time period.  Probably 
not used twice in a row would be sufficient.

> I would hope the usb would be supporting auto sense and that it will not
> fall into the case of having the error handler thread do a request sense
> command for it. If it did fall into this case the serial number that was
> used for the command having sense requested would not still be in
> flight.

We do support auto sense.  The problem arises with the TUR command, not 
the REQUEST-SENSE command (which I just included in my previous message 
for the sake of completeness).

> If the error handler is in the process of aborting / canceling the
> command it will not send a TUR until the command has been canceled.

Yes.  But the TUR will be the very next command sent after the one that 
failed.  This is the particular case that I would like to prevent.

Alan Stern

