From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] minimal SAS transport class
Date: Wed, 24 Aug 2005 10:12:30 +0100
Message-ID: <20050824091230.GB26447@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com> <430B5CDB.9070204@s5r6.in-berlin.de> <430BB91F.7000406@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60858 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750806AbVHXJMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 05:12:31 -0400
Content-Disposition: inline
In-Reply-To: <430BB91F.7000406@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>

On Tue, Aug 23, 2005 at 08:02:39PM -0400, Luben Tuikov wrote:
> In effect FC tells SCSI Core: here is a device I do not know anything
> about, other than the fact that it is on the fabric and it has
> a SCSI Target (or Initiator) Port: how you get to is is _my_ business,
> what is done with or to the device is _your_ business.
> 
> Then SCSI Core does LU discovery using SPC and SAM on the device
> using Execute Task.
> 
> All this _completely_ eliminates the need for HCIL.
> 
> How the FC layer identifies the device is the FC's layer problem.
> How SCSI Core identifies the device is SCSI Core's problem.
> 
> HCIL should have never been available to SCSI Core in the first place,
> but then again SAM didn't exist back then.

Ok, Luben, here's the TODO list to get there:

 (1) add a sdev_printk that takes a struct scsi_device * and prints
     a sensible name for it.  Later we might or might not make this
     a transport hook, but for now it gets rid of all these ->id
     references in LLDDs
 (2) add a variant of scsi_scan_target that takes a scsi_target * to
     scan, make the old scsi_scan_target a wrapper around it and
     introduce similar wrappers for transport-specific target identifiers
     (e.g. WWNs for FC and SAS)
 (3) fix a bunch of internal functions that use ->id despite not actually
     needing it, e.g. starget_for_each_device
 (4) eventually move the traditional scsi_scan_target and other functions
     that lookup a scsi_target based on ->id into the spi transport class
 (5) add an SPI-specific taget ID accessor and move all drivers over to it

