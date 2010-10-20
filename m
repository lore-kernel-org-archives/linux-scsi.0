From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH 3/6] bfa: remove os wrapper functions and macros
Date: Wed, 20 Oct 2010 16:04:09 -0700
Message-ID: <4CBF7569.90708@cisco.com>
References: <1287447149-28678-1-git-send-email-huangj@brocade.com> <4CBF09DF.8000308@redhat.com> <4CBF6A38.7060502@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:53003 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0JTXEZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2010 19:04:25 -0400
In-Reply-To: <4CBF6A38.7060502@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Rob Evers <revers@redhat.com>, Jing Huang <huangj@brocade.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On 10/20/10 3:16 PM, Mike Christie wrote:
> On 10/20/2010 10:25 AM, Rob Evers wrote:
>> Is scsi_for_each_sg() use pretty standard for mass storage drivers these
>> days?
> 
> Yes, the driver should be using it.
> 
>>
>> Is the byte swapping required if the more traditional sg implementation
>> is used?
>>
>>>
>>> #ifndef __BIGENDIAN
>>> -#define bfa_os_hton3b(_x) bfa_swap_3b(_x)
>>> +#define bfa_os_hton3b(_x) bfa_swap_3b(_x)
>>
>> Should bfa_os_hton3b and related functionality be relocated
>> appropriately and implemented in common form to the other common byte
>> swapping code?
>>
> 
> Yes. I think intel was working on that for fcoe. Someone should dig up the patches and finish pushing.

It's in <scsi/fc_frame.h> as hton24() / ntoh24().  It's written in
an endian-independent way.   I don't know of patches to move them to
a better place.

	Joe
