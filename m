From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Subject: Re: [usb-storage] [PATCH] SCSI: add check_capacity flag and
	sd_read_last_sector()
Date: Wed, 22 Apr 2009 21:17:52 +0200
Message-ID: <20090422191752.GA24309@ub>
References: <Pine.LNX.4.44L0.0904221034340.3405-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:63144 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZDVTtK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 15:49:10 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904221034340.3405-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Apr 22, 2009 at 10:42:36AM -0400, Alan Stern wrote:
> This patch (as1196) adds a new scsi_device flag to tell sd.c that it
> should verify the results of READ CAPACITY by trying the read the last
> sector.

Hi Alan,

I can see why you want to do this, but allow me to mutter a bit nevertheless.
Many devices are flaky and get into strange states requiring error-recovery
or reboot when you try an I/O that they do not like.
For this reason, and also for aesthetical reasons, I would prefer never to
do I/O to a device unless user space asks for it.

(So - this would be much more work, but I would prefer a capacity value
that says "it reported this, but we have not checked yet - try an actual
I/O if you really want to know", and leave it at that until the value is
needed. Typically one needs the value (i) to check against it if one
wants to do I/O, or (ii) when user space asks for it because some fdisk type
program is invoked. In case (i) an additional read is superfluous.
In case (ii) user space asked and we try to make sure.)

Comments?

Andries

