From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] virtio_scsi: Implement 'native LUN' feature
Date: Fri, 26 Jan 2018 17:57:02 +0100
Message-ID: <f291bf3b-6f45-41e8-1680-ce248d3aa65f@linux.vnet.ibm.com>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
 <1513246316-56019-4-git-send-email-hare@suse.de>
 <8b0a2527-7fe1-1475-49e4-0f34c753baaf@linux.vnet.ibm.com>
 <c17da627-3228-07c3-fdde-628949ac3053@suse.de>
 <7ce4e7ad-3f01-87e3-8710-953e1708a50b@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44338 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751112AbeAZQ5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Jan 2018 11:57:09 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0QGsi3j063829
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:57:09 -0500
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fr452tg5a-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:57:08 -0500
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Fri, 26 Jan 2018 16:57:07 -0000
In-Reply-To: <7ce4e7ad-3f01-87e3-8710-953e1708a50b@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 01/26/2018 03:15 PM, Steffen Maier wrote:
> On 12/18/2017 08:48 AM, Hannes Reinecke wrote:
>> On 12/15/2017 07:17 PM, Steffen Maier wrote:
>>> On 12/14/2017 11:11 AM, Hannes Reinecke wrote:

>>>> @@ -524,10 +532,16 @@ static void virtio_scsi_init_hdr(struct
>>>> virtio_device *vdev,
>>>>                     int target_id,
>>>>                     struct scsi_cmnd *sc)
>>>>    {
>>>> -    cmd->lun[0] = 1;
>>>> -    cmd->lun[1] = target_id;
>>>> -    cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
>>>> -    cmd->lun[3] = sc->device->lun & 0xff;
>>>> +    if (virtio_has_feature(vdev, VIRTIO_SCSI_F_NATIVE_LUN)) {
>>>> +        u64 lun = sc->device->lun << 16;
>>>> +        lun |= ((u64)1 << 8) | (u64)target_id;
>>>> +        int_to_scsilun(lun, (struct scsi_lun *)&cmd->lun);
>>>> +    } else {
>>>> +        cmd->lun[0] = 1;
>>>> +        cmd->lun[1] = target_id;
>>>> +        cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
>>>> +        cmd->lun[3] = sc->device->lun & 0xff;
>>>> +    }
>>>
>>> Above 2 patterns seem to repeat. Have helper functions (similar to
>>> int_to_scsilun()) now that it's more than just 4 lines of filling in the
>>> virtio lun?
>>>
>> Yes, can do.
> 
> Meanwhile I think I realized why I had trouble understanding what the 
> code does. I guess, I expected a conversion with int_to_scsilun() first, 
> and then we would fill in the virtio-specific parts of magic-one and 
> target-ID.
> You do it just the other way round, which is OK.
> 
> Say we have a 4 level 64-bit LUN and represent it in hex using 
> placeholder hexdigits for the 4 levels like this:
> 0xL1L1L2L2L3L3L4L4
> Its decimal SCSI LUN representation (in hex) is:
> 0xL4L4L3L3L2L2L1L1
> Then you shift left by 16 bits (2 bytes, 1 LUN level), basically 
> dropping the 4th level:
> 0xL3L3L2L2L1L10000
> The steering header is 0x01TT where TT is the target ID.
> You bitwise or the virtio-specific parts into the SCSI LUN representation:
> 0xL3L3L2L2L1L101TT
> Finally you convert it into the 64-bit LUN representation:
> 0x01TTL1L1L2L2L3L3
>    0123456789abcdef [char array indexes]
      0 1 2 3 4 5 6 7
of course
> So we nicely have the virtio-specific parts at those array indexes where 
> the virtio-scsi protocol expects them.
> The usage of the other bytes is now of course different from the 
> original LUN encoding: It allows more than just peripheral and flat 
> space addressing for the 1st level; and it now also uses levels 2 and 3 
> which were previously always zero. The 3rd level really requires 64-bit 
> support in the kvm host kernel.
> This also means that a 4-level LUN is not supported unless we would 
> create a new virtio-scsi protocol version that would transfer the target 
> ID in a separate field not as part of the LUN field.
> 
> Did I get that right?
> 
> A similar explanation in a kernel doc comment for the helper conversion 
> function(s) might be helpful.

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
