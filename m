From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] scsi_scan: Fixup scsilun_to_int()
Date: Fri, 27 Jun 2014 09:30:45 +0200
Message-ID: <53AD1DA5.1040605@suse.de>
References: <1403702859-74437-1-git-send-email-hare@suse.de> <1403702859-74437-5-git-send-email-hare@suse.de> <53AD1960.70703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaF0Has (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 03:30:48 -0400
In-Reply-To: <53AD1960.70703@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 06/27/2014 09:12 AM, Bart Van Assche wrote:
> On 06/25/14 15:27, Hannes Reinecke wrote:
>> scsilun_to_int() has an error which prevents it from generating
>> correct LUN numbers for 64bit values.
>> Also we should remove the misleading comment about portions of
>> the LUN being ignored; the initiator should treat the LUN as
>> an opaque value.
>> And, finally, the example given should use the correct
>> prefix (here: extended flat space addressing scheme).
>
> I'm still not enthusiast about the byte reordering by scsilun_to_int(=
)
> for extended logical unit addressing. But I can confirm that this pat=
ch
> passed the test that failed with the previous version of the 64-bit L=
UN
> patch series. So if you want you can add "Tested-by: Bart van Assche
> <bvanassche@acm.org>".
>
I can somewhat agree with your sentiment.

It should be possible eg to keep the LUN in native format (as now=20
both have the same length) and only use scsilun_to_int() when
displaying the LUN number.

But this needs a careful review, as occasionally the code might want=20
to traverse the LUN numbers by simply incrementing it, which of=20
course won't work anymore then.
Which was the main reason why I didn't do so in the first place.

Now, however, the necessary bits are done, so we should have a look=20
at that. Let's see ...

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
