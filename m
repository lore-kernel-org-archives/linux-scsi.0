From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv7 0/3][Resend] Display EVPD pages in sysfs
Date: Wed, 05 Mar 2014 09:34:47 +0100
Message-ID: <5316E1A7.8000308@suse.de>
References: <1392287281-75002-1-git-send-email-hare@suse.de> <5312F1A1.4070605@acm.org> <5316D99D.3060005@suse.de> <5316DF09.4070704@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaCEIet (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Mar 2014 03:34:49 -0500
In-Reply-To: <5316DF09.4070704@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 03/05/2014 09:23 AM, Bart Van Assche wrote:
> On 03/05/14 09:00, Hannes Reinecke wrote:
>> On 03/02/2014 09:53 AM, Bart Van Assche wrote:
>>> A general comment about this patch series: I think the cached copie=
s of
>>> these pages should be refreshed at least after an INQUIRY DATA HAS
>>> CHANGED unit attention code has been received. Some SCSI target
>>> implementations allow to change this data after a LUN has been crea=
ted.
>>
>> Yes, eventually. But this needs to be handled in a general context,
>> as (potentially) even the inquiry string itself has been invalidated
>> after receiving such an event.
>> So we should be doing a rescan of the scsi device upon receiving
>> such an event. But this is a general problem, not one particular to
>> this patchset.
>=20
> Sorry but since the ALUA patch series is based on this patch series I=
'm
> afraid that the ALUA patch series introduces a regression that seems
> unacceptable to me. SCSI target implementations like LIO allow to rem=
ove
> and re-add a LUN after initial discovery of a SCSI host. My concern h=
ere
> is that the caching introduced by this patch series and which is used=
 in
> the ALUA patch series will cause INQUIRY data not to be updated after=
 it
> has been changed at the target side. Today the scsi_dh_alua handler
> processes such INQUIRY data changes fine. Does this make sense to you=
 ?
>=20
Currently, the SCSI stack itself is not well-equipped to handle
these kind of setups anyway.
(The only known working solution is to remove the device _entirely_
and have the HBA rescan the LUN).
So while you are right I'm still preferring to keep those two issues
separate.

James, any preferences here?

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
