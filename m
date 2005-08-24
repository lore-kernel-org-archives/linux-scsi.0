From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC PATCH 1/4] convert block layer drivers to
	blkerr error values
Date: Wed, 24 Aug 2005 12:21:32 -0700
Message-ID: <20050824192132.GA20663@us.ibm.com>
References: <1124874238.10888.18.camel@max>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1124874238.10888.18.camel@max>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dm-devel@redhat.com, axboe@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 24, 2005 at 04:03:58AM -0500, Mike Christie wrote:

> -#define end_io_error(uptodate)	(unlikely((uptodate) <= 0))
> +enum {
> +	BLK_SUCCESS = 0,	/* Must be zero for compat with old usage */
> +	BLKERR_IO,		/* Generic I/O error */
> +	BLKERR_NOTSUPP,		/* Operation is not supported */
> +	BLKERR_WOULDBLOCK,	/* Operation would block */
> +	BLKERR_FATAL_DRV,	/* Fatal driver error */
> +	BLKERR_FATAL_DEV,	/* Fatal device error */
> +	BLKERR_FATAL_XPT,	/* Fatal transport error */
> +	BLKERR_RETRY_DRV,	/* Driver error, I/O may be retried */
> +	BLKERR_RETRY_DEV,	/* Device error, I/O may be retried */
> +	BLKERR_RETRY_XPT,	/* Transport error, I/O may retried */
> +};

Do you need to add and use a BLKERR_TIMEOUT? As we can't determine the
problem area for a timeout, and if it can or should be retried.

-- Patrick Mansfield
