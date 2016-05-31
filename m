From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: fix sleep in invalid context
Date: Tue, 31 May 2016 17:12:21 -0400
Message-ID: <574DFE35.8000801@interlog.com>
References: <1464632347-8621-1-git-send-email-dgilbert@interlog.com>
 <1464634965.2287.73.camel@HansenPartnership.com>
 <20160530190916.GA366@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55976 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbcEaVM2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2016 17:12:28 -0400
In-Reply-To: <20160530190916.GA366@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bart.vanassche@sandisk.com

On 2016-05-30 03:09 PM, Christoph Hellwig wrote:
> On Mon, May 30, 2016 at 12:02:45PM -0700, James Bottomley wrote:
>> This might fix the immediate warning, but won't it demand huge
>> contiguous memory chunks in high lun configurations and thus fail
>> randomly?  Report luns is important to us because if that fails the
>> target won't attach.
>>
>> What about vmalloc'ing enough space at configuration time, when you do
>> have process context, and simply reusing the already allocated buffer
>> in this routine?  If you want to be clever, you could do a single
>> vmalloc for the biggest LUN size you have and reuse that buffer for
>> every report lun command with suitable locking ... we tend to fire off
>> report luns sequentially at start of day, so it's not like they have
>> huge performance or concurrency requirements.
>
> There is no need for the allocation at all.  Instead of the big
> array and a single call to fill_from_dev_buffer we can simply
> have a single scsi_lun structure on stack that gets reused for
> every lun and individual calls to sg_copy_from_buffer for each
> one instead of a single big one.

Christoph,
Interesting idea but a time waster due to:
    s/sg_copy_from_buffer/sg_pcopy_from_buffer/

Otherwise the start of the sgl is overwritten by each subsequent
call. The "p" variant has a trailing 'off_t skip' argument and
currently there are no helper functions in scsi_cmnd.h for the
"pcopy" variants. Also handling the resid is fiddly, not helped by
initializing it to zero rather than scsi_bufflen().

Doug Gilbert

