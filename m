From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v9] st: implement tape statistics
Date: Mon, 01 Jun 2015 10:25:42 -0700
Message-ID: <1433179542.2174.23.camel@HansenPartnership.com>
References: <DDB9C85B850785449757F9914A034FCB3BFC42AA@G9W0748.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47995 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948AbbFARZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2015 13:25:44 -0400
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BFC42AA@G9W0748.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, "Laurence Oberman (loberman@redhat.com)" <loberman@redhat.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>

On Mon, 2015-06-01 at 06:43 +0000, Seymour, Shane M wrote:
> +#if (BITS_PER_LONG == 64)
> +#define PRId64 "ld"
> +#else
> +#define PRId64 "lld"
> +#endif

I know this is the windows recommended way to do this, but lets not
pollute the kernel with it because the kernel accepts %lld everywhere
for 64 bit integers (including on 64 bit platforms).

> +/**
> + * read_cnt_show - return read count - count of reads made from tape drive
> + * @dev: struct device
> + * @attr: attribute structure
> + * @buf: buffer to return formatted data in
> + */
> +static ssize_t read_cnt_show(struct device *dev,
> +	struct device_attribute *attr, char *buf)
> +{
> +	struct st_modedef *STm = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%"PRId64,
> +		atomic64_read(&STm->tape->stats->read_cnt));
> +

In the interests of time, I just fixed all of this up.

James


