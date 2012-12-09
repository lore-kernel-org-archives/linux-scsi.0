From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] scsi_transport_fc: Implement I_T nexus reset
Date: Sun, 09 Dec 2012 16:40:10 +0100
Message-ID: <50C4B0DA.9090904@suse.de>
References: <1354891880-16159-1-git-send-email-hare@suse.de> <50C23C5A.9090907@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2LINkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Dec 2012 08:40:47 -0500
In-Reply-To: <50C23C5A.9090907@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <jbottomley@parallels.com>

Am 12/07/2012 07:58 PM, schrieb Mike Christie:
> On 12/07/2012 08:51 AM, Hannes Reinecke wrote:
>> 'Bus reset' is not really applicable to FibreChannel, as
>> the concept of a bus doesn't apply. Hence all FC LLDD
>> simulate a 'bus reset' by sending a target reset to each
>> attached remote port, causing error handling to spill
>> over to unaffected devices.
>>
>> This patch implements a 'I_T nexus reset' handler,
>> which attempts to reset the I_T nexus to the remote
>> port. This way only the affected remote ports are
>> reset; other ports are left untouched.
>
> Is the I_T nexus reset we are doing in this patch supposed to be the
> same one defined in SAM? Was the I_T nexus reset TMF added to SAM at =
the
> same time the target reset one was removed? In SAM 4 and 5 there is n=
o
> target reset anymore is there?
>
> I think we should just kill the bus reset use from the FC drivers. Ad=
d a
> new I_T nexus reset callout to the scsi_host_template or to the
> scsi_transport_template. Then have scsi-ml call just either target re=
set
> eh callout or I_T nexus eh reset callout depending on what the target
> supports.
>
> To figure out what the target supports could we do a REPORTED SUPPORT=
ED
> TASK MANAGEMENT FUNCTION command. If the target supports that command
> and reports that the target supports the I_T nexus reset TMF then cal=
l
> that eh callback, else drop down to older target reset eh callback.
>
> It seems that if we do I_T nexus reset we do not need to also do a
> target reset do we?
>
Hmm. I would rather check the actual LLDDs if they do anything sensible=
=20
for target reset.
If not we sure can remove it.

>
>
>> @@ -3266,8 +3271,8 @@ fc_timeout_fail_rport_io(struct work_struct *w=
ork)
>>   	if (rport->port_state !=3D FC_PORTSTATE_BLOCKED)
>>   		return;
>>
>> -	rport->flags |=3D FC_RPORT_FAST_FAIL_TIMEDOUT;
>>   	fc_terminate_rport_io(rport);
>> +	rport->flags |=3D FC_RPORT_FAST_FAIL_TIMEDOUT;
>>   }
>>
>
> What was the reason for moving this? For the eh case in this patch wa=
s
> it causing IO to be failed with DID_TRANSPORT_FAILFAST when we wanted=
 it
> failed with some other error.
>
I wanted to ensure that fc_terminate_rport_io() was run when checking=20
=46C_RPORT_FAST_FAIL_TIMEOUT.
Without the move there is a race window between clearing the flag and
calling fc_terminate_rport_io(), which one might trigger by just=20
checking the flag.

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
