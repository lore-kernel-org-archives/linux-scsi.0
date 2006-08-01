From: Jens Axboe <axboe@suse.de>
Subject: Re: cd burning with plextor drives.
Date: Tue, 1 Aug 2006 08:54:56 +0200
Message-ID: <20060801065456.GF31908@suse.de>
References: <1154180419.9447.61.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <1154194239.9447.89.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291045540.4168@g5.osdl.org> <m3y7ubqdwg.fsf@zoo.weinigel.se> <Pine.LNX.4.64.0607301245500.4168@g5.osdl.org> <m3u04yr5s5.fsf@zoo.weinigel.se> <Pine.LNX.4.64.0607311328541.4168@g5.osdl.org> <20060731204109.GB31908@suse.de> <Pine.LNX.4.64.0607311344470.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:22875 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1161309AbWHAGyq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 02:54:46 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0607311344470.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Christer Weinigel <christer@weinigel.se>, James Bottomley <James.Bottomley@SteelEye.com>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

On Mon, Jul 31 2006, Linus Torvalds wrote:
> 
> 
> On Mon, 31 Jul 2006, Jens Axboe wrote:
> > 
> > There are, however, new uses of vendor specific commands that you need
> > access to for fully utilizing your drive. As mentioned, Plextor is one
> > of these. And they do make current and very good burners, yet we cannot
> > add their opcodes to the table because they (sanely) used the vendor
> > specific range for that.
> 
> However, before we do that, can somebody actially just FIX that stupid 
> cdrecord bug. It shouldn't say it can't write the drive, if it's just that 
> it's not allowed to use one of the vendor-specific extensions.
> 
> As mentioned, I bet burning _does_ actually work.

Oh yeah, I think so too. It's for other features on the Plextor, like
disc quality scans. So it's not critical as such for burning, but it is
something that we do want to work.

I don't think you disagree that we need to support the vendor unique
range of opcodes. And I don't think you disagree that we cannot safely
put these in the global table. So that leaves one sane option - per
device cmd filter table. I've kept Peter's original patch somewhat
uptodate, I'll bring it to 2.6.18-rc3 and test+submit for 2.6.19.

-- 
Jens Axboe

