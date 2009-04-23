From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 08:16:44 -0600
Message-ID: <20090423141644.GP1926@parisc-linux.org>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <d14109aa6209be628074.1240464572@sermon.lab.mkp.net> <20090423105245.GX4593@kernel.dk> <49F04C71.6050304@garzik.org> <20090423113841.GK1926@parisc-linux.org> <yq1r5zjbje2.fsf@sermon.lab.mkp.net> <49F06E3B.104@garzik.org> <1240495814.3514.8.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1240495814.3514.8.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 02:10:13PM +0000, James Bottomley wrote:
> I'm with Jeff on this one.  We had an identically similar problem with
> REPORT LUNS, which, today is the basis of SCSI discovery.

Yes, REPORT LUNS is quite essential.

It's not exactly in the same category as reporting device form factor
and rotational speed.  If REPORT LUNS is wrong, we're in really deep
trouble.  If device form factr is wrong ... umm ... nothing much happens.
If rotational speed is wrong, we might have a suboptimal IO pattern.
It's also fixable by udev.

The current check for is_ssd (that doesn't check the version) was put
in for 2.6.27.  It doesn't appear to have caused any trouble.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
