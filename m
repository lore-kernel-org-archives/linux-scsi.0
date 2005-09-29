From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SATA suspend/resume (was Re: [PATCH] updated version of Jens' SATA suspend-to-ram patch)
Date: Thu, 29 Sep 2005 08:34:37 +0100
Message-ID: <20050929073437.GC9669@infradead.org>
References: <20050923163334.GA13567@triplehelix.org> <433B79D8.9080305@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932080AbVI2Hen@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <433B79D8.9080305@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Joshua Kwan <joshk@triplehelix.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@suse.de, torvalds@osdl.org, randy_dunlap <rdunlap@xenotime.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 29, 2005 at 01:21:28AM -0400, Jeff Garzik wrote:
> Ah hah!  I found the other SCSI suspend patch:
> 
> 	http://lwn.net/Articles/97453/
> 
> Anybody (Joshua?) up for reconciling and testing the two?
> 
> The main change from Jens/Joshua's patch is that we use SCSI's 
> sd_shutdown() to call sync cache, eliminating the need for 
> ata_flush_cache(), since the SCSI layer would now perform that.
> 
> For bonus points,
> 
> 1) sd should call START STOP UNIT on suspend, which eliminates the need 
> for ata_standby_drive(), and completely encompasses the suspend process 
> in the SCSI layer.
> 
> 2) sd should call START STOP UNIT on resume -- and as a SUPER BONUS, the 
> combination of these two changes ensures that there are no queue 
> synchronization issues, the likes of which would require hacks like 
> Jens' while-loop patch.
> 
> None of these are huge changes requiring a lot of thinking/planning...
> 
> Finally, ideally, we should be issuing a hardware or software reset on 
> suspend.

I like this one much more than the other patch aswell, because suspsending
is an ULDD operation, not an LLDD one, and this fits the layering model
much better.  The only complaints here are cosmetics:

 - generic_scsi_suspend/generic_scsi_resume are misnamed, they should
   probably be scsi_device_suspend/resume.
 - while we're at it they could probably move to scsi_sysfs.c to keep
   them static in one file - they're just a tiny bit of glue anyway.
 - get rid of all the CONFIG_PM ifdefs - it just clutters thing up far
   too much.
