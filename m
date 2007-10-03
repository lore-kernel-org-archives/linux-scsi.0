From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH ver3 2/5] scsi_error: Refactoring scsi_error to
	facilitate in synchronous REQUEST_SENSE
Date: Wed, 03 Oct 2007 10:59:57 -0500
Message-ID: <1191427197.3340.10.camel@localhost.localdomain>
References: <46E59760.9020705@panasas.com> <46E59C7D.4040701@panasas.com>
	 <46E64C1D.6070508@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60219 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752037AbXJCRCE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 13:02:04 -0400
In-Reply-To: <46E64C1D.6070508@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

On Tue, 2007-09-11 at 11:04 +0300, Boaz Harrosh wrote:
> - Drivers/transports that want to send a synchronous REQUEST_SENSE command
>    as part of their .queuecommand sequence, have 2 new API's that facilitate
>    in doing so and abstract them from scsi-ml internals.
> 
>    void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
> 	struct scsi_eh_save *sesci, unsigned char *cmnd,
> 	int cmnd_size, int sense_bytes)
> 
>    Will hijack a command and prepare it for request sense if needed.
>    And will save any later needed info into a scsi_eh_save structure.
> 
>    void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd,
> 	struct scsi_eh_save *sesci);
> 
>    Will undo any changes done to a command by above function. Making
>    it ready for completion.
> 
>  - Re-factor scsi_send_eh_cmnd() to use above APIs
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

This one looks OK, but it will likely not apply when you fix the first
patch, so could you rebase and resend this as well.

Thanks,

James


