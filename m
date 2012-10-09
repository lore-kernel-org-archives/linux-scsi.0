From: Hannes Reinecke <hare@suse.de>
Subject: Decoding short sense buffers
Date: Tue, 09 Oct 2012 12:42:33 +0200
Message-ID: <5073FF99.3070808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab2JIKmg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2012 06:42:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

Hi all,

I've noticed that virtually everybody assumes that the length of the=20
sense buffer is SCSI_SENSE_BUFFERSIZE.
And consequently every caller uses SCSI_SENSE_BUFFERSIZE when=20
calling any of the sense processing functions like
scsi_normalize_sense() etc.

However, those processing functions to go into great detail handling=20
_shorter_ buffersizes, which of course will never happen.

On the other hand, most LLDDs are capable of detecting the actually=20
transmitted sense buffer sizes; there even is a field in struct=20
request which would allow us to transmit the number of bytes in the=20
sense buffer.
But this field is happily neglected, too.

So, questions here:
- Do we actually care for a sense buffer underflow?
We won't be able to detect it currently anyway;
plus we haven't received any error reports for it.
And the allocated sense buffer is _always_ SCSI_SENSE_BUFFERSIZE ...

- What is the intention of rq->sense_len?
 From what I gather it _should_ hold the size of the received sense=20
buffer data. But that doesn't happen currently.
=46or short sense buffers that doesn't matter, but for sense buffer=20
_overruns_ it would be quite good to know.

Which causes quite some confusion on how to probe for valid sense data:
- DRIVER_SENSE ?
- rq->sense_len?
- scsi_normalize_sense?

Thanks for clarification.

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
