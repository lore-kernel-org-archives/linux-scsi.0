From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 12/14] qla2xxx: Correct fc_host port_state display.
Date: Mon, 12 Dec 2011 14:31:17 -0500
Message-ID: <alpine.WNT.2.00.1112121420220.6940@N5102REMCQXM4BS.qlogic.org>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>  <1321635742-16426-13-git-send-email-chad.dupuis@qlogic.com> <1323679848.1512.30.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:36792
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab1LLTjR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2011 14:39:17 -0500
In-Reply-To: <1323679848.1512.30.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Mon, 12 Dec 2011, James Bottomley wrote:

> On Fri, 2011-11-18 at 09:02 -0800, Chad Dupuis wrote:
>> From: Saurav Kashyap <saurav.kashyap@qlogic.com>
>>
>> Add more fine grain parsing of vha->loop_state to export a more accurate
>> fc_host port_state.
>>
>> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>
> Could you pass your patches through checkpatch.pl, please?  There are 17
> errors in here including spaces instead of tabs and a missing space
> before the opening bracket of an if clause.

Thanks James.  We will be sure to run checkpatch.pl in our future
submissions.

>
> I fixed it up this time.
>
> James
>
>
>>  drivers/scsi/qla2xxx/qla_attr.c |   27 +++++++++++++++++++++++----
>>  1 files changed, 23 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
>> index ac326c4..7acd442 100644
>> --- a/drivers/scsi/qla2xxx/qla_attr.c
>> +++ b/drivers/scsi/qla2xxx/qla_attr.c
>> @@ -1762,12 +1762,31 @@ qla2x00_get_host_port_state(struct Scsi_Host *shost)
>>      scsi_qla_host_t *vha = shost_priv(shost);
>>      struct scsi_qla_host *base_vha = pci_get_drvdata(vha->hw->pdev);
>>
>> -    if (!base_vha->flags.online)
>> +    if (!base_vha->flags.online) {
>>              fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
>> -    else if (atomic_read(&base_vha->loop_state) == LOOP_TIMEOUT)
>> -            fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
>> -    else
>> +            return;
>> +    }
>> +
>> +        switch (atomic_read(&base_vha->loop_state)) {
>> +        case LOOP_UPDATE:
>> +            fc_host_port_state(shost) = FC_PORTSTATE_DIAGNOSTICS;
>> +            break;
>> +        case LOOP_DOWN:
>> +            if(test_bit(LOOP_RESYNC_NEEDED, &base_vha->dpc_flags))
>> +                    fc_host_port_state(shost) = FC_PORTSTATE_DIAGNOSTICS;
>> +            else
>> +                    fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
>> +            break;
>> +        case LOOP_DEAD:
>> +            fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
>> +            break;
>> +        case LOOP_READY:
>>              fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
>> +            break;
>> +        default:
>> +            fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
>> +            break;
>> +    }
>>  }
>>
>>  static int
>
>
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

