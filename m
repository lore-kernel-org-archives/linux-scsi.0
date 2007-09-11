From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH ver3 1/5] scsi_error: code cleanup before refactoring of
 scsi_send_eh_cmnd()
Date: Tue, 11 Sep 2007 11:41:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709111138460.3852-100000@iolanthe.rowland.org>
References: <46E64BDE.2070602@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38402 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751940AbXIKPlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 11:41:42 -0400
In-Reply-To: <46E64BDE.2070602@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

On Tue, 11 Sep 2007, Boaz Harrosh wrote:

>   - regrouped variables for easier reviewing of next patch
>   - Support of cmnd==NULL in call to scsi_send_eh_cmnd()
>   - In the copy_sense case set transfer size to the minimum
>     size of sense_buffer and passed @sense_bytes. cmnd[4] is
>     set accordingly.
>   - REQUEST_SENSE is set into cmnd[0] so if @sense_bytes is
>     not Zero passed cmnd can/should be NULL.
>   - Also save/restore resid of faild command.

The "if (sense_bytes)" block doesn't set scmd->cmd_len.  Yes, I know 
that value gets changed by the usb-storage driver, but nevertheless it 
should be set here to 6.

Apart from that, this looks fine to me.

Alan Stern

