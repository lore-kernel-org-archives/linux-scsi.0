From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH] pm8001: panics/lockups from asynchronous device removal.
Date: Wed, 18 Jan 2012 11:08:27 -0500
Message-ID: <D6D2776D-2AA8-461A-AA96-EB80B63CE625@xyratex.com>
References: <09A902B5-56B8-46CB-82B7-0DF81E7BBC12@xyratex.com> <CAA9_cmeNHj=MwuG8zzh9tpJ8M-80WNOn-cAOGF9o3d2EsvEFxQ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:42873 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757944Ab2ARQIi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2012 11:08:38 -0500
In-Reply-To: <CAA9_cmeNHj=MwuG8zzh9tpJ8M-80WNOn-cAOGF9o3d2EsvEFxQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, linux-scsi <linux-scsi@vger.kernel.org>, jack_wang Wang <jack_wang@usish.com>, crystal_yu <crystal_yu@usish.com>, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>, Greg KH <greg@kroah.com>

Thanks, Comments inline

On Jan 17, 2012, at 11:04 PM, Dan Williams wrote:

> On Tue, Jan 17, 2012 at 10:29 AM, Mark Salyzyn <mark_salyzyn@xyratex.com> wrote:
>> pm8001_query_task() and pm8001_abort_task() panic kernel when devices asynchronously disappear, a possible scenario since these functions are generally called when errors are mounting. Some of the panics are a direct result of a failure to NULL check some of the structure variables that are in certain states of teardown. One of the lockups was a direct result of returning an unexpected code to libsas' sas_scsi_find_task() function (creating a tight loop of an unexpected code 138 upstream to the scsi layer queue function).
>> 
>> Signed-off-by: mark_salyzyn@xyratex.com
>> Cc: jack_wang@usish.com
>> Cc: JBottomley@parallels.com
>> Cc: crystal_yu@usish.com
>> Cc: john_gong@usish.com
>> Cc: lindar_liu <lindar_liu@usish.com>
> 
> While your in the area of libsas error handling, mind weighing in on the pending libsas error handling rework backlog?
> 
> http://git.kernel.org/?p=linux/kernel/git/djbw/isci.git;a=shortlog;h=refs/heads/libsas-eh-reworks-v4

Xyratex has me focussed on 2.6.32 problems, I will look at these, but will be off the reservation (and with no Q/A testing resource to keep me honest) when doing so ;-}. Pure Code Inspection thus trumps experimentation ...

> ...more notes below:
> 
>> @@ -986,7 +997,8 @@ int pm8001_abort_task(struct sas_task *task)
>>        struct pm8001_device *pm8001_dev;
>>        struct pm8001_tmf_task tmf_task;
>>        int rc = TMF_RESP_FUNC_FAILED;
>> -       if (unlikely(!task || !task->lldd_task || !task->dev))
>> +       if (unlikely(!task || !task->lldd_task
>> +        || !task->dev || !task->dev->lldd_dev))
> 
> Hmm some of these are "never can happen" checks, so if you are indeed
> seeing !task or !task->dev something is very wrong in libsas. checking
> task->lldd_task and task->dev->lldd_dev should be all that is
> required.

OK, point taken, these issues surface with careless abandon in the 2.6.32-vintage kernels; and may, or may not, be present in 3.2.1-vintage kernels.

What this means is that maybe we should be submitting these stabilization/band-aid patches to the stable trees rather than to the top-of-tree?

I'd opt (not that I have the rights) for paranoia and adding these in at top-of-tree, as band-aids against panics (in libsas or pm8001). The checks are not costly IMHO (hopefully less-so as wrapped by unlikely()). My WAG is that this patch should be cancelled here, and placed into the 2.6.32-stable bucket ...

Looking forward to yours and Greg's comments to straighten me out.

> Also, I think it confuses the situation to return TMF_RESP_FUNC_FAILED
> in this case because the truth of the matter, as far as error handling
> is concerned, is that the lldd has forgotten the task, but you would
> need to check that the lldd does not subsequently call task->task_done
> in some other path.

In our private copy of the pm8001 driver, we have some debug code that performs tag tracking and memory-leak detection. In that code we ensure that task_done is not called for a tag that has already been released by another path. In 2.6.32-vintage kernels, when we hit these we try to remove them (those patches are in my back-log).

> Dan

Sincerely -- Mark Salyzyn

