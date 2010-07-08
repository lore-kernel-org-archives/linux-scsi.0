From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi/i2o: restore ioctl changes
Date: Thu, 08 Jul 2010 14:59:18 +0200
Message-ID: <4C35CBA6.10203@kernel.dk>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <201007072218.24013.arnd@arndb.de> <4C359200.8070105@kernel.dk> <201007081457.03994.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58361 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999Ab0GHM7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2010 08:59:20 -0400
In-Reply-To: <201007081457.03994.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org

On 2010-07-08 14:57, Arnd Bergmann wrote:
> This restores the changes from "scsi/i2o_block: cleanup ioctl
> handling", which accidentally got reverted.
>     
> Origignal changelog:
>       This fixes the ioctl function of the i2o_block driver, which
>       has multiple problems:
>     
>       * The BLKI2OSRSTRAT and BLKI2OSWSTRAT commands always return
>         -ENOTTY on success, where they should return 0.
>       * Support for 32 bit compat is missing
>       * The driver should use the .ioctl function and because
>         .locked_ioctl is going away.
>     
>       The use of the big kernel lock remains for now, but gets
>       made explictit in the ioctl function.
>     
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Jens, this is the commit that went missing due to my broken rebase.
> Please either apply on top of you for-next branch or fold into
> "block: push down BKL into .locked_ioctl", which reverted the change.

Thanks, I just applied this one on top to avoid rebasing things.

-- 
Jens Axboe

