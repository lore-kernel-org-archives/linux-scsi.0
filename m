From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 9 Jan 2008 13:58:50 -0700
Message-ID: <20080109205850.GU16309@parisc-linux.org>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de> <4785304A.60109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57017 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYAIU6w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 15:58:52 -0500
Content-Disposition: inline
In-Reply-To: <4785304A.60109@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Watte <jwatte@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Wed, Jan 09, 2008 at 12:36:26PM -0800, Jon Watte wrote:
> Stefan Richter wrote:
> >>Those systems (servers) typically have enough memory to tolerate a few
> >>extra KB of code without problems.  In fact most PCs these days have.
> >>    
> >
> >It would be a stupid solution nevertheless.
> >
> >(We also don't "select EXT3".)
> >  
> Not selecting EXT3 is a little more understandable, because there are 
> many options -- cramfs, xfs, reiserfs, etc, depending on target. 
> However, the number of people who DO want SATA support but DO NOT want 
> SD block device support is... uh.. anyone?
> 
> Solving the problem bigger and better, by factoring "SD" into a 
> mid-level menu, and maybe calling it something non-SCSI, would probably 
> be even better. And even more work.

OK, how about this?

config BLK_DEV_ATA_SD
	tristate "ATA disc support"
	select BLK_DEV_SD

config BLK_DEV_ATA_SR
	tristate "ATA CDROM support"
	select BLK_DEV_SR

Help text left as an exercise for the reader.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
