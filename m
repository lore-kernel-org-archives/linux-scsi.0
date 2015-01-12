From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Allow retry on UNIT_ATTENTION media changed if not
 CDROM drive
Date: Mon, 12 Jan 2015 01:44:03 -0800
Message-ID: <20150112094403.GA2721@infradead.org>
References: <1420756433-11850-1-git-send-email-alcooperx@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbbALJoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 04:44:08 -0500
Content-Disposition: inline
In-Reply-To: <1420756433-11850-1-git-send-email-alcooperx@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Cooper <alcooperx@gmail.com>
Cc: JBottomley@parallels.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>

On Thu, Jan 08, 2015 at 05:33:53PM -0500, Al Cooper wrote:
> Previous commit dfcf7775815504d13a1d273073810058caf84b9d added
> a workaround for CD-ROM drives that were out of spec. This is causing
> scsi_check_sense() to return an error instead of NEEDS_RETRY on
> some USB thumb drives that return UNIT_ATTENTION Media Changed
> (ASC/ASCQ 28/00) after resuming from S3. This can cause mounted
> thumb drives to fail on the next access to the filesystem after
> S3 resume. This is masked on many systems because udev/dbus event
> handlers open the /dev/sd* device before filesystem access and the
> open always retries the UNIT_ATTENTION. The fix is to limit the
> original workaround to CDROM drives.

Even better would be quirk for the deice mishandlign the UAs, but I
suspect that's too late now..

