From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 29 Sep 2004 15:50:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096487461.2028.134.camel@mulgrave>
References: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:13193 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266892AbUI2TvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 15:51:04 -0400
In-Reply-To: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On Wed, 2004-09-29 at 15:01, Alan Stern wrote:
> Regardless of how descriptive the value is, the code in
> scsi_dispatch_cmd treats anything other than SCSI_MLQUEUE_DEVICE_BUSY
> as SCSI_MLQUEUE_HOST_BUSY.  Will this matter?

Yes, you have to call cmd->done() having set the result field to
DID_NO_CONNECT; then return zero from queuecommand() indicating that
you're dealling with the command.

> It sounds like the two of you are in contradiction.  Should the SCSI core 
> deallocate in-flight commands without consulting the LLDD or shouldn't it?

Once you've called scsi_remove_host() the mid-layer will take control of
your in-flight commands (if there are any) and error them back to the
user.  You need to take any actions to clean up internal structures
belonging to the commands *before* you do a scsi_remove_host.

James


