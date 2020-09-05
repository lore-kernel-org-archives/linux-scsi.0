Return-Path: <SRS0=n0Yx=CO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F4EC433E2
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 20:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B6C520796
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Sep 2020 20:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgIEUhK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 16:37:10 -0400
Received: from smtp.infotech.no ([82.134.31.41]:59232 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEUhJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 5 Sep 2020 16:37:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E4260204190;
        Sat,  5 Sep 2020 22:37:06 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rkuurekMgpTJ; Sat,  5 Sep 2020 22:37:00 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 7564F20415B;
        Sat,  5 Sep 2020 22:36:58 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 1/4] scsi: sg: fix BLKSECTGET ioctl
To:     Bart Van Assche <bvanassche@acm.org>, Tom Yan <tom.ty89@gmail.com>,
        linux-scsi@vger.kernel.org
Cc:     stern@rowland.harvard.edu, James.Bottomley@SteelEye.com,
        akinobu.mita@gmail.com, hch@lst.de, jens.axboe@oracle.com
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com>
 <caf0aa91-3e54-f8bd-d818-587f4318716c@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <868195a0-94f2-f009-bfd4-f206f0da7db8@interlog.com>
Date:   Sat, 5 Sep 2020 16:36:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <caf0aa91-3e54-f8bd-d818-587f4318716c@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-05 3:32 p.m., Bart Van Assche wrote:
> On 2020-09-04 13:05, Tom Yan wrote:
>> It should give out the maximum number of sectors per request
>> instead of maximum number of bytes.
>>
>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>> ---
>>   drivers/scsi/sg.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index 20472aaaf630..e57831910228 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -922,6 +922,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>>   	int result, val, read_only;
>>   	Sg_request *srp;
>>   	unsigned long iflags;
>> +	unsigned int max_sectors;
>>   
>>   	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
>>   				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
>> @@ -1114,8 +1115,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>>   		sdp->sgdebug = (char) val;
>>   		return 0;
>>   	case BLKSECTGET:
>> -		return put_user(max_sectors_bytes(sdp->device->request_queue),
>> -				ip);
>> +		max_sectors = min_t(unsigned int, USHRT_MAX,
>> +				    queue_max_sectors(sdp->device->request_queue));
>> +		return put_user(max_sectors, ip);
>>   	case BLKTRACESETUP:
>>   		return blk_trace_setup(sdp->device->request_queue,
>>   				       sdp->disk->disk_name,
> 
> Is this perhaps a backwards-incompatible change to the kernel ABI, the
> kind of change Linus totally disagrees with?
> 
> Additionally, please Cc linux-api for patches that modify the kernel ABI.
>>From https://www.kernel.org/doc/man-pages/linux-api-ml.html: "The kernel
> source file Documentation/SubmitChecklist notes that all Linux kernel
> patches that change userspace interfaces should be CCed to
> linux-api@vger.kernel.org, so that the various parties who are interested
> in API changes are informed. For further information, see
> https://www.kernel.org/doc/man-pages/linux-api-ml.html"

Hmm,
The BLK* ioctl()s in the sg driver were an undocumented addition by others.
Plus it is not clear to me why a char device such as the sg driver should
be supporting BLK* ioctl(2)s. For example, how should an enclosure react to 
those ioctls or a WLUN?

If they are going to be supported for storage devices and /dev/sdb and
/dev/sg2 are the same device then if:
    blockdev --getmaxsect /dev/sg1

gives a different result to:
    blockdev --getmaxsect /dev/sdb

then I would consider that a bug. So fixing it is making the kernel ABI
more consistent :-)

Doug Gilbert



