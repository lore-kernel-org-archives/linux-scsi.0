From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] dc395x: dynamically map scatter-gather for PIO (take 2)
Date: Sat, 22 Apr 2006 00:30:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604220024540.3237@poirot.grange>
References: <Pine.LNX.4.60.0604022004520.17410@poirot.grange>
 <20060413132932.31871824.rdunlap@xenotime.net> <Pine.LNX.4.60.0604132256490.4711@poirot.grange>
 <20060419172733.d61e3365.rdunlap@xenotime.net> <Pine.LNX.4.60.0604212341260.3237@poirot.grange>
 <20060421150423.1416908a.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:59362 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751366AbWDUWaf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Apr 2006 18:30:35 -0400
In-Reply-To: <20060421150423.1416908a.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Sebastian@schnapsleichen.de, roubert@df.lth.se, lenehan@twibble.org

On Fri, 21 Apr 2006, Randy.Dunlap wrote:

> My current (ugly, debug) patch is at
>   http://www.xenotime.net/linux/patches/aha152x-sg-pio.patch 

A couple of quick notes:

1. You have to disable local interrupts before (scsi_)kmap_atomic(_sg)() 
and restore them after (scsi_)kunmap_atomic(_sg)() (didn't check the 
context of your patch, so, maybe it is already the case, if not, please, 
fix)

2. You have to initialise your sg_len variable before calling 
scsi_kmap_atomic_sg()

Thanks
Guennadi
---
Guennadi Liakhovetski
