From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 3/3][V3] iio: Handle enumerated properties with gaps
Date: Wed, 8 May 2019 16:17:49 +0300
Message-ID: <20190508131749.GM9224@smile.fi.intel.com>
References: <20190508111913.7276-1-alexandru.ardelean@analog.com>
 <20190508111913.7276-3-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190508111913.7276-3-alexandru.ardelean@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jic23@kernel.org, lars@metafoo.de
List-Id: linux-scsi@vger.kernel.org

On Wed, May 08, 2019 at 02:19:13PM +0300, Alexandru Ardelean wrote:
> From: Lars-Peter Clausen <lars@metafoo.de>
> 
> Some enums might have gaps or reserved values in the middle of their value
> range. E.g. consider a 2-bit enum where the values 0, 1 and 3 have a
> meaning, but 2 is a reserved value and can not be used.
> 
> Add support for such enums to the IIO enum helper functions. A reserved
> values is marked by setting its entry in the items array to NULL rather
> than the normal descriptive string value.
> 
> Also, `__sysfs_match_string()` now supports NULL gaps, so that doesn't
> require any changes.

> -	for (i = 0; i < e->num_items; ++i)
> +	for (i = 0; i < e->num_items; ++i) {
> +		if (!e->items[i])
> +			continue;
>  		len += scnprintf(buf + len, PAGE_SIZE - len, "%s ", e->items[i]);
> +	}

The problem here that the user will have no clue where the gap is happened, to
solve this we need either bitmap of array, where set bits shows defined items,
or use comma-separated list of values. The latter would need another node since
we don't break user space.

-- 
With Best Regards,
Andy Shevchenko
