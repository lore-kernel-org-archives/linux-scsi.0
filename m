Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F01CC433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A6A220679
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfHLQ0X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 12:26:23 -0400
Received: from smtp.infotech.no ([82.134.31.41]:37813 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbfHLQ0W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 12:26:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 6CFA7204193;
        Mon, 12 Aug 2019 18:26:10 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bf3cFIcvnMFR; Mon, 12 Aug 2019 18:26:05 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id E9528204155;
        Mon, 12 Aug 2019 18:26:01 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 12/20] sg: sense buffer rework
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-13-dgilbert@interlog.com>
 <20190812143759.GE16127@infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <3f1fc340-cacb-c3b4-9d16-aea9682ffce6@interlog.com>
Date:   Mon, 12 Aug 2019 12:26:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812143759.GE16127@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-12 10:37 a.m., Christoph Hellwig wrote:
> On Wed, Aug 07, 2019 at 01:42:44PM +0200, Douglas Gilbert wrote:
>> The biggest single item in the sg_request object is the sense
>> buffer array which is SCSI_SENSE_BUFFERSIZE bytes long. That
>> constant started out at 18 bytes 20 years ago and is 96 bytes
>> now and might grow in the future. On the other hand the sense
>> buffer is only used by a small number of SCSI commands: those
>> that fail and those that want to return more information
>> other than a SCSI status of GOOD.
>>
>> Set up a small mempool called "sg_sense" that is only used as
>> required and released back to the mempool as soon as practical.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>
>> -
>>
>> The scsi_lib.c file in the scsi mid-level maintains two sense
>> buffer caches but declares them and their access functions
>> static so they can't use by the sg driver. Perhaps the fastest
>> option would be to transfer ownership of a (non-empty) sense
>> buffer from the scsi_lib.c file to the sg driver. This technique
>> may be useful to ther ULDs.
> 
> Why do you need your own storage for the sense buffer?  As soon
> as you have allocate the request/scsi_request you can use its
> sense buffer.  There shouldn't really be a need to keep a copy
> around.

Different lifetimes between the corresponding struct request and
struct scsi_request objects, on one hand, and a sg_request object on
the other. The former are freed in sg_rq_end_io() (i.e. the callback
from the mid-level) while sg_request object must keep them until the
user space completion (e.g. calls to read() or ioctl(SG_IORECEIVE)).

This comment was left by you (?) or Jens in sg_rq_end_io():
         /*
          * Free the mid-level resources apart from the bio (if any). The bio's
          * blk_rq_unmap_user() can be called later from user context.
          */

I certainly didn't put it there.

Anyway Hannes didn't like a kmalloc(GFP_ATOMIC) in the callback
and suggested a mempool. Given that the sense buffer is not
required very often, I felt pre-allocating space in a
sg_request object was wasteful.  Got any better ideas?

One idea I floated was making these guys in scsi_lib:
   static struct kmem_cache *scsi_sense_cache;
   static struct kmem_cache *scsi_sense_isadma_cache;

... accessible to ULDs (because the st driver may benefit also) to
transfer ownership and free it when it was no longer needed. This
would allow the sg driver to transfer ownership of the sense
buffer in scsi_request before that scsi_request was "freed". Then
the sg_request could free up that sense_buffer when it was no
longer needed. No-one responded to that idea.


Doug Gilbert
