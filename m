From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Logging of all scsi commands to a certain target?
Date: Sun, 24 Aug 2014 14:08:49 -0700
Message-ID: <20140824210849.GA29246@infradead.org>
References: <53F8AB3F.50901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbaHXVIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2014 17:08:50 -0400
Content-Disposition: inline
In-Reply-To: <53F8AB3F.50901@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sat, Aug 23, 2014 at 04:54:55PM +0200, Hans de Goede wrote:
> Hi,
> 
> Now that the UAS driver is no longer marked as CONFIG_BROKEN,
> I'm getting quite a few bug reports about issues with UAS drives.
> 
> Some of these seem to be related to the scsi core and/or the sd
> driver sending a command the device does not like.
> 
> As such I'm wondering if there us a way to get the kernel
> to log each scsi command ? Or at least is there a helper
> function to log scsi commands which I can add to the uas driver
> (under a verbose option) to allow this ?

Enable the scsi_dispatch_cmd_start tracepoint using trace-cmd or
debugfs, and filter using host_no/channel/id/lun for your specific
device.  See Documentation/trace/events.txt for details on setting
up filters.

