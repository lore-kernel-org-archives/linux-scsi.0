From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/16] scsi_dh_alua: Make stpg synchronous
Date: Wed, 12 Feb 2014 16:29:23 +0100
Message-ID: <52FB9353.7040807@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-5-git-send-email-hare@suse.de> <52F435B3.3090600@cs.wisc.edu> <52F43CD7.5050900@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaBLP3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 10:29:24 -0500
In-Reply-To: <52F43CD7.5050900@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@parallels.com>, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/07/2014 02:54 AM, Mike Christie wrote:
> On 02/06/2014 07:24 PM, Mike Christie wrote:
>> On 01/31/2014 03:29 AM, Hannes Reinecke wrote:
>>> We should be issuing STPG synchronously as we need to
>>> evaluate the return code on failure.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>
>> I think we need to also make dm-mpath.c use a non-ordered workqueue =
for
>> kmpath_handlerd. With this patch and the current ordered workqueue i=
n
>> dm-mpath I think we will only be able to do one STPG at a time. I th=
ink
>> if we use a normal old non-ordered workqueue then we would be limite=
d to
>> have max_active STPGs executing.
>=20
> I goofed and commented in the order I saw the patches :) I take this
> comment back for this patch, because I see in 16/16 you added a new
> workqueue to scsi_dh_alua to do rtpgs and stpgs.
>=20
> For 16/16 though, do we want to make kmpath_aluad a non single thread=
ed
> workqueue? It looks like max_active for single threaded is only one w=
ork
> at a time too.
>=20
Well, that was by intention.

The workqueue will be triggered very infrequently (basically for
every path switch).
=46or implicit ALUA we just need to issue a RTPG to get the new path
status; there we might be suffering from single threaded behaviour.
But we need to issue it only once and it should be processed
reasonably fast.
=46or explicit ALUA we'll have to send an STPG, which has potentially
system-wide implications. So sending several to (supposedly)
different targets might actually be contraproductive, as the first
might have already set the status for the second call.
Here we most definitely _want_ serialisation to avoid superfluous STPGs=
=2E

So for now I think we can stick with the single threaded workqueue,
and can revise this later if it's found to be a scalability issue.

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
