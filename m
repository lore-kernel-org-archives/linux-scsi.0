From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET 0/3] pluto/fc - some fixes and cleanups
Date: Mon, 15 Oct 2007 19:20:53 +0200
Message-ID: <4713A175.9020408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:15478 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755968AbXJORVM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 13:21:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "David S. Miller" <davem@davemloft.net>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>linux-scsi <linux>
Cc: FUJITA Tomonori <tomof@acm.org>


I'm sending a small lift-up to the drivers/scsi/pluto.c and
drivers/fc4/fc.c pair, that where a bit stepped on lately.

Matthew this includes your patch, I just fixed up the patch
comment, since You had a good comment on the first patch
but sent a better second patch with no comment. (And my set
depends on yours so just to make sure.)

This is only compile tested, and from patch 3/3 below the
driver is in grate need of testers.

[patch 1/3] pluto/fc - Remove uses of the scsi_cmnd ->done
  This is Matthew's patch with right commit-log inline?

[patch 2/3] pluto/fc - Enable compilation for all ARCHs
  I'm not sure if the final verdict was yes on this one,
  but it's what I needed in order to compile this.

[patch 3/3] pluto/fc - fix INQUIRY still using !use_sg commands
  So this is broken and, can some body explain to me how this was
  checked, because it looks to me that it should surely crash
  terribly. pluto.c would send use_sg == 0 command on detection
  but fc.c was already converted.
  What this patch does is effectively reverts some of Tomo's
  !use_sg cleanup, but only for the INQUIRY command that is
  issued internally by pluto.c. (Sorry)

Happy testing
Boaz

