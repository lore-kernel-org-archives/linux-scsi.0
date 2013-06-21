From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Fri, 21 Jun 2013 04:57:46 -0700
Message-ID: <20130621115746.GA5142@infradead.org>
References: <20130522221737.GA12339@mtj.dyndns.org>
 <519DC926.4000106@redhat.com>
 <20130523090222.GA26592@mtj.dyndns.org>
 <519DE5AD.7080303@redhat.com>
 <20130524014405.GB16882@mtj.dyndns.org>
 <519F12FF.6090809@redhat.com>
 <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
 <1369456502.5008.5.camel@dabdike>
 <20130525052744.GA25186@infradead.org>
 <51A062B5.8040601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51A062B5.8040601@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, asias.hejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Sat, May 25, 2013 at 09:05:25AM +0200, Paolo Bonzini wrote:
> Linus wanted to keep that for CAP_SYS_RAWIO.  We found two uses of SG_IO
> on partitions: zfs-fuse used SYNCHRONIZE CACHE; some proprietary driver
> used TEST UNIT READY.

FYI I looked at the zfs code and the way it uses it is part of a huge
braindamage.

Given that the upstream appears dead I've Cc'd Asias He as he appears
to somehow maintain it as part of the Debian package.

Asias,

the flushwc() routine in zfs-fuse is overly complicated and will not do
the right thing for many cases like using device mapper, many modern SSD
device, or much simple file backed filesystems.

Fortunately fixing this is trivial - the call to flushwc can be replaced
with a call to fdatasync() and the the kernel will do the right thing
for any backing device or file.
