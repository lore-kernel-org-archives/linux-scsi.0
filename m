From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi: Implement per-cpu logging buffer
Date: Thu, 12 Feb 2015 14:29:35 +0100
Message-ID: <54DCAABF.20606@suse.de>
References: <20150211191614.349AF660DDA@gitolite.kernel.org> <CAMuHMdUKH1yuLZ9zLAK2STekLFXBufR9PM2_S11xExCtEc9dWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdUKH1yuLZ9zLAK2STekLFXBufR9PM2_S11xExCtEc9dWg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>
Cc: Josh Triplett <josh@joshtriplett.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/12/2015 01:36 PM, Geert Uytterhoeven wrote:
> On Wed, Feb 11, 2015 at 8:16 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
>> Gitweb:     http://git.kernel.org/linus/;a=3Dcommit;h=3Dded85c193a39=
1a84076d5c6a7a5668fe164a490e
>> Commit:     ded85c193a391a84076d5c6a7a5668fe164a490e
>> Parent:     b0a93d96b2814c725161f91a4e35d0c29ec0f95b
>> Refname:    refs/heads/master
>> Author:     Hannes Reinecke <hare@suse.de>
>> AuthorDate: Thu Jan 8 07:43:42 2015 +0100
>> Committer:  Christoph Hellwig <hch@lst.de>
>> CommitDate: Fri Jan 9 15:44:28 2015 +0100
>>
>>     scsi: Implement per-cpu logging buffer
>>
>>     Implement a per-cpu buffer for formatting messages to avoid line=
 breaks
>>     up under high load.  This patch implements scmd_printk() and
>>     sdev_prefix_printk() using the per-cpu buffer and makes sdev_pri=
ntk() a
>>     wrapper for sdev_prefix_printk().
>>
>>     Tested-by: Robert Elliott <elliott@hp.com>
>>     Reviewed-by: Robert Elliott <elliott@hp.com>
>>     Signed-off-by: Hannes Reinecke <hare@suse.de>
>>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>=20
>> --- /dev/null
>> +++ b/drivers/scsi/scsi_logging.c
>=20
>> +#define SCSI_LOG_SPOOLSIZE 4096
>> +#define SCSI_LOG_BUFSIZE 128
>> +
>> +#if (SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE) > BITS_PER_LONG
>> +#warning SCSI logging bitmask too large
>> +#endif
>> +
>> +struct scsi_log_buf {
>> +       char buffer[SCSI_LOG_SPOOLSIZE];
>> +       unsigned long map;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
>=20
> Do we really need a static 4 KiB per-CPU buffer?
>=20
> bloat-o-meter:
>=20
> add/remove: 183/94 grow/shrink: 314/211 up/down: 33467/-21291 (12176)
> function                                     old     new   delta
> scsi_format_log                                -    4100   +4100
> handle_mm_fault                             1794    2750    +956
> scsi_log_print_sense_hdr                       -     774    +774
> proc_keys_show                                 -     770    +770
>=20
Define 'need'.
We don't absolutely 'need' it. (Configure it out and it's gone).

But when we want to avoid several logging messages coming in from
various CPUs overwriting each other and _not_ introduce additional
latency by locking a single buffer, then yes.

We can possibly reduce it to, say, 1KiB or even lower by imposing
stricter rules on the logging functions.
But I don't see a way around the per-CPU buffer.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
