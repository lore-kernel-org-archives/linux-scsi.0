From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 03/10] scsi: Implement per-cpu logging buffer
Date: Mon, 17 Nov 2014 14:44:33 -0500
Message-ID: <546A5021.20302@interlog.com>
References: <1416230728-66425-1-git-send-email-hare@suse.de> <1416230728-66425-4-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39650 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaKQTos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 14:44:48 -0500
In-Reply-To: <1416230728-66425-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 14-11-17 08:25 AM, Hannes Reinecke wrote:
> Implement a per-cpu buffer for formatting messages to
> avoid line break up under high load.
> This patch implements scmd_printk() and sdev_prefix_printk()
> using the per-cpu buffer and makes sdev_printk() a wrapper
> for sdev_prefix_printk().
>
> Tested-by: Robert Elliott <elliott@hp.com>
> Reviewed-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/Makefile       |   2 +-
>   drivers/scsi/scsi_logging.c | 124 ++++++++++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_device.h  |  21 +++-----
>   3 files changed, 133 insertions(+), 14 deletions(-)
>   create mode 100644 drivers/scsi/scsi_logging.c
>
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 59f1ce6..4991b62 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -166,7 +166,7 @@ scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
>   scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
>   scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
>   scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
> -scsi_mod-y			+= scsi_trace.o
> +scsi_mod-y			+= scsi_trace.o scsi_logging.o
>   scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
>
>   hv_storvsc-y			:= storvsc_drv.o
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> new file mode 100644
> index 0000000..09d65de
> --- /dev/null
> +++ b/drivers/scsi/scsi_logging.c
> @@ -0,0 +1,124 @@
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
> +#if (SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE) > BITS_PER_LONG
> +#warning SCSI logging bitmask too large
> +#endif
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
> +	unsigned long map_bits = sizeof(buf->buffer) / SCSI_LOG_BUFSIZE;
> +	unsigned long idx = 0;
> +
> +	preempt_disable();
> +	buf = this_cpu_ptr(&scsi_format_log);
> +	idx = find_first_zero_bit(&buf->map, map_bits);
> +	if (likely(idx < map_bits)) {
> +		while (test_and_set_bit(idx, &buf->map)) {
> +			idx = find_next_zero_bit(&buf->map, map_bits, idx);
> +			if (idx >= map_bits)
> +				break;
> +		}
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
> +	if (bufptr >= buf->buffer &&
> +	    bufptr < buf->buffer + SCSI_LOG_SPOOLSIZE) {
> +		idx = (bufptr - buf->buffer) / SCSI_LOG_BUFSIZE;
> +		ret = test_and_clear_bit(idx, &buf->map);
> +		WARN_ON(!ret);
> +	}
> +	preempt_enable();
> +}
> +
> +int sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
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
> +EXPORT_SYMBOL(sdev_prefix_printk);
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
> +	if (!scmd || !scmd->cmnd)
> +		return 0;
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
> +	ret = dev_printk(level, &scmd->device->sdev_gendev, "%s", logbuf);
> +	scsi_log_release_buffer(logbuf);
> +	return ret;
> +}
> +EXPORT_SYMBOL(scmd_printk);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 0aeaa00..6fddcd2 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -230,9 +230,6 @@ struct scsi_dh_data {
>   #define transport_class_to_sdev(class_dev) \
>   	to_scsi_device(class_dev->parent)
>
> -#define sdev_printk(prefix, sdev, fmt, a...)	\
> -	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
> -
>   #define sdev_dbg(sdev, fmt, a...) \
>   	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
>
> @@ -240,16 +237,14 @@ struct scsi_dh_data {
>    * like scmd_printk, but the device name is passed in
>    * as a string pointer
>    */
> -#define sdev_prefix_printk(l, sdev, p, fmt, a...)			\
> -	(p) ?								\
> -	sdev_printk(l, sdev, "[%s] " fmt, p, ##a) :			\
> -	sdev_printk(l, sdev, fmt, ##a)
> -
> -#define scmd_printk(prefix, scmd, fmt, a...)				\
> -        (scmd)->request->rq_disk ?					\
> -	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
> -		    (scmd)->request->rq_disk->disk_name, ##a) :		\
> -	sdev_printk(prefix, (scmd)->device, fmt, ##a)
> +extern int sdev_prefix_printk(const char *, const struct scsi_device *,
> +			      const char *, const char *, ...);
> +
> +#define sdev_printk(l, sdev, fmt, a...)				\
> +	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
> +
> +extern int scmd_printk(const char *, const struct scsi_cmnd *,
> +		       const char *, ...);
>
>   #define scmd_dbg(scmd, fmt, a...)					   \
>   	do {								   \
>

The gcc compiler knows about the idiosyncrasies of printf()
and will warn about abuses like this:
    int k;
    printf("string=%s\n", k);


In sg3_utils I sometimes collapse fprintf(stderr, const char fmt ...)
with a new function declaration like this:
    int pr2serr(const char * fmt, ...)
         __attribute__ ((format (printf, 1, 2)));

The "1" is the position of the fmt string (origin 1) and the
"2" is the position of the first arg to check. That __attribute__
tells the compiler how to do printf() style checking on
pr2serr().


In the kernel include compiler-gcc.h contains this define:

   #define __printf(a, b)   __attribute__((format(printf, a, b)))

So I would suggest changing:
   extern int sdev_prefix_printk(const char *, const struct scsi_device *,
   			        const char *, const char *, ...);
to
   extern __printf(4, 5) int
      sdev_prefix_printk(const char *, const struct scsi_device *,
   			        const char *, const char *, ...);


plus a similar change to the scmd_printk() declaration (and any
other printf() style functions being introduced).

Doug Gilbert

