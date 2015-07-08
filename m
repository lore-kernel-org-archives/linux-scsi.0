From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 5/5] target: Fix wrong setting of sense format for
 PI errors
Date: Wed, 08 Jul 2015 12:59:18 +0200
Message-ID: <559D0286.4070202@suse.de>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com> <1436188508-1539-6-git-send-email-sagig@mellanox.com> <20150708101931.GD14466@infradead.org> <559CFD14.9090803@dev.mellanox.co.il> <20150708104955.GA20842@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbbGHK7V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 06:59:21 -0400
In-Reply-To: <20150708104955.GA20842@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>

On 07/08/2015 12:49 PM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2015 at 01:36:04PM +0300, Sagi Grimberg wrote:
>> We don't have any other information today, but sector is not the onl=
y
>> information that is requires a descriptor format, so maybe it will b=
e a
>> bit awkward to condition the descriptor format on the sector info?
>=20
> The only reason why you'd want to support descriptor type sense data =
is
> because you need to add a second descriptor.  If we have another case
> that needs descriptor sense data it'll also need to add that addition=
al
> descriptor.  So we'll need a conditional for it in the sense data
> generation anyway.
>=20
Actually it's controlled by the D_SENSE bit in the Control mode page
(that's bit[2] of byte 2 in the control mode page).
Which is currently set to '0', ie we will be returning fixed sense
information.
_If_ we were to report descriptor sense we will need to change that,
too.

And it's actually not true that you'd need descriptor sense to
encode the sector information; it'll be stored in the 'information'
section (byte 3-6) for fixed format sense.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
