From: David Buckley <dbuckley@oreilly.com>
Subject: Re: problem with discard granularity in sd
Date: Wed, 12 Apr 2017 16:58:22 -0700
Message-ID: <CA+Xd3XFoRY+SgowfzP69X1ZCSAPGTmec=qMxStoX=trths8kDg@mail.gmail.com>
References: <CA+Xd3XG1AN-ZTjn3SfZffrY=4vezSS8RrE88jG0QEsuyHC5k8A@mail.gmail.com>
 <yq14lxuv187.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:33555 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755833AbdDLX7F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2017 19:59:05 -0400
Received: by mail-lf0-f54.google.com with SMTP id h125so21987314lfe.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 16:59:04 -0700 (PDT)
In-Reply-To: <yq14lxuv187.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Hi Martin,

I have identified the key difference between the older working kernels
and newer ones; on older kernels the provisioning_mode is set to
'unmap', while on newer kernels it is 'writesame_16'.  This is due to
a change in sd_read_block_limits which prevents selection of
SD_LBP_UNMAP if the disk reports lbprz=1, which I'm assuming is the
desired behavior.

As I mentioned previously, one difference between working and failing
kernels is that discard_max_bytes is double the size on the latter.
To determine whether the NetApp incorrectly handles WRITE SAME with
UNMAP in general or if the increase in discard_max_bytes was
responsible, I swapped max_ws_blocks with max_unmap_blocks for WS16
requests in sd_config_discard in my test kernel.  Testing with this
change showed UNMAP requests working as expected, indicating that the
discard_max_bytes change is directly responsible for the failing
requests.

The underlying issue seems to be that (per VPD page) the maximum
supported unmap request is 8192 * 512 = 4194304 bytes, while the
maximum write same request is 0x4000 * 512 = 8388608 bytes.  It
appears both of these values are correct, and in the case where a WS
UNMAP request larger than 8192 blocks is received the UNMAP is ignored
and the result is effectively a WS ZERO request.

If I'm correct in my understanding, then it seems like the root cause
of the failures is that the current code assumes a disk will always
support WS UNMAP requests up to max_ws_blocks and does not account for
a case where max_unmap_blocks is smaller than max_ws_blocks.

I would think something like this could be a reasonable fix:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fe0f799..b0233c2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -643,6 +643,8 @@ static void sd_config_discard(struct scsi_disk
*sdkp, unsigned int mode)
        struct request_queue *q = sdkp->disk->queue;
        unsigned int logical_block_size = sdkp->device->sector_size;
        unsigned int max_blocks = 0;
+        unsigned int max_ws_unmap_blocks =
+                min_not_zero(sdkp->max_ws_blocks, sdkp->max_unmap_blocks);

        q->limits.discard_zeroes_data = 0;

@@ -679,7 +681,7 @@ static void sd_config_discard(struct scsi_disk
*sdkp, unsigned int mode)
                break;

        case SD_LBP_WS16:
-               max_blocks = min_not_zero(sdkp->max_ws_blocks,
+               max_blocks = min_not_zero(max_ws_unmap_blocks,
                                          (u32)SD_MAX_WS16_BLOCKS);
                q->limits.discard_zeroes_data = sdkp->lbprz;
                break;


Thanks yet again for all your help.

-David

On Tue, Apr 11, 2017 at 6:55 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> David,
>
>> I am wondering if part of the issue is that in my use case, UNMAP and
>> WRITE SAME zeros result in very different results.  With thin
>> provisioned LUNs, UNMAP requests result in the blocks being freed and
>> thus reduces the actual size of the LUN allocation on disk.  If WRITE
>> SAME requests are used to zero the blocks, they remain allocated and
>> thus the real size of the LUN grows to match the allocated size
>> (effectively thick-provisioning the LUN).
>
> The filer explicitly reported support for WRITE SAME(10/16) with UNMAP.
> It seems very odd that it would then completely ignore the UNMAP bit and
> do a regular WRITE SAME.
>
> Are you running latest firmware, btw.?
>
> In any case. The changes I mentioned are now queued up for 4.12. But
> it'll obviously take a while for those to trickle into the
> distributions...
>
> --
> Martin K. Petersen      Oracle Linux Engineering
