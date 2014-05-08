From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/16] scsi_dh_alua: Use workqueue for RTPG
Date: Thu, 08 May 2014 09:04:50 +0200
Message-ID: <536B2C92.1040703@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de>	 <1391160600-19652-17-git-send-email-hare@suse.de> <1398808055.29991.15.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbaEHHEw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2014 03:04:52 -0400
In-Reply-To: <1398808055.29991.15.camel@ict-vth-stewarts01.ict.englab.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: James Bottomley <jbottomley@parallels.com>, "George, Martin" <Martin.George@netapp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/29/2014 11:47 PM, Stewart, Sean wrote:
> On Fri, 2014-01-31 at 10:30 +0100, Hannes Reinecke wrote:
>> @@ -797,37 +838,40 @@ static int alua_rtpg(struct scsi_device *sdev,=
 struct alua_port_group *pg)
>>   		off =3D 8 + (ucp[7] * 4);
>>   	}
>>
>> -	sdev_printk(KERN_INFO, sdev,
>> -		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
>> -		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
>> -		    pg->pref ? "preferred" : "non-preferred",
>> -		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
>> -		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
>> -		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
>> -		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
>> -		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
>> -		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
>> -		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
> Hannes,
>
> I was wondering why this was changed from an sdev_printk to a printk?=
 I
> can see the AAS of a TPG on a target, but with it this way I do not k=
now
> with respect to what logical unit it is.
>
>> +	printk(KERN_INFO "%s: target %s port group %02x state %c %s "
>> +	       "supports %c%c%c%c%c%c%c\n", ALUA_DH_NAME, pg->target_id_st=
r,
>> +	       pg->group_id, print_alua_state(pg->state),
>> +	       pg->pref ? "preferred" : "non-preferred",
>> +	       valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
>> +	       valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
>> +	       valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
>> +	       valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
>> +	       valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
>> +	       valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
>> +	       valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
>>
>>
>
Reasoning was the the 'target port' is actually independent on the=20
scsi device; there might be several scsi devices pointing to the=20
same target port. So using 'sdev_printk' here wouldn't be entirely=20
correct.

But you are right, we're losing the information about the LUN here.
So I'll be reverting that bit.

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
