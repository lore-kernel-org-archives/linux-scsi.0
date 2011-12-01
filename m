From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Don't memset buffer unless debug level is
 enabled
Date: Thu, 1 Dec 2011 13:43:17 -0500
Message-ID: <alpine.WNT.2.00.1112011341510.196@N5102REMCQXM4BS.qlogic.org>
References: <1322690639-20756-1-git-send-email-nab@linux-iscsi.org>  <4ED736EB.4090201@linutronix.de>  <1322731309.25753.30.camel@haakon2.linux-iscsi.org>  <alpine.WNT.2.00.1112011259150.1224@N5102REMCQXM4BS.qlogic.org> <1322762860.6920.47.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1322762860.6920.47.camel@dabdike>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Roland Dreier <roland@purestorage.com>, Joern Engel <joern@logfs.org>
List-Id: linux-scsi@vger.kernel.org



On Thu, 1 Dec 2011, James Bottomley wrote:

> On Thu, 2011-12-01 at 13:01 -0500, Chad Dupuis wrote:
>>
>> On Thu, 1 Dec 2011, Nicholas A. Bellinger wrote:
>>
>>> On Thu, 2011-12-01 at 09:12 +0100, Sebastian Andrzej Siewior wrote:
>>>> On 11/30/2011 11:03 PM, Nicholas A. Bellinger wrote:
>>>>> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
>>>>> index 07372de..cc32ec8 100644
>>>>> --- a/drivers/scsi/qla2xxx/qla_dbg.c
>>>>> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
>>>>> @@ -1676,11 +1676,11 @@ ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, char *msg, ...) {
>>>>>     uint32_t len;
>>>>>     struct pci_dev *pdev = NULL;
>>>>>
>>>>> -   memset(pbuf, 0, QL_DBG_BUF_LEN);
>>>>> -
>>>>>     va_start(ap, msg);
>>>>>
>>>>>     if ((level&  ql2xextended_error_logging) == level) {
>>>>> +           memset(pbuf, 0, QL_DBG_BUF_LEN);
>>>>> +
>>>>
>>>> 512bytes on the stack is brave.
>>>
>>> ...
>>>
>>>>  Anyway, why do you memset the whole
>>>> buffer? As far the string processing is concerned, setting the first
>>>> byte to zero is enough.
>>>>
>>>
>>> After converting qla_target.c in a few hundred locations to use
>>> qla_dbg() my wrists are still hurting, so you can imagine I'm not real
>>> eager to look into this code.  ;)
>>>
>>> Anyways, memset of the whole buffer is overkill.  Since sprintf() is
>>> being used for qla_dbg.c cases, even the 1 byte memset is unnecessary.
>>
>> I do want to note that there is a patch posted already that removes the
>> memset as well:
>> http://marc.info/?l=linux-scsi&m=132163664809856&w=2.
>
> So since that one came from you as part of a series, I was originally
> planning to merge it before you acked this one, which basically makes
> this one redundant (and conflicting), doesn't it?  Which patch did you
> want me to take, since I can't take both?

Apologies for that. Please take the first one that was part of the series.

>
> James
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
