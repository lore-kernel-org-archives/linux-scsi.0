From: Christer Weinigel <christer@weinigel.se>
Subject: Re: cd burning with plextor drives.
Date: 30 Jul 2006 18:02:39 +0200
Message-ID: <m3y7ubqdwg.fsf@zoo.weinigel.se>
References: <20060729045249.GA23398@redhat.com>
	<20060729111240.GG13095@suse.de>
	<1154180419.9447.61.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.64.0607291005200.4168@g5.osdl.org>
	<1154194239.9447.89.camel@mulgrave.il.steeleye.com>
	<Pine.LNX.4.64.0607291045540.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:51606 "EHLO
	zoo.weinigel.se") by vger.kernel.org with ESMTP id S932341AbWG3QCk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 12:02:40 -0400
In-Reply-To: <Pine.LNX.4.64.0607291045540.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

Linus Torvalds <torvalds@osdl.org> writes:

> On Sat, 29 Jul 2006, James Bottomley wrote:
> > There are certain CDs that just require vendor specific magic to
> > work ... even cdrecord has no choice but to do this.
> 
> IF that is actually true (and if you were told this by Joerg, I would 
> double- and triple-check it from some other source), then in the end you 
> do end up having to have a per-device translation table, and it probably 
> shouldn't be in the kernel.

Joerg is correct about this.  I just went through the cdrecord sources
(from Fedora Core 5 with a DVD patch) and took a quick look at what
commands and mode pages were used by the different files.  I've
probably missed a few things, but this ought to give you and idea
about what is needed to burn a CD:

drv_philips.c -- Philips/Yamaha/Ricoh/Plasmon

    Commands:

    0xE2 -- Philips First Writeable Address
    0xE4 -- Philips Reserve Track
    0xE6 -- Philips Write Track
    0xE7 -- Philips Medium Load/Unload
    0xE9 -- Philips Fixation
    0xEC -- Philips Recover?
    0xEE -- Philips Read Session Info

    Mode pages:

    0x21 -- Philips Write Track Info?
    0x23 -- Philips speed select
    0x31 -- Yamaha speed select

scsi_mmc.c - MMC-3

    Commands:

    0x46 -- MMC Get Configuration

drv_7501.c -- Masushita CW-7501

    Commands:

    0x01 - Rezero Unit
    0xE2 -- Set Mode?
    0xE3 -- Fixate/Finalize
    0xE6 -- Write DAO
    0xE7 -- Reserve Track
    0xE9 -- Read Trackinfo

    Mode pages:

    0x20 -- Speed control
    0x21 -- MCN?
    0x22 -- ISRC
    0x23 -- Dummy / Write information
    0x24 -- CD-R Disk Information

scsi_cdr.c -- pre-MMC standard functions up to MMC-2

    Commands:
    
    0x00 -- Test Unit Ready
    0x01 -- Rezero Unit
    0x03 -- Request Sense
    0x04 -- Format Unit
    0x08 -- Read 6
    0x0B -- Seek 6
    0x0D -- Qic02 Sysgen SC4000?
    0x0a -- Write 6
    0x12 -- Inquiry
    0x15 -- Mode Select 10
    0x1B -- Start/Stop Unit
    0x1E -- Prevent/Allow Medium Removal
    0x1a -- Mode Sense 10
    0x25 -- Read Capacity
    0x28 -- Read 10
    0x2B -- Seek 10
    0x2a -- Write 10
    0x35 -- Flush Cache
    0x3B -- Write Buffer
    0x3C -- Read Buffer
    0x42 -- Read Subchannel
    0x43 -- Read TOC
    0x44 -- Read Header
    0x51 -- Read Disk Info
    0x52 -- Read Track Info
    0x53 -- Reserve Track
    0x54 -- Send OPC
    0x55 -- Mode Select 10
    0x59 -- Read Master Cue Sheet
    0x5A -- Mode Sense 10
    0x5B -- Close Track/Session
    0x5C -- Read Buffer Cap(acity?)
    0x5D -- Send Cue Sheet
    0xA1 -- Blank Unit
    0xA6 -- Medium Load/Unload
    0xAA -- Write XG5?
    0xAD -- Read DVD Structure
    0xB6 -- Set Streaming?
    0xBB -- Set CD Speed
    0xBF -- Send DVD Structure
    0xE5 -- Read Track Info Philips

    Except for 0x0D and the last bunch these commands are probably pretty
    generic for all CDROM drives.

drv_jvc.c -- JVR/TEAC

    Commands:

    0x2A -- Write 10
    0xB3 -- Set Limits
    0xC4 -- Read PMA
    0xC7 -- Read Disk Info
    0xE0 -- Buffer Inquiry
    0xE1 -- Write PMA
    0xE3 -- Freeze
    0xE4 -- Clear Subcode
    0xE6 -- Next Write Address
    0xEC -- Optimize Power
    0xEF -- Read Peak Buffer Capacity

    Commands 0xC1, 0xC3, 0xC6, 0xCE, 0xCF and 0xDF are also in the
    code but are never used.

    Mode Pages:

    0x00 -- Select Sector Size
    0x21 -- Dummy Selection
    0x31 -- Speed Selection

drv_mmc.c -- SCSI-3/mmc conforming drives

    Commands:

    0x3B -- Yamaha Write Buffer With Parameter
    0xBB -- Yamaha Force Speed
    0xE9 -- Plextor Drive Mode
    0xEB -- Plextor Get Speed List
    0xED -- Plextor Drive Mode 2
    0xF5 -- Plextor Read BPC

    Mode Pages:

    0x05 -- CD/DVD Write Parameters, Speed Select
    0x2A -- MMC mode page
    0x30 -- Ricoh Mode Page (burn-free and read speed control)
    0x31 -- Yamaha Tattoo Page

drv_sony.c -- Sony

    Commands:

    0xE0 -- Write Start
    0xE1 -- Write Continue
    0xE2 -- Discontinue
    0xEC -- Read Buffer Capacity
    0xF0 -- Close Track
    0xF1 -- Finalize
    0xF2 -- Flush
    0xF3 -- Reserve Track
    0xF5 -- Write Track
    0xF6 -- Recover
    0xF8 -- Set Write Parameter 

    Mode Pages:

    0x20 -- Mastering Information
    0x22 -- Disk Information
    0x23 -- Track Information
    0x31 -- Drive Speed

 /Christer

-- 
"Just how much can I get away with and still go to heaven?"

Freelance consultant specializing in device driver programming for Linux 
Christer Weinigel <christer@weinigel.se>  http://www.weinigel.se
