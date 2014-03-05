From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv7 0/3][Resend] Display EVPD pages in sysfs
Date: Wed, 05 Mar 2014 09:00:29 +0100
Message-ID: <5316D99D.3060005@suse.de>
References: <1392287281-75002-1-git-send-email-hare@suse.de> <5312F1A1.4070605@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaCEIAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 03:00:30 -0500
In-Reply-To: <5312F1A1.4070605@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 03/02/2014 09:53 AM, Bart Van Assche wrote:
> On 02/13/14 11:27, Hannes Reinecke wrote:
>> After discussion with jejb I've dropped the EVPD parsing.
>> So with this version we're just displaying the EVPD page
>> 0x80 and 0x83 as hexdumps; no parsing is attempted.
>> This drastically simplifies the patch, and we don't
>> have to worry about any parsing errors in kernel space.
>> Of course we'll need a parser in userspace, but that
>> doesn't need to do any I/O. So it's still a very nice
>> gain.
>=20
> A general comment about this patch series: I think the cached copies =
of
> these pages should be refreshed at least after an INQUIRY DATA HAS
> CHANGED unit attention code has been received. Some SCSI target
> implementations allow to change this data after a LUN has been create=
d.
>=20
Yes, eventually. But this needs to be handled in a general context,
as (potentially) even the inquiry string itself has been invalidated
after receiving such an event.
So we should be doing a rescan of the scsi device upon receiving
such an event. But this is a general problem, not one particular to
this patchset.

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
