From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] ib_srp: 64bit LUN fixes
Date: Fri, 04 Jul 2014 15:01:40 +0200
Message-ID: <53B6A5B4.2040807@suse.de>
References: <1404474875-109997-1-git-send-email-hare@suse.de> <1404474875-109997-3-git-send-email-hare@suse.de> <53B69E97.4050901@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbaGDNBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 09:01:42 -0400
In-Reply-To: <53B69E97.4050901@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 07/04/2014 02:31 PM, Bart Van Assche wrote:
> On 07/04/14 13:54, Hannes Reinecke wrote:
>> SRP is capable of handling 64bit LUNs, so as we now have proper
>> support for it we can modify the driver to use the standard function=
s.
>>
>> Cc: Bart van Assche <bvanassche@acm.org>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/infiniband/ulp/srp/ib_srp.c   |  9 ++--
>>   drivers/infiniband/ulp/srpt/ib_srpt.c | 81 +----------------------=
------------
>>   2 files changed, 7 insertions(+), 83 deletions(-)
>
> The SRP initiator and target drivers are independent drivers so this
> should be two patches instead of one. Furthermore, I do not agree wit=
h
> introducing a call to int_to_scsilun() in the hot path of the initiat=
or
> driver since that causes a small but unnecessary additional overhead.
> Please keep in mind that there is no need to repeat the int_to_scsilu=
n()
> conversion for every I/O request. Hence my earlier proposal to cache =
the
> int_to_scsilun() result.
>
What I would like to do is to provide accessor functions for the=20
scsi lun; I've started this already for the older SCSI parallel=20
drivers (see my earlier patch).
Once everything is moved over to accessors it should be trivial to=20
move from the current scsilun_to_int representation in struct=20
scsi_device to the 'real' LUN.

Adding another field would be bit of an overkill IMO, seeing that we=20
can achieve the very same thing with a bit of code reshuffling.

James, Christoph, what's your opinion on using accessors?
Would solve this issue nicely, and we can also use proper functions=20
for HBAs only capable of handling 32bit LUNs.
Drawback is that we would need accessors also for this capable of=20
handling full 64bit LUNs, thus potentially incur some overhead there.

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
