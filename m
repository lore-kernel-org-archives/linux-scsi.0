From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 10 Oct 2003 15:25:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065821134.7434.46.camel@patehci2>
References: <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2>
	 <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de>
	 <20031006234543.A11937@one-eyed-alien.net> <20031007064829.GQ972@suse.de>
	 <20031007000018.B11937@one-eyed-alien.net>  <20031007070404.GU972@suse.de>
	 <1065818209.7434.11.camel@patehci2>  <1065819846.7434.35.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:36330 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263141AbTJJVZs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 17:25:48 -0400
In-Reply-To: <1065819846.7434.35.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: mdharm-scsi@one-eyed-alien.net, linux-scsi@vger.kernel.org

Ouch.

make reminds me cdi->ops->capability is a "read-only-member".

I interpret that gcc warning to mean we intend to write the ->capability
when we allot it, and never again thereafter.

I'm therefore now guessing the patch we want is:

We add a ->capability of CDC_MMC_WR to both ide-cd and sr.  We teach
both of those lower level drivers to ->mask this capability by default,
but sometime thereafter we have cdrom author a few cdb's to decide to
unmask that capability for any device with one of the seven standard mmc
profiles that by definition imply feature x0020 random-writable.

Pat LaVarre


