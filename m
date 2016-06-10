From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Fri, 10 Jun 2016 12:03:51 -0700
Message-ID: <12c6229a-3188-b88c-523f-99219ed60c05@sandisk.com>
References: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <3303bc98-ade7-62f0-71c7-11e7ef42b42d@sandisk.com>
 <20160524160047.Horde.M1bK0S-HUnY41nXa9ZoJ6w1@ltc.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160524160047.Horde.M1bK0S-HUnY41nXa9ZoJ6w1@ltc.linux.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: Bryant G Ly <bryantly@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, akpm@linux-foundation.org, kvalo@codeaurora.org, davem@davemloft.net, gregkh@linuxfoundation.org, mchehab@osg.samsung.com, jslaby@suse.com, joe@perches.com, bp@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bgly <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 05/24/2016 01:00 PM, Bryant G Ly wrote:
> Quoting Bart Van Assche <bart.vanassche@sandisk.com>:
>> On 05/24/2016 06:52 AM, Bryant G. Ly wrote:
>>> +static uint64_t ibmvscsis_unpack_lun(const uint8_t *lun, int len)
>>> +{
>>> +    uint64_t res = NO_SUCH_LUN;
>>> +    int addressing_method;
>>> +
>>> +    if (unlikely(len < 2)) {
>>> +        pr_err("Illegal LUN length %d, expected 2 bytes or more\n",
>>> +            len);
>>> +        goto out;
>>> +    }
>>> +
>>> +    switch (len) {
>>> +    case 8:
>>> +        if ((*((__be64 *)lun) & cpu_to_be64(0x0000FFFFFFFFFFFFLL))
>>> != 0)
>>> +            goto out_err;
>>> +        break;
>>> +    case 4:
>>> +        if (*((__be16 *)&lun[2]) != 0)
>>> +            goto out_err;
>>> +        break;
>>> +    case 6:
>>> +        if (*((__be32 *)&lun[2]) != 0)
>>> +            goto out_err;
>>> +        break;
>>> +    case 2:
>>> +        break;
>>> +    default:
>>> +        goto out_err;
>>> +    }
>>> +
>>> +    addressing_method = (*lun) >> 6; /* highest two bits of byte 0 */
>>> +    switch (addressing_method) {
>>> +    case SCSI_LUN_ADDR_METHOD_PERIPHERAL:
>>> +    case SCSI_LUN_ADDR_METHOD_FLAT:
>>> +    case SCSI_LUN_ADDR_METHOD_LUN:
>>> +        res = *(lun + 1) | (((*lun) & 0x3f) << 8);
>>> +        break;
>>> +
>>> +    case SCSI_LUN_ADDR_METHOD_EXTENDED_LUN:
>>> +    default:
>>> +        pr_err("Unimplemented LUN addressing method %u\n",
>>> +            addressing_method);
>>> +        break;
>>> +    }
>>> +
>>> +out:
>>> +    return res;
>>> +out_err:
>>> +    pr_err("Support for multi-level LUNs has not yet been
>>> implemented\n");
>>> +    goto out;
>>> +}
>>
>> In the above function there is nothing that is specific to the VIO
>> mechanism. Please consider to merge this function with
>> scsilun_to_int(), e.g. by introducing a new function that accepts a
>> SCSI LUN and the addressing method as arguments and by making
>> scsilun_to_int() call that function with
>> SCSI_LUN_ADDR_METHOD_PERIPHERAL as one of its arguments.
>>
>
> We are going to keep this here atm, until we can make sure canonical can
> pick up
> these changes, since we have a deliverable for a 3rd party vendor who is
> going to
> fully utilize this driver. Once they can pick it up in 4.4 kernel I will
> make the
> change you recommended / move the scsi_lun_addr_method addressed below.
> I will also
> address the changes that ib_srpt needs to utilize this new function too.

A much better approach would be to move this function into the SCSI core 
and to add a copy of that function to the backported driver that will be 
provided to Canonical.

Thanks,

Bart.
