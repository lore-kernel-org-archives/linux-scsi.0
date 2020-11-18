Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E36AC63697
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 09:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 463D82467A
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 09:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKRJPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 04:15:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:49228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgKRJPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Nov 2020 04:15:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A72EAAD45;
        Wed, 18 Nov 2020 09:15:20 +0000 (UTC)
Subject: Re: [PATCH V4 12/12] scsi: replace sdev->device_busy with sbitmap
To:     Ming Lei <ming.lei@redhat.com>
Cc:     kernel test robot <lkp@intel.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, Omar Sandoval <osandov@fb.com>,
        "Ewan D . Milne" <emilne@redhat.com>
References: <20201116090737.50989-13-ming.lei@redhat.com>
 <202011161944.U7XHrbsd-lkp@intel.com> <20201118023507.GA92339@T590>
 <99089c7f-422b-3a61-a9c5-677a1e629862@suse.de> <20201118074405.GA111852@T590>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <145b2f31-674c-567a-f901-dde3f6f16b3a@suse.de>
Date:   Wed, 18 Nov 2020 10:15:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201118074405.GA111852@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/20 8:44 AM, Ming Lei wrote:
> On Wed, Nov 18, 2020 at 08:15:47AM +0100, Hannes Reinecke wrote:
>> Hey Ming,
>>
>> On 11/18/20 3:35 AM, Ming Lei wrote:
>>> Hello Kashyap & Sumanesh,
>>>
>>> On Mon, Nov 16, 2020 at 07:49:31PM +0800, kernel test robot wrote:
>>>> Hi Ming,
>>>>
>>>> Thank you for the patch! Yet something to improve:
>>>>
>>>> [auto build test ERROR on block/for-next]
>>>> [also build test ERROR on mkp-scsi/for-next scsi/for-next v5.10-rc4 next-20201116]
>>>> [If your patch is applied to the wrong git tree, kindly drop us a note.
>>>> And when submitting patch, we suggest to use '--base' as documented in
>>>> https://git-scm.com/docs/git-format-patch]
>>>>
>>>> url:    https://github.com/0day-ci/linux/commits/Ming-Lei/blk-mq-scsi-tracking-device-queue-depth-via-sbitmap/20201116-171449
>>>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
>>>> config: powerpc64-randconfig-r026-20201116 (attached as .config)
>>>> compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project c044709b8fbea2a9a375e4173a6bd735f6866c0c)
>>>> reproduce (this is a W=1 build):
>>>>           wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>>>           chmod +x ~/bin/make.cross
>>>>           # install powerpc64 cross compiling tool for clang build
>>>>           # apt-get install binutils-powerpc64-linux-gnu
>>>>           # https://github.com/0day-ci/linux/commit/cc286ae987be50d7b8e152cc80a5ccaa8682e3ff
>>>>           git remote add linux-review https://github.com/0day-ci/linux
>>>>           git fetch --no-tags linux-review Ming-Lei/blk-mq-scsi-tracking-device-queue-depth-via-sbitmap/20201116-171449
>>>>           git checkout cc286ae987be50d7b8e152cc80a5ccaa8682e3ff
>>>>           # save the attached .config to linux build tree
>>>>           COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=powerpc64
>>>>
>>>> If you fix the issue, kindly add following tag as appropriate
>>>> Reported-by: kernel test robot <lkp@intel.com>
>>>>
>>>> All errors (new ones prefixed by >>):
>>>>
>>>>>> drivers/scsi/megaraid/megaraid_sas_fusion.c:365:41: error: no member named 'device_busy' in 'struct scsi_device'
>>>>              sdev_busy = atomic_read(&scmd->device->device_busy);
>>>
>>> This new reference to sdev->device_busy is added by recent shared host
>>> tag patch, and according to the comment, you may have planed to convert into
>>> one megaraid internal counter.
>>>
>>>           /* TBD - if sml remove device_busy in future, driver
>>>            * should track counter in internal structure.
>>>            */
>>>
>>> So can you post one patch? And I am happy to fold it into this series.
>>>
>> Seeing that we already have the accessor 'scsi_device_busy()' it's probably
>> easier to just use that and not fiddle with driver internals.
>> See the attached patch.
>>
>> Cheers,
>>
>> Hannes
>> -- 
>> Dr. Hannes Reinecke                Kernel Storage Architect
>> hare@suse.de                              +49 911 74053 688
>> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
>> HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
> 
>>  From d8fa5e61187dbe851b8da9c65a5df5ec5809f8ea Mon Sep 17 00:00:00 2001
>> From: Hannes Reinecke <hare@suse.de>
>> Date: Wed, 18 Nov 2020 08:08:41 +0100
>> Subject: [PATCH] megaraid_sas: use scsi_device_busy() instead of direct access
>>   to atomic counter
>>
>> It's always a bad style to access structure internals, especially if
>> there is an accessor for it. So convert to use scsi_device_busy()
>> intead of accessing the atomic counter directly.
>>
>> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
>> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index fd607287608e..272ff123bc6b 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> @@ -362,7 +362,7 @@ megasas_get_msix_index(struct megasas_instance *instance,
>>   	/* TBD - if sml remove device_busy in future, driver
>>   	 * should track counter in internal structure.
>>   	 */
>> -	sdev_busy = atomic_read(&scmd->device->device_busy);
>> +	sdev_busy = scsi_device_busy(scmd->device);
> 
> megasas_get_msix_index() is called in .queuecommand() path,
> scsi_device_busy() might take more cycles since it has to iterate over
> each sbitmap words, especially when the sbitmap depth is high.
> 
> I'd suggest Kashyap/Sumanesh to check if there is better way to
> deal with it. If not, scsi_device_busy() should be fine.
> 
I guess this whole codepath will become obsolete if and when support for 
polling queues / io_uring will be implemented for megaraid_sas.
This whole section deals with spreading the load over several hardware 
queues once the dedicated one is at risk of being congested.
But this is only required if someone want to reach high IOPS; so if we 
have poll/io_uring support there won't be a need for this anymore.
Or that's the theory, at least :-)

But the patch should be good enough for now to get your patchset in.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
