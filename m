From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] scsi error: add target reset eh handler
Date: Fri, 21 Dec 2007 15:36:14 -0600
Message-ID: <1198272974.3130.70.camel@localhost.localdomain>
References: <1198037469664-git-send-email-michaelc@cs.wisc.edu>
	 <1198037477766-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [76.243.235.52] ([76.243.235.52]:38861 "EHLO
	accolon.hansenpartnership.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbXLUVg0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2007 16:36:26 -0500
In-Reply-To: <1198037477766-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org


On Tue, 2007-12-18 at 22:11 -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> Drivers like qla4xxx and bnx2i (and it looks like some fcp drivers too),
> want to be able to send a lun reset in the eh device handler and then a
> target reset in some other handler. The old linux-iscsi driver, which did
> the host per session like open-iscsi did the target reset in the host reset,
> because the scsi command accounting that scsi_error.c does worked out
> nicely for software iscsi, but does not work for hardware iscsi well.
> 
> This patch adds a eh_target_reset_handler any driver can use to send
> a target reset.
> 
> The next patch will hook qla4xxx into it, and patches for iscsi_tcp/iser
> and bnx2i will follow later when bnx2i is closer to getting merged.

We sort of have a mapping problem here.  In the old ways of the error
handler, since it was based on SPI and SCSI-2, when it said "device
reset" what it actually meant was target reset, since that was the only
message the SPI bus could send.  It was only in the later SCSI-3
standard that a LUN reset came along.  So, most resent implementations
(even FC ones) send a target reset for this function.

So ... where I'm going is that I'm not averse to adding a target reset
(it has been suggested before), but then we'll have to clean up a lot of
other drivers.  Alternatively, you could just plumb target reset in to
the qla2xxx where device reset now is.

What do people think?

James


