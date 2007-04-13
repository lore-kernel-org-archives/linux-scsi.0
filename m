From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: iterate over devices individually for /proc/scsi/scsi
Date: Fri, 13 Apr 2007 08:25:07 +0100
Message-ID: <20070413072506.GA20326@infradead.org>
References: <461E89C8.7040507@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48356 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbXDMHZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Apr 2007 03:25:08 -0400
Content-Disposition: inline
In-Reply-To: <461E89C8.7040507@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Apr 12, 2007 at 03:34:32PM -0400, Jeff Mahoney wrote:
>  On systems with very large numbers (> 1600 or so) of SCSI devices,
>  cat /proc/scsi/scsi ends up failing with -ENOMEM. This is due to
>  the show routine simply iterating over all of the devices with
>  bus_for_each_dev(), and trying to dump all of them into the buffer
>  at the same time. On my test system (using scsi_debug with 4064 devices),
>  the output ends up being ~ 632k, far more than kmalloc will typically allow.
> 
>  This patch uses seq_file directly instead of single_file, and breaks up
>  the operations into the 4 seq_file callbacks. The result is that
>  each show() operation only dumps ~ 180 bytes into the buffer at a time
>  so we don't run out of memory.

The simpler answer is don't use /proc/scsi/scsi, but lsscsi instead.
It even has an option to provide /proc/scsi/scsi-style output.

This already came up the last time someone from SuSE sent a patch
to fix an "issue" like that.  That time at least the patch was
massageable into something sane, which this one isn't.  So please
take the advice this time and stop using /proc/scsi/scsi.

