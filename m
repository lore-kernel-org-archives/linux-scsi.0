From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Mon, 28 Jan 2013 07:56:22 +0100
Message-ID: <51062116.2060709@suse.de>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com> <51011D2E.305@suse.de> <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com> <51014A7B.2060806@suse.de> <51014C84.4000906@cs.wisc.edu> <51015016.5050309@suse.de> <51041E57.3080104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab3A1G4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2013 01:56:24 -0500
In-Reply-To: <51041E57.3080104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 01/26/2013 07:20 PM, Mike Christie wrote:
> On 01/24/2013 09:15 AM, Hannes Reinecke wrote:
>> On 01/24/2013 04:00 PM, Mike Christie wrote:
>>> On 01/24/2013 07:51 AM, Hannes Reinecke wrote:
>>>> On 01/24/2013 03:38 PM, Bart Van Assche wrote:
>>>>> On Thu, Jan 24, 2013 at 4:38 AM, Hannes Reinecke <hare@suse.de> w=
rote:
>>>>>> As for AEN, does iSCSI _do_ AEN? I thought it got removed ...
>>>>>>
>>>>>> If it does, though, it should schedule an event on its own whene=
ver
>>>>>> an AER
>>>>>> is received. The same goes for LLDDs with vendor-specific AENs;
>>>>>> thinking of
>>>>>> megaraid_sas here ...
>>>>>
>>>>> Let me ask this another way. SAN users expect that the LUN list a=
t the
>>>>> initiator side gets updated automatically after a SAN configurati=
on
>>>>> change. How should a SAN system communicate to a SCSI initiator t=
hat
>>>>> the LUN list has been changed ? Some FC SAN systems send a LIP af=
ter a
>>>>> configuration change to force the initiator to rescan LUNs.
>>>>
>>>> And thereby disrupting traffic on _ALL_ LUNs on the loop.
>>>> Really cool idea.
>>>> I know; the one vendor which does _not_ talk to us.
>>>>
>>>>> But how to inform the initiator about a LUN change for other SCSI
>>>>> protocols ?
>>>>> I'm not sure that it is even possible to report such a change via=
 sense
>>>>> data in case a SAN user first removes all LUNs and after that cha=
nge
>>>>> adds one or more LUNs.
>>>>>
>>>> The official way is indeed via UAs; most storage arrays (Hello, Ne=
tApp!)
>>>> provide a default LUN0 which is always visible.
>>>> Up to the point that some even refuse to add 'normal' disk LUNs to=
 LUN0.
>>>> Or have the ominous 'Well-known Address' LUN to handle these kind =
of
>>>> issues.
>>>>
>>>> Obviously, one needs to send commands to it to even _get_ an UA ba=
ck.
>>>>
>>>
>>> In SAM5 there is that QUERY ASYNCHRONOUS EVENT TMF. Could we send t=
hat
>>> periodically to lun0/well-knwon-lun if the transport supports it (i=
scsi
>>> will in
>>> http://tools.ietf.org/html/draft-ietf-storm-iscsi-sam-06#section-6)=
=2E
>>> Whatever daemon in userspace handles these other events, could send=
 it
>>> (we just need to add a interface) or we could add kernel code.
>>>
>> Oh, cool.
>> Polling a device to figure out if we should poll it :-)
>>
>> We'd be better off sending TEST UNIT READY to it; then we should
>> be getting UAs regardless on the SAM version in use on the target.
>>
>
> To handle the case where all devices are removed then new ones are
> added, we will not have kernel structs or /dev/sdXs to send TURs to t=
o
> find new ones. Are you thinking we would do something like have the
> kernel create temp structs to send TURs to LUN0/well-known-lun? Or, d=
o
> you think we would have something doing scsi scans (call
> scsi_scan_target or scsi_scan_host) every once in a while?
>
Well, not as such.

Most arrays (eg RDAC, EVA, or EMC) will present you with a separate=20
device (like the infamous 'Universal Xport' :-) which will be=20
present always, so it can be used for polling in case no targets are=20
present.
NetApp and the like are more tricky as they do _not_ present any=20
targets per default. So we'd need something here to talk to.
Some kind of 'virtual' LUN0 or somesuch.

Wouldn't this be a grand topic for LSF?

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
