From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 2/3] libiscsi, iser: Adjust data_length to include
 protection information
Date: Wed, 13 Aug 2014 16:09:48 +0300
Message-ID: <53EB639C.3080307@dev.mellanox.co.il>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com> <1402477799-24610-3-git-send-email-sagig@mellanox.com> <53D4CFAB.3040804@gmail.com> <53E22300.3090907@dev.mellanox.co.il> <53E22CE6.9070202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <53E22CE6.9070202@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>, Sagi Grimberg <sagig@mellanox.com>, michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 8/6/2014 4:25 PM, Boaz Harrosh wrote:
> On 08/06/2014 03:43 PM, Sagi Grimberg wrote:
>> Hi Boaz,
>>
> <>
>>>
>>> I hate that you introduced this new transfer_length variable. It does
>>> not exist. In BIDI supporting driver there is out_len and in_len just
>>> as original code.
>>
>> Effectively, out_len and in_len are the same except for the bidi case.
>> Moreover, the hdr->data_length is exactly the command scsi data buffer
>> length, the bidi length is taken from scsi_in when we build the AHS for
>> bidi (rlen_ahdr->read_length).
>>
>> So to me it is correct and makes sense. But I'm don't feel so strong
>> about it...
>>
>> Mike what's your take on this?
>>
>
> I have a patch to clean all that, will send tomorrow.
>
> What I mean is that this is on the out-path only the in path is different.
> See the code this variable is only used in the if (== DMA_TO_DEVICE) case and
> should be local to that scope. This is my clean up
>

Hey Boaz,

So in the current flow, I still don't think it is wrong/buggy, the
transfer byte length related to scsi buffer length (In iscsi for sure 
but I think that for all transports it is the same).

But,
Since you have such a strong objection on this I'm also OK with changing
stuff... We can pass a buffer to scsi_transfer_length (although it has 
no meaning effectively) and we can keep in/out_len local variables and
print them along with total transfer.

Do you want me to send out a patch here (since I have some hardware to 
test it...) or are you still planning to send out something?

Cheers,
Sagi.
