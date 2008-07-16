From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: erase invalid data returned by device
Date: Wed, 16 Jul 2008 10:28:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807161026340.2322-100000@iolanthe.rowland.org>
References: <87prpd5356.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38397 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754096AbYGPO2N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 10:28:13 -0400
In-Reply-To: <87prpd5356.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 16 Jul 2008, Elias Oltmanns wrote:

> Oh, I see. The name fooled me there, I suppose. So, the meaning of
> req->data_len is inverted, as it were, when the LLDD performs the data
> transfer, right?

The inversion takes place in the midlayer, not in the LLDD.  Take a
look inside scsi_io_completion():

	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
		...
		req->data_len = scsi_get_resid(cmd);
	}

> Thanks for explaining,

Alan Stern

