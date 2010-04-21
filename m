From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 10:15:12 -0400
Message-ID: <1271859312.2893.60.camel@mulgrave.site>
References: <593030.61801.qm@web31804.mail.mud.yahoo.com>
	 <4BCF0310.4000906@pobox.com> <1271858694.2893.47.camel@mulgrave.site>
	 <4BCF06E5.1080302@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34252 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab0DUOPW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2010 10:15:22 -0400
In-Reply-To: <4BCF06E5.1080302@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: ltuikov@yahoo.com, Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On Wed, 2010-04-21 at 10:08 -0400, Mark Lord wrote:
> On 21/04/10 10:04 AM, James Bottomley wrote:
> >
> > But this isn't a userspace problem.  By the time we present the device
> > to userspace, we already know what it is ... so you can go by device
> > type and only use ATA_12 for disk devices.
> ..
> 
> Did you instead mean to say "use ATA_12 for non-disk devices" ?

No ... ATA_12 is opcode 0xa1 which is BLANK to MMC devices, hence we
should only use it for non-mmc devices.  However, the point I was making
is that actually only disk devices should use ATA.  ATAPI is really SCSI
encapsulation over ATA, so it doesn't really make sense to send ATA over
SCSI encapsulation to ATAPI devices, we should just send plain SCSI
(crosses fingers and hopes MMC devices never do smart).

James


