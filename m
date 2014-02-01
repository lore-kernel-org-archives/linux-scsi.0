From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Sat, 01 Feb 2014 15:06:51 +0100
Message-ID: <52ECFF7B.7000401@suse.de>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaBAMEL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Feb 2014 07:04:11 -0500
In-Reply-To: <52EBD2BB.8020705@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>
Cc: Kay Sievers <kay@vrfy.org>, Kai Makisara <kai.makisara@kolumbus.fi>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/31/2014 05:43 PM, Jeremy Linton wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 1/31/2014 2:46 AM, Hannes Reinecke wrote:
>
>> This patch make the tape always non-rewinding when SG_IO is used, th=
us
>> allowing udev to get a proper device id for tapes.
>
> 	Maybe instead of silently changing the behavior, if you just _HAVE_ =
to open
> the st device, add an ioctl or st/mt_op that disables the rewind on c=
lose.
> That way applications have to explicitly disable the rewind on close.
>
Okay, that sounds like a better alternative.
Point is for udev we simply _have_ to use the given device node.
And when this happens to be set to rewind on close we're doomed.

I'll be drafting up a patch.

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
