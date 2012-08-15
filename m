From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_tcp: add write permission to max_lun
Date: Wed, 15 Aug 2012 11:29:19 -0500
Message-ID: <502BCE5F.5060503@cs.wisc.edu>
References: <1345030205-23393-1-git-send-email-revers@redhat.com>  <DECF1C60-0ED2-4652-BD0D-5BA4F23F5D21@cs.wisc.edu> <1345047208.2976.71.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57406 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab2HOQ33 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 12:29:29 -0400
In-Reply-To: <1345047208.2976.71.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Rob Evers <revers@redhat.com>, linux-scsi@vger.kernel.org

On 08/15/2012 11:13 AM, James Bottomley wrote:
> On Wed, 2012-08-15 at 10:50 -0500, Michael Christie wrote:
>> On Aug 15, 2012, at 6:30 AM, Rob Evers <revers@redhat.com> wrote:
>>
>>> Add root write permission to iscsi_tcp max_lun parameter
>>>
>>> Signed-off-by: Rob Evers <revers@redhat.com>
>>> ---
>>> drivers/scsi/iscsi_tcp.c |    2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
>>> index 9220861..e8609a4 100644
>>> --- a/drivers/scsi/iscsi_tcp.c
>>> +++ b/drivers/scsi/iscsi_tcp.c
>>> @@ -56,7 +56,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht;
>>> static struct iscsi_transport iscsi_sw_tcp_transport;
>>>
>>> static unsigned int iscsi_max_lun = 512;
>>> -module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
>>> +module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO|S_IWUSR);
>>
>>
>>
>> Looks ok.
>>
>> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> Is there a reason not to raise the limit globally within iSCSI?  i.e. do

No reason that I know of now.

> what everyone else does (usually 0xFFFF for a single level lun hierarchy
> or ~0 for don't care), rather than have to have them twiddle a hard to
> find constant, since that seems to be the intent of the patch.
> 

Either is fine. Rob, do you want to do ~0 in your patch, because we do
not care. There is not a iscsi driver level side limitation.

