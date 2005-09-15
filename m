From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
	2.6.14-rc1
Date: Thu, 15 Sep 2005 17:08:03 -0400
Message-ID: <1126818483.4821.60.camel@mulgrave>
References: <20050915190338.GA6807@kroah.com>
	 <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org>
	 <20050915192912.GA7077@kroah.com>  <1126814226.4821.48.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:34177 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030492AbVIOVIL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 17:08:11 -0400
In-Reply-To: <1126814226.4821.48.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Thu, 2005-09-15 at 15:57 -0400, James Bottomley wrote:
> I haven't had time to review the eh changes, but I was going to reply to
> the other one (basically there's a better way to try to close the device
> add/host remove race using the host state model).
> 
> Let me complete the SCSI process and I'll take them through the scsi-rc-
> fixes tree.

Well, I think the symptoms are racing scsi_remove_host() calls and the
solution is to enforce the state model on removal (as in if the host is
already in the remove state, don't try to remove it again).

Could you try the patch here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112613077011571

And see if it will fix the problem?

James


