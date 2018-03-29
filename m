From: Jens Axboe <axboe@kernel.dk>
Subject: Re: General protection fault with use_blk_mq=1.
Date: Wed, 28 Mar 2018 21:22:47 -0600
Message-ID: <735c5d75-eacf-8ed2-ba9b-9ff4b0b5290d@kernel.dk>
References: <7d8a9c62-7d3e-879c-5b5b-30707f04553e@aehallh.com>
 <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>
 <b347896e-f770-8987-ad90-a595a5fa926a@aehallh.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b347896e-f770-8987-ad90-a595a5fa926a@aehallh.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Zephaniah E. Loss-Cutler-Hull" <warp@aehallh.com>, "Zephaniah E. Loss-Cutler-Hull" <warp-spam_kernel@aehallh.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Paolo Valente <paolo.valente@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On 3/28/18 9:13 PM, Zephaniah E. Loss-Cutler-Hull wrote:
> On 03/28/2018 06:02 PM, Jens Axboe wrote:
>> On 3/28/18 5:03 PM, Zephaniah E. Loss-Cutler-Hull wrote:
>>> I am not subscribed to any of the lists on the To list here, please CC
>>> me on any replies.
>>>
>>> I am encountering a fairly consistent crash anywhere from 15 minutes to
>>> 12 hours after boot with scsi_mod.use_blk_mq=1 dm_mod.use_blk_mq=1> 
>>> The crash looks like:
>>>
> 
>>>
>>> Looking through the code, I'd guess that this is dying inside
>>> blkg_rwstat_add, which calls percpu_counter_add_batch, which is what RIP
>>> is pointing at.
>>
>> Leaving the whole thing here for Paolo - it's crashing off insertion of
>> a request coming out of SG_IO. Don't think we've seen this BFQ failure
>> case before.
>>
>> You can mitigate this by switching the scsi-mq devices to mq-deadline
>> instead.
>>
> 
> I'm thinking that I should also be able to mitigate it by disabling
> CONFIG_DEBUG_BLK_CGROUP.
> 
> That should remove that entire chunk of code.
> 
> Of course, that won't help if this is actually a symptom of a bigger
> problem.

Yes, it's not a given that it will fully mask the issue at hand. But
turning off BFQ has a much higher chance of working for you.

This time actually CC'ing Paolo.


-- 
Jens Axboe
