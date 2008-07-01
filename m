From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] cciss: read config to obtain max outstanding
 commands per controller
Date: Tue, 1 Jul 2008 14:23:08 -0700
Message-ID: <20080701142308.4958bc5f.akpm@linux-foundation.org>
References: <20080701210247.GA5095@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbYGAVXx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jul 2008 17:23:53 -0400
In-Reply-To: <20080701210247.GA5095@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 1 Jul 2008 16:02:47 -0500
Mike Miller <mike.miller@hp.com> wrote:

> This patch changes the way we determine the maximum number of outstanding
> commands for each controller. Most Smart Array controllers can support up
> to 1024 commands, the notable exceptions are the E200 and E200i.
> The next generation of controllers which were just added support a mode of
> operation called Zero Memory Raid (ZMR).  In this mode they only support 64 
> outstanding commands. In Full Function Raid (FFR) mode they support 1024. 
> We have been setting the queue depth by arbitrarily assigning some value for
> each controller. We needed a better way to set the queue depth to avoid lots 
> of annoying "fifo full" messages. So we made the driver a little smarter. We 
> now read the config table and subtract 4 from the returned value. The -4 is 
> to allow some room for ioctl calls which are not tracked the same way as io 
> commands are tracked.

What would be the effect of _not_ having this patch upon users of the
new hardware?

If the answer is "bad" then we should get this change into 2.6.26 and
2.6.25.x, because people will surely be running those kernels on the
new hardware.
