From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v4 0/5] tcmu: Add Type of reconfig into netlink
Date: Fri, 30 Jun 2017 12:51:01 -0500
Message-ID: <59568F85.8010702@redhat.com>
References: <1496759332-35216-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1496988706.28997.40.camel@haakon3.risingtidesystems.com>
 <593DAFE8.80705@redhat.com> <593E3822.5030408@redhat.com>
 <1498807891.24896.48.camel@haakon3.risingtidesystems.com>
 <497e60b0-5ade-b266-af5b-e47a013369b9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbdF3RvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 13:51:03 -0400
In-Reply-To: <497e60b0-5ade-b266-af5b-e47a013369b9@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>

On 06/30/2017 11:58 AM, Mike Christie wrote:
> On 06/30/2017 02:31 AM, Nicholas A. Bellinger wrote:
>> Hey MNC,
>>
>> On Mon, 2017-06-12 at 01:43 -0500, Mike Christie wrote:
>>> On 06/11/2017 04:02 PM, Mike Christie wrote:
>>>> On 06/09/2017 01:11 AM, Nicholas A. Bellinger wrote:
>>>>> Hi Bryant & Co,
>>>>>
>>>>> On Tue, 2017-06-06 at 09:28 -0500, Bryant G. Ly wrote:
>>>>>> From: "Bryant G. Ly" <bgly@us.ibm.com>
>>>>>>
>>>>>> This patch consists of adding a netlink to allow for reconfiguration
>>>>>> of a device in tcmu.
>>>>>>
>>>>>> It also changes and adds some attributes that are reconfigurable:
>>>>>> write_cache, device size, and device path.
>>>>>>
>>>>>> V2 - Fixes kfree in tcmu: Make dev_config configurable
>>>>>> V3 - Fixes spelling error
>>>>>> V4 - change strcpy to strlcpy for tcmu_dev_path_store and move
>>>>>>      tcmu_reconfig_type into target_core_user.h
>>>>>>
>>>>>>
>>>>>> Bryant G. Ly (5):
>>>>>>   tcmu: Support emulate_write_cache
>>>>>>   tcmu: Add netlink for device reconfiguration
>>>>>>   tcmu: Make dev_size configurable via userspace
>>>>>>   tcmu: Make dev_config configurable
>>>>>>   tcmu: Add Type of reconfig into netlink
>>>>>>
>>>>>>  drivers/target/target_core_user.c     | 152 ++++++++++++++++++++++++++++++++--
>>>>>>  include/uapi/linux/target_core_user.h |   9 ++
>>>>>>  2 files changed, 155 insertions(+), 6 deletions(-)
>>>>>>
>>>>>
>>>>> AFAICT, it looks like all of the review comments have been addressed in
>>>>> -v4.
>>>>>
>>>>> Applied to target-pending/for-next, with MNC's (pseudo) Reviewed-by's
>>>>> added for #3-#5.
>>>>>
>>>>> Please let me know if anything else needs to be changed.
>>>>>
>>>>
>>>> The patches look ok. Thanks. Could you just merge the attached patch
>>>> into "[PATCH v4 5/5] tcmu: Add Type of reconfig into netlink" or into
>>>> the patchset after it? It just makes some of the names a little less
>>>> generic and only returns the reconfig attr for reconfig commands.
>>>>
>>>
>>> Actually Nick, do not merge the last patch. I have a lot more fixes/changes.
>>>
>>> Bryant, could you test and adapt your userspace patches for the attached
>>> patch build over Nicks for-next branch.
>>>
>>> Basically, the patch just has use pass the value being reconfigured with
>>> the netlink event. Along the way, it fixes a couple bugs.
>>>
>>> Nick, when we have tested the patch, then I can submit as a formal
>>> patchset, or you can fold into the existing patches or whatever you prefer.
>>>
>>
>> Looking at merging your -v4 patches series here next:
>>
>> [PATCH V4 00/10] target/tcmu: make tcmu netlink ops sync
>> http://www.spinics.net/lists/target-devel/msg15706.html
>>
>> Do you still want me to drop the patch from Bryant below as mentioned
>> earlier..?
> 
> Hey,
> 
> First, sorry for the mess of comments/patches in various threads.
> 
> No need to drop it. The first patch:

Oh wait. Just to make sure I understood you correctly. I meant you do
not need to drop any of Bryant's patches. But, the patches:

https://www.spinics.net/lists/target-devel/msg15593.html
https://www.spinics.net/lists/target-devel/msg15595.html

I sent in Bryant's thread "[PATCH v4 0/5] tcmu: Add Type of reconfig
into netlink" do not need to be applied. The patch "[PATCH 01/10] tcmu:
reconfigure netlink attr changes" in my patchset you referenced "[PATCH
V4 00/10] target/tcmu: make tcmu netlink ops sync" is the correct up to
date patch.


> 
> [PATCH 01/10] tcmu: reconfigure netlink attr changes
> 
> in the thread you referenced above just fixes the stuff that needed to
> be fixed.
> 
> 
>>
>> tcmu: Add Type of reconfig into netlink
>> https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git/commit/?h=for-next&id=28d44b983000754677155e46f6bdafc7b4d84213
>>
> 
