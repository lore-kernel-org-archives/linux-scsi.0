From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 01/10] scsi: Use real functions for logging
Date: Tue, 11 Nov 2014 17:38:26 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593870CD@G4W3202.americas.hpqcorp.net>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
 <1415088409-46590-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:54674 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaKKRja convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2014 12:39:30 -0500
In-Reply-To: <1415088409-46590-2-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Tuesday, 04 November, 2014 2:07 AM
...
> diff --git a/drivers/scsi/scsi_logging.c
> b/drivers/scsi/scsi_logging.c
...
> @@ -0,0 +1,119 @@
> +/*
> + * scsi_logging.c
> + *
> + * Copyright (C) 2014 SUSE Linux Products GmbH
> + * Copyright (C) 2014 Hannes Reinecke <hare@suse.de>
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/atomic.h>
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_dbg.h>
> +
> +#define SCSI_LOG_SPOOLSIZE 4096
> +#define SCSI_LOG_BUFSIZE 128
> +
> +struct scsi_log_buf {
> +	char buffer[SCSI_LOG_SPOOLSIZE];
> +	unsigned long map;
> +};
> +
> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
> +
> +static char *scsi_log_reserve_buffer(size_t *len)
> +{
> +	struct scsi_log_buf *buf;
> +	unsigned long map_bits = SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE;
> +	unsigned long idx = 0;
> +
> +	WARN_ON(map_bits > BITS_PER_LONG);

Since SCSI_LOG_SPOOLSIZE, SCSI_LOG_BUFSIZE, and BITS_PER_LONG
are constants, that can be a compile-time check.

> +	preempt_disable();
> +	buf = this_cpu_ptr(&scsi_format_log);
> +	idx = find_first_zero_bit(&buf->map, map_bits);

If this fails to find a bit, it returns map_bits.
This could result in the next test_and_set_bit call 
accessing an address that is outside the bounds of
buf->map.

A safety check seems prudent before the test_and_set_bit:
	if (likely(idx < map_bits))

> +	while (test_and_set_bit(idx, &buf->map)) {
> +		idx = find_next_zero_bit(&buf->map, map_bits, idx);
> +		if (idx >= map_bits) {
> +			break;
> +		}

scripts/checkpatch.pl -f doesn't like the {} on that.

> +	}
> +	if (WARN_ON(idx >= map_bits)) {
> +		preempt_enable();
> +		return NULL;
> +	}
> +	*len = SCSI_LOG_BUFSIZE;
> +	return buf->buffer + idx * SCSI_LOG_BUFSIZE;
> +}
> +
> +static void scsi_log_release_buffer(char *bufptr)
> +{
> +	struct scsi_log_buf *buf;
> +	unsigned long idx;
> +	int ret;
> +
> +	buf = this_cpu_ptr(&scsi_format_log);
> +	if (bufptr < buf->buffer + SCSI_LOG_SPOOLSIZE) {

Should that also check that bufptr > buf->buffer?

> +		idx = (bufptr - buf->buffer) / SCSI_LOG_BUFSIZE;
> +		ret = test_and_clear_bit(idx, &buf->map);
> +		WARN_ON(!ret);
> +	}
> +	preempt_enable();
> +}
> +
> +int sdev_prefix_printk(const char *level, const struct scsi_device
> *sdev,
> +		       const char *name, const char *fmt, ...)
> +{
> +	va_list args;
> +	char *logbuf;
> +	size_t off = 0, logbuf_len;
> +	int ret;
> +
> +	if (!sdev)
> +		return 0;
> +
> +	logbuf = scsi_log_reserve_buffer(&logbuf_len);
> +	if (!logbuf)
> +		return 0;
> +
> +	if (name)
> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 "[%s] ", name);
> +	va_start(args, fmt);
> +	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
> +	va_end(args);
> +	ret = dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
> +	scsi_log_release_buffer(logbuf);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sdev_prefix_printk);
> +
> +int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
> +		const char *fmt, ...)
> +{
> +	struct gendisk *disk = scmd->request->rq_disk;
> +	va_list args;
> +	char *logbuf;
> +	size_t off = 0, logbuf_len;
> +	int ret;
> +
> +	if (!scmd || scmd->cmnd == NULL)
> +		return 0;

!scmd->cmnd seems more common in neighboring code.

> +
> +	logbuf = scsi_log_reserve_buffer(&logbuf_len);
> +	if (!logbuf)
> +		return 0;
> +	if (disk)
> +		off += scnprintf(logbuf + off, logbuf_len - off,
> +				 "[%s] ", disk->disk_name);
> +	va_start(args, fmt);
> +	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
> +	va_end(args);
> +	ret = dev_printk(level, &scmd->device->sdev_gendev, "%s",
> logbuf);
> +	scsi_log_release_buffer(logbuf);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(scmd_printk);
...

dev_printk is EXPORT_SYMBOL.  The former macro versions of 
sdev_printk and scmd_printk just called dev_printk, and not
being symbols, did not change that.

So, I think these function versions should use EXPORT_SYMBOL, so 
the hated binary drivers can still call them.


---
Rob Elliott    HP Server Storage



