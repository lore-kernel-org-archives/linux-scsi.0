From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] scsi: megaraid_sas - add module param max_sectors, cmd_per_lun
Date: Wed, 7 Nov 2007 17:42:48 +0000
Message-ID: <20071107174248.GE25560@infradead.org>
References: <20071030173858.GB16455@infradead.org> <9738BCBE884FDB42801FAD8A7769C26501CA1BB4@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50807 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbXKGRmu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 12:42:50 -0500
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501CA1BB4@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>

On Tue, Nov 06, 2007 at 12:06:39PM -0700, Yang, Bo wrote:
> The fast_load parameter is for the user to decide at driver load time if
> (s)he wants to skip scan of devices in PD channels.
> After driver is loaded the user cannot be permitted to modify this
> value. If the user needs to see the devices in the PD channels, (s)he
> may initiate a scan via sysfs/proc based on the kernel being used. Once
> the user has done the scan, the fast_load value does not have any
> significance and thus not exposed for reading.

The issue here is that this should really be a per-hba setting, and
as HBAs can appear anytime due to PCI hotplug a module paramater is not
enough.  Then again I still don't see why we need to spend so much effort
on this as you could trivially just fail the PD scanning commands in the
firmware without messing up the driver.

> cmd_per_lun & max_sectors are also intended to be provided by user only
> at driver load time. In the current implementation both these do appear
> as read-only values under host# in sysfs. The current design is not to
> allow these values to be modified on the fly. 

Same argument here about beeing per-hba.  And they really should be changeable
at runtime at least for hbas that don't have commands in flight.

