From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Wed, 23 Oct 2013 11:25:16 +0200
Message-ID: <526795FC.6050303@suse.de>
References: <1372661455-122384-1-git-send-email-hare@suse.de>	 <1372661455-122384-8-git-send-email-hare@suse.de> <1381936290.1864.11.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51126 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab3JWHXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Oct 2013 03:23:20 -0400
In-Reply-To: <1381936290.1864.11.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

On 10/16/2013 09:22 PM, James Bottomley wrote:
> On Mon, 2013-07-01 at 08:50 +0200, Hannes Reinecke wrote:
>> This patchs adds an 'eh_deadline' sysfs attribute to the scsi
>> host which limits the overall runtime of the SCSI EH.
>> The 'eh_deadline' value is stored in the now obsolete field
>> 'resetting'.
>> When a command is failed the start time of the EH is stored
>> in 'last_reset'. If the overall runtime of the SCSI EH is longer
>> than last_reset + eh_deadline, the EH is short-circuited and
>> falls through to issue a host reset only.
>
> OK, so the specific problem with this one is that potentially it will
> spend all its time mucking about with aborts (which most often time o=
ut
> on non FC kit because of the issue problems) and then proceed to host
> reset, which mostly does nothing for failing devices.
>
> If you want to impose a deadline, then we need to spend only 50% of t=
he
> time attempting aborts and the rest of the time escalating the resets=
=2E
>
> [...]
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index f43de1e..84369f2 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -89,6 +89,18 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
>>   }
>>   EXPORT_SYMBOL_GPL(scsi_schedule_eh);
>>
>> +static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>> +{
>> +	if (!shost->last_reset || !shost->eh_deadline)
>> +		return 0;
>> +
>> +	if (time_before(jiffies,
>> +			shost->last_reset + shost->eh_deadline))
>> +		return 0;
>> +
>> +	return 1;
>> +}
>> +
>
> What about instead:
>
> static int scsi_host_eh_past_deadline(struct Scsi_Host *shost, int pe=
rcent) {
> 	if (!shost->last_reset || !shost->eh_deadline)
> 		return 0;
>
> 	if (time_before(jiffies,
> 			shost->last_reset + shost->eh_deadline * percent/100))
> 		return 0;
>
> 	return 1;
> }
>
> which allows us to have
>
> if (scsi_host_eh_past_deadline(shost, 50)) {
>
> in scsi_eh_abort_cmds()
>
> if (scsi_host_eh_past_deadline(shost, 66) {
>
> in scsi_eh_bus_device_reset()
>
> say 83 in target reset, and 100 in bus reset.
>
> Thus ensuring we at least get a crack at the reset chain?
>
Alternatively we could just escalate directly to LUN reset once the=20
first abort fails. That looks like a cleaner solution here.

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
