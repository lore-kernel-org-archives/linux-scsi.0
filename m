From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2 of 9] block: Export I/O topology for block devices and partitions
Date: Fri, 24 Apr 2009 08:47:06 -0600
Message-ID: <20090424144706.GC1926@parisc-linux.org>
References: <patchbomb.1240551141@sermon.lab.mkp.net> <72f4e15760670febdb40.1240551143@sermon.lab.mkp.net> <ac3eb2510904240514y660973abj7621864e11e514f2@mail.gmail.com> <49F1B68D.3010304@garzik.org> <ed038eb20904240737u4d248b63s580f7d4d1831e173@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:50957 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbZDXOrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2009 10:47:08 -0400
Content-Disposition: inline
In-Reply-To: <ed038eb20904240737u4d248b63s580f7d4d1831e173@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Garzik <jeff@garzik.org>, Kay Sievers <kay.sievers@vrfy.org>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Apr 24, 2009 at 04:37:17PM +0200, Carl Henrik Lunde wrote:
> > On Fri, Apr 24, 2009 at 07:32, Martin K. Petersen <martin.petersen@oracle.com> wrote:
> > +What: ? ? ? ? ?/sys/block/<disk>/alignment
> > +What: ? ? ? ? ?/sys/block/<disk>/<partition>/alignment
> > +What: ? ? ? ? ?/sys/block/<disk>/queue/minimum_io_size
> > +What: ? ? ? ? ?/sys/block/<disk>/queue/optimal_io_size
> 
> Would it also be possible and useful to include the number of
> spindles/channels, i.e., how many requests the device can handle
> concurrently?  CFQ could for example serve two time slices
> concurrently if you have sequential reads and the device reports two
> spindles.

This is what we call "creeping featurism" (or other names not as nice).
You'll then want to know which data are provided by which spindle.
Then you'll want to know how fast each spindle is.  Then you'll find that
not all storage gives you that information (try asking an EMC Symmetrix
how many spindles it has and where data is mapped ...)

Let's just get something merged which gives us an improvement.
Then you're free to experiment with adding the spindles count yourself,
and if you can show a real advantage to it, come back and we can argue
over it with data.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
