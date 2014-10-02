From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Thu, 02 Oct 2014 11:50:42 +0200
Message-ID: <542D1FF2.1010307@suse.de>
References: <1411991272-129962-1-git-send-email-hare@suse.de> <542C4D33.2030401@hp.com> <20141001211003.GA24820@infradead.org> <542CF5E8.3030601@suse.de> <20141002091916.GA13227@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaJBJuo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 05:50:44 -0400
In-Reply-To: <20141002091916.GA13227@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Webb Scales <webbnh@hp.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 10/02/2014 11:19 AM, Christoph Hellwig wrote:
> On Thu, Oct 02, 2014 at 08:51:20AM +0200, Hannes Reinecke wrote:
>>
>> I'm afraid it's not _that_ easy.
>> SCSI-II tagged queueing has some specific tag values:
>>
>> #define SIMPLE_QUEUE_TAG    0x20
>> #define HEAD_OF_QUEUE_TAG   0x21
>> #define ORDERED_QUEUE_TAG   0x22
>=20
> These are not tag values.  These are message codes set in the first b=
yte
> of the Queue tag message, the second byte is the actual tag.
>=20
>> The recommendation here is to use 'scmd->request->tag' whenever
>> you want to get to the tag number, and 'scmd->tag' if you have to
>> play around with SCSI-II TCQ.
>> But if not I would strongly advise to leave 'scmd->tag' alone.
>=20
> Or kill off scmd->tag..  Let's see how feasible that is.
>=20
I'm about to.
(See my last two patches).
There are now two instances left:
NCR5380 (and derived LLDDs) and fnic.
=46or some weird reasons fnic decided to duplicate blk-tag
functionality. Looking into it.

And NCR5380 tag support can be safely ignored, it never worked anyway.

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
