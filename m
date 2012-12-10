From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Mon, 10 Dec 2012 11:18:25 +0100
Message-ID: <50C5B6F1.9080703@suse.de>
References: <1354891880-16159-1-git-send-email-hare@suse.de> <50C23C5A.9090907@cs.wisc.edu> <alpine.WNT.2.00.1212071451330.6432@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab2LJISb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Dec 2012 03:18:31 -0500
In-Reply-To: <alpine.WNT.2.00.1212071451330.6432@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <jbottomley@parallels.com>

Am 12/07/2012 08:58 PM, schrieb Chad Dupuis:
>
>
> On Fri, 7 Dec 2012, Mike Christie wrote:
>
>> On 12/07/2012 08:51 AM, Hannes Reinecke wrote:
>>> 'Bus reset' is not really applicable to FibreChannel, as
>>> the concept of a bus doesn't apply. Hence all FC LLDD
>>> simulate a 'bus reset' by sending a target reset to each
>>> attached remote port, causing error handling to spill
>>> over to unaffected devices.
>>>
>>> This patch implements a 'I_T nexus reset' handler,
>>> which attempts to reset the I_T nexus to the remote
>>> port. This way only the affected remote ports are
>>> reset; other ports are left untouched.
>>
>> Is the I_T nexus reset we are doing in this patch supposed to be the
>> same one defined in SAM? Was the I_T nexus reset TMF added to SAM at=
 the
>> same time the target reset one was removed? In SAM 4 and 5 there is =
no
>> target reset anymore is there?
>>
>> I think we should just kill the bus reset use from the FC drivers. A=
dd a
>> new I_T nexus reset callout to the scsi_host_template or to the
>> scsi_transport_template. Then have scsi-ml call just either target r=
eset
>> eh callout or I_T nexus eh reset callout depending on what the targe=
t
>> supports.
>>
>> To figure out what the target supports could we do a REPORTED SUPPOR=
TED
>> TASK MANAGEMENT FUNCTION command. If the target supports that comman=
d
>> and reports that the target supports the I_T nexus reset TMF then ca=
ll
>> that eh callback, else drop down to older target reset eh callback.
>>
>> It seems that if we do I_T nexus reset we do not need to also do a
>> target reset do we?
>>
>
> It would be good to have a specific I_T nexus reset callout in either=
 the
> host or transport so we can clean things up.
>
> Currently in the bus reset handler after we perform all the
> target resets we wait for all the associated DMA activity to clear up
> before we return from the bus_reset handler.  It would be good to hav=
e
> the same capability in a new I_T nexus reset handler as well.
>
Hmm. Thanks for bringing this up, as this is exactly one of the issues
I wanted to get feedback from the hardware guys.

When doing an I_T Nexus reset I'd need:
- Set the port type to BLOCKED
- Abort all outstanding I/O
- invoke dev_loss_tmo to reset the port
- Return status 'GOOD' if we could abort all I/O or FAILED if not

I'm not sure about the third item; I _think_ we might be okay by just=20
setting the port state to 'BLOCKED' and invoke the dev_loss_tmo
mechanism here. That should be resetting the port eventually.

However, the tricky bit is the second item.
fc_terminate_rport_io() is more often than not invoked asynchronously,
so the only thing I can be sure of is that we have _started_ to
abort all I/O, not neccessarily that all I/O is actually aborted.

So hooking up eh_target_reset there instead of fc_terminate_rport_io()
would not only clear up any outstanding I/O but also give me a nice
status back.

Hmm. That actually makes sense.
I think I'll be drafting out a new version of the patch.

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
