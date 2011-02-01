From: Hannes Reinecke <hare@suse.de>
Subject: Re: Current plans for SDEV_EVT_* and friends
Date: Tue, 01 Feb 2011 16:29:50 +0100
Message-ID: <4D4826EE.3030906@suse.de>
References: <4D481ED2.1060109@suse.de> <20110201145903.GO14211@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1BAPWF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Feb 2011 10:22:05 -0500
In-Reply-To: <20110201145903.GO14211@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <jbottomley@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Richard Sharpe <realrichardsharpe@gmail.com>, kay.sievers@vrfy.org

On 02/01/2011 03:59 PM, Tejun Heo wrote:
> (cc'ing Kay)
>=20
> Hello,
>=20
> On Tue, Feb 01, 2011 at 03:55:14PM +0100, Hannes Reinecke wrote:
>> seeing that you are moving the old SCSI / libata AEN handling over
>> to the new block-based workqueue, I was wondering what your plans
>> are with the remaining SDEV_EVT_* things.
>=20
> SDEV_EVT_* are basically dead.  There's no valid user for it in the
> kernel.  libata-scsi hasn't been converted yet - virtually SATA AN is
> pretty much stillborn and converting it would require a way to map AT=
A
> device to block device which isn't easy without changing SCSI.
>=20
>> Thing is I'm currently working on implementing proper Unit Attention
>> handling in the SCSI stack. For this I would need to have some field
>> off the scsi_device structure into which I can store information
>> about which events / event types are supported and which are activat=
ed.
>> So the existing bitmap approach with 'supported_events' would quite
>> a good starting point here, and it will even be useful to add
>> another one, eg 'enabled_events'.
>> And, of course, plan is to route appropriate events over to the
>> block workqueue by calling disk_check_events().
>>
>> Unless you have other ideas/plans here ...
>=20
> So, I think using the block layer DISK_EVENT_* would be the right way
> to do it, but what kind of events do you have on mind?
>=20
Well, partially.

DISK_EVENT_* is of course the right way to got if we're dealing with
events which _can_ be mapped onto a gendisk.
However, not all SCSI LUNs do have this mapping (eg LUNs not
associated with any device driver) and not all events affect a
single LUN. Some classes of events actually relate to the entire
target, which would require us to call back into the SCSI host itself.
Case in point: REPORT LUN DATA CHANGED, for which we would need to
rescan the host.

So we basically have to have another set of events in the SCSI
layer, some of which map to the existing DISK_EVENT_*, and some don't.
Of course I can go ahead and create my own set of events, but that
would nearly amount to code duplication.
Hence the idea of re-using SDEV_EVT_*
Or I'll be renaming them to SDEV_EVENT_* to be in-line with your
DISK_EVENT_* thing and to avoid confusion with the previous
implementation.

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
