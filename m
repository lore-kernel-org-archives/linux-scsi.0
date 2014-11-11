From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/10] scsi: Use real functions for logging
Date: Tue, 11 Nov 2014 20:07:06 +0100
Message-ID: <54625E5A.5080904@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de> <1415088409-46590-2-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B4029593870CD@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbaKKTHI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2014 14:07:08 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593870CD@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 11/11/2014 06:38 PM, Elliott, Robert (Server Storage) wrote:
>=20
>=20
>> -----Original Message-----
>> From: Hannes Reinecke [mailto:hare@suse.de]
>> Sent: Tuesday, 04 November, 2014 2:07 AM
> ...
>> diff --git a/drivers/scsi/scsi_logging.c
>> b/drivers/scsi/scsi_logging.c
> ...
>> @@ -0,0 +1,119 @@
>> +/*
>> + * scsi_logging.c
>> + *
>> + * Copyright (C) 2014 SUSE Linux Products GmbH
>> + * Copyright (C) 2014 Hannes Reinecke <hare@suse.de>
>> + *
>> + * This file is released under the GPLv2
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/atomic.h>
>> +
>> +#include <scsi/scsi.h>
>> +#include <scsi/scsi_cmnd.h>
>> +#include <scsi/scsi_device.h>
>> +#include <scsi/scsi_dbg.h>
>> +
>> +#define SCSI_LOG_SPOOLSIZE 4096
>> +#define SCSI_LOG_BUFSIZE 128
>> +
>> +struct scsi_log_buf {
>> +	char buffer[SCSI_LOG_SPOOLSIZE];
>> +	unsigned long map;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
>> +
>> +static char *scsi_log_reserve_buffer(size_t *len)
>> +{
>> +	struct scsi_log_buf *buf;
>> +	unsigned long map_bits =3D SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE;
>> +	unsigned long idx =3D 0;
>> +
>> +	WARN_ON(map_bits > BITS_PER_LONG);
>=20
> Since SCSI_LOG_SPOOLSIZE, SCSI_LOG_BUFSIZE, and BITS_PER_LONG
> are constants, that can be a compile-time check.
>=20
Ok.

>> +	preempt_disable();
>> +	buf =3D this_cpu_ptr(&scsi_format_log);
>> +	idx =3D find_first_zero_bit(&buf->map, map_bits);
>=20
> If this fails to find a bit, it returns map_bits.
> This could result in the next test_and_set_bit call=20
> accessing an address that is outside the bounds of
> buf->map.
>=20
> A safety check seems prudent before the test_and_set_bit:
> 	if (likely(idx < map_bits))
>=20
Ah. I wasn't quite sure what find_first_zero_bit would return
on failure. But yeah, that check seems to be appropriate.

>> +	while (test_and_set_bit(idx, &buf->map)) {
>> +		idx =3D find_next_zero_bit(&buf->map, map_bits, idx);
>> +		if (idx >=3D map_bits) {
>> +			break;
>> +		}
>=20
> scripts/checkpatch.pl -f doesn't like the {} on that.
>=20
Sigh.

>> +	}
>> +	if (WARN_ON(idx >=3D map_bits)) {
>> +		preempt_enable();
>> +		return NULL;
>> +	}
>> +	*len =3D SCSI_LOG_BUFSIZE;
>> +	return buf->buffer + idx * SCSI_LOG_BUFSIZE;
>> +}
>> +
>> +static void scsi_log_release_buffer(char *bufptr)
>> +{
>> +	struct scsi_log_buf *buf;
>> +	unsigned long idx;
>> +	int ret;
>> +
>> +	buf =3D this_cpu_ptr(&scsi_format_log);
>> +	if (bufptr < buf->buffer + SCSI_LOG_SPOOLSIZE) {
>=20
> Should that also check that bufptr > buf->buffer?
>=20
Probably.

>> +		idx =3D (bufptr - buf->buffer) / SCSI_LOG_BUFSIZE;
>> +		ret =3D test_and_clear_bit(idx, &buf->map);
>> +		WARN_ON(!ret);
>> +	}
>> +	preempt_enable();
>> +}
>> +
>> +int sdev_prefix_printk(const char *level, const struct scsi_device
>> *sdev,
>> +		       const char *name, const char *fmt, ...)
>> +{
>> +	va_list args;
>> +	char *logbuf;
>> +	size_t off =3D 0, logbuf_len;
>> +	int ret;
>> +
>> +	if (!sdev)
>> +		return 0;
>> +
>> +	logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
>> +	if (!logbuf)
>> +		return 0;
>> +
>> +	if (name)
>> +		off +=3D scnprintf(logbuf + off, logbuf_len - off,
>> +				 "[%s] ", name);
>> +	va_start(args, fmt);
>> +	off +=3D vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
>> +	va_end(args);
>> +	ret =3D dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
>> +	scsi_log_release_buffer(logbuf);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(sdev_prefix_printk);
>> +
>> +int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
>> +		const char *fmt, ...)
>> +{
>> +	struct gendisk *disk =3D scmd->request->rq_disk;
>> +	va_list args;
>> +	char *logbuf;
>> +	size_t off =3D 0, logbuf_len;
>> +	int ret;
>> +
>> +	if (!scmd || scmd->cmnd =3D=3D NULL)
>> +		return 0;
>=20
> !scmd->cmnd seems more common in neighboring code.
>=20
Ok.

>> +
>> +	logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
>> +	if (!logbuf)
>> +		return 0;
>> +	if (disk)
>> +		off +=3D scnprintf(logbuf + off, logbuf_len - off,
>> +				 "[%s] ", disk->disk_name);
>> +	va_start(args, fmt);
>> +	off +=3D vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
>> +	va_end(args);
>> +	ret =3D dev_printk(level, &scmd->device->sdev_gendev, "%s",
>> logbuf);
>> +	scsi_log_release_buffer(logbuf);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(scmd_printk);
> ...
>=20
> dev_printk is EXPORT_SYMBOL.  The former macro versions of=20
> sdev_printk and scmd_printk just called dev_printk, and not
> being symbols, did not change that.
>=20
> So, I think these function versions should use EXPORT_SYMBOL, so=20
> the hated binary drivers can still call them.
>=20
Okay, will be fixing things up for the next revision.

Thanks for the review.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
