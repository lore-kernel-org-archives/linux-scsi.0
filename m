From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 29 Sep 2004 16:41:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096490471.2028.140.camel@mulgrave>
References: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
	<1096487461.2028.134.camel@mulgrave>  <20040929203104.GB6179@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10419 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269049AbUI2UlW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 16:41:22 -0400
In-Reply-To: <20040929203104.GB6179@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On Wed, 2004-09-29 at 16:31, Mike Anderson wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > Once you've called scsi_remove_host() the mid-layer will take control of
> > your in-flight commands (if there are any) and error them back to the
> > user.  You need to take any actions to clean up internal structures
> > belonging to the commands *before* you do a scsi_remove_host.
> > 
> 
> How do we address the problem we get into with the reordering in
> scsi_remove_host (i.e. the call to scsi_forget_host prior to
> scsi_host_cancel) if we possibly generate new io from sd_sync_cache
> that will cause the error handler to fire up if the LLDD just lets the
> command fall on the floor with no response.

That's why LLD's are responsible for erroring all commands issued at
this time if the removal is a surprise ejection.  The commands have to
be errored in a way (like DID_NO_CONNECT) that won't excite the error
handler.

James


