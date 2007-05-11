From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Sat, 12 May 2007 03:42:58 +0900
Message-ID: <20070512034258L.fujita.tomonori@lab.ntt.co.jp>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:40958 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbXEKSnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 14:43:04 -0400
In-Reply-To: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 13:33:41 -0500

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

Several drivers don't take account of the mapping failure and handling
the failure for some is tricky. So it would be nice if the mid layer
takes care about the mapping.
