From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Wed, 27 Mar 2013 08:37:00 +0100
Message-ID: <5152A19C.7010500@suse.de>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706Ab3C0HhE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Mar 2013 03:37:04 -0400
In-Reply-To: <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>

On 03/26/2013 07:00 PM, Chad Dupuis wrote:
>
>
> On Tue, 19 Feb 2013, Hannes Reinecke wrote:
>
>> This patchset updates the SCSI midlayer to use 64-bit LUNs
>> internally.
>> It eliminates the need to limit the number of LUNs artificially to
>> avoid aliasing issues; the SCSI midlayer can now accept any LUN
>> presented
>> to it.
>>
>> The LLDD specific settings for 'max_lun' have been left untouched;
>> it should be raised to '~0' if the HBA supports 64-bit LUNs
>> internally.
>> However, it is up to the driver maintainer to raise that limit.
>>
>> Hannes Reinecke (4):
>>  scsi_scan: Fixup scsilun_to_int()
>>  scsi: use 64-bit LUNs
>>  scsi: use 64-bit value for 'max_luns'
>>  scsi: Remove CONFIG_SCSI_MULTI_LUN
>>
>
> Hannes,
>
> As we've reviewed these patches internally, the one question that kee=
ps
> coming up is how do we handle hardware that cannot handle a 64-bit LU=
N
> address? For example, some of our older 2G/bps hardware can only
> handle a 16-bit LUN address.  Currently we convert the u32 value to u=
16.
 >  Do we do the same for the 64-bit conversion? Can a way be=20
devised to
> "opt-out" of receiving a 64-bit address in the first place (IIRC this
 > was an option in the v1 patch set)?
>
Yes, you can.

The idea here is to let 'max_luns' control this behaviour;=20
'max_luns' is the highest LUN number the host can support.
So for 16-bit LUN you would set max_luns to '0xFFFF', and for 32-bit
LUN addresses you would be setting max_luns to '0xFFFFFFFF'.

However, since you mention it, maybe I should add a 'scsilun_to_u32'
conversion routine, as this is requested in several places.

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
