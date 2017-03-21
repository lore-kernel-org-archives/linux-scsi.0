From: Tejun Heo <tj@kernel.org>
Subject: Re: support ranges TRIM for libata
Date: Tue, 21 Mar 2017 14:59:01 -0400
Message-ID: <20170321185901.GB3706@htj.duckdns.org>
References: <20170320204319.12628-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:35581 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933246AbdCUS7E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2017 14:59:04 -0400
Content-Disposition: inline
In-Reply-To: <20170320204319.12628-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: martin.petersen@oracle.com, axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

Hello,

On Mon, Mar 20, 2017 at 04:43:12PM -0400, Christoph Hellwig wrote:
> This series implements rangeѕ discard for ATA SSDs.  Compared to the
> initial NVMe support there are two things that complicate the ATA
> support:
> 
>  - ATA only suports 16-bit long ranges
>  - the whole mess of generating a SCSI command first and then
>    translating it to an ATA one.
> 
> This series adds support for limited range size to the block layer,
> and stops translating discard commands - instead we add a new
> Vendor Specific SCSI command that contains the TRIM payload when
> the device asks for it.

I do like the fact that this is a lot simpler than the previous
implementation but am not quite sure we want to deviate significantly
from what we do for other commands (command translation).  Is it
because fixing the existing implementation would involve invaisve
changes including memory allocations?

Thanks.

-- 
tejun
