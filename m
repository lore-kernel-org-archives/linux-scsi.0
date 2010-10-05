From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Drop srb reference before waiting for
 completion
Date: Tue, 5 Oct 2010 08:42:03 -0700
Message-ID: <C8D0955B.9DF5%giridhar.malavali@qlogic.com>
References: <4CA64E3D.7080207@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:50601 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0JEPmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2010 11:42:07 -0400
In-Reply-To: <4CA64E3D.7080207@cs.wisc.edu>
Content-Language: en
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, LinuxSCSI <linux-scsi@vger.kernel.org>




On 10/1/10 2:10 PM, "Mike Christie" <michaelc@cs.wisc.edu> wrote:

> On 10/01/2010 04:01 PM, Mike Christie wrote:
>> On 10/01/2010 07:18 AM, Hannes Reinecke wrote:
>>> 
>>> This patch fixes a regression introduced by commit
>>> 083a469db4ecf3b286a96b5b722c37fc1affe0be
>>> 
>>> qla2xxx_eh_wait_on_command() is waiting for an srb to
>>> complete, which will never happen as the routine took
>>> a reference to the srb previously and will only drop it
>>> after this function. So every command abort will fail.
>>> 
>>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>>> Cc: Andrew Vasquez<andrew.vasquez@qlogic.com>
>>> 
>>> diff --git a/drivers/scsi/qla2xxx/qla_os.c
>>> b/drivers/scsi/qla2xxx/qla_os.c
>>> index 1e4bff6..0af7549 100644
>>> --- a/drivers/scsi/qla2xxx/qla_os.c
>>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>>> @@ -883,6 +883,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>>> }
>>> spin_unlock_irqrestore(&ha->hardware_lock, flags);
>>> 
>>> + if (got_ref)
>>> + qla2x00_sp_compl(ha, sp);
>>> +
>> 
>> You can just get rid of got_ref, because if you just move the compl call
>> up a little more you know that in that code path we always get a ref.
>> And there is no need to hold the ref to where it is above. See attached
>> patch.
>> 
> 
> Sorry. Last patch had some other iscsi dev loss stuff in there. See this
> patch.

Mike,

The whole purpose of completing the command after the delay is to give
sufficient time for firmware to complete the original command and abort
command issued through interrupt. This makes sure that commands of concern
are no longer with firmware/hardware before completing it to upper layers. I
feel it is better to call qla2x00_sp_compl after waiting.

-- Giri




