From: Hannes Reinecke <hare@suse.de>
Subject: Re: question on SDEV_BLOCK vs. SDEV_QUIESCE
Date: Tue, 25 Sep 2007 09:42:36 +0200
Message-ID: <46F8BBEC.4090602@suse.de>
References: <200709250934.30213.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXIYHmi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2007 03:42:38 -0400
In-Reply-To: <200709250934.30213.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Oliver Neukum wrote:
> Hi,
>=20
> what is the difference between these states? What function should
> I call to block a device in order to securely flush the caches?
>=20
SDEV_BLOCK blocks _any_ commands from the midlayer; eg. if the LLDD
is doing some internal recovery.
SDEV_QUIESCE only blocks 'normal' data commands; others (like control
commands) can still get through.

So for flushing you should use SDEV_QUIESCE.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
