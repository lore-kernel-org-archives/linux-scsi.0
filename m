From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bio: return EINTR if copying to user space got
 interrupted
Date: Fri, 12 Feb 2016 08:17:58 -0700
Message-ID: <56BDF7A6.8070207@kernel.dk>
References: <1455266355-44676-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35207 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbcBLPSB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2016 10:18:01 -0500
Received: by mail-ob0-f175.google.com with SMTP id xk3so124535402obc.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Feb 2016 07:18:01 -0800 (PST)
In-Reply-To: <1455266355-44676-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, #@suse.de, v.3.11+@suse.de

On 02/12/2016 01:39 AM, Hannes Reinecke wrote:
> Commit 35dc248383bbab0a7203fca4d722875bc81ef091 introduced a check for
> current->mm to see if we have a user space context and only copies data
> if we do. Now if an IO gets interrupted by a signal data isn't copied
> into user space any more (as we don't have a user space context) but
> user space isn't notified about it.
>
> This patch modifies the behaviour to return -EINTR from bio_uncopy_user()
> to notify userland that a signal has interrupted the syscall, otherwise
> it could lead to a situation where the caller may get a buffer with
> no data returned.
>
> This can be reproduced by issuing SG_IO ioctl()s in one thread while
> constantly sending signals to it.

Good catch, fix looks good to me. Applied for 4.5.

-- 
Jens Axboe

