From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] Fix DID_OK handling in __scsi_error_from_host_byte()
Date: Thu, 5 Apr 2018 10:48:52 +0200
Message-ID: <20180405084852.GA2286@lst.de>
References: <20180404175355.15982-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180404175355.15982-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Douglas Gilbert <dgilbert@interlog.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 04, 2018 at 10:53:55AM -0700, Bart Van Assche wrote:
> +		/*
> +		 * Also check the other bytes than the status byte in result
> +		 * to handle the case when a SCSI LLD sets result to
> +		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
> +		 */
> +		return scsi_status_is_good(result) && (result & ~0xff) == 0 ?
> +			BLK_STS_OK : BLK_STS_IOERR;

How about an readable version of the statement above?

		if (scsi_status_is_good(result) && (result & ~0xff))
			return BLK_STS_OK;
		return BLK_STS_IOERR;
