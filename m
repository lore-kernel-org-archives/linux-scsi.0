From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 04/43] hpsa: clean up aborts
Date: Fri, 17 Apr 2015 14:59:58 +0200
Message-ID: <553103CE.40108@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134703.30238.10876.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbbDQM77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 08:59:59 -0400
In-Reply-To: <20150416134703.30238.10876.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:47 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>=20
> Do not send aborts to logical devices that do not support aborts
>=20
> Instead of relying on what the Smart Array claims for supporting logi=
cal
> drives, simply try an abort and see how it responds at device discove=
ry
> time.  This way devices that do support aborts (e.g. MSA2000) can wor=
k
> and we do not waste time trying to send aborts to logical drives that=
 do
> not support them (important for high IOPS devices.)
>=20
> While rescanning devices only test whether devices support aborts
> the first time we encounter a device rather than every time.
>=20
> Some Smart Arrays required aborts to be sent with tags in
> the wrong endian byte order.  To avoid having to know about
> this, we would send two aborts with tags with each endian order.
> On high IOPS devices, this turns out to be not such a hot idea.
> So we now have a list of the devices that got the tag backwards,
> and we only send it one way.
>=20
> If all available commands are outstanding and the abort handler
> is invoked, the abort handler may not be able to allocate a command
> and may busy-wait excessivly.  Reserve a small number of commands
> for the abort handler and limit the number of concurrent abort
> requests to the number of reserved commands.
>=20
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
