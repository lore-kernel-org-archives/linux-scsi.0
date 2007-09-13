From: Christoph Hellwig <hch@infradead.org>
Subject: Re: switch sdev sysfs attributes to default attributes
Date: Thu, 13 Sep 2007 14:29:25 +0100
Message-ID: <20070913132925.GA30622@infradead.org>
References: <1189522814.4564.12.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47634 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbXIMN33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Sep 2007 09:29:29 -0400
Content-Disposition: inline
In-Reply-To: <1189522814.4564.12.camel@lov.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On Tue, Sep 11, 2007 at 05:00:14PM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: [SCSI] switch sdev sysfs attributes to default attributes
> 
> This removes the unused sysfs attribute overwriting logic for most of
> the attributes, and plugs them into the driver core default attribute
> creation.
> 
> Without this patch, at the time of the events for the SCSI LUN's, there
> will be no sysfs files, because their creation is delayed until the sd
> driver has spun up the disks, which might take several seconds. It is the
> last WAIT_FOR_SYSFS rule in the default udev setup which can be removed
> with this change.

Looks good for to me.  How does sysfs react if some driver would add the
same attribute the core has already added?  If it give back a sane error
(and maybe even prints a message) then it's fine, otherwise we might have
to add some debug code to error out if a driver tries to add an existing
attribute because it sneaked through review or similar.

