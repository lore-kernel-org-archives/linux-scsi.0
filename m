From: Ted Ts'o <tytso@mit.edu>
Subject: Re: I/O topology fixes for big physical block size
Date: Thu, 30 Sep 2010 12:30:47 -0400
Message-ID: <20100930163047.GA4098@thunk.org>
References: <yq1pqvzcddq.fsf@sermon.lab.mkp.net>
 <4CA118FF.1080100@fusionio.com>
 <yq18w2mddav.fsf@sermon.lab.mkp.net>
 <20100927231551.GA15653@redhat.com>
 <4CA16F6A.1090904@fusionio.com>
 <4CA17B13.7080801@redhat.com>
 <20100928141545.GA21587@redhat.com>
 <20100928205741.GA22257@thunk.org>
 <yq162xpa7dj.fsf@sermon.lab.mkp.net>
 <4CA25FEA.6040505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CA25FEA.6040505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 28, 2010 at 04:36:42PM -0500, Eric Sandeen wrote:
> Ok, then it sounds like mkfs.ext4's refusal to make fs blocksize less
> than device physical sectorsize without -F is broken, and that should
> be removed.  I'd say issue a warning in the case but if there's a 16k
> physical device maybe there's no point in warning either?

If the device physical sectorsize is that big, should we perhaps use
that as a hint to align writes to that blocks aligned with that
physical sectorsize?  Right now we use the optimal I/O size, but if
the optimal I/O size is not specified and the physical sectorsize is,
say, 16k or 32k, maybe we should use to calculate for
s_raid_stripe_width?

						- Ted
