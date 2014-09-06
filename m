From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/22] scsi: align logging messages
Date: Fri, 5 Sep 2014 17:34:03 -0700
Message-ID: <20140906003403.GB18426@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-21-git-send-email-hare@suse.de>
 <20140831222556.GL16432@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958C2F65E@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaIFAeH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2014 20:34:07 -0400
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C2F65E@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Hoffmann, Elliot" <elliot.hoffmann@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Mon, Sep 01, 2014 at 01:00:26AM +0000, Elliott, Robert (Server Storage) wrote:
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> > Sent: Sunday, 31 August, 2014 5:26 PM
> ...
> > On Thu, Aug 28, 2014 at 07:33:34PM +0200, Hannes Reinecke wrote:
> > > Always use 'scmd 0x%p' when logging a command pointer.
> > 
> > Is there any good reason to print the address of a command pointer?
>  
> It relates the messages to each other.  When you get lots of
> interleaved messages like:
> 
> [ 3161.441116] sd 2:0:0:2: [sdt] scmd ffff88041a874e70 abort scheduled
> [ 3161.444258] sd 2:0:0:2: [sdt] scmd ffff88041a8b3b30 abort scheduled
> ...
> [ 3162.707427] sd 2:0:0:2: [sdt] aborting command ffff88041a8b3b30
> [ 3162.710445] sd 2:0:0:2: [sdt] scmd ffff88041a8b3b30 abort failed, rtn 8195
> [ 3162.713092] sd 2:0:0:2: [sdt] aborting command ffff88041a8dd530
> [ 3162.715172] sd 2:0:0:2: [sdt] scmd ffff88041a8dd530 abort failed, rtn 8195
> ...
> [ 3171.052277] sd 2:0:0:2: [sdt] scsi_eh_2: flush retry cmd: ffff88041a8b3b30
> [ 3171.054910] sd 2:0:0:2: [sdt] scsi_eh_2: flush retry cmd: ffff88041a8dd530
> ...
> [ 3203.406218] sd 2:0:0:0: [sdr] scmd ffff88041a8214b0 not aborting, host in recovery
> [ 3203.406424] sd 2:0:0:0: [sdr] scmd ffff88041a8474f0 not aborting, host in recovery
> 
> scmd ties the messages together so you can tell which command
> has gotten to which state.  grep works.

Can we just print the tag instead, that would be a much more human
readable number normally.
