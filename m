From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC PATCH] isci: filter broadcast change notifications during
 SMP phy resets
Date: Mon, 27 Jun 2011 16:34:20 +0200
Message-ID: <4E0894EC.2010509@suse.de>
References: <20110624194109.26706.58553.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1F0OeY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2011 10:34:24 -0400
In-Reply-To: <20110624194109.26706.58553.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, dmilburn@redhat.com, jack_wang@usish.com, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, yuxiangl@marvell.com, hch@lst.de

On 06/24/2011 09:48 PM, Dan Williams wrote:
> From: Jeff Skirvin<jeffrey.d.skirvin@intel.com>
>
> When resetting a sata device in the domain we have seen occasions whe=
re
> libsas prematurely marks a device gone in the time it takes for the
> device to re-establish the link.  This plays badly with software raid
> arrays.  Other libsas drivers have non-uniform delays in their reset
> handlers to try to cover this condition, but not sufficient to close =
the
> hole.  Given that a sata device can take many seconds to recover we
> filter bcns and poll for the device reattach state before notifying
> libsas that the port needs the domain to be rediscovered.  Once this =
has
> been proven out at the lldd level we can think about uplevelling this
> feature to a common implementation in libsas.
>
That's the second time something like this have come up now.
Wouldn't it makes sense to implement something like the dev_loss_tmo=20
mechanism with have for FC? That should cover this situation nicely ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
