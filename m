From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] updated: suspending I/Os to a device
Date: 19 Aug 2004 13:42:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092937373.2378.697.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C02D85A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53739 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266596AbUHSRm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 13:42:57 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02D85A@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-08-19 at 13:24, James.Smart@Emulex.Com wrote:
> The one con:
>   Depends on well-behaved LLDD's to not leave the device blocked indefinitely.
>   But this is no different from scsi_block_requests().

But that's the big one.

A significant number of driver bugs have come to us from incorrect timer
handling (not understanding the difference between del_timer and
del_timer_sync being the biggest).

The whole reason for moving the code up into the mid-layer is to avoid
the LLD handling the timer.

After the rewrite to simplify the code, the added overhead of having the
mid-layer (and transport classes) do the timer is scarcely sevently
lines longer than the one you currently attach.

James


