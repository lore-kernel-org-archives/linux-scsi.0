From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: 29 Oct 2003 08:58:28 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067439510.1829.4.camel@mulgrave>
References: <20031027155713.GA28140@lst.de>
	<20031027160101.76d5291b.rddunlap@osdl.org> <20031028090600.GA7370@lst.de>
	<20031028124536.3ce82c23.rddunlap@osdl.org> <3F9EF2B4.9030708@us.ibm.com>
	<20031028162610.6dcfd06e.rddunlap@osdl.org>
	<20031029122008.GA5903@linux-buechse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:63236 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261744AbTJ2O6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 09:58:43 -0500
In-Reply-To: <20031029122008.GA5903@linux-buechse.de>
List-Id: linux-scsi@vger.kernel.org
To: "Juergen E. Fischer" <fischer@linux-buechse.de>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, fischer@norbit.de

On Wed, 2003-10-29 at 06:20, Juergen E. Fischer wrote:
> The first is when a command returns with status CHECK CONDITION and the
> driver needs to do a REQUEST SENSE to fetch sense data and add that to
> the Ssci_Cmnd which resulted in the CHECK CONDITION.  The internally
> queued command fills the sense_buffer of the offending command and then
> calls its ->scsi_done().

You don't actually need a new command for this.  The struct scsi_cmnd
layout is designed to allow you to reuse the current command for
clearing contingent allegiance conditions (the fields you need to alter
all have copies stored somewhere which you can restore when you have the
sense data.  See for example how the 53c700 does this, or aic7xxx_old)

> The second it when the controller needs to be resetted.  Both are purely
> internal to the driver.

As a rule of thumb: as long as the command is never seen outside the
driver, then using kmalloc is fine.  If it is ever seen outside the
driver (like in requeueing conditions) then you should use
scsi_get_command().

James


James


