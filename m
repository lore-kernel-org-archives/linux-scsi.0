From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 10 Oct 2003 14:36:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065818209.7434.11.camel@patehci2>
References: <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2>
	 <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de>
	 <20031006234543.A11937@one-eyed-alien.net> <20031007064829.GQ972@suse.de>
	 <20031007000018.B11937@one-eyed-alien.net>  <20031007070404.GU972@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:39653 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263151AbTJJUhh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 16:37:37 -0400
In-Reply-To: <20031007070404.GU972@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: mdharm-scsi@one-eyed-alien.net, linux-scsi@vger.kernel.org

> From: Jens Axboe ...
> Please add the GET_CONFIGURATION stuff to cdrom.c
> instead so it works with ide-cd as well ...

Help!  I do not know Where to add this code.

Tell me again where is the one place I can patch to add discovery of
more capability in both sr and ide-cd devices?

Closer study now again seemingly tells me that ide-cd and sr
independently work to try the op x5A Mode Sense of page x2A Capabilities
and not op x46 Get Configuration.

On this point do we agree?

drivers/ide/ide.cd ide_cdrom_get_capabilities speaks thru
drivers/cdrom/cdrom.c cdrom_mode_sense, aye.

drivers/scsi/sr.c get_capabilities speaks instead thru
drivers/scsi/scsi_lib.c scsi_mode_sense.

printk tells me with a usb-storage.ko drive I get as far as 'dd: opening
`/dev/scd0': Read-only file system' without cdrom.c cdrom_mode_sense
ever being called.  With an ide-cd.ko driver, I do see cdrom_mode_sense
called.  The ide-cd command is -x 5A 00 2A:00:00:00 00 00:18 00 -i x18,
rather than the less polite -x 5A 00 2A:00:00:00 00 00:80 00 -i x80 of
sr.

Does a place exist in drivers/cdrom where I can insert code to run after
ide-cd and sr finish their op x5A Mode Sense?

Have I misunderstood your request?  Did you actually mean to tell me to
go so far as to move the op x5A Mode Sense out of ide-cd and out of sr
and into cdrom?  If indeed I should move those out, to where should I
move them?

> The ->generic_packet() hook and
> cdrom_generic_command was invented to solve
> this code duplication.

Found, thank you:

I see cdrom.c cdrom_mode_sense speaks thru cdo->generic_packet.

I see include/linux/cdrom.h defines a struct cdrom_generic_command that
field-for-field matches other simplifications of scsi/sg.h sg_io_hdr
that appear on the web, such as my own plscsi and gccscsi.

> [op x46] GPCMD_GET_CONFIGURATION already exists.

Found, thank you.

Also op x5A GPCMD_MODE_SENSE_10 and page x2A GPMODE_CAPABILITIES_PAGE in
ide-cd.

Also op x5A MODE_SENSE_10 and anonymous x2a in sr.

> make DVD-RAM drives set CDC_MMC_RW as well
> and only check for that at open.

This part I still think I understand how to do.

> why then some things only work if you have ide-cd
> loaded, or if you use ide-scsi and sr ... a bad idea.

Aye.

Pat LaVarre


