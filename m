From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/4] iscsi class: fix get_host_stats error handling
Date: Thu, 31 Jul 2014 17:32:21 -0500
Message-ID: <53DAC3F5.5070108@cs.wisc.edu>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu> <1405198311-64449-2-git-send-email-michaelc@cs.wisc.edu> <53D8EA2F.8040505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48201 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbaGaWcb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2014 18:32:31 -0400
In-Reply-To: <53D8EA2F.8040505@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On 07/30/2014 07:50 AM, Hannes Reinecke wrote:
> On 07/12/2014 10:51 PM, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> iscsi_get_host_stats was dropping the error code returned
>> by drivers like qla4xxx.
>>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> ---
>>   drivers/scsi/scsi_transport_iscsi.c |    4 ++++
>>   1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c
>> b/drivers/scsi/scsi_transport_iscsi.c
>> index b481e62..14bfa53 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -3467,6 +3467,10 @@ iscsi_get_host_stats(struct iscsi_transport
>> *transport, struct nlmsghdr *nlh)
>>           memset(buf, 0, host_stats_size);
>>
>>           err = transport->get_host_stats(shost, buf, host_stats_size);
>> +        if (err) {
>> +            kfree(skbhost_stats);
>> +            goto exit_host_stats;
>> +        }
>>
>>           actual_size = nlmsg_total_size(sizeof(*ev) + host_stats_size);
>>           skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
>>
> What happens with the skbhost_stats allocated earlier? Shouldn't it be
> freed here, too?
> 

You mean for this success path right. It is not freed here by the iscsi
code on purpose. For the code path here where we have successfully
called into the driver then a couple lines below we will do

iscsi_multicast_skb() -> nlmsg_multicast()

which will pass the skbhost_stats skb to the netlink layer. The
netlink/socket/skb code then frees it when it is done with it.

