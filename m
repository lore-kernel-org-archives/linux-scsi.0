From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] libiscsi: Fix iscsi_check_transport_timeouts possible
 infinite loop
Date: Sat, 4 Jul 2015 13:34:16 +0300
Message-ID: <5597B6A8.2080001@dev.mellanox.co.il>
References: <1435676153-27822-1-git-send-email-sagig@mellanox.com>
 <55959AD4.8050209@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33057 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbbGELYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2015 07:24:09 -0400
Received: by wiwl6 with SMTP id l6so261539553wiw.0
        for <linux-scsi@vger.kernel.org>; Sun, 05 Jul 2015 04:23:48 -0700 (PDT)
In-Reply-To: <55959AD4.8050209@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org
Cc: Sagi Grimberg <sagig@mellanox.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Ariel Nahum <arieln@mellanox.com>

On 7/2/2015 11:11 PM, Mike Christie wrote:
> On 6/30/15, 9:55 AM, Sagi Grimberg wrote:
>> From: Ariel Nahum <arieln@mellanox.com>
>>
>> Connection last_ping is not being updated when iscsi_send_nopout fails.
>> Not updating the last_ping will cause firing a timer to a past time
>> (last_ping + ping_tmo < current_time) which triggers an infinite loop of
>> iscsi_check_transport_timeouts() and hogs the cpu.
>>
>> Fix this issue by checking the return value of iscsi_send_nopout.
>> If it fails set the next_timeout to one second later.
>>
>> Signed-off-by: Ariel Nahum <arieln@mellanox.com>
>> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
>> ---
>>   drivers/scsi/libiscsi.c |   15 ++++++++++-----
>>   1 files changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 8053f24..1ea4213 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -979,13 +979,13 @@ static void iscsi_tmf_rsp(struct iscsi_conn
>> *conn, struct iscsi_hdr *hdr)
>>       wake_up(&conn->ehwait);
>>   }
>>
>> -static void iscsi_send_nopout(struct iscsi_conn *conn, struct
>> iscsi_nopin *rhdr)
>> +static int iscsi_send_nopout(struct iscsi_conn *conn, struct
>> iscsi_nopin *rhdr)
>>   {
>>           struct iscsi_nopout hdr;
>>       struct iscsi_task *task;
>>
>>       if (!rhdr && conn->ping_task)
>> -        return;
>> +        return -EINVAL;
>>
>>       memset(&hdr, 0, sizeof(struct iscsi_nopout));
>>       hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
>> @@ -999,13 +999,16 @@ static void iscsi_send_nopout(struct iscsi_conn
>> *conn, struct iscsi_nopin *rhdr)
>>           hdr.ttt = RESERVED_ITT;
>>
>>       task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr,
>> NULL, 0);
>> -    if (!task)
>> +    if (!task) {
>
>
> Are you hitting the failure case in the first chunk of the patch or the
> failure right above? If the latter, why is it failing?

__iscsi_conn_send_pdu() might fail in various places but Iin our case
session->tt->xmit_task() might fail in a couple of scenarios:

1. Hot device removal: In this case the iser transport receives an
async event of a device removal and alerts the iscsi layer of a
connection failure, but it may still race with an async timer driven
nopout sends.

2. Device catastrophic error recovery: In this scenario, the RDMA device
enters a catastrophic error condition and initiates a recovery sequence. 
At this period, the HW interfaces (packet send) are blocked
and immediately failed. This condition propagates to iscsi layer which
should take into account that xmit_task() might fail.

>
>>           iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
>> +        return -EIO;
>> +    }
>>       else if (!rhdr) {
>
> I think the coding style is wrong. It should be:
>
> if () {
>
> } else if {
>
> }

Yep, we'll fix that in v1.
