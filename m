From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] iscsi class: fix get_host_stats error handling
Date: Fri, 01 Aug 2014 15:31:46 +0200
Message-ID: <53DB96C2.1070701@suse.de>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu> <1405198311-64449-2-git-send-email-michaelc@cs.wisc.edu> <53D8EA2F.8040505@suse.de> <53DAC3F5.5070108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296AbaHANbs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2014 09:31:48 -0400
In-Reply-To: <53DAC3F5.5070108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On 08/01/2014 12:32 AM, Mike Christie wrote:
> On 07/30/2014 07:50 AM, Hannes Reinecke wrote:
>> On 07/12/2014 10:51 PM, michaelc@cs.wisc.edu wrote:
>>> From: Mike Christie <michaelc@cs.wisc.edu>
>>>
>>> iscsi_get_host_stats was dropping the error code returned
>>> by drivers like qla4xxx.
>>>
>>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>>> ---
>>>    drivers/scsi/scsi_transport_iscsi.c |    4 ++++
>>>    1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_transport_iscsi.c
>>> b/drivers/scsi/scsi_transport_iscsi.c
>>> index b481e62..14bfa53 100644
>>> --- a/drivers/scsi/scsi_transport_iscsi.c
>>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>>> @@ -3467,6 +3467,10 @@ iscsi_get_host_stats(struct iscsi_transport
>>> *transport, struct nlmsghdr *nlh)
>>>            memset(buf, 0, host_stats_size);
>>>
>>>            err =3D transport->get_host_stats(shost, buf, host_stats=
_size);
>>> +        if (err) {
>>> +            kfree(skbhost_stats);
>>> +            goto exit_host_stats;
>>> +        }
>>>
>>>            actual_size =3D nlmsg_total_size(sizeof(*ev) + host_stat=
s_size);
>>>            skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
>>>
>> What happens with the skbhost_stats allocated earlier? Shouldn't it =
be
>> freed here, too?
>>
>
> You mean for this success path right. It is not freed here by the isc=
si
> code on purpose. For the code path here where we have successfully
> called into the driver then a couple lines below we will do
>
> iscsi_multicast_skb() -> nlmsg_multicast()
>
> which will pass the skbhost_stats skb to the netlink layer. The
> netlink/socket/skb code then frees it when it is done with it.
>
No, I meant the failure path.

You do an alloc_skb above, then get_host_stats failed, and you exit=20
the function without freeing the skb.
Or do I miss something?


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
