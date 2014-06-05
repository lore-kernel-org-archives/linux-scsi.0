From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH v2] sg: add SG_FLAG_Q_AT_TAIL flag
Date: Thu, 05 Jun 2014 18:27:02 +0300
Message-ID: <53908C46.8080308@gmail.com>
References: <538F3416.5090306@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:52030 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaFEP1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 11:27:08 -0400
Received: by mail-yh0-f43.google.com with SMTP id v1so974317yhn.30
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jun 2014 08:27:07 -0700 (PDT)
In-Reply-To: <538F3416.5090306@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@parallels.com>

On 06/04/2014 05:58 PM, Douglas Gilbert wrote:
> When the SG_IO ioctl was copied into the block layer and
> later into the bsg driver, subtle differences emerged.
> 
> One difference is the way injected commands are queued through
> the block layer (i.e. this is not SCSI device queueing nor SATA
> NCQ). Summarizing:
>    - SG_IO in the block layer: blk_exec*(at_head=false)
>    - sg SG_IO: at_head=true
>    - bsg SG_IO: at_head=true
> 
> Some time ago Boaz Harrosh introduced a sg v4 flag called
> BSG_FLAG_Q_AT_TAIL to override the bsg driver default.
> This patch does the equivalent for the sg driver.
> 

Yep

> 
> ChangeLog:
>      Introduce SG_FLAG_Q_AT_TAIL flag to cause commands
>      to be injected into the block layer with
>      at_head=false.
> 
> Changes since v1:
>      Make guard condition (only take sg v3 interface or later
>      invocations) clearer.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> 

Douglas Hi

Please I'm just curious? up until now all application users
used "SG_FLAG_Q_AT_HEAD". Therefor I deduce that you guys
came across a new application that can make use of the new
SG_FLAG_Q_AT_TAIL facility.

What was the application's writer considerations for using
the old sg interface and not use the newer bsg interface
that already has this support. For me I can see 2 main areas
that I find bsg missing.

1. aio "scatter_gather" type io. 
   (ie multiple pointers multiple length buffers that are
    written / read from same linear range on device)
  [The async aspect of aio can be implemented via bsg
   with the write+read system calls]
2. mmap of direct device range to user vm memory

Which of these, or other, considerations where cardinal
in using of the old interface in new code?

(For me personally both above shortcomings are very
 much missed]

Thanks
Boaz

