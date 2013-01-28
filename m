From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Mon, 28 Jan 2013 16:48:48 +0100
Message-ID: <51069DE0.4010006@suse.de>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com> <51011D2E.305@suse.de> <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com> <5106939E.1010301@tributary.com> <51069CC8.3000103@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab3A1Psu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2013 10:48:50 -0500
In-Reply-To: <51069CC8.3000103@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jeremy Linton <jlinton@tributary.com>, "Ewan D. Milne" <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/28/2013 04:44 PM, Bart Van Assche wrote:
> On 01/28/13 16:05, Jeremy Linton wrote:
>> What I think your looking for is RSCN (Registered State Change
>> notification).
>> Hook that, and then check the name server. This will tell you when
>> ports get
>> added/removed. You can then report luns against lun 0 of all the
>> known target
>> ports. This allows you to transparently detect changes.
>>
>> Otherwise, you run the risk of trapping UA's in the lower level
>> portions of
>> the stack that _REALLY_ need to be propagated to the controlling
>> driver or
>> application.
>
> Thanks for the feedback. Unfortunately sending an RSCN is only
> possible when using Fibre Channel as transport layer. I'm looking
> for a solution that also works with other SCSI transports, e.g.
> iSCSI and SRP.
>
And we're already doing that. Rather, the FC HBAs do exactly this.

So the proposal would be to export a 'virtual' LUN0 if none is=20
present, so that we always have a device to talk to, right?

Shouldn't be too hard; we already create a 'virtual' LUN0 during=20
scanning, only we delete it if no LUNs are found.
So we're already doing this, only we don't tell :-)

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
