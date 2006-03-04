From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: The SCSI transfer size limits in 2.6.15-rcx
Date: Sat, 4 Mar 2006 15:14:37 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0603041504320.4281@kai.makisara.local>
References: <Pine.LNX.4.63.0603041314540.4277@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:51369 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751862AbWCDNLZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 08:11:25 -0500
Received: from kai.makisara.local ([85.156.161.105])
          by fep02-app.kolumbus.fi with ESMTP
          id <20060304131122.NEYI14691.fep02-app.kolumbus.fi@kai.makisara.local>
          for <linux-scsi@vger.kernel.org>; Sat, 4 Mar 2006 15:11:22 +0200
In-Reply-To: <Pine.LNX.4.63.0603041314540.4277@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sat, 4 Mar 2006, Kai Makisara wrote:

...
> The next thing was to increase the queue maximum segment size to 128 kB by
> editing linux/include/blkdev.h (#define MAX_SEGMENT_SIZE (2 * 65536)). This
> enabled transfers up to 16383 kB. This is below the theoretical limit of 16384
> kB but in this case the limiting factor was the maximum block size of the
> drive.
> 
Don't try this at home (unless you know your hardware :-) A better way to 
increase the maximum segment size is to add a call to 
blk_queue_max_segment_size to slave_configure() for the HBA.

I continued experimentation with sg and scsi_debug. I changed in 
scsi_debug.c the following things:
- .sg_tablesize = SG_ALL
- .max_sectors = 0xFFFF
- .use_clustering = ENABLE_CLUSTERING
- added blk_queue_max_segment_size(sdp->request_queue, 256 * 1024) to
  scsi_debug_slave_configure

and in include/scsi/sg.h:
- #define SG_SCATTER_SZ (64 * 4096)

This enabled read size up to 32 MB - 512 B, as predicted. After this the 
test program fails with errno set to ENOMEM.

-- 
Kai
