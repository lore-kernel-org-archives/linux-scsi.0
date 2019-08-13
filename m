Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEB6C433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 23:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF37E20578
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 23:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfHMXq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 19:46:28 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43248 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfHMXq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 19:46:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id AB59720423A;
        Wed, 14 Aug 2019 01:46:25 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cdkcflaYPil8; Wed, 14 Aug 2019 01:46:18 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id BFDBB20414F;
        Wed, 14 Aug 2019 01:46:17 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 11/20] sg: replace rq array with lists
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        Matthew Wilcox <willy@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-12-dgilbert@interlog.com>
 <20190812143516.GD16127@infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <ebb817b4-463e-4e43-aca1-a35a2395cd22@interlog.com>
Date:   Tue, 13 Aug 2019 19:46:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812143516.GD16127@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-12 10:35 a.m., Christoph Hellwig wrote:
> On Wed, Aug 07, 2019 at 01:42:43PM +0200, Douglas Gilbert wrote:
>> Remove the fixed size array of 16 request elements per file
>> descriptor and replace with two linked lists per file descriptor.
>> One list is for active commands, the other list is a free list.
>> sg_request objects are now kept, available for re-use, until
>> their owning file descriptor is closed. The sg_request deletions
>> are now in sg_remove_sfp_usercontext(). Each active sg_request
>> has associated block request and scsi_request objects which are
>> released much earlier; their lifetime is the same as it was in
>> the v3 sg driver. The lifetime of the bio is also the same (but
>> is stretched in a later patch).
> 
> Willy would probably want you to use an xarray.

The new code spends little time scanning the active request
list so I see very little benefit from the O(1) random access
capability that I assume xarray would offer. It might be useful
if my code could access the active request list/array by pack_id.
That would require sparse array support, but even that is not
sufficient because the pack_id is user supplied and there has never
been a requirement in the sg driver that the pack_id be unique.
If they search responses by pack_id and its not unique then the
first found on the list is given back. That will typically be the
oldest.


BTW I have added a per file descriptor soft limit on the sum
of data-in and data-out buffers in use (sg_fd::sum_fd_dlens).
That is meant to trip up a malformed user space app (e.g. with
ioctl(SG_IOSUBMIT) in an infinite loop) from eating up all the
kernel's memory.

>> Add an enum for request state (sg_rq_state) and collect
>> various flags into bit maps: one for requests (SG_FRQ_*) and
>> the other for file descriptors (SG_FFD_*). They join a
>> per sg_device bit map (SG_FDEV_*) added in an earlier
>> patch.
>>
>> Prior to a new sg_request object being (re-)built, information
>> that will be placed in it uses a new struct sg_comm_wr_t
>> object.
>>
>> Since the above changes touch almost every function and low
>> level structures, this patch is big. With so many changes, the
>> diff utility that generates the patch sometimes loses track.
> 
> There seem to be a lot of rather unrelated changes here.  Also
> please don't use __put_user/__get_user for that same reason that
> drivers should not use __copy_to_user/__copy_from_user.
> 

They are all in one place ***:

static int
sg_ctl_scsi_id(struct scsi_device *sdev, struct sg_fd *sfp, void __user *p)
{
         struct sg_scsi_id __user *sg_idp = p;
         struct scsi_lun lun8b;

         SG_LOG(3, sfp, "%s:    SG_GET_SCSI_ID\n", __func__);
         if (unlikely(!access_ok(p, sizeof(struct sg_scsi_id))))
                 return -EFAULT;

         if (unlikely(SG_IS_DETACHING(sfp->parentdp)))
                 return -ENODEV;
         __put_user((int)sdev->host->host_no,
                    &sg_idp->host_no);
         __put_user((int)sdev->channel, &sg_idp->channel);
         __put_user((int)sdev->id, &sg_idp->scsi_id);
         __put_user((int)sdev->lun, &sg_idp->lun);
         __put_user((int)sdev->type, &sg_idp->scsi_type);
         __put_user((short)sdev->host->cmd_per_lun,
                    &sg_idp->h_cmd_per_lun);
         __put_user((short)sdev->queue_depth,
                    &sg_idp->d_queue_depth);
         int_to_scsilun(sdev->lun, &lun8b);
         __copy_to_user(sg_idp->scsi_lun, lun8b.scsi_lun, 8);
         return 0;
}

So its an optimization with a (pretty small) risk that the user
space process disappears after the access_ok() and before the
final __copy_to_user() completes.

Obviously a better way is to build the output in a kernel based object
and copy_to_user() the lot in one shot.

Doug Gilbert


*** which you would now if you had been applying the patches to the
     in kernel driver as you went. Reviewing a big patch set (in this
     case: on about 3000 lines, changing half of them and ending up with
     4500 lines) without reference to the effect they have on the
     existing code (by applying them) is 'impressive'. Like doing
     analysis on a chess match when you can't see the board but instead
     have a long list of moves from a starting position that you only
     have a fuzzy recollection of.

