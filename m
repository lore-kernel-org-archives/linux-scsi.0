From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH 09/13] qla4xxx: Fixed device blocked issue on link
 up-down.
Date: Tue, 4 Oct 2011 10:07:59 -0700
Message-ID: <CAB08316.991A%vikas.chaudhary@qlogic.com>
References: <4E8A261F.9080803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:34795
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644Ab1JDRIe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Oct 2011 13:08:34 -0400
In-Reply-To: <4E8A261F.9080803@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>


On 03/10/11 2:16 PM, "Mike Christie" <michaelc@cs.wisc.edu> wrote:

>On 10/03/2011 04:01 PM, Mike Christie wrote:
>> On 10/03/2011 12:29 PM, vikas.chaudhary@qlogic.com wrote:
>>> From: Manish Rangankar <manish.rangankar@qlogic.com>
>>>
>>> Devices are getting blocked during continuous link up and down.
>>>Solution is,
>>> during relogin unblock the session before sending connection logged in
>>>event.
>>>
>>> JIRA Key: UPSISCSI-138
>>>
>>> Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
>>> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>>> ---
>>>  drivers/scsi/qla4xxx/ql4_init.c |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/qla4xxx/ql4_init.c
>>>b/drivers/scsi/qla4xxx/ql4_init.c
>>> index cc10bac..e07d99b 100644
>>> --- a/drivers/scsi/qla4xxx/ql4_init.c
>>> +++ b/drivers/scsi/qla4xxx/ql4_init.c
>>> @@ -900,6 +900,7 @@ int qla4xxx_process_ddb_changed(struct
>>>scsi_qla_host *ha, uint32_t fw_ddb_index,
>>>          switch (state) {
>>>          case DDB_DS_SESSION_ACTIVE:
>>>          case DDB_DS_DISCOVERY:
>>> +            iscsi_unblock_session(ddb_entry->sess);
>>
>> Shouldn't this alreadu get done when start_conn callback is called?
>>
>> Is the problem that start_conn is getting called when login is started
>> and not when we are actually logged in (when we get the logged in event
>> below)?
>>
>> The start_conn callback use looks wrong right now for qla4xxx.
>> user/initiator.c:setup_offload_login_phase() will call it when we are
>> only in_login. It should only be called when we are logged_in, because
>> it will unlbock the devices, update the iscsi session state and could
>> start IO before the driver is ready.
>>
>
>One clarification. Qla4xxx needs to do its setup in there but it should
>not call iscsi_conn_start until it is actually logged in.
>
>I think we want to do like the attached (patch not even compile tested).
>It is built over this patch and 10/13.
>

We are testing this patch we will update you once we are done with testing.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

