From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] Refactoring scsi_error to facilitate in synchronous REQUEST_SENSE
Date: Mon, 10 Sep 2007 16:12:58 +0100
Message-ID: <20070910151258.GA16802@infradead.org>
References: <46E5508B.7030108@panasas.com> <46E55378.1090600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46629 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbXIJPNO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 11:13:14 -0400
Content-Disposition: inline
In-Reply-To: <46E55378.1090600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Christoph Hellwig <hch@infradead.org>

> +void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
> +	struct scsi_eh_save_cmnd_info *sesci, unsigned char *cmnd,
> +	int cmnd_size, int copy_sense)

I think just struct "struct scsi_eh_save *save" is descriptive enough and
almost fits on a line as well..  Also continuation of the prototype
is indented by two tabs normally.

> +struct scsi_eh_save_cmnd_info {
> +	int old_result;
> +	enum dma_data_direction old_data_direction;
> +	unsigned char old_cmd_len;
> +	unsigned char old_cmnd[MAX_COMMAND_SIZE];
> +	
> +	void* old_buffer;

	void *old_buffer;

> +	unsigned old_bufflen;
> +	unsigned short old_use_sg;
> +	int old_resid;
> +
> +	struct scatterlist sense_sgl;
> +};

I think you can kill the old prefixes in the struct, they're saved
per defintion.

Except for these cosmetic details the patch looks fine to me,
thanks a lot!
