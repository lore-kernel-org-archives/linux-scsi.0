From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/10] scsi: Use real functions for logging
Date: Tue, 04 Nov 2014 15:22:25 +0100
Message-ID: <5458E121.3060505@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de> <1415088409-46590-2-git-send-email-hare@suse.de> <20141104135845.GA3531@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaKDOW1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 09:22:27 -0500
In-Reply-To: <20141104135845.GA3531@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On 11/04/2014 02:58 PM, Christoph Hellwig wrote:
> On Tue, Nov 04, 2014 at 09:06:40AM +0100, Hannes Reinecke wrote:
>> Implement a per-cpu buffer for formatting messages,
>> and add real functions for scmd_printk and sdev_prefix_printk
>> using that buffer and use dev_printk() to print out things.
>> And make sdev_printk() a wrapper for sdev_prefix_printk().
>=20
> The "real functions" mostly seem to be a side effect of the
> implementation, how about a more descriptive subject line?
>=20
> Also adding a sentence or two why this is done to the patch descripti=
on
> would be very helpful.
>=20
Ok.

>> +/*
>> + * scsi_logging.c
>=20
> Please don't mention the file name in top of file comments, it's boun=
d
> to get out of date.
>=20
Ok.

>> +#define SCSI_LOG_SPOOLSIZE 4096
>> +#define SCSI_LOG_BUFSIZE 128
>> +
>> +struct scsi_log_buf {
>> +	char buffer[SCSI_LOG_SPOOLSIZE];
>> +	unsigned long map;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
>=20
> Some sort of comment explaining why we need the per-cpu buffers also
> would be very useful.  To me this seems like a little bit too much
> duplication of the tracing code.
>=20
Hehe. It is _not_.
(Not now, anyway).

The problem with the current tracing code is that it's split in two,
a writing side and a reading side.
So you cannot write to it and have it read back in the same function
without using really heavy locking.
But as we _do_ want to have the message printed out as soon as it's
being written we cannot use the tracing code as-is.

_And_ the current tracing infrastructure is using a single buffer,
so if we were to use it our messages would be interspersed with
other, unrelated, tracing messages.

So we'd need to implement our own buffer anyway, which is what
I did. And it was actually suggested by Stephen Rostedt at LPC :-)
Stephen is working on abstracting away some parts of the
tracing infrastructure for general consumption, but until
that's done one has to do it manually.

(The whole issue is just because printk() is so damn stupid.
If we had a printk() workqueue for printing out messages we could
separate the submission side from the logging side. Then
we could expose the internal functions which adds items
to the internal printk buffer, and we could work on those items
directly. But we haven't, and I don't think it's going to
change anytime soon.
Hmm. Would be fit topic for KS. For which I won't be invited.
So there.)

But yeah, I can update the description here.

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
