From: David Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH 1/2] scsi:netlink support in scsi and fc transports for
 hbaspecific messages
Date: Thu, 31 Jul 2008 11:58:19 -0700
Message-ID: <C4B7595B.160C%david.somayajulu@qlogic.com>
References: <D1D4C3FF75F9354393DB8314DF43DEF2E7F511@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4759 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbYGaStx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 14:49:53 -0400
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7F511@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org
Cc: David Somayajulu <david.somayajulu@qlogic.com>




On 7/30/08 7:09 PM, "James.Smart@Emulex.Com" <James.Smart@Emulex.Com> wrote:
James,
Thanks for the feedback.
> David,
> 
> I've had a similar patch floating around now for months, but it was
> more for messages destined to the transport. It should easily extend
> to driver messages too.
> 
> My approach had the drivers registering with the scsi netlink module
> rather than using the host template (transports don't have a template,
> so its either reg/dereg or a static table). Comparing the two, yours
> seems cleaner, as the registration/deregistration creates some
> headaches. 
> I'm a little bothered that there's nothing that qualifies the driver
> to the shost before invoking the LLDD handler (e.g. driver has a
> signature, message header contains signature, and the two must match).
The idea was to let the Low Level Driver validate the message contents -
signature, etc. Since this is a private message to the LLD, I felt it was
appropriate that the signature or any other message validation scheme should
be left to the LLD. The scsi-ml should not be responsible for it.
> But, perhaps that's livable. One thing yours doesn't do is communicate
> netlink events to the consumers, so if they were tracking anything
> by pid, they could clean up. You could add this, but it would mean
> another template entry point.
I would appreciate if you can explain your comment a bit more, if my
reasoning below does not suffice. I have already provided a function
"fc_host_post_vendor_event_to_pid() [in scsi_transport_fc.c]", which enables
an LLD to post a message to a specific pid. This may be used by the LLD to
send response messages to the pid, for command messages sent by the pid. It
can also be used to post any event messages, provided the user process(pid)
has already informed the LLD to post event messages to it (in this case the
LLD can cache the pid value and use it to post event messages to it). I am
not sure why another template entry point is needed.
> 
> I've attached my patch for comparison, although it would need work to
> do what you are doing.  Anyone else with a preference on the approach ?
> 
> -- james s
> 
> 
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org
>> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of David
>> Somayajulu
>> Sent: Wednesday, July 30, 2008 5:54 PM
>> To: linux-scsi@vger.kernel.org
>> Cc: David Somayajulu; David Wagner
>> Subject: [PATCH 1/2] scsi:netlink support in scsi and fc
>> transports for hbaspecific messages
>> 
>> This patch adds support to the scsi transport layer for
>> passing hba specific netlink messages to a low level driver.
>> Also support is added to the fc transport, to enable an FC
>> hba driver to post netlink message to a specific user process.
>> 
>> Signed-off-by: David C Somayajulu <david.somayajulu@qlogic.com>
>> ---
>>  drivers/scsi/scsi_netlink.c      |   13 +++++++
>>  drivers/scsi/scsi_transport_fc.c |   72
>> ++++++++++++++++++++++++++++++++++++++
>>  include/scsi/scsi_host.h         |    6 +++
>>  include/scsi/scsi_netlink.h      |    3 +-
>>  include/scsi/scsi_transport_fc.h |    2 +
>>  5 files changed, 95 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
>> index ae7ed9a..3bc85c9 100644
>> --- a/drivers/scsi/scsi_netlink.c
>> +++ b/drivers/scsi/scsi_netlink.c
>> @@ -24,6 +24,7 @@
>>  #include <net/sock.h>
>>  #include <net/netlink.h>
>>  
>> +#include <scsi/scsi_host.h>
>>  #include <scsi/scsi_netlink.h>
>>  #include "scsi_priv.h"
>>  
>> @@ -47,6 +48,7 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
>> struct scsi_nl_hdr *hdr;
>> uint32_t rlen;
>> int err;
>> + struct Scsi_Host *shost;
>>  
>> while (skb->len >= NLMSG_SPACE(0)) {
>> err = 0;
>> @@ -89,6 +91,17 @@ scsi_nl_rcv_msg(struct sk_buff *skb)
>> /*
>> * We currently don't support anyone sending us
>> a message
>> */
>> +  if (hdr->msgtype == SCSI_NL_HOST_PRIVATE) {
>> +   shost = scsi_host_lookup(hdr->host_no);
>> +   if (!shost) {
>> +    printk(KERN_ERR "%s:
>> scsi_host_lookup failed "
>> +     "host no %u\n",
>> __FUNCTION__, hdr->host_no);
>> +   } else if (shost->hostt->netlink_rcv_msg) {
>> +    err = 
>> shost->hostt->netlink_rcv_msg(shost,
>> +     (void *)((char
>> *)hdr+sizeof(*hdr)),
>> +     hdr->msglen,
>> NETLINK_CREDS(skb)->pid);
>> +   }
>> +  }
>>  
>>  next_msg:
>> if ((err) || (nlh->nlmsg_flags & NLM_F_ACK))
>> diff --git a/drivers/scsi/scsi_transport_fc.c
>> b/drivers/scsi/scsi_transport_fc.c
>> index cb971f0..d1b38d9 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -627,6 +627,78 @@ EXPORT_SYMBOL(fc_host_post_vendor_event);
>>  
>>  
>>  
>> +/**
>> + * fc_host_post_vendor_event_to_pid - called to post a
>> vendor unique event
>> + *   on an fc_host to a specific process
>> + * @shost:  host the event occurred on
>> + * @event_number: fc event number obtained from
>> get_fc_event_number()
>> + * @data_len:  amount, in bytes, of vendor unique data
>> + * @data_buf:  pointer to vendor unique data
>> + * @vendor_id:          Vendor id
>> + * @pid:  proc id of the receiver
>> + *
>> + * Notes:
>> + * This routine assumes no locks are held on entry.
>> + */
>> +void
>> +fc_host_post_vendor_event_to_pid(struct Scsi_Host *shost,
>> u32 event_number,
>> +  u32 data_len, char * data_buf, u64 vendor_id,
>> uint32_t pid)
>> +{
>> + struct sk_buff *skb;
>> + struct nlmsghdr *nlh;
>> + struct fc_nl_event *event;
>> + u32 len, skblen;
>> + int err;
>> +
>> + if (!scsi_nl_sock) {
>> +  err = -ENOENT;
>> +  goto send_vendor_fail;
>> + }
>> +
>> + len = FC_NL_MSGALIGN(sizeof(*event) + data_len);
>> + skblen = NLMSG_SPACE(len);
>> +
>> + skb = alloc_skb(skblen, GFP_KERNEL);
>> + if (!skb) {
>> +  err = -ENOBUFS;
>> +  goto send_vendor_fail;
>> + }
>> +
>> + nlh = nlmsg_put(skb, 0, 0, SCSI_TRANSPORT_MSG,
>> +    skblen - sizeof(*nlh), 0);
>> + if (!nlh) {
>> +  err = -ENOBUFS;
>> +  goto send_vendor_fail_skb;
>> + }
>> + event = NLMSG_DATA(nlh);
>> +
>> + INIT_SCSI_NL_HDR(&event->snlh, SCSI_NL_TRANSPORT_FC,
>> +    FC_NL_ASYNC_EVENT, len);
>> + event->seconds = get_seconds();
>> + event->vendor_id = vendor_id;
>> + event->host_no = shost->host_no;
>> + event->event_datalen = data_len; /* bytes */
>> + event->event_num = event_number;
>> + event->event_code = FCH_EVT_VENDOR_UNIQUE;
>> + memcpy(&event->event_data, data_buf, data_len);
>> +
>> + err = nlmsg_unicast(scsi_nl_sock, skb, pid);
>> + if (err && (err != -ESRCH)) /* filter no recipient errors */
>> +  /* nlmsg_multicast already kfree_skb'd */
>> +  goto send_vendor_fail;
>> +
>> + return;
>> +
>> +send_vendor_fail_skb:
>> + kfree_skb(skb);
>> +send_vendor_fail:
>> + printk(KERN_WARNING
>> +  "%s: Dropped Event : host %d vendor_unique - err %d\n",
>> +  __FUNCTION__, shost->host_no, err);
>> + return;
>> +}
>> +EXPORT_SYMBOL(fc_host_post_vendor_event_to_pid);
>> +
>>  static __init int fc_transport_init(void)
>>  {
>> int error;
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 44a55d1..04afe93 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -485,6 +485,12 @@ struct scsi_host_template {
>> * module_init/module_exit.
>> */
>> struct list_head legacy_hosts;
>> + /*
>> +  * passes host specific to netlink messages received on
>> scsi_nl_sock
>> +  * to the LLD
>> +  */
>> + int (* netlink_rcv_msg)(struct Scsi_Host *, void
>> *payload, uint32_t len,
>> +    uint32_t pid);
>>  };
>>  
>>  /*
>> diff --git a/include/scsi/scsi_netlink.h b/include/scsi/scsi_netlink.h
>> index 8c1470c..b32596e 100644
>> --- a/include/scsi/scsi_netlink.h
>> +++ b/include/scsi/scsi_netlink.h
>> @@ -42,6 +42,7 @@ struct scsi_nl_hdr {
>> uint16_t magic;
>> uint16_t msgtype;
>> uint16_t msglen;
>> + uint16_t host_no;
>>  } __attribute__((aligned(sizeof(uint64_t))));
>>  
>>  /* scsi_nl_hdr->version value */
>> @@ -56,7 +57,7 @@ struct scsi_nl_hdr {
>>  #define SCSI_NL_MAX_TRANSPORTS   2
>>  
>>  /* scsi_nl_hdr->msgtype values are defined in each transport */
>> -
>> +#define SCSI_NL_HOST_PRIVATE   1
>>  
>>  /*
>>   * Vendor ID:
>> diff --git a/include/scsi/scsi_transport_fc.h
>> b/include/scsi/scsi_transport_fc.h
>> index 21018a4..217fdc9 100644
>> --- a/include/scsi/scsi_transport_fc.h
>> +++ b/include/scsi/scsi_transport_fc.h
>> @@ -747,6 +747,8 @@ void fc_host_post_event(struct Scsi_Host
>> *shost, u32 event_number,
>> enum fc_host_event_code event_code, u32 event_data);
>>  void fc_host_post_vendor_event(struct Scsi_Host *shost, u32
>> event_number,
>> u32 data_len, char * data_buf, u64 vendor_id);
>> +void fc_host_post_vendor_event_to_pid(struct Scsi_Host
>> *shost, u32 event_number,
>> +                u32 data_len, char * data_buf, u64
>> vendor_id, uint32_t pid);
>> /* Note: when specifying vendor_id to
>> fc_host_post_vendor_event()
>> *   be sure to read the Vendor Type and ID formatting
>> requirements
>> *   specified in scsi_netlink.h
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 

