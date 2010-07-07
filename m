From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/6] block: push down BKL into .locked_ioctl
Date: Wed, 7 Jul 2010 15:28:30 +0200
Message-ID: <201007071528.30333.arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-2-git-send-email-arnd@arndb.de> <20100707015207.GE2950@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab0GGN2e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2010 09:28:34 -0400
In-Reply-To: <20100707015207.GE2950@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org

On Wednesday 07 July 2010, Christoph Hellwig wrote:
> 
> Looking at this again I don't like the foo_unlock_ioctl naming you're
> adding.  Just rename the existing ioctl routines to foo_locked_ioctl
> or move the lock_kernel/unlock_kernel calls into the function, which
> would be even better.

Good point. I followed the naming that I used for the file_operations
conversion, but since the block_device_operations don't use .unlocked_ioctl,
the naming you suggested is better.

I've now changed the sr.c and sd.c to use include the lock_kernel() call
directly in their ioctl functions. For the various floppy drivers, I'd
prefer using separate wrappers because these drivers are mostly legacy
and any subtle bugs introduced could probably go unnoticed for years.

As I mentioned to Sam, I'm more confident with the wrapper than rewriting
a longish function that I can't test.

I also now changed the i2o_block driver ioctl function but split that out
into a separate patch, since I found two more existing issues with
that function that I'm addressing at the same time.

	Arnd
