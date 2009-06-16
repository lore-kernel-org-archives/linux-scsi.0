From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Return of PENDING status to SCSI driver
Date: Tue, 16 Jun 2009 14:39:18 +0000
Message-ID: <1245163158.3965.38.camel@mulgrave.site>
References: <4A363EB4.8000102@panasas.com>
	 <Pine.LNX.4.44L0.0906150958570.2928-100000@iolanthe.rowland.org>
	 <3e7aae30906150707we781237o366950971d748b6f@mail.gmail.com>
	 <4A365BBE.3010708@panasas.com>
	 <3e7aae30906150742l18e74a8fua5f08686c2c76454@mail.gmail.com>
	 <4A36776C.5010208@panasas.com>
	 <3e7aae30906160635g4d191a4exdb710554a349cac0@mail.gmail.com>
	 <4A37ABDC.4050308@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46207 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281AbZFPOjV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 10:39:21 -0400
In-Reply-To: <4A37ABDC.4050308@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Ramya Desai <ramya.desai@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On Tue, 2009-06-16 at 17:27 +0300, Boaz Harrosh wrote:
> scsi will call .queuecommand upto min(can_queue, .cmd_per_lun) times
> without any call to done(). Then for each done() called it will call
> .queuecommand again. (If more commands are pending)

Actually, there's one extra piece to this:  you have to return 0 from
your .queuecommand() routine to get the next command.

The helpful documentation for all of this is

Documentation/scsi/scsi_mid_low_api.txt

James


