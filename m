From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 3 Feb 2014 15:58:17 -0600
Message-ID: <52F010F9.5090305@tributary.com>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com> <52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com> <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:32258 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCV6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2014 16:58:30 -0500
In-Reply-To: <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay@vrfy.org>
Cc: Hannes Reinecke <hare@suse.de>, =?UTF-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVt?= =?UTF-8?B?YnVzKSI=?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

On 2/3/2014 2:51 PM, Kay Sievers wrote:
> This is not simple and not going to happen. Sibling devices in /sys cannot
> have a relationship in udev, there are only parent/child dependencies.

	Ok.. so if we can't ignore all the "spare" device nodes in a given /sys entry
for a given device. Why open the device to scan it?

	I've often wondered why the serial number isn't part of the data in /sys
along with the manufacture/model. The last tape drive I saw that failed to
respond to inquiry page 0x80 was over a decade ago (probably manufactured in
the early 90s). So enabling it just for tape is pretty safe.


	Matching Manufacturer/model/serial is going to be better than anything your
going to get out of 0x83 anyway. That data is guaranteed to be there, but its
also guaranteed to be unreliable (every device, and every port has a slightly
different set of descriptors they choose to support).

	Plus, your not going to have issues accidentally rewinding a device, or
resetting a tape density, or accidentally turning compression off if you don't
open the device.



> Hannes, can't you just drop the weird auto-rewinding device matches from
> the persistent rules, is that really useful today?

	The relationship between the st and nst devices is leveraged by a large
number of backup applications in the field. If you change it, its likely lots
of breakage will ensue.







