From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 10 Oct 2003 15:04:06 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065819846.7434.35.camel@patehci2>
References: <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2>
	 <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de>
	 <20031006234543.A11937@one-eyed-alien.net> <20031007064829.GQ972@suse.de>
	 <20031007000018.B11937@one-eyed-alien.net>  <20031007070404.GU972@suse.de>
	 <1065818209.7434.11.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:25831 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262732AbTJJVEV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 17:04:21 -0400
In-Reply-To: <1065818209.7434.11.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: mdharm-scsi@one-eyed-alien.net, linux-scsi@vger.kernel.org

> > Help!  I do not know Where to add this code.

Just now I weakly concluded somewhere I need to add:

op x46 GPCMD_GET_CONFIGURATION
op x5A GPCMD_MODE_SENSE_10 of page x2A GPMODE_CAPABILITIES_PAGE

To let me proceed to write source without yet knowing where to insert
it, I will insert it to a known wrong place that mostly works.

Specifically, I will add code to drivers/cdrom/cdrom.c cdrom_open, to
try to clear the CDROM_CAN(CDC_MMC_WR) incapability only after some
tries cdrom_open with (fp->f_mode & FMODE_WRITE).

I believe this won't actually work.  I believe this will teach only
cdrom.ko to pass thru the writes, but then sr_mod.ko will still refuse
them.  But I will now go prove or disprove that theory.

Pat LaVarre


