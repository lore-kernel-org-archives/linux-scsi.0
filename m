From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Sun, 07 Feb 2016 15:07:21 -0800
Message-ID: <1454886441.2329.27.camel@HansenPartnership.com>
References: <1454783624.2809.6.camel@HansenPartnership.com>
	 <20160207092241.GA15331@lst.de>
	 <1454861040.2329.4.camel@HansenPartnership.com>
	 <56B7C527.6050300@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56B7C527.6050300@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2016-02-07 at 15:28 -0700, Jens Axboe wrote:
> On 02/07/2016 09:04 AM, James Bottomley wrote:
> > On Sun, 2016-02-07 at 10:22 +0100, Christoph Hellwig wrote:
> > > Keith said it should be on by default, and I promised him to
> > > change
> > > it once we run into problems, which I guess this counts as.
> > > 
> > > But just curious:  what distro are you using?  Upstream systemd
> > > explicitly rejected using scsi_id for NVMe here:
> > > 
> > > 	https://github.com/systemd/systemd/issues/1453
> > > 
> > > and all my test systems don't do this either.
> > 
> > This was SUSE (in my case, openSUSE Leap).  I just checked the
> > source
> > package; they patch the by-id rules back in for NVME:
> > 
> > # PATCH-FIX-SUSE 1101-rules-persistent-device-names-for-NVMe
> > -devices.patch (bsc#944132)
> > Patch1101:      1101-rules-persistent-device-names-for-NVMe
> > -devices.patch
> > 
> > The bugzilla is giving access denied for bug id 944132, so it's
> > likely
> > some proprietary vendor problem.  The patch has no preamble, so
> > it's
> > hard to tell what they were thinking.
> 
> I run root-on-nvme on my laptop, and I haven't observed any problems.

Me too apparently.  It looks like this problem may be SUSE specific
unless another distro has enabled this.  I can see why they would: you
do need persistent names for devices, even NVMe ones.

> Generally I hate for options to default y unless absolutely 
> necessary, it's a sure fire way to feature creep your kernel without 
> noticing. I don't think getting all hot about this issue is fair, if 
> the only known case is suse.

Well, OK, I'm annoyed because it was a systemd system which means
debugging boot failures are excruciatingly difficult so it took me a
week and a half to find out what the problem was.  Perhaps I was a bit
rash to label this as an easily foreseen problem.

I opened a bug against SUSE to tell them to turn it on:

https://bugzilla.opensuse.org/show_bug.cgi?id=965497

The second problem is that there's currently no way to transition to
using the serial attribute the way the udev 60-persistent-storage.rules
are written, so if distros have some by-id hack, it will have to be
maintained for a while.  I annotated the already closed bug on this in
systemd with the rules that work for me.

> If anything, let's make the description better. It's trying to be
> funny, it'd be better if it was descriptive and covered this case as
> well.

The problem with this is that when moving to new kernels, distro
maintainers don't read the new option help texts, they just take the
defaults.  However, I checked the only other distribution I use
(debian) and they don't have a nvme persistent ID hack, so if someone
checked ubuntu and Red Hat, I think all the majors are now covered and
perhaps there's no need to do anything more.

James
