From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Return of PENDING status to SCSI driver
Date: Tue, 16 Jun 2009 14:59:46 +0100
Message-ID: <20090616145946.1c3234e3@lxorguk.ukuu.org.uk>
References: <4A363EB4.8000102@panasas.com>
	<Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
	<3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>
	<4A365BBE.3010708@panasas.com>
	<3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
	<4A36776C.5010208@panasas.com>
	<3e7aae30906160635g4d191a4exdb710554a349cac0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40055 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbZFPN6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 09:58:48 -0400
In-Reply-To: <3e7aae30906160635g4d191a4exdb710554a349cac0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

> If I call void (*done)(struct scsi_cmnd *) call back immediately after
> receiving a command, will I get another command ?

The mid layer will throw commands at you until either you tell it to
stop, there is an error or the amount of pending queued commands for the
target, or the adapter is reached.

In the utterly simplistic case of a totally dumb PIO adapter with no
interrupt support the flow is essentially

	foo_queue_command(cmd)
		cmd->done(cmd)
	return 0

	foo_queue_command(cmd)
		cmd->done(cmd)
	return 0

If you want the scsi mid layer to shut up for a bit then return one of
the MLQUEUE_xxx_BUSY forms and the command will be requeued and fed to
you again later.


