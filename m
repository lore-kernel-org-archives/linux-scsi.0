From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [RFC PATCH 2/2] iscsi_transport: Modidify recovery_tmo from sysfs
Date: Tue, 13 Jul 2010 14:20:19 +0530
Message-ID: <2FC85B10-5878-4CFC-9C96-59C519F91AB9@qlogic.com>
References: <20100706051844.GA15263@sles11sp1b1.qlogic.org> <4C399F6E.80501@cs.wisc.edu> <CA02FE64-B0A9-40BC-B902-70625181529F@qlogic.com> <4C3B5343.7010805@cs.wisc.edu>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:44657 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab0GMJEA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2010 05:04:00 -0400
In-Reply-To: <4C3B5343.7010805@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>, vikas.chaudhary@qlogic.com


On Jul 12, 2010, at 11:09 PM, Mike Christie wrote:

> On 07/12/2010 08:43 AM, Vikas Chaudhary wrote:
>>
>> On Jul 11, 2010, at 4:09 PM, Mike Christie wrote:
>>
>>> On 07/06/2010 12:18 AM, Vikas Chaudhary wrote:
>>>> Added support to modify session->recovery_tmo from sysfs
>>>>
>>>> Signed-off-by: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>>>> Signed-off-by: Ravi Anand<ravi.anand@qlogic.com>
>>>> ---
>>>> drivers/scsi/scsi_transport_iscsi.c | 37
>>>> ++++++++++++++++++++++++++++++----
>>>> 1 files changed, 32 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/scsi_transport_iscsi.c
>>>> b/drivers/scsi/scsi_transport_iscsi.c
>>>> index b9aec30..fe8704c 100644
>>>> --- a/drivers/scsi/scsi_transport_iscsi.c
>>>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>>>> @@ -1786,11 +1786,33 @@ show_priv_session_##field(struct device  
>>>> *dev, \
>>>> return sprintf(buf, format"\n", session->field); \
>>>> }
>>>>
>>>> -#define iscsi_priv_session_attr(field, format) \
>>>> +#define iscsi_priv_session_attr_store(field) \
>>>> +static ssize_t \
>>>> +store_priv_session_##field(struct device *dev, \
>>>> + struct device_attribute *attr, \
>>>> + const char *buf, size_t count) \
>>>> +{ \
>>>> + int val; \
>>>> + char *cp; \
>>>> + struct iscsi_cls_session *session = \
>>>> + iscsi_dev_to_session(dev->parent); \
>>>> + if ((session->state == ISCSI_SESSION_FREE) || \
>>>> + (session->state == ISCSI_SESSION_FAILED)) \
>>>> + return -EBUSY; \
>>>> + val = simple_strtoul(buf,&cp, 0); \
>>>> + if ((*cp&& (*cp != '\n')) || (val< 0)) \
>>>
>>>
>>> -1 is a ok value. It is like setting fast io fail to -"off".
>>
>> if we set "session->recovery_tmo" to off (-1) iscsi_transport never  
>> make
>> call to
>> "session_recovery_timedout" in that case iscsi_transport never set
>> session state to
>> "ISCSI_SESSION_FREE" and qla4xxx driver will never set DDB state to
>> "DDB_STATE_DEAD" so in this case driver will never do failover to
>> another path.
>> Do we need to add some thing more for failover to work in this case?
>
> You would never set that to off when using multipath.
>
> It is more for setups like root on iscsi with no multipath.

If we set recovery_tmo to off on setup with no multipath and device goes
offline then "iscsi_transport" will always return I/O's with status
"DID_IMM_RETRY" from function "iscsi_session_chkready" and I/O's will
never fail. Is it expected behavior? Or LDD / iscsi_tansport need to
implement another timer to fail I/O's and make session free. (Some thing
similar to fiber channel like dev_loss_tmo)

Just wanted to conform before I send next patch.
