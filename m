From: Jens Axboe <axboe@kernel.dk>
Subject: Re: RFC: struct request cleanups
Date: Tue, 05 May 2015 13:41:40 -0600
Message-ID: <55491CF4.6060903@kernel.dk>
References: <1429303042-12078-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37325 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbbEETlr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 15:41:47 -0400
Received: by igblo3 with SMTP id lo3so108340464igb.0
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2015 12:41:43 -0700 (PDT)
In-Reply-To: <1429303042-12078-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org
Cc: linux-scsi@vger.kernel.org

On 04/17/2015 02:37 PM, Christoph Hellwig wrote:
> The first 5 patches move the magic IDE request types into the old IDE
> driver to keep the core block code clean of them.  Those are basically
> ready to merge, just like the 6th one which is a cleanup on it's own.
>
> The real RFC is the last one which allocates the block_pc specific
> data separately in the callers instead of bloating every struct
> request with it.  I always hated what we did, but with the upcoming
> split of nvme into transports and command sets we'll need a NVME
> equivalent of BLOCK_PC, and as NVMe was designed by crackmonkeys
> dreaming of an ATA controller the "command block" for NVME is even
> bigger than what we have to deal with in SCSI.
>
> Note that the old IDE driver doesn't compile with the last patch
> yet as there are major nightmares to sort out, and BLOCK_PC passthrough
> with dm-multipath doesn't work yet either.  If I get some general
> concensus on the approach I'll fix those of course.

These are nice improvements, it'd be great to get rid of embeeding the 
command block. I have applied 1-6 for 4.2.

-- 
Jens Axboe

