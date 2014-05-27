From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: iSCSI Expected Data Transfer Length for T10-PI
Date: Tue, 27 May 2014 20:12:18 +0300
Message-ID: <5384C772.80007@dev.mellanox.co.il>
References: <53820C9B.3090003@dev.mellanox.co.il> <8D3D17ACE214DC429325B2B98F3AE712076C662FE9@MX15A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <8D3D17ACE214DC429325B2B98F3AE712076C662FE9@MX15A.corp.emc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Black, David" <david.black@emc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, "james.smart@emulex.com" <james.smart@emulex.com>, Or Gerlitz <ogerlitz@mellanox.com>, "cbm@chadalapaka.com" <cbm@chadalapaka.com>, "julians@infinidat.com" <julians@infinidat.com>, "meth@il.ibm.com" <meth@il.ibm.com>, "blaine@ethernetalliance.org" <blaine@ethernetalliance.org>
List-Id: linux-scsi@vger.kernel.org

On 5/27/2014 2:58 PM, Black, David wrote:
> Hi Sagi,

Hey David,

>
>> RFC-7143 states:
>> "the Expected Data Transfer Length field contains the number of bytes of
>> data involved in this SCSI operation."
>> Since this field relates to *data bytes* I kept T10-PI implicit wrt this
>> field. The iSCSI target calculates the
>> total transfer length (data + protection) from the cdb transfer length
>> field and protect bits.
> That is wrong.  At the SCSI transport interface (both iSCSI and FCP are
> SCSI transports), the concept of "data bytes" includes SCSI protection
> information.
>
>> In FC, the fc_dl field was updated to relate to the total number of
>> transfer bytes and includes
>> data and protection bytes. virtio_scsi was added with a header PI
>> section (virtio_scsi_cmd_req_pi).
> That is the correct approach.
>
> At the SCSI transport interface (both FCP and iSCSI are SCSI transports),
> no distinction is made between user data and protection information.
> therefore, a transfer of 512 bytes of user data + 8 bytes of protection
> information is a 520 byte transfer for both protocols.
>
> The authority for this is SAM-5, or SAM-4 if one wants to refer to an
> approved standard.  Neither are open to interpretation on this point.

I see, thanks for clarifying this for me.

> All SCSI transports are supposed to behave the same way.  I hope this
> can be corrected quickly.

No problem, I'll fix it.

Sagi.
