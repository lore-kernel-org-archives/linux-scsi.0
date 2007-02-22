From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch 2/2] cciss: add reboot notifier support to driver
Date: Thu, 22 Feb 2007 03:33:19 +0000
Message-ID: <20070222033319.GA7493@infradead.org>
References: <20070221211251.GB2672@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41389 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbXBVDd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 22:33:26 -0500
Content-Disposition: inline
In-Reply-To: <20070221211251.GB2672@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: jens.axboe@oracle.com, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Wed, Feb 21, 2007 at 03:12:51PM -0600, Mike Miller (OS Dev) wrote:
> Patch 2/2
> 
> This patch adds reboot_notifier support to cciss. Changes in firmware make this patch
> essential. Without this patch there may be valid data left in the controller's battery
> backed write cache (BBWC) on shutdown. We found out the hard way that the kernel does
> not call our cleanup routines on shutdown or reboot. It seems that only rmmod calls
> the cleanup.
> Please consider this for inclusion.
> 

NAK.  This should be using the shutdown method in struct pci_driver instead.

I really wish we wouldn't export the reboot_notifier so people don't repeat
this mistake over and over again..

