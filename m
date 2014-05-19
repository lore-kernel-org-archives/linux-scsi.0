From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi error handling thread and REQUEST SENSE
Date: Mon, 19 May 2014 12:37:40 +0200
Message-ID: <5379DEF4.9000301@suse.de>
References: <94D0CD8314A33A4D9D801C0FE68B402956F17E1F@G4W3202.americas.hpqcorp.net> <1400270713.3813.33.camel@localhost.localdomain> <5379C1B2.2040600@suse.de> <5379DD04.9020303@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaESKhm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2014 06:37:42 -0400
In-Reply-To: <5379DD04.9020303@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, emilne@redhat.com, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/19/2014 12:29 PM, Bart Van Assche wrote:
> On 05/19/14 10:32, Hannes Reinecke wrote:
>> Well, problem here is that the 'REQUEST SENSE' command has two probl=
ems:
>> a) Most modern HBA (ie all non-SPI HBAs) use autosense, ie the sense
>> code is returned with the command. So issuing 'REQUEST SENSE' here i=
s
>> pointless.
>> b) The sense code (when retrieved via 'REQUEST SENSE') relates to th=
e
>> most recently processed command (from the target perspective).
>> Which is a bit hard to make out, as by the time SCSI EH starts
>> several other commands might have been processed already, so any
>> sense we'd be retrieving most likely does not relate to the failed c=
ommand.
>>
>> I would propose to disable the 'REQUEST_SENSE' step as soon as the H=
BA
>> is capable of autosensing. We requires us to add another flag
>> to the scsi_host field.
>>
>> What about the attached patch? That should roughly do what's require=
d
>> here, right?
>
> This patch does not address the SRP initiator. There might be more SC=
SI
> initiator drivers that support autosense but that are not addressed b=
y
> this patch. Has it been considered to set the autosense flag for all
> HBA's and clear it in those SCSI initiator drivers that do not suppor=
t
> autosense ?
>
Correct.
I haven't looked at the SRP spec to figure out if it does autosense=20
or not. If it does we should be updating the patch.

And yes, it has been considered.
However, I decided against it because it would require to check
each and every driver to figure out if they do autosense or not.
So as a first test I decided it to be quicker to have a 'whitelist'=20
kind of approach and enable only those for which autosense is=20
required by protocol.

This also excludes all RAID HBAs, which need to be checked=20
individually. And the SPI HBAs, of course.

Plus this is just a test patch, nothing official yet.
I'm happy to include the changes for SRP if you can confirm that SRP=20
requires autosense.

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
