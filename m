From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: Wed, 29 Sep 2004 13:31:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929203104.GB6179@us.ibm.com>
References: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org> <1096487461.2028.134.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:58761 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S269018AbUI2Ub2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 16:31:28 -0400
Content-Disposition: inline
In-Reply-To: <1096487461.2028.134.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> Once you've called scsi_remove_host() the mid-layer will take control of
> your in-flight commands (if there are any) and error them back to the
> user.  You need to take any actions to clean up internal structures
> belonging to the commands *before* you do a scsi_remove_host.
> 

How do we address the problem we get into with the reordering in
scsi_remove_host (i.e. the call to scsi_forget_host prior to
scsi_host_cancel) if we possibly generate new io from sd_sync_cache
that will cause the error handler to fire up if the LLDD just lets the
command fall on the floor with no response.

-andmike
--
Michael Anderson
andmike@us.ibm.com

