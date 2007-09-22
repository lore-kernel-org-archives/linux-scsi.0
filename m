From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/9] mpt fusion: error recovery improvements, and
	synchronizing internal commands
Date: Sat, 22 Sep 2007 10:38:39 -0500
Message-ID: <1190475519.3347.13.camel@localhost.localdomain>
References: <20070918015801.GA22729@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51082 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751034AbXIVPil (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Sep 2007 11:38:41 -0400
In-Reply-To: <20070918015801.GA22729@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-09-17 at 19:58 -0600, Eric Moore wrote:
> 1) mpt_fault_reset_work - new workthread to quickly handle a card that goes into FAULT state.  Previously handled by eh threads, requiring commands to timeout (SD_TIMEOUT) to recover a card.
> 2) mpt_SoftResetHandler - less expensive method to reset card, other known as MESSAGE_UNIT_RESET-MUR.  The MUR doesn't perform a start_of_day recovery as does mpt_HardResetHandler, hence its quicker recovery time.  Also with MUR, the firmware is not reloaded, and only single pci function will be reset, whereas mpt_HardResetHandler will reset both functions.  An example of dual function card is the U320 1030 chip.
> 3) rewrite of all internal generated functions that issue commands to firmware, porting them to be single threaded using the generic MPT_MGMT struct. Killing all the watchdog timer functions that were previously handling timeout of internal commands, thus addressing race conditions reported by several customers.
> 4) cleanup MPT_SCSI_HOST struct, deleting unused struct members
> 5) cleanup ioc_reset callback handlers, introducing wrappers for synronizing error recovery (mpt_set_taskmgmt_in_progress_flag, mpt_clear_taskmgmt_in_progress_flag), as the fusion firmware only handles one task management request at a time.
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

Well, I'll put this in this time.  However, it contains a whole slew of
pointless changes like this:


> -                       mdelay (10);
> +                       udelay (10000);

and

> -               mdelay(1);
> +               udelay(1000);

Which is going to excite the janitors into a frenzy of replace udelay
with mdelay patches, which I can well do without ... please don't do
this type of change unless there's some actual reason for it.

James


