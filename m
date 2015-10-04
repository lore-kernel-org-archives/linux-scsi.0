From: Christoph Hellwig <hch@lst.de>
Subject: Re: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi
	device
Date: Sun, 4 Oct 2015 09:42:35 +0200
Message-ID: <20151004074235.GA13912@lst.de>
References: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp> <20150930151857.GA26594@lst.de> <20151001005640.GA4821@xzibit.linux.bs1.fc.nec.co.jp> <20151001043844.GA8397@xzibit.linux.bs1.fc.nec.co.jp> <20151001052159.GA14247@lst.de> <20151001114021.GA15125@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49796 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbbJDHmi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Oct 2015 03:42:38 -0400
Content-Disposition: inline
In-Reply-To: <20151001114021.GA15125@xzibit.linux.bs1.fc.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Thu, Oct 01, 2015 at 11:40:23AM +0000, Junichi Nomura wrote:
> On 10/01/15 14:21, Christoph Hellwig wrote:
> > Any chance you could share all your multipath tests in a git repository
> > somewhere?  It seems like you're the only one actually having a good
> > set of reproducable but minimalistic tests.
> 
> Hmm, sorry I don't have a public git repository...
> 
> I'm using a pair of KVM guest, one for iSCSI target and the other
> for testing.

Any chance you could share your various scripts in some way to that
people doing multipath changes can run them to verify those changes?

> 
> I could reproduce the crash using this loop, within a few minutes:
> 
>    service multipathd start
>    while true; do
>      multipath -F
>      iscsiadm -m node --logout
>      iscsiadm -m node --login
>    done
> 
> It might implicitly depend on udev to do some small amount of I/O
> after device uevent though.

I can't reproduce this unfortunately.  I suspect udev doesn't do enough
stupid things on my old Debian test system.
