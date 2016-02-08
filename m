From: Christoph Hellwig <hch@lst.de>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
	support optional
Date: Mon, 8 Feb 2016 08:24:01 +0100
Message-ID: <20160208072401.GA30007@lst.de>
References: <1454783624.2809.6.camel@HansenPartnership.com> <20160207092241.GA15331@lst.de> <1454861040.2329.4.camel@HansenPartnership.com> <56B7C527.6050300@kernel.dk> <1454886441.2329.27.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60096 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbcBHHYF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 02:24:05 -0500
Content-Disposition: inline
In-Reply-To: <1454886441.2329.27.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, Feb 07, 2016 at 03:07:21PM -0800, James Bottomley wrote:
> > I run root-on-nvme on my laptop, and I haven't observed any problems.
> 
> Me too apparently.  It looks like this problem may be SUSE specific
> unless another distro has enabled this.  I can see why they would: you
> do need persistent names for devices, even NVMe ones.

I don't have root on nvme, just my xfstests device, but I still didn't
see the problem, neither did my various nvme development setups.

> I opened a bug against SUSE to tell them to turn it on:
> 
> https://bugzilla.opensuse.org/show_bug.cgi?id=965497
> 
> The second problem is that there's currently no way to transition to
> using the serial attribute the way the udev 60-persistent-storage.rules
> are written, so if distros have some by-id hack, it will have to be
> maintained for a while.  I annotated the already closed bug on this in
> systemd with the rules that work for me.

We now expose the NVMe serial and NGUI, out of which the evpd page is
mangled depending on the NVMe spec version that the device supports as
sysfs attributes, distros can do the same mangling if they want to
support their old ids.
