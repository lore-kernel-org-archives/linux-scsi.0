From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: lots and lots of disks again
Date: Wed, 11 Feb 2004 22:53:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210102603.0c835212.akpm@osdl.org> <20040211145614.GA4010@tpkurt.garloff.de> <20040211132848.49eece0d.akpm@osdl.org> <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:56969 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266255AbUBKWxw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 17:53:52 -0500
Content-Disposition: inline
In-Reply-To: <20040211142933.484ca978.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Kurt Garloff <garloff@suse.de>, hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com

On Wed, Feb 11, 2004 at 02:29:33PM -0800, Andrew Morton wrote:
> Kurt Garloff <garloff@suse.de> wrote:
> >
> > We're fighting about a static 4k array currently ;-)
> 
> yup.  Sorry I was distracting.
> 
> > Actually, I'm not sure we currently have the right discussion here.
> 
> Absolutely.
> 
> I was rather hoping that Al would follow up on his comments yesterday
> actually.

OK.  Proposed "sparse" partition numbers are Bad Idea(tm), for the same
reasons why 255.255.252.240 is not a good netmask for a subnet in class B.
It might be possible to handle if we do a single ->probe() for entire
major and put the smarts into it (about the only way to do that, actually),
but we'll have a hell of time hunting down all places assuming that
device number == first device number + partition number.  Note that we
are talking about late-boot code, fs/partition/*, anything that calls
bdget_disk(), etc.  _And_ unknown amount of userland code.  And code that
exports information to userland (e.g. /proc/paritions or sysfs per-disk
subtrees).

Unless somebody has a good idea of the modifications involved and is willing
to describe them (_not_ on usual aeb level of handwaving, please), I consider
that idea as non-feasible.
