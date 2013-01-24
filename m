From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Thu, 24 Jan 2013 12:38:22 +0100
Message-ID: <51011D2E.305@suse.de>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab3AXLiY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2013 06:38:24 -0500
In-Reply-To: <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 01/24/2013 01:19 AM, Bart Van Assche wrote:
> On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wr=
ote:
>> This patch set adds changes to the SCSI mid-layer, sysfs and scsi_de=
bug
>> to provide enhanced support for Unit Attention conditions, as well a=
s
>> detection of reported sense data overflow conditions and some change=
s
>> to sense data processing.  It also adds a uevent when the reported
>> capacity changes on an sd device.
>>
>> There was some discussion about this a couple of years ago on the li=
nux-scsi
>> mailing list:  http://marc.info/?l=3Dlinux-scsi&m=3D129702506514742&=
w=3D2
>> Although one approach is to send all SCSI sense data to a userspace =
daemon
>> for processing, this patch set does not take that approach due to th=
e
>> difficulty in reliably delivering all of the data.  An interesting U=
A
>> condition might not be delivered due to a flood of media errors, for=
 example.
>>
>> The mechanism used is to flag when certain UA ASC/ASCQ codes are rec=
eived
>> that report asynchronous changes to the storage device configuration=
=2E
>> An appropriate uevent is then generated for the scsi_device or scsi_=
target
>> object.  An aggregation mechanism is used to avoid generating uevent=
s at
>> too high a rate, and to coalesce multiple UAs reported by LUNs on th=
e
>> same target for a REPORTED LUNS DATA HAS CHANGED sense code.
>
> Does this patch series add a function that allows SCSI LLDs to report
> AEN data to the SCSI core ? What if a SCSI target reports a LUN
> inventory change via AER to e.g. the iSCSI initiator and that
> initiator ignores the AEN data ? Will that result in AEN data being
> ignored and no automatic LUN rescanning ?
>
Well, first and foremost we _don't_ have automatic LUN rescanning.
This patchset just puts in the infrastructure that userspace can=20
know _when_ a LUN rescan might be in order.

As for AEN, does iSCSI _do_ AEN? I thought it got removed ...

If it does, though, it should schedule an event on its own whenever=20
an AER is received. The same goes for LLDDs with vendor-specific=20
AENs; thinking of megaraid_sas here ...

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
