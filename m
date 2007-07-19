From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 3/3] ps3: FLASH ROM Storage Driver
Date: Thu, 19 Jul 2007 13:25:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707191106310.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
 <20070716162206.723142000@pademelon.sonytel.be> <20070718165222.e504d92e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1837770057-1184837142=:8661"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42291 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759614AbXGSLZt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jul 2007 07:25:49 -0400
In-Reply-To: <20070718165222.e504d92e.akpm@linux-foundation.org>
Content-ID: <Pine.LNX.4.62.0707191139380.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1837770057-1184837142=:8661
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0707191139381.8661@pademelon.sonytel.be>

	Hi Andrew,

On Wed, 18 Jul 2007, Andrew Morton wrote:
> > +struct ps3flash_private {
> > +	struct mutex mutex;	/* Bounce buffer mutex */
> > +};
> > +#define ps3flash_priv(dev)	((dev)->sbd.core.driver_data)
> 
> bzzzt!

Same defense as ps3rom ;-)

> > +static loff_t ps3flash_llseek(struct file *file, loff_t offset, int origin)
> > +{
> > +	struct ps3_storage_device *dev = ps3flash_dev;
> > +	u64 size = dev->regions[dev->region_idx].size*dev->blk_size;
> > +
> > +	switch (origin) {
> > +	case 1:
> > +		offset += file->f_pos;
> > +		break;
> > +	case 2:
> > +		offset += size;
> > +		break;
> > +	}
> > +	if (offset < 0)
> > +		return -EINVAL;
> > +
> > +	file->f_pos = offset;
> > +	return file->f_pos;
> > +}
> 
> lseek implementations usually need locking.  file->f_mapping->host->i_mutex
> would be typical.
> 
> That locking mostly protects 64-bit f_pos on 32-bit architectures so you
> can perahps kinda get away with it here.  However the code is a bit racy
> even on 64-bit, for silly userspace.
> 
> That being said, I'd have thought that you could use one of our many
> generic lseek library fucntions here, or even an newly-exported
> block_llseek().  That assumes that i_size is correct, which I trust is the
> case.

You mean generic_file_llseek()?

Who is responsible for setting i_size in that case? This is not a file, but a
character device, so currently i_size is always zero.

So I'll just add the missing locks.

> > +static ssize_t ps3flash_read(struct file *file, char __user *buf, size_t count,
> > +			     loff_t *pos)
> > +{
> > +	struct ps3_storage_device *dev = ps3flash_dev;
> > +	struct ps3flash_private *priv = ps3flash_priv(dev);
> > +	u64 size, start_sector, end_sector, offset;
> > +	ssize_t sectors_read;
> > +	size_t remaining, n;
> > +
> > +	dev_dbg(&dev->sbd.core,
> > +		"%s:%u: Reading %zu bytes at position %lld to user 0x%p\n",
> > +		__func__, __LINE__, count, *pos, buf);
> > +
> > +	size = dev->regions[dev->region_idx].size*dev->blk_size;
> > +	if (*pos >= size || !count)
> > +		return 0;
> > +
> > +	if (*pos+count > size) {
> > +		dev_dbg(&dev->sbd.core,
> > +			"%s:%u Truncating count from %zu to %llu\n", __func__,
> > +			__LINE__, count, size - *pos);
> > +		count = size - *pos;
> > +	}
> > +
> > +	start_sector = do_div_llr(*pos, dev->blk_size, &offset);
> > +	end_sector = DIV_ROUND_UP(*pos+count, dev->blk_size);
> > +
> > +	remaining = count;
> > +	do {
> > +		mutex_lock(&priv->mutex);
> > +
> > +		sectors_read = ps3flash_read_sectors(dev, start_sector,
> > +						     end_sector-start_sector,
> > +						     0);
> > +		if (sectors_read < 0) {
> > +			mutex_unlock(&priv->mutex);
> > +			return sectors_read;
> > +		}
> > +
> > +		n = min(remaining, sectors_read*dev->blk_size-offset);
> > +		dev_dbg(&dev->sbd.core,
> > +			"%s:%u: copy %lu bytes from 0x%p to user 0x%p\n",
> > +			__func__, __LINE__, n, dev->bounce_buf+offset, buf);
> > +		if (copy_to_user(buf, dev->bounce_buf+offset, n)) {
> > +			mutex_unlock(&priv->mutex);
> > +			return -EFAULT;
> > +		}
> > +
> > +		mutex_unlock(&priv->mutex);
> > +
> > +		*pos += n;
> > +		buf += n;
> > +		remaining -= n;
> > +		start_sector += sectors_read;
> > +		offset = 0;
> > +	} while (remaining > 0);
> > +
> > +	return count;
> > +}
> 
> There are several nasty deeply-embedded return points in this function.

Will change to `goto fail' and common error return.

> > +	if (*pos+count > size) {
> 
> checkpatch missed stuff here.

Checkpatch is silent...

> > +		dev_dbg(&dev->sbd.core,
> > +			"%s:%u Truncating count from %zu to %llu\n", __func__,
> > +			__LINE__, count, size - *pos);
> > +		count = size - *pos;
> > +	}
> > +
> > +	chunk_sectors = dev->bounce_size / dev->blk_size;
> > +
> > +	start_write_sector = do_div_llr(*pos, dev->bounce_size, &offset) *
> > +			     chunk_sectors;
> 
> It's strange to see a do_div_llr() in the middle of all this 64-bit-only
> code.  Could use / and %?

Sure.

Note that in theory do_div_llr() could do the division and modulo in one
instruction on architectures that support that (hmm, that's div_long_long_rem).

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-1837770057-1184837142=:8661--
