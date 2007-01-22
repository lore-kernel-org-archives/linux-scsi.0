From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Mon, 22 Jan 2007 12:07:13 -0600
Message-ID: <1169489233.2769.30.camel@mulgrave.il.steeleye.com>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org>
	 <b43c8fc9882e65d397a6465e6cb7c998@aboo.org>
	 <45B4EAAC.5000008@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49191 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932155AbXAVSHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 13:07:30 -0500
In-Reply-To: <45B4EAAC.5000008@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: aboo <aboo@aboo.org>, dougg@torque.net, linux-scsi@vger.kernel.org

On Mon, 2007-01-22 at 17:47 +0100, Stefan Richter wrote:
> As I wrote before, deal with it like with hot-unplug. A kernel driver
> cannot prevent the user from pulling a cable.

This is exactly the correct advice.

The hotplug model requires that you own a reference on the resources you
want to access.  When you're done, you release the reference and the
last person to drop the reference causes the object to be freed.

For scsi_hosts, every open device keeps a reference on the host, so the
way do destroy one is to do a scsi_remove_host() which releases your
interest in the host object, but keeps it around long enough to tidy up
after it.  For physical drivers, your queuecommand() routine may still
be required to handle the odd stray command after the removal notice has
been issued, however, by and large SCSI begins rejecting I/O to the
devices higher up.  When the last device is closed, it will release the
last reference to the host and trigger final cleanup.

James


