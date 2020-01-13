Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9071C33CAD
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 10:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5D4420661
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 10:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgAMKjw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 05:39:52 -0500
Received: from smtp.infotech.no ([82.134.31.41]:54294 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgAMKjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 05:39:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7703E2041CB;
        Mon, 13 Jan 2020 11:39:49 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xSGg+thqD+xk; Mon, 13 Jan 2020 11:39:49 +0100 (CET)
Received: from [82.134.31.177] (unknown [82.134.31.177])
        by smtp.infotech.no (Postfix) with ESMTPA id 4C595204163;
        Mon, 13 Jan 2020 11:39:49 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v6 31/37] sg: add sg_iosubmit_v3 and sg_ioreceive_v3
 ioctls
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20200112235755.14197-1-dgilbert@interlog.com>
 <20200112235755.14197-32-dgilbert@interlog.com>
 <b17072fb-e8c3-6425-1876-5c2aa51a1641@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <f88fd35f-af9c-ccf8-6e96-21a90794409f@interlog.com>
Date:   Mon, 13 Jan 2020 11:39:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b17072fb-e8c3-6425-1876-5c2aa51a1641@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-13 1:50 a.m., Bart Van Assche wrote:
> On 2020-01-12 15:57, Douglas Gilbert wrote:
>> Add ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3). These ioctls
>> are meant to be (almost) drop-in replacements for the write()/read()
>> async version 3 interface. They only accept the version 3 interface.
>>
>> See the webpage at: http://sg.danny.cz/sg/sg_v40.html
>> specifically the table in the section titled: "13 SG interface
>> support changes".
>>
>> If sgv3 is a struct sg_io_hdr object, suitably configured, then
>>      res = write(sg_fd, &sgv3, sizeof(sgv3));
>> and
>>      res = ioctl(sg_fd, SG_IOSUBMIT_V3, &sgv3);
>> are equivalent. Dito for read() and ioctl(SG_IORECEIVE_V3).
> 
> The Linux kernel already supports several interfaces for submitting I/O
> requests asynchronously, e.g. libaio and io_uring. Do we really need yet
> another interface for submitting I/O requests? Has it been considered to
> add SG I/O support to one of the existing asynchronous I/O request
> interfaces?

Linux policy toward new ioctl()s has changed over the years. Where adding new
ones was once forbidden or strongly discouraged they are now preferred
over unconstrained methods such as adding new system calls or using write()
and read(). The SG_IOSUBMIT and SG_IORECEIVE ioctls have now been proposed
on several occasions by L. Torvalds as replacements for write() and read()
that together with the sg v3 interface (based on struct sg_io_hdr) predate
both libaio and io_uring. So I view these two new ioctls for the sg v3
interfaces as allowing the existing write() and read() interface to be first
deprecated, then removed with the these ioctls as drop in replacements. I view
this as more end-user friendly that just removing the write() and read() calls
as the bsg driver did (and thus removing its async interface and breaking code
that used it).

As my second stage patchset demonstrates, the superior user data handling
architecture *** of the SCSI command sets (as compared to say NVMe and ATA)
allows for major performance wins in areas such as copying and comparing
disk-to-disk operations that are not available in libaio and io_uring.

Douglas Gilbert


*** that being: do _not_ specify the details of how near end user data is
     handled in the command set, leave it to lower levels. So in the case
     of a disk to disk copy, the commands may come asynchronously from the
     user space but there is no need for the user data to leave the kernel
     level. Offloaded copies now being discussed throw the problem "over
     the fence" but ultimately some system needs to do the copy, and there
     is a good chance that is a Linux embedded system, especially if it has
     good support for copying.


