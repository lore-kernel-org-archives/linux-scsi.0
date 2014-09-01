From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/22] scsi: use local buffer for printing the opcode
Date: Mon, 01 Sep 2014 10:57:41 +0200
Message-ID: <54043505.5090607@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-14-git-send-email-hare@suse.de> <20140831221946.GI16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbaIAI5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 04:57:43 -0400
In-Reply-To: <20140831221946.GI16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On 09/01/2014 12:19 AM, Christoph Hellwig wrote:
> On Thu, Aug 28, 2014 at 07:33:27PM +0200, Hannes Reinecke wrote:
>> SCSI opcode printing is tricky and needs to take into account
>> several different corner cases. So instead of trying to come
>> up with an elaborate printk() statement we should be printing
>> it into a local buffer.
>=20
> scsi_print_command callers are usually deep down the call chain., so =
I'd
> rather avoid using up even more stack here.  What are the exact reaso=
ns
> that we need the local buffer?
>=20
I know, and I'm not happy with this patch, either.

However, we really, _really_, want to print the decode command name
and the CDB in one line ie with one printk() statement.
If we don't we'll end up with individual logging messages with one
byte per line under high load.
Making it impossible to figure out to which CDB these individual
bytes are related to.

It would be possible to unroll the CDB decoding loop, as we're
typically have only 3 formats. But it's near impossible to find some
common ground when decoding the command; I've ended up having
really convoluted #defines calling into each other, making debugging
that code really horrible.

You're more than welcome to try...

But for now I fear we have to bite the bullet, and ensure the
additional stack space it only used when logging is enabled.

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
