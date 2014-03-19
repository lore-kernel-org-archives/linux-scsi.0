From: Hannes Reinecke <hare@suse.de>
Subject: Re: BLIST_SINGLELUN
Date: Wed, 19 Mar 2014 16:42:35 +0100
Message-ID: <5329BAEB.7090109@suse.de>
References: <20140318142804.GA25309@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965389AbaCSPmh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2014 11:42:37 -0400
In-Reply-To: <20140318142804.GA25309@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 03/18/2014 03:28 PM, Christoph Hellwig wrote:
> Does anyone still have a device listed in the blacklist with
> BLIST_SINGLELUN?
>=20
> From reading the source code I'm not sure the code actually works as
> expected currently, or did for a long time.
>=20
> While scsi_target_queue_ready makes sure to only queue commands to th=
e
> right lun as long as starget_sdev_user is set, scsi_single_lun_run
> clears starget_sdev_user as soon as the any command completes on a
> target marked with the flag, allowing the following situation:
>=20
>  - cmd 1 lun 0		submitted
>  - cmd 2 lun 0		submitted
>  - cmd 1 lun 0		completed
>  - cmd 9 lun 1		submitted
>=20
> and thus having commands for two luns in flight at the same time
> if we hit the narrow enough race of entering the scsi_request_fn
> for lun 1 before scsi_single_lun_run does so for lun 0.

You know what, I've been looking at that, too.
And indeed, it looks like you're right.

I do wonder, though, why we don't do away with the
starget_sdev_user and just set max_target_blocked to 1 ...

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
