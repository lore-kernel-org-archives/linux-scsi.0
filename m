From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] scsi: zero per-cmd driver data before each I/O
Date: Tue, 21 Feb 2017 09:19:05 -0700
Message-ID: <d22be48c-51ca-ea12-6143-d1582eb6012f@kernel.dk>
References: <20170221090455.4633-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:33397 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752591AbdBUQTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2017 11:19:08 -0500
Received: by mail-it0-f51.google.com with SMTP id d9so34402420itc.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2017 08:19:07 -0800 (PST)
In-Reply-To: <20170221090455.4633-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: decui@microsoft.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On 02/21/2017 02:04 AM, Christoph Hellwig wrote:
> Without this drivers that don't clear the state themselves can see off
> effects.  For example Hyper-V VMs using the storvsc driver will often
> hang during boot due to uncleared Test Unit Ready failures.
> 
> Fixes: e9c787e6 ("scsi: allocate scsi_cmnd structures as part of struct request")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Tested-by: Dexuan Cui <decui@microsoft.com>
> ---
> 
> Changes since V1:
>  - use a single memset as suggested by Bart

That's much better. I'll queue this up for the next pull in this merge
window.

-- 
Jens Axboe
