From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC PATCH 1/4] convert block layer drivers to
	blkerr error values
Date: Wed, 24 Aug 2005 15:33:56 -0500
Message-ID: <1124915637.5116.54.camel@mulgrave>
References: <1124874238.10888.18.camel@max> <20050824192132.GA20663@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050824192132.GA20663@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, dm-devel@redhat.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2005-08-24 at 12:21 -0700, Patrick Mansfield wrote:
> On Wed, Aug 24, 2005 at 04:03:58AM -0500, Mike Christie wrote:
> 
> > -#define end_io_error(uptodate)	(unlikely((uptodate) <= 0))
> > +enum {
> > +	BLK_SUCCESS = 0,	/* Must be zero for compat with old usage */
> > +	BLKERR_IO,		/* Generic I/O error */
> > +	BLKERR_NOTSUPP,		/* Operation is not supported */
> > +	BLKERR_WOULDBLOCK,	/* Operation would block */
> > +	BLKERR_FATAL_DRV,	/* Fatal driver error */
> > +	BLKERR_FATAL_DEV,	/* Fatal device error */
> > +	BLKERR_FATAL_XPT,	/* Fatal transport error */
> > +	BLKERR_RETRY_DRV,	/* Driver error, I/O may be retried */
> > +	BLKERR_RETRY_DEV,	/* Device error, I/O may be retried */
> > +	BLKERR_RETRY_XPT,	/* Transport error, I/O may retried */
> > +};

Actually, I'd really be happier if these were a bitmap rather than an
enumeration.  That way we can divide them easily into cause (Driver,
Device or Transport) and severity (fatal or retryable), so something
like dm-multipath would only be interested in errors it made sense for a
path to be failed over for (i.e. all transport and driver errors).

James
