From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid: Add module param to export disks as 'fixed'
 instead of 'removable'
Date: Tue, 17 May 2011 15:35:44 -0400
Message-ID: <20110517193544.GA27336@infradead.org>
References: <4DD2CE01.9090403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1EQTfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2011 15:35:46 -0400
Content-Disposition: inline
In-Reply-To: <4DD2CE01.9090403@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ankit Jain <jankit@suse.de>
Cc: linux-scsi@vger.kernel.org, aacraid@adaptec.com, Hannes Reinecke <hare@suse.de>

On Wed, May 18, 2011 at 01:05:29AM +0530, Ankit Jain wrote:
> aacraid: Add 'aac_export_fixed' module param to export disks as
> 'fixed' instead of 'removable'.
> 
> Adaptec controllers set the removable flag on devices to
> allow for reconfiguration. The fear is that _not_ setting this
> flag would inhibit the OS from detecting any device reconfiguration.

The flag should not be set at all and just be removed.

> This manifested itself in a bug where Paravirtualized NetWare
> was not able to boot with more than one PHY disk attached to a Xen
> VM. NetWare sees two removable disks (and not CD-ROM), which is
> an unsupported configuration. Details can be found at -
> https://bugzilla.novell.com/show_bug.cgi?id=667226 .

But if you can't get aacraid fixed entirely the next best work around
is to stop Xen from blindly copying flags to the guest disk.

