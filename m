From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH ver2 printk_ratelimit] bsg: Error print if device is not
 bidi capable when refusing a bidi command
Date: Tue, 20 Jan 2009 17:31:53 +0200
Message-ID: <4975EE69.1020404@panasas.com>
References: <4975DC00.2090005@panasas.com> <20090120141517.GM30821@kernel.dk> <4975E1EE.5070101@panasas.com> <20090120144608.GQ30821@kernel.dk> <4975E748.6040705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:4470 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754967AbZATPb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 10:31:58 -0500
In-Reply-To: <4975E748.6040705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Boaz Harrosh wrote:
> Jens Axboe wrote:
>> Thanks, that works. But why isn't the -EOPNOTSUPP error return (which the
>> app can see and print info about) enough? Do we really need to put this
>> in the kernel log?
>>
> 
> 
> But let me check I had problems with the return value.

OK I found my problem, blush:

-		ret = ioctl(fd, SG_IO, &sg);
+		ret = ioctl(fd, SG_IO, &sg) ? -errno : 0;

So if I do a print to stderr in the lowest-most library will
that be visible enough to an Admin. I have utils like
osd_format, mkfs.exofs, a FUSE filesystem ...
OK I can always redirect stderr to the dmsg log

Thanks
Boaz
