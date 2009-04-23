From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 14:10:13 +0000
Message-ID: <1240495814.3514.8.camel@mulgrave.int.hansenpartnership.com>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
	 <d14109aa6209be628074.1240464572@sermon.lab.mkp.net>
	 <20090423105245.GX4593@kernel.dk> <49F04C71.6050304@garzik.org>
	 <20090423113841.GK1926@parisc-linux.org>
	 <yq1r5zjbje2.fsf@sermon.lab.mkp.net>  <49F06E3B.104@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49F06E3B.104@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-04-23 at 09:33 -0400, Jeff Garzik wrote:
> Martin K. Petersen wrote:
> >>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:
> > 
> > Matthew> I already did that.  The only problem is that you made me
> > Matthew> include the stupid:
> > 
> > Matthew>         if (ata_id_major_version(args->id) > 7) {
> > 
> > Matthew> so of course it doesn't work on any existing hardware.  How
> > Matthew> about applying this patch:
> > 
> > Maybe we could incubate your patch in the next tree for a bit and see
> > what breaks without the version check?
> > 
> > We could even be somewhat conservative like we were with RC16 in SCSI.
> > The SATA devices I have here with valid rotational flags all report
> > version 7.  I wonder if > 6 do the trick?
> 
> linux/ata.h illustrates the standard ATA rules for validating bits of 
> IDENTIFY DEVICE.
> 
> Just checking the version was always just a simplistic hack...  we are 
> talking specifically about trusting values listed as undefined in the 
> relevant specs.  That requires more, not less, gymnastics :)

I'm with Jeff on this one.  We had an identically similar problem with
REPORT LUNS, which, today is the basis of SCSI discovery.

The default rule is that if you're less than SCSI-3 (where REPORT LUNS
was introduced) we *don't* send you REPORT LUNS and if you're 3 or above
we always discover via REPORT LUNS.  However, for the bunch of early
adopters we have the BLIST_REPORTLUN2 flag to say do it anyway
regardless of the SCSI level.  (And for the screw ups we have
BLIST_NOREPORTLUN for the ones who couldn't implement a standard to save
their corporate life).

James


