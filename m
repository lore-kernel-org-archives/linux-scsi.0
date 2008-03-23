From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/8] Fix refcounting for attribute_container
Date: Sun, 23 Mar 2008 09:59:47 -0500
Message-ID: <1206284387.3494.8.camel@localhost.localdomain>
References: <20080318133228.7B58F159166@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49318 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757327AbYCWO7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Mar 2008 10:59:50 -0400
In-Reply-To: <20080318133228.7B58F159166@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-03-18 at 14:32 +0100, Hannes Reinecke wrote:
> attribute_container_add_device() takes an explicit reference on the
> parent device, making it impossible to remove the parent by doing
> a simple put_device(). So we'd rather _not_ take a reference here as
> attribute_container will be handled explicitly by calls to
> attribute_container_remove_device()/_destroy_device() anyway.

I really don't think this is right.  The attribute container does hold a
reference to the device, so we should make it explicit.  You could argue
that in the new parent indicates class device model there's *already* a
reference, so this one is superfluous, but it does help to make the
relationship explicit.  Regardless, because we have an implicit
reference, your comment for the patch can't work (whether we explicitly
take the ref or not, you can't expect the device to be unrefereced by
the attribute container).

James


