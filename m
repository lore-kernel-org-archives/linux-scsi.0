From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Repeating Scsi_Cmnd serial numbers in the error-handler
Date: Wed, 30 Apr 2003 09:26:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030430162641.GB2350@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0304301014310.762-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:1747 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262195AbTD3QMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 12:12:22 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0304301014310.762-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

Alan,

Is the requirement that all serial numbers in flight be unique or that
once a serial number is used that is not be used again.

I would hope the usb would be supporting auto sense and that it will not
fall into the case of having the error handler thread do a request sense
command for it. If it did fall into this case the serial number that was
used for the command having sense requested would not still be in
flight.

If the error handler is in the process of aborting / canceling the
command it will not send a TUR until the command has been canceled.

Alan Stern [stern@rowland.harvard.edu] wrote:
> While the SCSI error handler is in operation it may issue some commands on
> its own behalf, in particular REQUEST-SENSE and TEST-UNIT-READY.  These
> both get transmitted via scsi_send_eh_cmnd(), which does not increment the
> serial number.  Consequently these commands are issued with the same
> serial number as the failed command they are trying to recover from.  
> This makes life difficult for drivers like usb-storage which rely on the
> serial number to be a unique tag for purposes of matching up requests with
> responses.
> 
> This ought to be very easy to fix, but I prefer to leave it up to someone
> who knows more than I do about the details of the SCSI system.
> 
> Alan Stern
> 

-andmike
--
Michael Anderson
andmike@us.ibm.com

