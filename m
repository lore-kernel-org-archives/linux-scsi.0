From: Jens Axboe <axboe@suse.de>
Subject: Re: writable mmc profiles actually are writable
Date: Tue, 7 Oct 2003 23:00:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007210020.GJ1704@suse.de>
References: <1065463946.5185.8.camel@patehci2> <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de> <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de> <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2> <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de> <1065559619.2875.63.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:47830 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262887AbTJGVAf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 17:00:35 -0400
Content-Disposition: inline
In-Reply-To: <1065559619.2875.63.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: mdharm-scsi@one-eyed-alien.net, linux-scsi@vger.kernel.org

On Tue, Oct 07 2003, Pat LaVarre wrote:
> > Please add ...
> > to cdrom.c instead ... GPCMD_GET_CONFIGURATION
> 
> Happily will do.  I'll continue to reply as I progress or not.

Great, thanks.

> Before now, I did not know I could find any one place in the kernel
> source to tweak CDC decisions.  To my confused newbie eye, ide-cd.c and
> sr.c appeared coded independently to fetch mode page x2A Capabilities
> and neglect op x46 Get Configuration in slightly different ways.  I
> erroneously had planned to develop an ide-cd.c patch after the sr.c
> patch.

You'd end up adding about the same code in both places. The
->generic_packet() hook and cdrom_generic_command was invented to solve
this code duplication. So in cdrom.c you just setup the cgc as needed,
and pass it down to ide-cd or sr. See cdrom_mode_sense() for one of the
many examples.

> Already I have one reaction to share ...
> 
> I'm now vague on how we want /proc/sys/dev/cdrom/info to change?
> 
> I see:
> 
> In -test6 for dvd_ram we have:
> 
> Can write CD-R:         0
> Can write CD-RW:        0
> Can read DVD:           0
> Can write DVD-R:        0
> Can write DVD-RAM:      1
> 
> I ask:
> 
> What do we want the new CDC_MMC_RW line to look like?
> 
> Should our new line be a CDC_MMC_RW &~ CDC_DVD_RAM line?  That would

I think CDC_MMC_RW should be independent of that. The idea was to make
CDC_DVD_RAM really be the hardware type indication and not the pseudo
randomly writable flag that it is now.

> give us the same appearance as the last patch I posted i.e. commonly
> different devices would provoke only the two exclusive combinations: 
> 
> Can write DVD-RAM:      1
> Can write other MMC-RW: 0
> 
> Can write DVD-RAM:      0
> Can write other MMC-RW: 1
> 
> Or should our new line look very different, and appear explicitly set
> for any CDC_MMC_RW, perhaps:
> 
> Tolerates random write: 1
> 
> Or do we prefer some other alternative?

No that is what I had in mind as well, although I would probably have
worded it a bit differently :). But that's detail, please proceed, I
think you are on the right track.

-- 
Jens Axboe

