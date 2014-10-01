From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: uas breakage when using scsi_mod.blk_mq=Y
Date: Wed, 01 Oct 2014 17:53:10 +0200
Message-ID: <542C2366.30700@redhat.com>
References: <542BB8A5.4000308@redhat.com> <20141001124543.GB14872@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbaJAPxi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 11:53:38 -0400
In-Reply-To: <20141001124543.GB14872@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>

Hi,

On 10/01/2014 02:45 PM, Christoph Hellwig wrote:
> On Wed, Oct 01, 2014 at 10:17:41AM +0200, Hans de Goede wrote:
>> The problematic part here, which I believe is caused by scsi_mod.blk_mq=Y,
>> is the tag number 33. uas.c does the following in slave_configure:
>>
>> 	scsi_activate_tcq(sdev, devinfo->qdepth - 2);
>>
>> Where qdepth is 32, so 30 gets passed in. uas.c stranslates scsi tags
>> to uas stream ids, which means it adds 2 (stream ids start at 1 not 0,
>> and 1 is reserved for untagged commands).
>>
>> So the tag 33 above, means that the scsi subsys has called uas.c with
>> a tagged command with a tag of 31, which should not happen when using
>> scsi_activate_tcq(sdev, 30).
>>
>> So should the uas.c code do something different with blk-mq to tell
>> it to only use tags 0-29, or is this a blk-mq bug ?
> 
> This is a mismatch between the (undocumented) existing behavior and
> what blk-mq implements.  In the old code unless you use host-shared
> maps you would never see a tag number greater than the queue depth
> when using block layer tags.  With blk-mq we also use host-wide maps,
> so you can easily see tag numbers bigger than the queue depth.
> 
> So far it seems uas is the only driver with this expectation.
> Given how it maps tags to a non-scsi concept it might be better to
> just use a separate bitmaps for the streams inside uas than reusing
> the tags.

So let me see if I understand this correctly, blk-mq will never queue
more then qdepth commands, but it will use higher tag numbers ?

If that is the case fixing this should be easy, uas already has
an array to map stream-ids to scsi cmnds so that when it gets a status
urb, it can find the scsi cmnd which belongs to that status urb. We
can just search for a free slot in that array.

> Is this mapping an implementation detail of the Linux uas
> driver or part of the spec?

The mapping is a Linux uas implementation detail, the spec is
silent on how to map things.

Regards,

Hans
