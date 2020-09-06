Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB314C43461
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 05:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F47B2075A
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 05:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725497AbgIFFJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Sep 2020 01:09:13 -0400
Received: from smtp.infotech.no ([82.134.31.41]:60144 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgIFFJM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 6 Sep 2020 01:09:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 44F0B204194;
        Sun,  6 Sep 2020 07:09:10 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id r6uLZHpHoYwM; Sun,  6 Sep 2020 07:09:03 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 05182204153;
        Sun,  6 Sep 2020 07:09:01 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 1/4] scsi: sg: fix BLKSECTGET ioctl
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, akinobu.mita@gmail.com,
        hch@lst.de
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com>
 <caf0aa91-3e54-f8bd-d818-587f4318716c@acm.org>
 <868195a0-94f2-f009-bfd4-f206f0da7db8@interlog.com>
 <CAGnHSE=bhpL4REG5PXST6dF3gSWeewg1Eqr+sLw_9rtqL-ToFQ@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <1a0b8035-8072-6de0-5e4f-b6c2848d3a1c@interlog.com>
Date:   Sun, 6 Sep 2020 01:09:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGnHSE=bhpL4REG5PXST6dF3gSWeewg1Eqr+sLw_9rtqL-ToFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-05 9:19 p.m., Tom Yan wrote:
> It was my concern as well, that for this sort of
> "backwards-incompatible reason", it has been kept broken
> intentionally.

Bumping the sg driver version number is simple:

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20472aaaf630..c9763b85961f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -11,8 +11,8 @@
   *        Copyright (C) 1998 - 2014 Douglas Gilbert
   */

-static int sg_version_num = 30536;     /* 2 digits for each component */
-#define SG_VERSION_STR "3.5.36"
+static int sg_version_num = 30537;     /* 2 digits for each component */
+#define SG_VERSION_STR "3.5.37"

  /*
   *  D. P. Gilbert (dgilbert@interlog.com), notes:


And bumping the version number is appropriate for an interface
tweak/correction.

I'm rewriting the sg driver currently (12 months and counting) and am up
to version 11 of the _first_ half. So far I'm using a sg_version_num of
 > 40000 for the rewritten code. Please keep away from version numbers
40000 and above.

The rewritten driver is documented here:
     https://doug-gilbert.github.io/sg_v40.html

and its ioctls are listed in Table 8, including the BLK* ones. Perhaps you
could suggest some corrections. Obviously BLKSSZGET needs to be added
when your patches are accepted.

Doug Gilbert

> I am not sure if queue_max_sectors() or BLKSECTGET has ever been
> implemented in the block layer to give out the limit in bytes, but it
> certainly isn't the case anymore.
> 
> I am not in position to say whether it's "right" or "wrong" to
> implement BLKSECTGET/BLKSSZGET in the sg driver, but they is
> definitely useful in some cases (as long as the queue_* functions work
> for the given underlying device). Is it not okay if they don't
> ultimately work on *some* devices, even when they aren't named SG_*?
> 
> Perhaps we can consider having them removed as well (and implement
> them as e.g. SG_GET_MAX_SECTORS and SG_GET_LBS; but IMHO that only
> makes a point if they can be made to work on more than block devices).
> 
> 
> On Sun, 6 Sep 2020 at 04:37, Douglas Gilbert <dgilbert@interlog.com> wrote:
>>
>> On 2020-09-05 3:32 p.m., Bart Van Assche wrote:
>>> On 2020-09-04 13:05, Tom Yan wrote:
>>>> It should give out the maximum number of sectors per request
>>>> instead of maximum number of bytes.
>>>>
>>>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>>>> ---
>>>>    drivers/scsi/sg.c | 6 ++++--
>>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>>>> index 20472aaaf630..e57831910228 100644
>>>> --- a/drivers/scsi/sg.c
>>>> +++ b/drivers/scsi/sg.c
>>>> @@ -922,6 +922,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>>>>       int result, val, read_only;
>>>>       Sg_request *srp;
>>>>       unsigned long iflags;
>>>> +    unsigned int max_sectors;
>>>>
>>>>       SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
>>>>                                  "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
>>>> @@ -1114,8 +1115,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>>>>               sdp->sgdebug = (char) val;
>>>>               return 0;
>>>>       case BLKSECTGET:
>>>> -            return put_user(max_sectors_bytes(sdp->device->request_queue),
>>>> -                            ip);
>>>> +            max_sectors = min_t(unsigned int, USHRT_MAX,
>>>> +                                queue_max_sectors(sdp->device->request_queue));
>>>> +            return put_user(max_sectors, ip);
>>>>       case BLKTRACESETUP:
>>>>               return blk_trace_setup(sdp->device->request_queue,
>>>>                                      sdp->disk->disk_name,
>>>
>>> Is this perhaps a backwards-incompatible change to the kernel ABI, the
>>> kind of change Linus totally disagrees with?
>>>
>>> Additionally, please Cc linux-api for patches that modify the kernel ABI.
>>> >From https://www.kernel.org/doc/man-pages/linux-api-ml.html: "The kernel
>>> source file Documentation/SubmitChecklist notes that all Linux kernel
>>> patches that change userspace interfaces should be CCed to
>>> linux-api@vger.kernel.org, so that the various parties who are interested
>>> in API changes are informed. For further information, see
>>> https://www.kernel.org/doc/man-pages/linux-api-ml.html"
>>
>> Hmm,
>> The BLK* ioctl()s in the sg driver were an undocumented addition by others.
>> Plus it is not clear to me why a char device such as the sg driver should
>> be supporting BLK* ioctl(2)s. For example, how should an enclosure react to
>> those ioctls or a WLUN?
>>
>> If they are going to be supported for storage devices and /dev/sdb and
>> /dev/sg2 are the same device then if:
>>      blockdev --getmaxsect /dev/sg1
>>
>> gives a different result to:
>>      blockdev --getmaxsect /dev/sdb
>>
>> then I would consider that a bug. So fixing it is making the kernel ABI
>> more consistent :-)
> 
> That's exactly my point. They should work identically as the ones
> implemented in the block layer, because of their names.
> 
> With that said, sg_version needs to be bumped once the fix gets in, so
> that there's a way to differentiate the "different implementations" in
> userspace.
> 
>>
>> Doug Gilbert
>>
>>
>>
> 
> Regards,
> Tom
> 

