From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] megaraid_sas: Enable shared tag map
Date: Thu, 02 Oct 2014 14:00:32 +0200
Message-ID: <542D3E60.40009@suse.de>
References: <1411991272-129962-1-git-send-email-hare@suse.de> <542C4D33.2030401@hp.com> <20141001211003.GA24820@infradead.org> <542CF5E8.3030601@suse.de> <20141002091916.GA13227@infradead.org> <542D1FF2.1010307@suse.de> <20141002113652.GB26897@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaJBMAe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 08:00:34 -0400
In-Reply-To: <20141002113652.GB26897@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Webb Scales <webbnh@hp.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 10/02/2014 01:36 PM, Christoph Hellwig wrote:
> On Thu, Oct 02, 2014 at 11:50:42AM +0200, Hannes Reinecke wrote:
>> NCR5380 (and derived LLDDs) and fnic.
>=20
> fnic needs a tag for a device reset, which we don't provide if it
> is issue by ioctl.  This is also showed up during the blk-mq work.
>=20
Actually, I've hit a similar issue for megaraid_sas (and I guess
others which implement a host-wide tag map might suffer here, too):
tags need to be used even for internal commands.
But tag allocation is done exclusively in the block layer, so one
cannot readily influence this.
(Or, if you do, you'll end up with code duplication like the fnic
driver).
Thing is, for internal commands we typically do not _need_ a fully
formed request, we just need to tag number.

So we could try to implement a function like 'blk_tag_reserve'
to return the next free tag.

But even with that we'd be hitting a tag starvation issue; when
all command tags are in use we cannot send internal commands.
And if the command abort happens to be modelled with an internal
command, we cannot even abort commands anymore.
Which is probably _not_ what we want.
(And I think fnic will suffer from this, too ...)

So I guess we need to set aside a reserved tag pool from which
the internal commands will be allocated.
(Bit like the emergency network skb pool).
With that the tag starvation issue will be resolved, and
we should be able to remove the custom code in fnic.

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
