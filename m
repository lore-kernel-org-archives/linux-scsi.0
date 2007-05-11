From: David Miller <davem@davemloft.net>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 13:00:24 -0700 (PDT)
Message-ID: <20070511.130024.104034874.davem@davemloft.net>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45417
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759351AbXEKUAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 16:00:19 -0400
In-Reply-To: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
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
> 
> So what do people think about this?

This would require platforms to handle all of their bus types
behind the generic dma_*() and that's isn't true everywhere yet.

For example, SBUS still requires explicitly using sbus_map_sg() etc.

I plan to fix that of course, but we're not there now.
