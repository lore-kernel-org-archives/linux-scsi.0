From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [RFC][PATCH] limit state change to SDEV_BLOCK devices in	scsi_internal_device_unblock
Date: Mon, 27 Apr 2009 23:27:59 -0400
Message-ID: <49F677BF.9020106@redhat.com>
References: <49F5E6E5.20904@redhat.com> <1240862889.3387.37.camel@mulgrave.int.hansenpartnership.com> <49F64559.5020802@redhat.com> <20090428023132.GI1926@parisc-linux.org> <49F66F1F.2050803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49501 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbZD1D1q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2009 23:27:46 -0400
In-Reply-To: <49F66F1F.2050803@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, mchristi@redhat.com, mbarrow@redhat.com

Takahiro Yasui wrote:
> Matthew Wilcox wrote:
>> On Mon, Apr 27, 2009 at 07:52:57PM -0400, Takahiro Yasui wrote:
>>> James Bottomley wrote:
>>>>> +	if (sdev->sdev_state != SDEV_BLOCK)
>>>> This isn't quite correct.  There are two blocked states in the model
>>>> currently:  SDEV_BLOCK and SDEV_CREATED_BLOCK ... you'd need to check
>>>> for both of them
>>>>
>>>>> +		return 0;
>>>> Traditionally the return for an attempted invalid state transition is
>>>> -EINVAL.
>>>>
>>>> I suppose for lower down, if you check the state, now we know we go 
>>>>
>>>> SDEV_CREATED_BLOCK -> SDEV_CREATED
>>>>
>>>> or
>>>>
>>>> SDEV_BLOCK -> SDEV_RUNNING
>>>>
>>>> so there's no need for the dual scsi_device_set_state.
>>> Thank you for the comments. If I understand your comments correctly, 
>>> the state transition is better to be defined in scsi_device_set_state(),
>>> and both transitions, "SDEV_CREATED_BLOCK -> SDEV_CREATED" and
>>> "SDEV_BLOCK -> SDEV_RUNNING" need to be covered. I updated the patch
>>> so that the transition of "SDEV_OFFLINE -> SDEV_RUNNING" is prohibited.
>> I don't think that's what he meant.  I think he meant something more like:

I have one question about the order of comparisons. The original code
tries to change to SDEV_BLOCK first and retries to SDEV_CREATED.
If they are transformed just that order, I think that comparisons will
be as follows.

	if (sdev->sdev_state == SDEV_BLOCK)
		sdev->sdev_state = SDEV_RUNNING;
	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
		sdev->sdev_state = SDEV_CREATED;
	else
		return -EINVAL;

Is this wrong order?

Regards,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.

