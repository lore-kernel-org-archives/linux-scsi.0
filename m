From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [Target_Core_Mod/PSCSI]: Use struct request to struct
 scsi_device->request_queue
Date: Thu, 04 Dec 2008 10:57:15 +0200
Message-ID: <49379B6B.8040906@panasas.com>
References: <1228265348.6229.130.camel@haakon2.linux-iscsi.org>	 <49366289.2010500@panasas.com> <1228340447.4153.53.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:4021 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751999AbYLDI5U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2008 03:57:20 -0500
In-Reply-To: <1228340447.4153.53.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Nicholas A. Bellinger wrote:
> On Wed, 2008-12-03 at 12:42 +0200, Boaz Harrosh wrote:
>> Nicholas A. Bellinger wrote:
>>> >From 1b14b5e1fc9a7074322b1015bb86eca2a8ef4560 Mon Sep 17 00:00:00 2001
>>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>> Date: Tue, 2 Dec 2008 16:30:51 -0800
>>> Subject: [PATCH] [Target_Core_Mod/PSCSI]: Use struct request to struct scsi_device->request_queue
>>>
>>> This patch begins to remove the usage of scsi_execute_async() from the PSCSI
>>> subsystem plugin for v3.0 generic target core.
>>>
>>> It uses blk_get_request() to allocate struct request in pscsi_blk_get_request()
>>> and used by all CDB types and both memory backing types.  struct request is then
>>> released with __blk_put_request() in the struct request->end_io() context in
>>> pscsi_req_done().
>>>
>>> Also, this patch adds a temporary EXPORT_SYMBOL_GPL() for
>>> scsi/drivers/scsi_lib.c:scsi_req_map_sg() (which will also be going away at
>>> some point).  At that point, the upstream struct scatterlist and/or
>>> struct page -> struct request mapping for usage with struct scsi_device->request_queue
>>> will be dropped into place in drivers/lio-core/target_core_pscsi.c:pscsi_map_task_SG()
>>>
>>> Tested on v2.6.28-rc7 32-bit x86 with virtual VMware TYPE_DISK on virtual MPT-Fusion
>>>
>>> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
>>> ---
>>>  drivers/lio-core/target_core_pscsi.c |  206 +++++++++++++++++++++++++---------
>>>  drivers/lio-core/target_core_pscsi.h |    5 +-
>>>  drivers/scsi/scsi_lib.c              |    6 +-
>>>  3 files changed, 161 insertions(+), 56 deletions(-)
>>>
>> This patch confuses me. Is this the same one posted few days ago minus the double-free
>> bug? It would be nice if you said that somewhere. Like [PATCH ver2] ...
>>
> 
> <nod> sorry for the confusion.
> 
>> But what confuses me are the previous two patches you sent that makes this patch not
>> compile. (Rename of se_task_t->task_buf => se_task_t->task_sg).
>>
> 
> Ok yes, this one is the 2nd rev of the original patch to remove the
> usage of scsi_execute_async().  The other two are for getting rid of the
> casts in between target_core_mod se_task_t scatterlist memory and
> mapping into target core subsystem plugins (PSCSI, IBLOCK, FILEIO)
> following your recommendations. 
> 
>> The previous two patches are not bisectable btw. Numbering a patchset could maybe help
>> a little, but will not help here, whichever way you order them they will only compile at
>> the very end (Well not even that, not with this one applied).
>>
> 
> <nod, point taken.
> 
>> Sorry but I'm unable to farther review any of the patches. Please re-post everything
>> as a patchset so I can understand whats going on.
>>
> 
> Ok, here commit diffs for the three patches that affect target_core_mod:
> 
> [PATCH] [Target_Core_Mod/PSCSI]: Use struct request to struct scsi_device->request_queue
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=1b14b5e1fc9a7074322b1015bb86eca2a8ef4560
> 
> [PATCH] [Target_Core_Mod]: Convert to se_task_t->task_sg usage in core and subsystem plugins
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=41e98940da5ffaf7e31fce8d1f706e3e0a679654
> 
> [PATCH] [Target_Core_Mod]: Update PSCSI, IBLOCK, FILEIO and RAMDISK for se_task_t->task_sg
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=e030ca2b9bbb81402b3ed669bb5e1d54fed0dff7
> 
> 
>> (And please give the URL of the git tree they are based on in each [PATCH 00/xx] mail.
>> Usually one states what the patchset is based on, eg. "based on scsi-misc as of ..."
>> but we all know where scsi-misc is)
>>
> 
> Ok, these patches are against the development lio-core-2.6.git (v3.0)
> tree (currently at v2.6.28-rc7) which tracks linux-2.6.git.  I will be
> sure to include this in futher postings.  
> 
> Also, I am posting the patches related to the generic target core
> (target_core_mod) and plugins that hook into Linux storage subsystems
> (PSCSI, IBLOCK, FILEIO) to start getting some feedback on the current
> work in the v3.0 development tree.  The code in
> lio-core-2.6.git/drivers/lio-core is the ConfigFS enabled generic target
> engine, subsystem plugins, and traditional LIO iSCSI target engine that
> will be submitted for upstream inclusion (most likely in that order) as
> work continues, sometime in the v2.6.29 timeframe.
> 
> Many thanks for your comments,
> 
> --nab
> 
> 

Thanks now I understand

OK So back to the patch.

As I said scsi_req_map_sg() will go away the same day scsi_execute_async
will. So this patch does only half a job. You Better past it into your
files, and don't patch scsi_lib.

And about the other two in related to this code. They are not enough,
you will have to go deep and wide. You only carry scatterlist pointers
everywhere and only the callers that have a kernel pointer do sg_init_one()
and call down the API with scatterlist pointer. So for example in this patch
the pscsi_map_task_non_SG is dropped. Specifically pt->pscsi_buf will be
pt->pscsi_sg and I'm sure that goes deep into plugins territory.

I hope I got this code right, I only looked at the patches you sent.
Next week I promise to look at the full source code, you stated above,
and review.

Boaz
