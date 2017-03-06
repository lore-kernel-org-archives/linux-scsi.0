From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] target/user: Fix possible overwrite of t_data_sg's
 lastiov[]
Date: Mon, 6 Mar 2017 10:09:56 -0800
Message-ID: <403e24b7-ecab-24e8-24cc-b9755b937c99@redhat.com>
References: <1488260828-28167-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <92ad7848-8d75-3344-eff6-b003599c55e9@redhat.com>
 <edee1773-74b5-d0e2-4b81-12cd75e55e52@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <edee1773-74b5-d0e2-4b81-12cd75e55e52@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: Xiubo Li <lixiubo@cmss.chinamobile.com>, nab@linux-iscsi.org
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, mchristi@redhat.com, Ilias Tsitsimpis <iliastsi@arrikto.com>
List-Id: linux-scsi@vger.kernel.org

On 03/05/2017 09:48 PM, Xiubo Li wrote:
>> Maybe fix this by exiting aasda() with iov pointing at the next unused
>> iov in the array?
> May it shouldn't be the aasda()'s duty to increment the iov ptr.

Sure, your call.

[snip text where we agree current solution allows data block sharing,
and new approach does not, and we're both ok with that]

>> Option B is we go with changing the implementation to always use a
>> separate data block for BIDI data (BIDI cmds are rare so no big deal),
>> but then also please look into simplifying code in aasda() and
>> tcmu_queue_cmd_ring that may now be overly complex.
>>
> Yes, there still has other bugs like this one,  i will try to simplify
> the code then.

Great :)

> For the BIDI data, still hasn't been used by the tcmu-runner. Is any
> other consumer using this?

Well with kernel APIs you just never know if somebody's using it but 
just not saying anything. But given this bug, how could they?

Regards -- Andy
