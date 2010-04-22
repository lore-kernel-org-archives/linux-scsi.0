From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Thu, 22 Apr 2010 10:52:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1004221046140.1704-100000@iolanthe.rowland.org>
References: <701340.64320.qm@web31803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41656 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755432Ab0DVOwO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2010 10:52:14 -0400
In-Reply-To: <701340.64320.qm@web31803.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, "<linux-hotplug@vger.kernel.org>" <linux-hotplug@vger.kernel.org>, "<linux-usb@vger.kernel.org>" <linux-usb@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>, "<Dinh.Nguyen@freescale.com>" <Dinh.Nguyen@freescale.com>, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>

On Wed, 21 Apr 2010, Luben Tuikov wrote:

> Well BOT is the exception. In general transports aren't concerned
> with the size, etc of the command. They just transport the CDB. UAS
> for example, being in SAM-spirit transport and in this sense being
> mature over BOT.
> 
> The transfer length is part of the CDB, if the command is expected to
> transfer data and ATA PT CDBs are no exception. The transport bridge
> would "convert" from one transport protocol into another and it thus
> need to know the transfer size if any to prep the next protocol for
> the command. In this case this is visualized as
> UAS(SCSI)<-->SATA(ATA). Use BOT, wlg.
> 
> This is really the function of SAT. Unknown CDBs are treated as
> bi-directional to let the target determine data transfer direction if
> any.

This is somewhat off-topic, but perhaps you can help.  In reading
through the UAS draft specification, I didn't see any description of
how disagreements over transfer lengths should be handled.  Suppose the
initiator thinks the CDB for a particular IN command asks for N bytes,
but the target thinks the CDB asks for M bytes.  What should happen if
N < M or N > M?  And likewise for OUT commands.

Alan Stern

