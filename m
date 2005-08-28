From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: libata: clustering on or off?
Date: Sun, 28 Aug 2005 12:22:21 +0200
Message-ID: <1125224541.3219.13.camel@laptopd505.fenrus.org>
References: <20050828094218.GA29145@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49795 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750963AbVH1KWh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Aug 2005 06:22:37 -0400
In-Reply-To: <20050828094218.GA29145@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Sun, 2005-08-28 at 05:42 -0400, Jeff Garzik wrote:
> The constant ATA_SHT_USE_CLUSTERING in include/linux/libata.h controls
> the use of SCSI layer's use_clustering feature, for a great many libata
> drivers.
> 
> The current setup has clustering disabled, which in theory causes the
> block layer to do less work, at the expense of a greater number of
> scatter/gather table entries used.
> 
> Any opinions WRT turning on clustering for libata?

in 2.4 clustering was expensive due to a large number of checks that
were done (basically the number of fragments got recounted a gazilion
times). In 2.6 Jens fixed that afaik to make it basically free...
at which point it's a win always.

Imo clustering on the driver level should announce driver capabilities.
If clustering for some arch/kernel makes it slower, that should be
decided at a midlayer level and not in each driver; eg the midlayer
would chose to ignore the drivers capabilities.
So .. my opinion would be that libata should announce the capability (it
seems the code/hw can do it). 

