From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 29 Sep 2004 15:39:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096486793.2124.129.camel@mulgrave>
References: <Pine.LNX.4.44L0.0409291239250.1167-100000@ida.rowland.org>
		<415AF8A6.2080705@adaptec.com> <1096481358.2123.74.camel@mulgrave>
	<415B05E3.10300@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:26337 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268894AbUI2TkB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 15:40:01 -0400
In-Reply-To: <415B05E3.10300@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On Wed, 2004-09-29 at 14:58, Luben Tuikov wrote:
> Does this mean that scsi_device_cancel() should set the result
> code to DID_NO_CONNECT either?

No, I think for in-flight commands, DID_ERROR is the safest.  They
could, after all have partially deposited their data load before being
cancelled.  DID_NO_CONNECT means that no processing was ever done.

> > Right.  scsi_remove_host tells the mid-layer that it's OK to trash all
> > inflight commands because you removed all their users before calling
> > it.  It also tells us that you won't accept any future commands for this
> > host (because you'll error any attempt in queuecommand).
> 
> Do you mean to say that when scsi_remove_host() is called,
> the LLDD must no own any commands?  This is good, it means
> that the LLDD plugged queuecommand(), did "recovery" of
> pending commands and is ready for slave_destroy().

No.  It's up to the LLD.  If it wants to complete all its commands then
call scsi_remove_host(), that's fine.  However it's also fine for it to
call  scsi_remove_host() with pending in-flight commands; if it does,
ownership of these is transferred back to the mid-layer and we cancel
them all.

James


