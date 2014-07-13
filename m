From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Remove some false sharing in Scsi_Host /
 Scsi_Device
Date: Sun, 13 Jul 2014 04:46:21 -0700
Message-ID: <20140713114621.GA4316@infradead.org>
References: <1405110310-3555-1-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaGMLqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 07:46:22 -0400
Content-Disposition: inline
In-Reply-To: <1405110310-3555-1-git-send-email-andi@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>

On Fri, Jul 11, 2014 at 01:25:10PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> These data structures are accessed by different CPUs and have some
> fields which are mostly read only and others which are frequently
> written. Separate some common ones into separate cache line
> to minimize false sharing while submitting a command.
> 
> This allows scsi_dispatch_cmd to do more work with shared clean
> cache lines.
> 
> - Move the cmd_serial_number to the end before the host data
> - Separate write common fields from read mostly fields in
> the scsi device

Looks useful, but please provide some numbers on how this actually
helps.

