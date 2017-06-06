From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/6] sd: add support for TCG OPAL self encrypting disks
Date: Mon, 05 Jun 2017 20:48:00 -0400
Message-ID: <yq1lgp6djr3.fsf@oracle.com>
References: <20170604124225.27032-1-hch@lst.de>
        <20170604124225.27032-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170604124225.27032-7-hch@lst.de> (Christoph Hellwig's message
        of "Sun, 4 Jun 2017 14:42:25 +0200")
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> +static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
> +{
> +	struct scsi_device *sdev = sdkp->device;
> +
> +	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
> +			SECURITY_PROTOCOL_IN) == 1 &&
> +	    scsi_report_opcode(sdev, buffer, SD_BUF_SIZE,
> +			SECURITY_PROTOCOL_OUT) == 1)
> +		sdkp->security = 1;
> +}
> +
>  /**
>   *	sd_revalidate_disk - called the first time a new disk is seen,
>   *	performs disk spin up, read_capacity, etc.
> @@ -3067,6 +3102,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		sd_read_cache_type(sdkp, buffer);
>  		sd_read_app_tag_own(sdkp, buffer);
>  		sd_read_write_same(sdkp, buffer);
> +		sd_read_security(sdkp, buffer);
>  	}

For WRITE SAME, scsi_report_opcode() is gated not only by
sdev->no_report_opcodes but by sdev->no_write_same.

I'm concerned about firing off REPORT OPCODES to random devices without
a sufficiently good heuristic. Doesn't look like SAT has anything to
offer in this department, though. Maybe it's time to consider a
vendor-specific Linux VPD page...

-- 
Martin K. Petersen	Oracle Linux Engineering
