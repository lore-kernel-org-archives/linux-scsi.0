From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] use mmiowb in qla1280.c
Date: 24 Oct 2004 12:20:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098634812.10906.38.camel@mulgrave>
References: <200410211613.19601.jbarnes@engr.sgi.com>
	<200410211617.14809.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2780 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261534AbUJXQUZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 12:20:25 -0400
In-Reply-To: <200410211617.14809.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, jeremy@sgi.com, jes@sgi.com

On Thu, 2004-10-21 at 19:17, Jesse Barnes wrote:
> There are a few spots in qla1280.c that don't need a full PCI write flush to 
> the device, but rather a simple write ordering guarantee.  This patch changes 
> some of the PIO reads that cause write flushes into mmiowb calls instead, 
> which is a lighter weight way of ensuring ordering.
> 
> Jes and James, can you ack this and/or push it in via the SCSI BK tree?

This doesn't seem to work:

  CC [M]  drivers/scsi/qla1280.o
drivers/scsi/qla1280.c: In function `qla1280_64bit_start_scsi':
drivers/scsi/qla1280.c:3404: warning: implicit declaration of function
`mmiowb'

  MODPOST
*** Warning: "mmiowb" [drivers/scsi/qla1280.ko] undefined!

James


