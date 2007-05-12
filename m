From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Sat, 12 May 2007 09:35:44 +0300
Message-ID: <20070512063544.GO4523@rhun.ibm.com>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:25060 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbXELGfs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 02:35:48 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l4C6ZkcZ188722
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2007 06:35:46 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4C6ZkIe2519130
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2007 07:35:46 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4C5YNPu031606
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2007 06:34:24 +0100
Content-Disposition: inline
In-Reply-To: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, May 11, 2007 at 01:33:41PM -0500, James Bottomley wrote:
> Right at the moment, we're planning to clean up the way SCSI drivers
> process commands.  The proposals are essentially:
> 
>      1. Get rid of the now unnecessary map_single path (every command is
>         either zero transfer or scatter/gather)
>      2. use accessors to manipulate the SG lists (mainly so that we can
>         alter the implementation without affecting the drivers)
> 
> It strikes me that in all of this, we could also consider doing the DMA
> mapping inside the mid layer (instead of in every driver).  This is
> essentially what libata is already doing ... leading to confusion in
> SCSI drivers that use libata for SATA.
> 
> So what do people think about this?

Yes please. It will be easier to modify the DMA API interface to
better support hypervisors and other "DMA mapping heavy" users if it's
localized to the mid-layer rather than spread out in drivers.

Cheers,
Muli
