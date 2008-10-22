From: Elias Oltmanns <eo@nebensachen.de>
Subject: Smart plugging of multiple devices connected to a single controller
Date: Wed, 22 Oct 2008 20:24:27 +0200
Message-ID: <87y70gpjxg.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:46029 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYJVSYl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2008 14:24:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Jens,

in an effort to avoid calling the ->request_fn() from hard irq context
in ide, a patch like the one attached below would seem convenient (not
even compile tested yet). However, before implementing this or, indeed,
in case you should outright reject this patch, I'd like to ask for your
opinion about a more general approach: Since ide, scsi and libata (once
it has moved out of scsi) have very similar issues with devices that
cannot process the request queue in parallel (typically because they are
connected to the same controller), would it be appropriate to deal with
that in the block layer directly? Currently, I'm mainly concerned with
the problem that devices connected to the same controller are served
without too much discrimination due to races in the (un)plug logic,
which is currently being dealt with more or less cleverly in scsi / ide.
Generally though, there might be other shared resources (like a tag map,
etc.) that could be maintained in a in a block layer structure similar to
struct Scsi_Host. All request queues belonging to such a group could be
added to a circular link list rooted at the structure containing the
shared resources, i.e. the unplug_timer and whatever you deem adequate
to be moved there.

What do you think about it?

Regards,

Elias
