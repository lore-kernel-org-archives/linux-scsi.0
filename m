From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/10] scsi: Implement per-cpu logging buffer
Date: Tue, 18 Nov 2014 16:25:01 +0100
Message-ID: <546B64CD.4010604@suse.de>
References: <1416230728-66425-1-git-send-email-hare@suse.de> <1416230728-66425-4-git-send-email-hare@suse.de> <546A5021.20302@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154AbaKRPZF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2014 10:25:05 -0500
In-Reply-To: <546A5021.20302@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 11/17/2014 08:44 PM, Douglas Gilbert wrote:
> On 14-11-17 08:25 AM, Hannes Reinecke wrote:
>> Implement a per-cpu buffer for formatting messages to
>> avoid line break up under high load.
>> This patch implements scmd_printk() and sdev_prefix_printk()
>> using the per-cpu buffer and makes sdev_printk() a wrapper
>> for sdev_prefix_printk().
>>
>> Tested-by: Robert Elliott <elliott@hp.com>
>> Reviewed-by: Robert Elliott <elliott@hp.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/Makefile       |   2 +-
>>   drivers/scsi/scsi_logging.c | 124
>> ++++++++++++++++++++++++++++++++++++++++++++
>>   include/scsi/scsi_device.h  |  21 +++-----
>>   3 files changed, 133 insertions(+), 14 deletions(-)
>>   create mode 100644 drivers/scsi/scsi_logging.c
>>
>> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
>> index 59f1ce6..4991b62 100644
>> --- a/drivers/scsi/Makefile
>> +++ b/drivers/scsi/Makefile
>> @@ -166,7 +166,7 @@ scsi_mod-y            +=3D scsi_scan.o
>> scsi_sysfs.o scsi_devinfo.o
>>   scsi_mod-$(CONFIG_SCSI_NETLINK)    +=3D scsi_netlink.o
>>   scsi_mod-$(CONFIG_SYSCTL)    +=3D scsi_sysctl.o
>>   scsi_mod-$(CONFIG_SCSI_PROC_FS)    +=3D scsi_proc.o
>> -scsi_mod-y            +=3D scsi_trace.o
>> +scsi_mod-y            +=3D scsi_trace.o scsi_logging.o
>>   scsi_mod-$(CONFIG_PM)        +=3D scsi_pm.o
>>
>>   hv_storvsc-y            :=3D storvsc_drv.o
>> diff --git a/drivers/scsi/scsi_logging.c
>> b/drivers/scsi/scsi_logging.c
>> new file mode 100644
>> index 0000000..09d65de
>> --- /dev/null
>> +++ b/drivers/scsi/scsi_logging.c
>> @@ -0,0 +1,124 @@
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
>> +#if (SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE) > BITS_PER_LONG
>> +#warning SCSI logging bitmask too large
>> +#endif
>> +
>> +struct scsi_log_buf {
>> +    char buffer[SCSI_LOG_SPOOLSIZE];
>> +    unsigned long map;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
>> +
>> +static char *scsi_log_reserve_buffer(size_t *len)
>> +{
>> +    struct scsi_log_buf *buf;
>> +    unsigned long map_bits =3D sizeof(buf->buffer) / SCSI_LOG_BUFSI=
ZE;
>> +    unsigned long idx =3D 0;
>> +
>> +    preempt_disable();
>> +    buf =3D this_cpu_ptr(&scsi_format_log);
>> +    idx =3D find_first_zero_bit(&buf->map, map_bits);
>> +    if (likely(idx < map_bits)) {
>> +        while (test_and_set_bit(idx, &buf->map)) {
>> +            idx =3D find_next_zero_bit(&buf->map, map_bits, idx);
>> +            if (idx >=3D map_bits)
>> +                break;
>> +        }
>> +    }
>> +    if (WARN_ON(idx >=3D map_bits)) {
>> +        preempt_enable();
>> +        return NULL;
>> +    }
>> +    *len =3D SCSI_LOG_BUFSIZE;
>> +    return buf->buffer + idx * SCSI_LOG_BUFSIZE;
>> +}
>> +
>> +static void scsi_log_release_buffer(char *bufptr)
>> +{
>> +    struct scsi_log_buf *buf;
>> +    unsigned long idx;
>> +    int ret;
>> +
>> +    buf =3D this_cpu_ptr(&scsi_format_log);
>> +    if (bufptr >=3D buf->buffer &&
>> +        bufptr < buf->buffer + SCSI_LOG_SPOOLSIZE) {
>> +        idx =3D (bufptr - buf->buffer) / SCSI_LOG_BUFSIZE;
>> +        ret =3D test_and_clear_bit(idx, &buf->map);
>> +        WARN_ON(!ret);
>> +    }
>> +    preempt_enable();
>> +}
>> +
>> +int sdev_prefix_printk(const char *level, const struct
>> scsi_device *sdev,
>> +               const char *name, const char *fmt, ...)
>> +{
>> +    va_list args;
>> +    char *logbuf;
>> +    size_t off =3D 0, logbuf_len;
>> +    int ret;
>> +
>> +    if (!sdev)
>> +        return 0;
>> +
>> +    logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
>> +    if (!logbuf)
>> +        return 0;
>> +
>> +    if (name)
>> +        off +=3D scnprintf(logbuf + off, logbuf_len - off,
>> +                 "[%s] ", name);
>> +    va_start(args, fmt);
>> +    off +=3D vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
>> +    va_end(args);
>> +    ret =3D dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
>> +    scsi_log_release_buffer(logbuf);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL(sdev_prefix_printk);
>> +
>> +int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
>> +        const char *fmt, ...)
>> +{
>> +    struct gendisk *disk =3D scmd->request->rq_disk;
>> +    va_list args;
>> +    char *logbuf;
>> +    size_t off =3D 0, logbuf_len;
>> +    int ret;
>> +
>> +    if (!scmd || !scmd->cmnd)
>> +        return 0;
>> +
>> +    logbuf =3D scsi_log_reserve_buffer(&logbuf_len);
>> +    if (!logbuf)
>> +        return 0;
>> +    if (disk)
>> +        off +=3D scnprintf(logbuf + off, logbuf_len - off,
>> +                 "[%s] ", disk->disk_name);
>> +    va_start(args, fmt);
>> +    off +=3D vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
>> +    va_end(args);
>> +    ret =3D dev_printk(level, &scmd->device->sdev_gendev, "%s",
>> logbuf);
>> +    scsi_log_release_buffer(logbuf);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL(scmd_printk);
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 0aeaa00..6fddcd2 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -230,9 +230,6 @@ struct scsi_dh_data {
>>   #define transport_class_to_sdev(class_dev) \
>>       to_scsi_device(class_dev->parent)
>>
>> -#define sdev_printk(prefix, sdev, fmt, a...)    \
>> -    dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
>> -
>>   #define sdev_dbg(sdev, fmt, a...) \
>>       dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
>>
>> @@ -240,16 +237,14 @@ struct scsi_dh_data {
>>    * like scmd_printk, but the device name is passed in
>>    * as a string pointer
>>    */
>> -#define sdev_prefix_printk(l, sdev, p, fmt, a...)            \
>> -    (p) ?                                \
>> -    sdev_printk(l, sdev, "[%s] " fmt, p, ##a) :            \
>> -    sdev_printk(l, sdev, fmt, ##a)
>> -
>> -#define scmd_printk(prefix, scmd, fmt, a...)                \
>> -        (scmd)->request->rq_disk ?                    \
>> -    sdev_printk(prefix, (scmd)->device, "[%s] " fmt,        \
>> -            (scmd)->request->rq_disk->disk_name, ##a) :        \
>> -    sdev_printk(prefix, (scmd)->device, fmt, ##a)
>> +extern int sdev_prefix_printk(const char *, const struct
>> scsi_device *,
>> +                  const char *, const char *, ...);
>> +
>> +#define sdev_printk(l, sdev, fmt, a...)                \
>> +    sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
>> +
>> +extern int scmd_printk(const char *, const struct scsi_cmnd *,
>> +               const char *, ...);
>>
>>   #define scmd_dbg(scmd, fmt, a...)                       \
>>       do {                                   \
>>
>=20
> The gcc compiler knows about the idiosyncrasies of printf()
> and will warn about abuses like this:
>    int k;
>    printf("string=3D%s\n", k);
>=20
>=20
> In sg3_utils I sometimes collapse fprintf(stderr, const char fmt ...)
> with a new function declaration like this:
>    int pr2serr(const char * fmt, ...)
>         __attribute__ ((format (printf, 1, 2)));
>=20
> The "1" is the position of the fmt string (origin 1) and the
> "2" is the position of the first arg to check. That __attribute__
> tells the compiler how to do printf() style checking on
> pr2serr().
>=20
>=20
> In the kernel include compiler-gcc.h contains this define:
>=20
>   #define __printf(a, b)   __attribute__((format(printf, a, b)))
>=20
> So I would suggest changing:
>   extern int sdev_prefix_printk(const char *, const struct
> scsi_device *,
>                       const char *, const char *, ...);
> to
>   extern __printf(4, 5) int
>      sdev_prefix_printk(const char *, const struct scsi_device *,
>                       const char *, const char *, ...);
>=20
>=20
> plus a similar change to the scmd_printk() declaration (and any
> other printf() style functions being introduced).
>=20
Hmm. I guess you are right. Will be updating the patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
