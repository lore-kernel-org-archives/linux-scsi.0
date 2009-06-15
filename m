From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Mon, 15 Jun 2009 13:19:08 -0400
Message-ID: <4A36828C.1020506@garzik.org>
References: <4A363EB4.8000102@panasas.com>	 <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>	 <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>	 <4A365BBE.3010708@panasas.com> <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45122 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbZFORTF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 13:19:05 -0400
In-Reply-To: <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

Ramya Desai wrote:
> I can not post the code in public because of some limitations I have.
> But Still I am confused with return status (to SCSI layer) for the
> command while it is in progress, to get the next command. Is it some
> thing like PENDING?


To repeat:  any "return status" of a currently-executing command is 
largely irrelevant to you.

1) You are given a command, via ->queuecommand

2) You send that command to hardware

3) When hardware is done, call the completion callback

Your driver never returns a "pending" status to the SCSI layer.  The 
SCSI layer is __already__ fully aware that a command is pending, when it 
is passed to your driver.

	Jeff




