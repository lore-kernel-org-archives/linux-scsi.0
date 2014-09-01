From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/22] scsi: do not decode sense extras
Date: Mon, 01 Sep 2014 10:10:24 +0200
Message-ID: <540429F0.7010708@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de> <1409247216-76074-8-git-send-email-hare@suse.de> <20140831220622.GC16432@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaIAIK1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 04:10:27 -0400
In-Reply-To: <20140831220622.GC16432@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Kai.Makisara@kolumbus.fi, Willem Riede <osst@riede.org>

On 09/01/2014 12:06 AM, Christoph Hellwig wrote:
> On Thu, Aug 28, 2014 at 07:33:21PM +0200, Hannes Reinecke wrote:
>> Currently we're only decoding sense extras for tape devices.
>> And even there only for fixed format sense formats.
>> As this is of rather limited use in the general case we should
>> be stop trying to decode things here and rather dump the entire
>> sense code.
>=20
> I don't like this one at all.  Not that I'm attached to decoding the
> extra sense buffer, but:
>=20
>   - __scsi_print_sense now prints both decoded sense data as well as =
a
>     full dump, which is rather ugly
>   - __scsi_print_sense prints that buffer unconditionally
>=20
> I'd say let's sit down and work with the tape driver maintainers on
> finding a better way to deal with their sense printing needs.  And pa=
rt
> of that should probably be to get rid of __scsi_print_sense entirely
> and make the tape drivers use pre-decoded and normalized sense buffer=
s.
>=20
Well, thing is the tape driver does it's own sense decoding anyway.
So there's no need for that to be done here.

I've updated the patch to not dump any sense code and adapted the
descriptions somewhat.

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
