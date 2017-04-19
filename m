From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 26/27] scsi: sd: Separate zeroout and discard command
 choices
Date: Wed, 19 Apr 2017 16:56:31 +0200
Message-ID: <58c3d6a6-924e-cc86-1907-a9fd02a39c0e@redhat.com>
References: <20170405172125.22600-1-hch@lst.de>
 <20170405172125.22600-27-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170405172125.22600-27-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 05/04/2017 19:21, Christoph Hellwig wrote:
> +static ssize_t
> +zeroing_mode_store(struct device *dev, struct device_attribute *attr,
> +		   const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +
> +	if (!strncmp(buf, zeroing_mode[SD_ZERO_WRITE], 20))
> +		sdkp->zeroing_mode = SD_ZERO_WRITE;
> +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS], 20))
> +		sdkp->zeroing_mode = SD_ZERO_WS;
> +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS16_UNMAP], 20))
> +		sdkp->zeroing_mode = SD_ZERO_WS16_UNMAP;
> +	else if (!strncmp(buf, zeroing_mode[SD_ZERO_WS10_UNMAP], 20))
> +		sdkp->zeroing_mode = SD_ZERO_WS10_UNMAP;

Should this be conditional on lbprz, lbpws, lbpws10 and max_ws_blocks?

Thanks,

Paolo
