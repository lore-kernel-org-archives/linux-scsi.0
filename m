From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/8] Fixup initialisation oops for anonymous transport
	classes
Date: Thu, 20 Mar 2008 13:14:40 -0500
Message-ID: <1206036880.3038.32.camel@localhost.localdomain>
References: <20080318133228.53EAE1F60F@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42597 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754893AbYCTSOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 14:14:44 -0400
In-Reply-To: <20080318133228.53EAE1F60F@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org


On Tue, 2008-03-18 at 14:32 +0100, Hannes Reinecke wrote:
> Anonymous transport classes might call transport_add_class_devices
> with NULL classdev.

They do ... but it doesn't cause an oops.  class_device_add first calls
class_device_get() which returns -EINVAL for a NULL classdev.  It looks
like device_add() does exactly the same thing in the new scheme, so what
oops were you seeing?

James


